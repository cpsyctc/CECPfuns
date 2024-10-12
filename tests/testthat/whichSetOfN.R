testthat::test_that("sanity checks work", {
  testthat::expect_error(whichSetOfN(0, 3))
  testthat::expect_error(whichSetOfN(-1:3, 3))
    testthat::expect_error(whichSetOfN(3, -3))
  testthat::expect_error(whichSetOfN(3, 0))
  testthat::expect_error(whichSetOfN(3, 1))
  testthat::expect_error(whichSetOfN(3, 2.1))
})

## test warnings
testthat::test_that("sanity checks work", {
  testthat::expect_warning(whichSetOfN(.5, 10))
  testthat::expect_warning(whichSetOfN(0.2, 3))
})

### test of outputs
testthat::test_that("Output correct", {
  set.seed(12345)
  testthat::expect_equal(whichSetOfN(1:30, 9),
                         c(1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3,
                           3, 3, 3, 3, 3, 3, 3, 4, 4, 4))
})
