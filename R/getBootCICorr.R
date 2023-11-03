#' Function to return observed correlation between two variables with bootstrap CI
#'
#' @param formula1 formula defining the two variables to be correlated as var1 ~ var2
#' @param data data.frame or tibble with the data, often subset of the data created with group_by() and pick()
#' @param bootReps integer giving number of bootstrap replications
#' @param conf numeric value giving width of confidence interval, e.g. .95 (default)
#' @param method string giving correlation method, can be single letter 'p', 's' or 'k' for pearson, spearman or kendall (in cor())
#' @param bootCImethod string giving method to derive bootstrap CI, can be two letters 'pe', 'no', 'ba' or 'bc' for percentile, normal, basic or bca
#'
#' @return list of named values: obsCorr, LCLCorr and UCLCorr
#' @export
#'
#' @examples
#' \dontrun{
#' library(tidyverse)
#' ### create some data
#' set.seed(12345) # make this replicable
#' n <- 150
#' tibble(x = rnorm(n), y = rnorm(y)) %>%
#'    ### that's got us sample x and y from population in which they're uncorrelated
#'    ### make them correlated:
#'    mutate(y = y + .2 * x)  -> data
#'
#' data %>%
#'    ### don't forget to prefix the call with "list(" to tell dplyr
#'    ### you are creating list output
#'    summarise(corr = list(getBootCICorr(x ~ y,
#'              pick(everything()),
#'              ### pick(everything()) is, to my mind, a rather verbose replacement for cur_data()
#'              method = "p", # gets the Pearson correlation
#'              bootReps = 1000,
#'              ### "pe" in next line gets the percentile bootstrap CI
#'              bootCImethod = "pe"))) %>%
#'    ### now unnest the list output to separate columns
#'    unnest_wider(corr)
#'}
#'
#' @family bootstrap CI functions
#'
#' @author Chris Evans
#'
#' @section History/development log:
#' Started before 5.iv.21
#'
getBootCICorr <- function(formula1, data, method = "p", bootReps = 1000, conf = .95, bootCImethod = "pe") {
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
  vecVar1 <- eval(var1, data, e)
  ### same for the predictor
  vecVar2 <- eval(var2, data, e)
  ### sanity check 4: variables must be numeric
  if (!is.numeric(vecVar1) | !is.numeric(vecVar2)) {
    stop("Variables must be numeric")
  }
  ### sanity check 5: R must be numeric and integer
  ### can't imagine we really need this but ...
  ### function from documentation of integer in base R
  is.wholenumber <-
    function(x, tol = .Machine$double.eps^0.5)  abs(x - round(x)) < tol
  if (!is.numeric(bootReps) | !is.wholenumber(bootReps) | bootReps < 20) {
    stop("Bootreps must be integer and numeric and, even for testing, >= 20")
  }
  ### sanity check 6: conf must be sensible
  if (!is.numeric(conf) | conf <= 0 | conf > .999) {
    stop("conf must be numeric and 0 < conf < .999")
  }
  ### sanity check 7: check method
  ### sanity check 8: check method
  if (!is.character(method) | length(method) != 1) {
    stop("method must be character variable of length 1")
  }
  method <- stringr::str_to_lower(stringr::str_sub(method, 1, 1))
  if (!method %in% c("p", "s", "k")) {
    stop("method must start with one of 'p', 'P', 's', 'S', 'k', 'K'")
  }
  ### clumsy switch but easy to read
  if (method == "p") {
    useMethod <- "pearson"
  }
  if (method == "s") {
    useMethod <- "spearman"
  }
  if (method == "k") {
    useMethod <- "kendall"
  }
  ### sanity check 8: check bootCImethod, i.e. type of bootstrap CI to be used
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
  message("Function: getBootCICorr")
  message(paste("Correlation method is:",
                useMethod))
  message("Function always uses only pairwise complete values of both variables")
  message(paste("Number of bootstrap replications is:",
                bootReps))
  message(paste("Method for computing bootstrap confidence interval is:",
                useBootCImethod))
  message(paste("Width of confidence interval is:",
                conf,
                "i.e. ",
                paste0(round(100 * conf),
                      "%")))
  ### now we need a function to feed into boot() to get Pearson correlation
  pearsonForBoot <- function(x, i) {
    ### expects x as two column structure
    stats::cor(x[i, 1],
        x[i, 2],
        method = useMethod,
        use = "pairwise.complete.obs")
  }
  ### make x
  x <- cbind(vecVar1, vecVar2)
  ### now use that to do the bootstrapping
  tmpBootRes <- boot::boot(x, statistic = pearsonForBoot, R = bootReps)
  ### and now get the CI from that,
  tmpCI <- boot::boot.ci(tmpBootRes,
                         type = useBootCImethod,
                         conf = conf)
  if (bootCImethod == "pe") {
    retVal <- list(obsCorr = as.numeric(tmpBootRes$t0),
                   LCLCorr = tmpCI$percent[4],
                   UCLCorr = tmpCI$percent[5])
  }
  if (bootCImethod == "ba") {
    retVal <- list(obsCorr = as.numeric(tmpBootRes$t0),
                   LCLCorr = tmpCI$basic[4],
                   UCLCorr = tmpCI$basic[5])
  }
  if (bootCImethod == "bc") {
    retVal <- list(obsCorr = as.numeric(tmpBootRes$t0),
                   LCLCorr = tmpCI$bca[4],
                   UCLCorr = tmpCI$bca[5])
  }
  if (bootCImethod == "no") {
    retVal <- list(obsCorr = as.numeric(tmpBootRes$t0),
                   LCLCorr = tmpCI$normal[2],
                   UCLCorr = tmpCI$normal[3])
  }
  retVal
}
