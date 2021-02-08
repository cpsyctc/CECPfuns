#' Title
#' Trivial function to count number of non-NA values in input
#' @param x vector
#'
#' @return numeric
#' @export
#'
#' @examples
#' getNOK(c(1:5, NA, 7:10))
getNOK <- function(x){
  sum(!is.na(x))
}
