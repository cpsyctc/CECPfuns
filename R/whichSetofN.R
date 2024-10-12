#' Function that takes an index number and gives which sequential set of N it is in
#' @description
#' Finds the sequential number of sets of data when reading fixed size multirow blocks of rows.
#' @param x object to test
#' @param n size of set
#'
#' @return integer: the number of the set, 1,2,3 ...
#'
#' @family utility functions
#'
#' @section Background:
#' I am quite often importing data with a multirow nested structure so I may have data from participants
#' with different ID values and with different occasions per participant and then some fixed number of
#' rows of data per person per occasion. For one set of data I might have say four rows of medication
#' data per participant per occasion per actual medication prescribed.  I use whichSetOfN(row_number(), 4)
#' to tell me the sequential number of the prescription this row (found by row_number() inside a group_by()).
#'
#' @export
#'
#' @examples
#' whichSetOfN(1:7, 3)
#' ### shows that 1:3 belong to set 1, 4:6 to set 2 and 7 to set 3
#'
#'
#' @author Chris Evans
#' @section History/development log:
#' Started 12.x.24
#'
whichSetOfN <- function(x, n){
  ### sanity checking
  if (x[1] <= 0) {
    stop("Index number, x, must be 1 or higher")
  }
  if (abs(x[1] - round(x[1])) > .05) {
    warning(paste0("The x value you input: ",
                   x[1],
                   " is not an integer, is this really what you want?"))
  }
  if (n <= 2) {
    stop("Set size must be 2 or higher")
  }
  if (abs(n - round(n)) > .0000005) {
    stop(paste0("The n value you input: ",
                   x,
                   " is not an integer. I don't believe you meant that, the set size must be an integer."))
  }

  ### OK do the work
  if (x == 1){
    return(1)
  }
  tmpX <- 1 + (x %/% n)
  if (x[1] %% n == 0) {
    return(tmpX - 1)
  } else {
    return(tmpX)
  }
}

whichSetOfN <- Vectorize(whichSetOfN, vectorize.args = "x")
