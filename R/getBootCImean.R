#' Function to return bootstrap CI around observed mean
#' @param var name of variable in ...
#' @param data dataframe or tibble (often cur_data() if using function in dplyr pipe)
#' @param bootReps integer for number of bootstrap replications
#' @param conf confidence interval desired as fraction, e.g. .95
#' @param bootCImethod method of deriving bootstrap CI from "perc", "norm", "basic" or "bca"
#' @param na.rm logical, set to FALSE to ensure function will fail if there are missing data
#' @param verbose logical, FALSE suppresses the messages
#'
#' @return list of length 3: obsmean, LCLmean and UCLmean
#' @export
#'
#' @examples
#' \dontrun{
#' set.seed(12345) # get replicable results
#'
#' ### now make up some silly data
#' n <- 50
#' rnorm(n) %>% # get some random Gaussian data
#'   as_tibble() %>%
#'   ### create a spurious grouping variable
#'   mutate(food = sample(c("sausages", "carrots"), n, replace = TRUE),
#'          ### create variable with some missing data to test na.rm = FALSE
#'          y = if_else(value < -1, NA_real_, value)) -> tmpDat
#'
#' ### check that worked!
#' tmpDat
#' ### looks fine!
#'
#' ### default arguments, get mean of value
#' tmpDat %>%
#'   summarise(meanCI = list(getBootCImean(value, cur_data()))) %>%
#'   unnest_wider(meanCI)
#'
#' ### default arguments, get mean of value by food
#' tmpDat %>%
#'   group_by(food) %>%
#'   summarise(meanCI = list(getBootCImean(value, cur_data()))) %>%
#'   unnest_wider(meanCI)
#'
#' ### suppress messages
#' tmpDat %>%
#'   summarise(meanCI = list(getBootCImean(value,
#'                                         cur_data(),
#'                                         verbose = FALSE))) %>%
#'   unnest_wider(meanCI)
#'
#' ### default silent omission of missing data, messages back
#' ###  analysing variable y which has missing data
#' ###  (see "Usable n")
#' tmpDat %>%
#'   summarise(meanCI = list(getBootCImean(y,
#'                                         cur_data(),
#'                                         verbose = TRUE))) %>%
#'   unnest_wider(meanCI)
#'
#' ### use na.rm = FALSE to ensure call will fail if there are missing data
#' tmpDat %>%
#'   summarise(meanCI = list(getBootCImean(y,
#'                                         cur_data(),
#'                                         verbose = TRUE,
#'                                         na.rm = FALSE))) %>%
#'   unnest_wider(meanCI)
#'
#' ### change bootstrap interval
#' tmpDat %>%
#'   summarise(meanCI = list(getBootCImean(y,
#'                                         cur_data(),
#'                                         conf = .9))) %>%
#'   unnest_wider(meanCI)
#'
#' ### change bootstrap CI method ("perc" is default)
#' tmpDat %>%
#'   summarise(meanCI = list(getBootCImean(y,
#'                                         cur_data(),
#'                                         verbose = TRUE,
#'                                         bootCImethod = "no"))) %>%
#'   unnest_wider(meanCI)
#'
#' ### should fail on impossible to decode choice of method in args
#' tmpDat %>%
#'   summarise(meanCI = list(getBootCImean(y,
#'                                         cur_data(),
#'                                         verbose = TRUE,
#'                                         bootCImethod = "b"))) %>%
#'   unnest_wider(meanCI)
#'}
#'
#' @family bootstrap CI functions
#'
#' @author Chris Evans
#'
getBootCImean <- function(var,
                          data,
                          bootReps = 1000,
                          conf = .95,
                          bootCImethod = c("perc", "norm", "basic", "bca"),
                          na.rm = TRUE,
                          verbose = TRUE) {

  ### function to return bootstrap CI around an observed mean for
  ### single variable fed in within a data frame or tibble, data
  ### bootReps sets the number of bootstrap replications
  ### conf sets the width of the CI
  ### uses the boot() and boot.ci() functions from the package boot, hence ...
  invisible(stopifnot(base::requireNamespace("boot")))
  ### OK now some input sanity checking largely to get informative error messages
  ### if things go wrong
  ### sanity check 1: var must be numeric
  if (!is.numeric(var)) {
    stop("Input var to getBootCImean() must be numeric.")
  }
  ### sanity check 2: if !na.rm, stop if any missing data
  if (!na.rm & sum(is.na(var)) > 0) {
    stop("You have set na.rm = FALSE for getBootCImean and there are missing data.")
  }
  var <- na.omit(var) # now remove missing values
  ### sanity check 3: sample smaller than 20 won't give to get stable bootstrap
  if (length(var) < 20) {
    stop("You won't get a stable bootstrap CI with minimum cell size < 20.")
  }
  ### sanity check 4: R must be numeric and integer
  ### can't imagine we really need this but ...
  ### function from documentation of integer in base R
  is.wholenumber <-
    function(x, tol = .Machine$double.eps^0.5)  abs(x - round(x)) < tol
  if (!is.numeric(bootReps) | !is.wholenumber(bootReps) | bootReps < 20){
    stop("Bootreps must be integer and numeric and, even for testing, >= 20")
  }
  ### sanity check 5: conf must be sensible
  if (!is.numeric(conf) | conf <= 0 | conf > .999 ) {
    stop("conf must be numeric and 0 < conf < .999")
  }
  ### sanity check 6: check bootCImethod, i.e. type of bootstrap CI to be used
  bootCImethod <- stringr::str_to_lower(bootCImethod)
  useBootCImethod <- match.arg(bootCImethod)
  ### end of sanity checking
  ###
  if (verbose){
    message("Function: getBootCImean{CECPfuns}")
    message(paste("Call:", match.call()))
    message(paste("Usable n =", length(var)))
    message(paste("Number of bootstrap replications is:",
                  bootReps))
    message(paste("Method for computing bootstrap confidence interval is:",
                  useBootCImethod))
    message(paste("Width of confidence interval is:",
                  conf,
                  "i.e.",
                  paste0(round(100*conf),
                         "%")))
  }
  ### now we need a function to feed into boot() to get C
  getMeanforBoot <- function(dat, i) {
    mean(dat[i])
  }
  ### now use that to do the bootstrapping
  tmpBootRes <- boot::boot(var, # data
                           statistic = getMeanforBoot,
                           R = bootReps) # number of bootstrap replications
  ### and now get the CI from that,
  tmpCI <- boot::boot.ci(tmpBootRes,
                         type = useBootCImethod,
                         conf = conf)
  if (useBootCImethod == "perc") {
    retVal <- list(obsmean = as.numeric(tmpBootRes$t0),
                   LCLmean = tmpCI$percent[4],
                   UCLmean = tmpCI$percent[5])
  }
  if (useBootCImethod == "basic") {
    retVal <- list(obsmean = as.numeric(tmpBootRes$t0),
                   LCLmean = tmpCI$basic[4],
                   UCLmean = tmpCI$basic[5])
  }
  if (useBootCImethod == "bca") {
    retVal <- list(obsmean = as.numeric(tmpBootRes$t0),
                   LCLmean = tmpCI$bca[4],
                   UCLmean = tmpCI$bca[5])
  }
  if (useBootCImethod == "norm") {
    retVal <- list(obsmean = as.numeric(tmpBootRes$t0),
                   LCLmean = tmpCI$normal[2],
                   UCLmean = tmpCI$normal[3])
  }
  retVal
}
