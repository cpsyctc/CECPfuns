#' function returning observed Cronbach alpha with bootstrap confidence interval around that value
#'
#' @param dat data, matrix, data frame or tibble and numeric item data as columns
#' @param verbose logical, if FALSE switches off messages
#' @param na.rm logical which causes function to throw error if there is missing data
#' @param nLT20err logical, throws error if length(na.omit(dat)) < 20, otherwise returns NA for CI
#' @param nGT10kerr logical, throws error if length(na.omit(dat)) > 10k to prevent very long rusn, override with FALSE
#' @param bootReps integer for number of bootstrap replications
#' @param conf numeric confidence interval desired as fraction, e.g. .95
#' @param bootCImethod method of deriving bootstrap CI from "perc", "norm", "basic" or "bca"
#'
#' @return list of length 3: obsAlpha, LCLAlpha and UCLAlpha
#' @export
#'
#' @examples
#' \dontrun{
#' set.seed(12345)
#' tmpMat <- matrix(rnorm(200), ncol = 10)
#' tmpDat <- as.data.frame(tmpMat)
#' tmpTib <- as_tibble(tmpDat)
#'
#' ### all default arguments
#' getBootCIalpha (tmpMat)
#' }
#'
#' @family bootstrap CI functions
#' @family Chronbach alpha functions
#'
#' @author Chris Evans
#'
getBootCIalpha  <- function(dat,
                           verbose = TRUE,
                           na.rm = TRUE,
                           nLT20err = TRUE,
                           nGT10kerr = TRUE,
                           bootReps = 1000,
                           conf = .95,
                           bootCImethod = c("perc", "norm", "basic", "bca")) {
  ### builds on trivial function getBootCIalpha ,
  ### takes data, dat
  ### removes rows with any missing data
  ### and computes Cronbach's alpha and bootstrap CI around that
  ### assuming all remaining rows of data should be used
  ### and that all columns of data should be used
  ### and assumes that all variables are already cued the same way
  ###
  ### sanity check 1
  if (!is.data.frame(dat) & !is.matrix(dat)) {
    stop("Input dat to getChronbachAlpha must be tibble, data frame or matrix")
  }
  ###
  ### sanity check 2
  if (ncol(dat) < 3) {
    stop("No point in computing alpha for just two variables")
  }
  ### turn dat to matrix (makes next checks easier)
  if (!is.matrix(dat)) {
    dat <- as.matrix(dat)
  }
  ###
  ### sanity check 3
  if (!is.numeric(dat)) {
    stop("All columns of dat submitted to getChronbachAlpha must be numeric")
  }
  ### OK, purge out missing data rowwise
  tmpN <- nrow(dat)
  dat <- na.omit(dat)
  if (!na.rm & nrow(dat) != tmpN) {
    stop("You have set na.rm to FALSE and you do have missing data so getBootCIalpha  is exiting")
  }
  ###
  ### sanity check 4
  if (nrow(dat) < 20) {
    ### the default setting of nLT20err is to throw an error for fewer than 20 usable values
    if (nLT20err) {
      stop("You won't get a stable bootstrap CI with minimum cell size < 20.")
    } else {
      ### if that is changed to FALSE, give a warning and return NAs for LCL and UCL
      warning("You won't get a stable bootstrap CI with minimum cell size < 20, returning NA for LCL and UCL.")
      return(list(obsAlpha = getChronbachAlpha(dat),
                  LCLAlpha = NA,
                  UCLAlpha = NA))
    }
  }
  ###
  ### sanity check 5
  tmpVars <- apply(dat, 2, stats::var)
  if (sum(tmpVars < .Machine$double.eps) > 0) {
    tmpColIndices <- which(tmpVars < .Machine$double.eps)
    if (length(tmpColIndices) == 1) {
      stop(paste0("You appear to have one variable, with column number ",
                  tmpColIndices,
                  " whose non-missing values have essentially zero variance: no meaningful alpha possible"))
    } else {
      stop(paste0("You appear to have variables, with column numbers\n     ",
                  paste(tmpColIndices, collapse = " "),
                  "\n whose non-missing values have essentially zero variance: no meaningful alpha possible"))
    }
  }
  ###
  ### sanity check 6
  if (!is.logical(verbose)) {
    stop("The argument verbose to getBootCIalpha () must be logical")
  }
  ###
  ### sanity check 7
  if (!is.logical(na.rm)) {
    stop("The argument na.rm to getBootCIalpha () which terminates the run if there is missing data must be logical")
  }
  ### sanity check 8
  if (!is.logical(nLT20err)) {
    stop("The argument nLT20err to getBootCIalpha () which terminates the run if there are fewer than 20 rows of non-missing data must be logical")
  }
  ### sanity check 9
  if (!is.logical(nGT10kerr)) {
    stop("The argument nLT20err to getBootCIalpha () which terminates the run if there are more than 10k rows of non-missing data must be logical")
  }
  ###
  ### sanity check 10
  if (!is.character(bootCImethod)) {
    stop("Argument bootCImethod must be character")
  }
  ###
  ### sanity check 11
  bootCImethod <- tolower(bootCImethod)
  match.arg(bootCImethod)
  ###
  ### end of sanity checking
  ###

  ### check out bootstrap method
  bootCImethod <- stringr::str_to_lower(bootCImethod)
  useBootCImethod <- match.arg(bootCImethod)

  if (verbose) {
    message("Function: getBootCImean{CECPfuns}")
    message(paste("Call:", list(match.call())))
    message(paste("Usable n = ",
                  nrow(dat),
                  " and ",
                  ncol(dat),
                  " columns."))
    message(paste("Number of bootstrap replications is:",
                  bootReps))
    message(paste("Method for computing bootstrap confidence interval is:",
                  useBootCImethod))
    message(paste("Width of confidence interval is:",
                  conf,
                  "i.e.",
                  paste0(round(100 * conf),
                         "%")))
    message(paste0("Function getBootCIalpha  returning Cronbach alpha from data with ",
                   ncol(dat),
                   " columns of data and ",
                   nrow(dat),
                   " rows with no missing data."))
  }
  ###

  tmpGetCronbachForBoot <- function(dat, i) {
    ### compute alpha
    ### after checking out a number of packaged functions:
    ###    cronbach from psyc
    ###    cronbachs_alpha from performance
    ###    alpha from psych
    ### all of which are nice and give the same results on trivial testing
    ### I have used slightly pruned code from psychometric::alpha()
    ### kudos to Thomas D. Fletcher who wrote psychometric
    ###
    ### this just indexes dat by i to feed boot::boot()
    dat <- dat[i, ]
    k <- ncol(dat)
    alpha <- (k / (k - 1)) * (1 - sum(apply(dat, 2, stats::var)) / stats::var(apply(dat, 1, sum)))
    alpha
  }

  ### now use that to do the bootstrapping
  tmpBootRes <- boot::boot(dat, # data
                           statistic = tmpGetCronbachForBoot,
                           R = bootReps) # number of bootstrap replications
  ### and now get the CI from that,
  tmpCI <- boot::boot.ci(tmpBootRes,
                         type = useBootCImethod,
                         conf = conf)
  if (useBootCImethod == "perc") {
    retVal <- list(obsAlpha = as.numeric(tmpBootRes$t0),
                   LCLAlpha = tmpCI$percent[4],
                   UCLAlpha = tmpCI$percent[5])
  }
  if (useBootCImethod == "basic") {
    retVal <- list(obsAlpha = as.numeric(tmpBootRes$t0),
                   LCLAlpha = tmpCI$basic[4],
                   UCLAlpha = tmpCI$basic[5])
  }
  if (useBootCImethod == "bca") {
    retVal <- list(obsAlpha = as.numeric(tmpBootRes$t0),
                   LCLAlpha = tmpCI$bca[4],
                   UCLAlpha = tmpCI$bca[5])
  }
  if (useBootCImethod == "norm") {
    retVal <- list(obsAlpha = as.numeric(tmpBootRes$t0),
                   LCLAlpha = tmpCI$normal[2],
                   UCLAlpha = tmpCI$normal[3])
  }
  retVal
}
