testthat::test_that("sanity checks work", {
  testthat::expect_error(getCISpearman(.9))
  testthat::expect_error(getCISpearman(n = 5))
  testthat::expect_error(getCISpearman("a"))
  testthat::expect_error(getCISpearman(r = .7, "a"))
  testthat::expect_error(getCISpearman(r = .7, 20, "c"))
  testthat::expect_error(getCISpearman(-1.2, 7))
  testthat::expect_error(getCISpearman(1.2, 7))
  testthat::expect_error(getCISpearman(.7, 2))
  testthat::expect_error(getCISpearman(.7, 5, 1))
  testthat::expect_error(getCISpearman(.7, 5, .5))
  testthat::expect_error(getCISpearman(.7, 5, FALSE, 1))
  testthat::expect_error(getCISpearman(.7, 5, FALSE, .5))
})
### test warnings
testthat::test_that("sanity checks work", {
  testthat::expect_warning(getCISpearman(.5, 10))
  testthat::expect_warning(getCISpearman(.95, 100))
})

### test of outputs
testthat::test_that("Output correct", {
  set.seed(12345)
  testthat::expect_equal(getCISpearman(.5, 50),
                         c(LCL = 0.233827406055309, UCL = 0.696452302146405))
})
testthat::test_that("Output correct", {
  set.seed(12345)
  testthat::expect_equal(getCISpearman(.5, 50, Gaussian = TRUE),
                         c(LCL = 0.241224508653415, UCL = 0.69239327300752))
})
testthat::test_that("Output correct", {
  set.seed(12345)
  testthat::expect_equal(getCISpearman(.5, 50, Gaussian = TRUE, FHP = TRUE),
                         c(LCL = 0.249579417145174, UCL = 0.68773647839708))
})
testthat::test_that("Output correct", {
  set.seed(12345)
  testthat::expect_equal(getCISpearman(.5, 50, Gaussian = FALSE, FHP = TRUE),
                         c(LCL = 0.242430383655474, UCL = 0.69172592059618))
})

