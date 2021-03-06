### trivial tests of outputs

testthat::test_that("Outputs OK", {
  testthat::expect_equal(getNNA(1:4), 0)
  testthat::expect_equal(getNNA(rep(1,50)), 0)
  testthat::expect_equal(getNNA(rep(NA,4)), 4)
})
