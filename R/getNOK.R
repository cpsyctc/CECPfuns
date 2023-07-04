#' Trivial function to count number of non-NA values in input
#' @param x is a vector of values
#'
#' @return numeric: the number of non-NA values in x
#' @export
#'
#' @examples
#' getNOK(c(1:5, NA, 7:10))
#'
#' @family counting functions
#' @family data checking functions
#' @seealso \code{\link{getNNA}} for count of missing values
#'
#' @author Chris Evans
#'
#' @section History/development log:
#' Started before 5.iv.21
#'
getNOK <- function(x) {
  sum(!is.na(x))
}
