testthat::test_that("sanity checks work", {
  testthat::expect_error(getCIPearson(.9))
  testthat::expect_error(getCIPearson(n = 5))
  testthat::expect_error(getCIPearson("a"))
  testthat::expect_error(getCIPearson(r = .7, "a"))
  testthat::expect_error(getCIPearson(r = .7, 20, "c"))
  testthat::expect_error(getCIPearson(-1.2, 7))
  testthat::expect_error(getCIPearson(1.2, 7))
  testthat::expect_error(getCIPearson(.7, 2))
  testthat::expect_error(getCIPearson(.7, 5, 1))
  testthat::expect_error(getCIPearson(.7, 5, .5))
})
### test of outputs
testthat::test_that("Output correct", {
  set.seed(12345)
  testthat::expect_equal(getCIPearson(1, 7),
                         c(LCL = 1, UCL = 1))
})
testthat::test_that("Output correct", {
  set.seed(12345)
  testthat::expect_equal(getCIPearson(.7, 10),
                         c(LCL = 0.125833243162428, UCL = 0.922878359394515))
})
testthat::test_that("Output correct", {
  set.seed(12345)
  testthat::expect_equal(getCIPearson(.7, 100),
                         c(LCL = 0.583858098393912, UCL = 0.788064953357309))
})
testthat::test_that("Output correct", {
  set.seed(12345)
  testthat::expect_equal(getCIPearson(.7, 100, .9),
                         c(LCL = 0.604552419247413, UCL = 0.775631220332656))
})
