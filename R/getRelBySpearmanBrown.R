#' Function using the Spearman-Brown formula to predict reliability for new length or get length for desired reliability
#'
#' @param oldRel numeric: the reliability you have
#' @param lengthRatio numeric: the ratio of the new length to the old length
#' @param newRel  numeric: the desired reliability
#' @param verbose logical: whether to give messages explaining the function
#'
#' @return numeric: either predicted reliability or desired length ratio (whichever was input as NULL)
#' @export
#'
#' @section background:
#' This is ancient psychometrics but still of some use.  It has been checked against two functions in the
#' psychometric package with gratitude.
#'
#' The background is that any multi-item measure will have overall internal reliability/consistency that is
#' a function of the mean inter-item correlations and the number of items and, for any mean inter-item
#' correlation, a longer measure will have a higher reliabilty.  The formula for the relationship was
#' published separately by both Spearman in 1910 and in the same year by Brown, who was working for Karl Pearson,
#' who had a running feud with Spearman.  See https://en.wikipedia.org/wiki/Spearman%E2%80%93Brown_prediction_formula#History
#' That also gives some arguments that the formula should really be termed the Brown-Spearman formula but I am
#' bowing to history here.
#'
#' @examples
#' \dontrun{
#' ### if you had a reliability of .8 from a measure of, say 10, items,
#' ###   what reliability might you expect from one of 34 items?
#' getRelBySpearmanBrown(.8, 3.4)
#'
#' ### if you had a reliability of .7 from 10 items how much lower
#' ###  would you expect the reliability to be from a measure of only 5 items?
#' ### from examples for psychometric::SBrel() with respect and gratitude!
#' getRelBySpearmanBrown(.7, .5, verbose = FALSE)
#'
#' ### if you have a reliability of .7, how much longer a measure do you expect
#' ###    to need for a reliability of .9?
#' ###    again with acknowledgement to psychometric::SBlength() with respect and gratitude!
#' getRelBySpearmanBrown(.7, lengthRatio = NULL, .9)
#' }
#'
#' @family converting functions
#'
#' @author Chris Evans
#'
getRelBySpearmanBrown <- function(oldRel, lengthRatio = NULL, newRel = NULL, verbose = TRUE) {
  ### simple function using Spearman-Brown (or Brown-Spearman) formula
  ### to predict reliability from reliability of existing measure (oldRel)
  ### from a measure lengthRatio times the length of that gave oldRel
  ### sanity check input
  ### sanity check 1: numeric oldRel and assume 0 < oldRel < 1
  ### as no real point in using formula for other possible values
  ### or for impossible values
  if (!is.numeric(oldRel) | length(oldRel) != 1 | oldRel <= 0 | oldRel >= 1) {
    stop("oldRel must be numeric, of length 1 and 0 <= oldrel <= 1")
  }
  ### sanity check 2: check you're only being asked for one answer!
  if (sum(is.null(lengthRatio), is.null(newRel)) != 1) {
    stop("One and only one of lengthRatio or newRel must be NULL")
  }
  ### sanity check 3: check lengthRatio
  if (!is.null(lengthRatio)) {
    if (!is.numeric(lengthRatio) | length(lengthRatio) != 1 | lengthRatio <=0) {
      stop("If not null (sought) then lengthRatio must be numeric of length 1 and > 0")
    }
  }
  ### sanity check 4: check newRel
  if (!is.null(newRel)) {
    if (!is.numeric(newRel) | length(newRel) != 1 | newRel <=0) {
      stop("If not null (sought) then lengthRatio must be numeric of length 1 and > 0")
    }
  }
  ### sanity check 5: check verbose!
  if (!is.logical(verbose)) {
    stop("Somehow your arguments have resulted in a value for verbose that is not a logical")
  }
  ### end of sanity checking
  if (verbose)  {
    message("Function: getRelBySpearmanBrown{CECPfuns}")
    message(paste("Call:", list(match.call())))
  }
  if (is.null(newRel)) {
    ### seeking a predicted new value
    if (verbose) {
      message(paste0("Returning predicted reliability for measure ",
                     lengthRatio,
                     "x that of measure that had reliability ",
                     oldRel))
    }
    newRel <- lengthRatio * oldRel / (1 + (lengthRatio - 1) * oldRel)
    return(newRel)
  } else {
    ### seeking a lengthRatio to give newRel from oldRel
    if (verbose) {
      message(paste0("Returning length ratio of new measure giving desired reliability ",
                     newRel,
                     " times length of measure that had reliability ",
                     oldRel))
    }
    lengthRatio <- newRel * (1 - oldRel) / (oldRel * (1 - newRel))
    return(lengthRatio)
  }
}

