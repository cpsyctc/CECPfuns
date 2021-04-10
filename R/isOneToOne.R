#' Data checking function to check if the contents of two variables have a 1:1 mapping
#'
#' @param x first variable
#' @param y second variable
#'
#' @return logical: TRUE if 1:1 mapping, FALSE otherwise
#' @export
#'
#' @section Background:
#' This is a little utility function that I use from time to time when I want to check
#' whether two variables have a one to one mapping they should have.  Typically this
#' is where one of them is a short code say variable x, for the other, say variable y.
#' If you have two vectors, one of the short codes, x, and one of the longer, y,
#' they should have a perfect 1:1 mapping, so for any value in x there must the same
#' number of its mapped value in y.  For example:
#'
#'   x | y
#'   --|---
#'   1 | Male
#'   2 | Female
#'   3 | Other
#'   2 | Female
#'   2 | Female
#'   1 | Male
#'   3 | Other
#' Has a perfect 1:1 mapping of x to y so, assuming that
#' I had x and y as vectors,
#' \code{isOneToOne(x, y)} will return TRUE.
#'
#'   x | y
#'   --|---
#'   1 | Male
#'   2 | Feemale
#'   3 | Other
#'   2 | Female
#'   2 | Female
#'   1 | male
#'   3 | Other
#' does not 1:1 (and isn't a completely mad example
#' of typical messes in real world data, if perhaps a very
#' simple one!) Of course, here
#' \code{isOneToOne(x, y)} will return FALSE.
#'
#'
#' @examples
#' \dontrun{
#' ### this should map OK
#' isOneToOne(1:5,letters[1:5])
#' ### 1:1 doesn't actually mean just one of each,
#' ### just that the mapping is 1:1!
#' isOneToOne(rep(1:5, 2), rep(letters[1:5], 2))
#' ### should throw an error as unequal length
#' isOneToOne(1:26, letters[1:25])
#' ### but this is OK
#' isOneToOne(1:26, c("1", letters[1:25]))
#' ### but this is not as it's no longer 1:1
#' isOneToOne(c(1, 1:26), c("1", letters[1:25], "1"))
#' ### same the other way around (essentially)
#' isOneToOne(1:26,c("a",letters[1:25]))
#' }
#'
#'
#' @section Acknowledgements:
#' I found this nice way of doing this at
#'  https://stackoverflow.com/questions/52399474/check-if-variables-are-in-a-one-to-one-mapping
#'
#' @family data checking functions
#'
#' @author Chris Evans
#'
#' @section History/development log:
#' Started before 5.iv.21
#'
isOneToOne <- function(x, y) {
  ### checking that there is a 1:1 correspondence between values of x and y
  ### uses a simplification of the plan I found in
  ###     https://stackoverflow.com/questions/52399474/check-if-variables-are-in-a-one-to-one-mapping
  ###
  ### sanity checks
  ###
  ### sanity check 1
  if (length(x) != length(y)) {
    stop("Can't be 1:1 mapping if lengths of x and y aren't the same!")
  }
  ###
  ### OK check
  ### get the crosstabulation as a matrix
  tmpMat <- as.matrix(table(x, y))
  ### if the mapping is 1:1 then for each column in that crosstabulation
  ### and each row, there can be one and only one row/column with a
  ### non-zero entry.
  ### That means that the column sums ...
  tmpVecColSums <- colSums(tmpMat)
  ### must equal the row maxima ...
  tmpVecRowMaxima <- apply(tmpMat, 2, max)
  ### return the test of that
  isTRUE(all.equal(tmpVecColSums, tmpVecRowMaxima))
}
#' @rdname isOneToOne
#' @export
checkIsOneToOne <- isOneToOne
#' @examples
#' \dontrun{
#' ### this should map OK
#' checkOneToOne(1:5,letters[1:5])
#' ### 1:1 doesn't actually mean just one of each,
#' ### just that the mapping is 1:1!
#' checkOneToOne(rep(1:5, 2), rep(letters[1:5], 2))
#' ### should throw an error as unequal length
#' checkOneToOne(1:26, letters[1:25])
#' ### but this is OK
#' checkOneToOne(1:26, c("1", letters[1:25]))
#' ### but this is not as it's no longer 1:1
#' checkOneToOne(c(1, 1:26), c("1", letters[1:25], "1"))
#' ### same the other way around (essentially)
#' checkOneToOne(1:26,c("a",letters[1:25]))
#' }
