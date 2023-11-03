#' Title
#'  Function designed for use in dplyr (tidyverse) piping to return mean diff and bootstrap CI around that
#' @param formula1 formula defining the two variables to be correlated as scores ~ group
#' @param data data.frame or tibble with the data, often a subset of data created with group_by() and pick()
#' @param bootReps integer giving number of bootstrap replications
#' @param conf numeric value giving width of confidence interval, e.g. .95 (default)
#' @param bootCImethod string giving method to derive bootstrap CI, minimum two letters 'pe', 'no', 'ba' or 'bc' for percentile, normal, basic or bca
#'
#' @return list of named values obsDiff, LCLdiff and UCLdiff
#' @export
#'
#' @importFrom stats na.omit
#' @importFrom stats sd
#' @importFrom dplyr n
#' @importFrom dplyr mutate
#'
#' @family bootstrap CI functions
#'
#' @examples
#' \dontrun{
#' ### will need tidyverse to run
#' library(tidyverse)
#' ### create some data
#' ### get replicable data
#' set.seed(12345)
#' n <- 120
#' list(scores = rnorm(n), # Gaussian random base for scores
#'   ### now add a grouping variable: help-seeking or not
#'   grp = sample(c("HS", "not"), n, replace = TRUE),
#'   ### now add gender
#'   gender = sample(c("F", "M"), n, replace = TRUE)) %>%
#'   as_tibble() %>%
#'   ### next add a gender effect nudging women's scores up by .4
#'   mutate(scores = if_else(gender == "F", scores + .4, scores),
#'   ### next add the crucial help-seeking effect of 1.1
#'         scores = if_else(grp == "HS", scores + 1.1, scores)) -> tmpDat
#' #
#' ### have a look at that
#' tmpDat
#' #
#' set.seed(12345) # to get replicable results from the bootstrap
#' tmpDat %>%
#'   ### don't forget to prefix the call with "list(" to tell dplyr
#'   ### you are creating list output
#'   ### pick(everything()) has replaced cur_data(), verbose but more flexbible
#'   summarise(meanDiff = list(getBootCIgrpMeanDiff(scores ~ grp, pick(everything())))) %>%
#'   ### now unnest the list to columns
#'   unnest_wider(meanDiff)
#'
#' ### now an example of how this becomes useful: same but by gender
#' set.seed(12345) # to get replicable results from the bootstrap
#' tmpDat %>%
#'   group_by(gender) %>%
#'   ### remember the list output again!
#'   summarise(meanDiff = list(getBootCIgrpMeanDiff(scores ~ grp, pick(everything())))) %>%
#'   ### remember to unnnest again!
#'   unnest_wider(meanDiff)
#'   }
#'
getBootCIgrpMeanDiff <- function(formula1, data, bootReps = 1000, conf = .95, bootCImethod = "pe") {
  ### function to return bootstrap CI around an observed correlation
  ### between two variables fed in within a formula as variable1 ~ variable2
  ### and each within a data frame or tibble, data
  ### method sets the correlation method from the stats::cor() package options
  ### bootReps sets the number of bootstrap replications
  ### conf sets the width of the CI
  ### uses the boot() and boot.ci() functions from the package boot, hence ...
  invisible(stopifnot(base::requireNamespace("boot")))
  ### OK now some input sanity checking largely to get informative error messages
  ### if things go wrong
  ### sanity check 1: is formula1 a formula?!
  if (!inherits(formula1, "formula")) {
    stop("first argument must be a simple formula of form dependent ~ predictor")
  }
  ### sanity check 2: it should have two terms
  if (length(formula1) != 3) {
    stop("first argument must be a simple formula of form variable1 ~ variable2")
  }
  var1 <- formula1[[2]]
  var2 <- formula1[[3]]
  ### sanity check 3
  if (length(var1) != 1 | length(var2) != 1) {
    stop("formula input can only have one term on each side of the formula")
  }
  ### I think this will always work and just pulls the environment
  e <- environment(formula1)
  ### which can then be used to get the dependent out of data in that environment
  scores <- eval(var1, data, e)
  ### same for the predictor
  grp <- eval(var2, data, e)
  ### boot() needs stratification variable, i.e. grouping variable, to be numeric
  if (!is.numeric(grp)) {
    if (is.factor(grp)) {
      grp <- as.numeric(grp)
    } else {
      grp <- as.numeric(factor(grp))
    }
  }
  ### sanity check 4: must have only 2 values in grp
  if (dplyr::n_distinct(grp) != 2) {
    stop("Grouping variable must have two and only two values.  You may see this if group_by() stratifying\nhas meant you don't have two values of the grouping variable.")
  }
  list(scores = scores,
       grp = grp) %>%
    as_tibble() %>%
    na.omit() -> tmpDat
  ### sanity check 5: scores must be numeric
  if (!is.numeric(scores)) {
    stop("Scores must be numeric")
  }
  ### sanity check 6: smallest sample must be > 20 to get stable bootstrap
  tmpDat %>%
    dplyr::group_by(grp) %>%
    dplyr::summarise(n = n()) %>%
    dplyr::summarise(min = min(n)) %>%
    dplyr::pull() -> valMinN
  if (valMinN < 20) {
    stop("You won't get a stable bootstrap CI with minimum cell size < 20. You may see this if group_by() stratifying\nhas given you a small cell size.")
  }
  ### sanity check 7: R must be numeric and integer
  ### can't imagine we really need this but ...
  ### function from documentation of integer in base R
  is.wholenumber <-
    function(x, tol = .Machine$double.eps^0.5)  abs(x - round(x)) < tol
  if (!is.numeric(bootReps) | !is.wholenumber(bootReps) | bootReps < 20) {
    stop("Bootreps must be integer and numeric and, even for testing, >= 20")
  }
  ### sanity check 8: conf must be sensible
  if (!is.numeric(conf) | conf <= 0 | conf > .999) {
    stop("conf must be numeric and 0 < conf < .999")
  }
  ### sanity check 9: check bootCImethod, i.e. type of bootstrap CI to be used
  if (!is.character(bootCImethod) | length(bootCImethod) != 1) {
    stop("bootCImethod must be character variable of length 1")
  }
  bootCImethod <- stringr::str_to_lower(stringr::str_sub(bootCImethod, 1, 2))
  if (!bootCImethod %in% c("no", "ba", "st", "pe", "bc")) {
    stop("bootCImethod must start, after lowercasing with one of 'no', 'ba', 'pe' or 'bc'")
  }
  ### clumsy switch but easy to read
  if (bootCImethod == "no") {
    useBootCImethod <- "norm"
  }
  if (bootCImethod == "ba") {
    useBootCImethod <- "basic"
  }
  if (bootCImethod == "pe") {
    useBootCImethod <- "perc"
  }
  if (bootCImethod == "bc") {
    useBootCImethod <- "bca"
  }
  ### end of sanity checking
  ###
  message("Function: getBootCIgrpMeanDiff")
  message("Function always uses only complete values of both variables")
  message(paste("Number of bootstrap replications is:",
                bootReps))
  message(paste("Method for computing bootstrap confidence interval is:",
                useBootCImethod))
  message(paste("Width of confidence interval is:",
                conf,
                "i.e.",
                paste0(round(100 * conf),
                       "%")))
  ### now we need a function to feed into boot() to get mean
  ### first a minimal getMeanLocal
  getMeanlocal <- function(tmpDat) {
    ### tmpDat has two columns: scores and grp and has been prechecked
    tmpDat %>%
      dplyr::group_by(grp) %>%
      dplyr::summarise(mean = mean(scores)) %>%
      ungroup() %>%
      pull() -> vecMeans
    ### get the difference
    vecMeans[2] - vecMeans[1]
  }
  getMeanforBoot <- function(tmpDat, i) {
    ### expects x as two column structure
    getMeanlocal(tmpDat[i, ])
  }
  ### now use that to do the bootstrapping
  ### have to use as.data.frame() so we can index by columns even though
  ### tmpDat is a tibble
  tmpDat <- as.data.frame(tmpDat)
  tmpBootRes <- boot::boot(tmpDat, # data
                           statistic = getMeanforBoot, # function to apply
                           stype = "i", # bootstrapping within strata done by indexing
                           # that means that i is a row number _within_ the stratum for each stratum
                           strata = tmpDat[, 2], # tells boot::boot() which variable to use for strata
                           R = bootReps) # number of bootstrap replications
  ### and now get the CI from that,
  tmpCI <- boot::boot.ci(tmpBootRes,
                         type = useBootCImethod,
                         conf = conf)
  if (bootCImethod == "pe") {
    retVal <- list(Diff = as.numeric(tmpBootRes$t0),
                   LCLdiff = tmpCI$percent[4],
                   UCLdiff = tmpCI$percent[5])
  }
  if (bootCImethod == "ba") {
    retVal <- list(Diff = as.numeric(tmpBootRes$t0),
                   LCLdiff = tmpCI$basic[4],
                   UCLdiff = tmpCI$basic[5])
  }
  if (bootCImethod == "bc") {
    retVal <- list(Diff = as.numeric(tmpBootRes$t0),
                   LCLdiff = tmpCI$bca[4],
                   UCLdiff = tmpCI$bca[5])
  }
  if (bootCImethod == "no") {
    retVal <- list(Diff = as.numeric(tmpBootRes$t0),
                   LCLdiff = tmpCI$normal[2],
                   UCLdiff = tmpCI$normal[3])
  }
  retVal
}




