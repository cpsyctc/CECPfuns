#' Function to return bootstrap CI around observed mean
#' @param x name of variable in data, character or bare name, or simply a numeric vector if data is NULL, see examples
#' @param data data frame or tibble containing variable, NULL if x passed directly
#' @param bootReps integer for number of bootstrap replications
#' @param conf numeric confidence interval desired as fraction, e.g. .95
#' @param bootCImethod method of deriving bootstrap CI from "perc", "norm", "basic" or "bca"
#' @param na.rm logical, set to FALSE to ensure function will fail if there are missing data
#' @param verbose logical, FALSE suppresses the messages
#' @param nLT20err logical, throws error if length(na.omit(x)) < 20, otherwise returns NA for CI
#' @param nGT10kerr logical, throws error if length(na.omit(x)) > 10k to prevent very long rusn, override with FALSE
#' @param zeroSDerr logical, default is to return NA for CI if sd(x) is near zero or zero, zeroSDerr throws error
#'
#' @return list of length 3: obsmean, LCLmean and UCLmean
#' @export
#'
#' @importFrom tidyr unnest_wider
#' @importFrom dplyr mutate
#' @importFrom dplyr cur_data
#'
#' @section comment:
#' I have tried to make this function as flexible as possible in two particular ways.
#' 1. The variable on which to compute the bootstrapped CI of the mean can be fed in as a simple vector, or as a named column in a dataframe or tibble
#' 2. The function defaults to stop with an error where it might run for many hours.  However, that can be overridden with nGT10kerr = FALSE.
#' 3. Where there are insufficient non-missing values the default is to stop but again nLT20err = FALSE overrides that and returns NA for the
#' confidence limits.
#' 4. Where there is zero or near zero variance the function returns NA for the confidence limits but that can be made an error condition with zeroSDerr = TRUE.
#' 5. The function defaults (verbose = TRUE) to give quite a lot of information in messages.  Those can be switched off.
#' 4. The width of the confidence interval and the method of computing it can be set, as can the number of bootstrap resamples to run.
#'
#' As with almost all my functions in the CECPfuns package, getBootCImean() is primarily designed for use in dplyr piping.
#'
#' @examples
#' \dontrun{
#' set.seed(12345) # get replicable results
#' library(magrittr)
#' ### now make up some silly data
#' n <- 50
#' rnorm(n) %>% # get some random Gaussian data
#'   as_tibble() %>%
#'   ### create a spurious grouping variable
#'   mutate(food = sample(c("sausages", "carrots"), n, replace = TRUE),
#'          ### create variable with some missing data to test na.rm = FALSE
#'          y = if_else(value < -1, NA_real_, value)) -> tmpDat
#'
#' ### check that worked
#' tmpDat
#' ### looks fine!
#'
#' ### default arguments, just supply variable
#' getBootCImean(tmpDat$value)
#'
#' ### default arguments, select variable by name as character
#' getBootCImean("value", tmpDat))
#'
#' ### default arguments, select variable by name as bare name
#' tmpDat %>%
#'   summarise(meanCI = list(getBootCImean(value, cur_data()))) %>%
#'   unnest_wider(meanCI)
#'
#' ### default arguments, select variable by name as character
#' tmpDat %>%
#'   summarise(meanCI = list(getBootCImean("value", cur_data()))) %>%
#'   unnest_wider(meanCI)
#'
#' ### default arguments, select variable by name as bare name
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
getBootCImean <- function(x,
                          data = NULL,
                          bootReps = 1000,
                          conf = .95,
                          bootCImethod = c("perc", "norm", "basic", "bca"),
                          na.rm = TRUE,
                          verbose = TRUE,
                          nLT20err = TRUE,
                          nGT10kerr = TRUE,
                          zeroSDerr = FALSE) {

  ### function to return bootstrap CI around an observed mean for
  ### single variable fed in within a data frame or tibble, data
  ### bootReps sets the number of bootstrap replications
  ### conf sets the width of the CI
  ### uses the boot() and boot.ci() functions from the package boot, hence ...
  invisible(stopifnot(base::requireNamespace("boot")))
  invisible(stopifnot(base::requireNamespace("magrittr")))
  ### OK now some input sanity checking largely to get informative error messages
  ### if things go wrong
  ### parse the arguments
  listCall <- as.list(match.call())
  ### sort out data
  if (!is.null(listCall$data)) {
    if (!("data.frame" %in% class(data))) {
      stop("You passed non-null data argument into getBootCImean so must have 'data.frame' in class(data), i.e. should be data.frame or tibble generally.")
    }
    if (is.character(listCall$x)){
      x <- data[[x]]
    } else {
      # ### I think this will always work and just pulls the environment
      x <- eval(substitute(x), data, parent.frame())
      # x <- eval(deparse(substitute(x)), data, parent.frame())
      # x <- data[[deparse(substitute(x))]]
    }
  }
  ### sanity check 1: x must be numeric
  if (!is.numeric(x)) {
    stop("Input x to getBootCImean() must be numeric.")
  }
  ### sanity check 2: if !na.rm, stop if any missing data
  if (!na.rm & sum(is.na(x)) > 0) {
    stop("You have set na.rm = FALSE for getBootCImean and there are missing data.")
  }
  x <- na.omit(x) # now remove missing values
  ### sanity check 3: sample smaller than 20 won't give to get stable bootstrap
  if (length(x) < 20) {
    ### the default setting of nLT20err is to throw an error for fewer than 20 usable values
    if (nLT20err) {
      stop("You won't get a stable bootstrap CI with minimum cell size < 20.")
    } else {
      ### if that is changed to FALSE, give a warning and return NAs for LCL and UCL
      warning("You won't get a stable bootstrap CI with minimum cell size < 20, returning NA for LCL and UCL.")
      return(list(obsmean = mean(x),
                  LCLmean = NA,
                  UCLmean = NA))
    }
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
  ### sanity check 7: large sample?
  if (nGT10kerr == TRUE & length(x) > 10000) {
    stop("The default in getBootCImean() is to stop if length(!is.na(x)) > 10k as it may take ages to analyse.  Override with nGT10kerr = FALSE")
  }
  if (nGT10kerr == FALSE & length(x) > 10000) {
    warning("The default in getBootCImean() is to stop if length(!is.na(x)) > 10k as it may take ages to analyse.  Override with nGT10kerr = FALSE")
  }
  ### sanity check 8: negligible SD
  if (sd(x) < sqrt(.Machine$double.eps)) {
    if (zeroSDerr == TRUE) {
      stop("Negligible or zero variance in x, can't compute CI(mean)")
    } else {
      ###
      warning("Negligible or zero variance in x, can't compute CI(mean), returning NA for LCL and UCL")
      return(list(obsmean = mean(x),
                  LCLmean = NA,
                  UCLmean = NA))
    }
  }
  ### end of sanity checking
  ###
  if (verbose){
    message("Function: getBootCImean{CECPfuns}")
    message(paste("Call:", list(match.call())))
    message(paste("Usable n =", length(x)))
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
  tmpBootRes <- boot::boot(x, # data
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

