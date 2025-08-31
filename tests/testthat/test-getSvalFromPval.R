testthat::test_that("sanity checks work", {
  ### test pVal
  testthat::expect_error(getSvalFromPval("A", 2))
  testthat::expect_error(getSvalFromPval(c(.9, .7), 2))
  testthat::expect_error(getSvalFromPval(-2, 2))
  testthat::expect_error(getSvalFromPval(1.2, 2))

  ### test dp
  testthat::expect_error(getSvalFromPval(.8, "A"))
  testthat::expect_error(getSvalFromPval(.8, 1:2))
})


### test of outputs
testthat::test_that("Output correct", {
  testthat::expect_equal(getSvalFromPval(.05, ),
                         4.322)
  testthat::expect_equal(getSvalFromPval(.05, 5),
                         4.32193)
  testthat::expect_equal(getSvalFromPval(.2^4, 5),
                         9.28771)
})
