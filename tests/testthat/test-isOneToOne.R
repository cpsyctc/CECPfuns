### test the sanity checks

testthat::test_that("sanity check works", {
### 1
### if (length(x) != length(y)) {
  testthat::expect_error(isOneToOne(1:2, 1:3))
})

### there are no warnings to test

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
### trivial tests of outputs
testthat::test_that("Output correct", {
  testthat::expect_equal(isOneToOne(1:5, letters[1:5]), TRUE)
  testthat::expect_equal(isOneToOne(rep(1:5, 2), rep(letters[1:5], 2)), TRUE)
  testthat::expect_equal(isOneToOne(1:26, c("1", letters[1:25])), TRUE)
  testthat::expect_equal(isOneToOne(c(1, 1:26), c("1", letters[1:25], "1")), FALSE)
  testthat::expect_equal(isOneToOne(1:26,c("a",letters[1:25])), FALSE)
})

### test comment:
### I did play with this:
###
# isOneToOne2 <- function(x, y) {
#   ### checking that there is a 1:1 correspondence between values of x and y
#   ### uses a simplification of the plan I found in
#   ###     https://stackoverflow.com/questions/52399474/check-if-variables-are-in-a-one-to-one-mapping
#   ###
#   ### sanity checks
#   ###
#   ### sanity check 1
#   if (length(x) != length(y)) {
#     stop("Can't be 1:1 mapping if lengths of x and y aren't the same!")
#   }
#   ###
#   ### OK check
#   if (length(unique(x)) != length(unique(y))) {
#     return(FALSE)
#   }
#   ### get the crosstabulation as a matrix
#   tmpMat <- as.matrix(table(x, y))
#   ### if the mapping is 1:1 then for each column in that crosstabulation
#   ### and each row, there can be one and only one row/column with a
#   ### non-zero entry.
#   ### That means that the column sums ...
#   tmpVecColSums <- colSums(tmpMat)
#   ### must equal the row maxima ...
#   tmpVecRowMaxima <- apply(tmpMat, 2, max)
#   ### return the test of that
#   isTRUE(all.equal(tmpVecColSums, tmpVecRowMaxima))
# }
###
### as I thought that might be faster but certainly with even large numeric x and y (length(x) = 100000) there was no speed improvement and both were very fast
