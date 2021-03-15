#' Simple function to return Cronbach's alpha
#'
#' @param dat data, matrix, data frame or tibble and numeric item data as columns
#' @param verbose logical, if FALSE switches off message about n(items) and number of usable rows
#' @param na.rm logical which causes function to throw error if there is missing data
#'
#' @return Cronbach as numeric
#' @export
#'
#' @examples
#' \dontrun{
#' ### make some nonsense data
#' tmpMat <- matrix(rnorm(200), ncol = 10)
#' ### default call
#' getChronbachAlpha(tmpMat)
#' ### switch off message with dimensions of non-missing data
#' getChronbachAlpha(tmpMat, verbose = FALSE)
#' }
#'
#' @section Background:
#' Very simple function that does a fair bit of sanity checking on the input and returns Cronbach's alpha
#' which was first described comprehensively in the classic paper Cronbach (1951).  There is an extensive
#' literature criticising alpha as an index of internal consistency/reliability often, to my reading,
#' failing to note that Cronbach's original paper was quite clear about the issues.  Alpha is not a measure
#' of unidimensionality but a measure of shared covariance and there are strong arguments that it is not
#' the best indicator of internal reliability when there are marked differences in variance between items.
#' The various arguments have led many to recommend McDonald's omega as a better measure than alpha.
#' Perhaps partly because the canonical reference to McDonald's omega is to his book (McDonald, 1999) and
#' not to a paper, the literature on this is, to my mind again, a bit complicated.  There is good coverage
#' in the help for omega() in Revelle's package psych \link[psych]{omega}. Despite the complexities alpha
#' remains the most reported statistic for internal relability of multi-item measures with some good
#' reasons: it is simple, robust and never claimed to be doing things it doesn't do!
#'
#' @family Chronbach alpha functions
#'
#' @author Chris Evans
#'
#' @references
#' Cronbach, L. J. (1951). Coefficient alpha and the internal structure of tests. Psychometrika, 16(3), 297–334.
#' McDonald R. P. (1999) Test Theory: A Unified Treatment. Mahwah, NJ: Erlbaum

getChronbachAlpha <- function(dat, na.rm = TRUE, verbose = TRUE) {
  ### trivial function which takes data, dat
  ### removes rows with any missing data
  ### and computes Cronbach's alpha
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
    stop("You have set na.rm to FALSE and you do have missing data so getCronbachAlpha is exiting")
  }
  ###
  ### sanity check 4
  if (nrow(dat) < 3) {
    stop("Can't compute meaningful alpha with only two non-missing rows of data. You may see this if group_by() stratifying\nhas given you a small cell size.")
  }
  ###
  ### sanity check 5
  tmpVars <- apply(dat, 2, stats::var)
  if (sum(tmpVars < .Machine$double.eps) > 0) {
    tmpColIndices <- which(tmpVars < .Machine$double.eps)
    if (length (tmpColIndices) == 1) {
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
    stop("The argument verbose to getCronbachAlpha() must be logical")
  }
  ###
  ### sanity check 7
  if (!is.logical(na.rm)) {
    stop("Argument na.rm to getCronbachAlpha which causes function to throw error if there is missing data must be logical")
  }
  ### end of sanity checking
  ###
  if (verbose) {
    message(paste0("Function getCronbachAlpha returning Cronbach alpha from data with ",
                   ncol(dat),
                   " columns of data and ",
                   nrow(dat),
                   " rows with no missing data."))
  }
  ###
  ### compute alpha
  ### after checking out a number of packaged functions:
  ###    psyc::cronbach()
  ###    performance::cronbachs_alpha()
  ###    psych::alpha()
  ### all of which are nice and give the same results on trivial testing
  ### I have used slightly pruned code from psychometric::alpha()
  ### kudos to Thomas D. Fletcher who wrote psychometric
  nv1 <- ncol(dat)
  pv1 <- nrow(dat)
  alpha <- (nv1/(nv1 - 1)) * (1 - sum(apply(dat, 2, stats::var))/stats::var(apply(dat, 1, sum)))
  alpha
}
