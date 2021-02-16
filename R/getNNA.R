#' Title
#' Trivial function to count number of NA values in input
#' @param x vector
#'
#' @return numeric
#' @export
#'
#' @examples
#' getNNA(c(1:5, NA, 7:10))
#' getNNA(c(1:5, NA, 7:10))
#'
#' @family counting functions
#' @seealso \code{\link{getNOK}} for count of non-missing values
#'
getNNA <- function(x){
  sum(is.na(x))
}
