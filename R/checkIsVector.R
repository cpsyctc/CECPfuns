#' Function to check if something is a vector, ignoring attributes
#'
#' @param x object to test
#' @noRd
#' @return logical: TRUE if x is a vector even if it has attributes
#'
#' @importFrom methods is
#'
#' @examples
#' \dontrun{
#' tmpLetters <- letters
#' is.vector(tmpLetters)
#' comment(tmpLetters) <- "Attached comment"
#' is.vector(tmpLetters) # FALSE because tmpLetters is no longer a simple vector
#' checkIsVector(tmpLetters) # TRUE
#' }
#'
#' @author Chris Evans
#' @section History/development log:
#' Started 12.iv.21
#'
checkIsVector <- function(x) {
  ### alternative to base::is.vector() where you aren't worried about a vector having additional attributes
  ### if it does base::is.vector() will return FALSE
  !is.list(x) && methods::is(x, "vector")
  ### this will return FALSE if x is a list, you may occasionally want to treat a list of length 1 as a vector
  ### use checkIsOneDim() for that
}
