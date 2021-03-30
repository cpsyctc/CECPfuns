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
### nothing to say!
