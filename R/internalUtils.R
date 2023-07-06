#' Title Tests for NULL, NA or NAN
#'
#' @param x input to test
#'
#' @return logical TRUE if x is NULL, NA or NAN
#' @keywords internal
#' @export
#'
#' @section Background:
#' from https://stackoverflow.com/questions/19655579/a-function-that-returns-true-on-na-null-nan-in-r
#' function contributed by https://stackoverflow.com/users/2275286/hbat
isNothing <- function(x) {
  ### avoids problems with length of x > 1 throwing an error
  ### and correctly tests through the options: nice.  Thank you hbat!
  any(is.null(x))  || any(is.na(x))  || any(is.nan(x))
}
