#' Trivial function to count number of NA values in input
#' @param x vector containing the values to check for NAs
#'
#' @return numeric: the number of NA values in
#' @export
#'
#' @examples
#' getNNA(c(1:5, NA, 7:10))
#' getNNA(c(1:5, NA, 7:10))
#'
#' @family counting functions
#' @family data checking functions
#' @seealso \code{\link{getNOK}} for count of non-missing values
#'
#' @author Chris Evans
#'
getNNA <- function(x) {
  sum(is.na(x))
}
