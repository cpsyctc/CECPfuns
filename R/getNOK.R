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
#' @seealso \code{\link{getNNA}} for count of missing values
#'
#' @author Chris Evans
#'
getNOK <- function(x){
  sum(!is.na(x))
}


