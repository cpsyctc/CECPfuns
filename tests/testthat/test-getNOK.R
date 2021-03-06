### trivial tests of outputs

testthat::test_that("Outputs OK", {
  testthat::expect_equal(getNOK(1:4), 4)
  testthat::expect_equal(getNOK(rep(1,50)), 50)
  testthat::expect_equal(getNOK(rep(NA,4)), 0)
})
