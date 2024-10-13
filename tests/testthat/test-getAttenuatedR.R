testthat::test_that("sanity checks work", {
  ### test unattR
  testthat::expect_error(getAttenuatedR("A", .7, .7))
  testthat::expect_error(getAttenuatedR(c(.9, .7), "A", .7))
  testthat::expect_error(getAttenuatedR(-2, .7, .7))
  testthat::expect_error(getAttenuatedR(1.2, .7, .7))

  ### test rel1
  testthat::expect_error(getAttenuatedR(.9, "A", .7))
  testthat::expect_error(getAttenuatedR(.9, c(.7, .8), .7))
  testthat::expect_error(getAttenuatedR(.8, .0001, .7))
  testthat::expect_error(getAttenuatedR(.8, 1.2, .7))
  ### test rel2
  testthat::expect_error(getAttenuatedR(.9, .7, "A"))
  testthat::expect_error(getAttenuatedR(.9, .7, c(.7, .8)))
  testthat::expect_error(getAttenuatedR(.8, .7, .0001))
  testthat::expect_error(getAttenuatedR(.8, .7, 1.2))
  ### test dp
  testthat::expect_error(getAttenuatedR(.8, .7, 1.2, "A"))
  testthat::expect_error(getAttenuatedR(.8, .7, 1.2, 1:2))
})

## test warnings
testthat::test_that("Test warning", {
  testthat::expect_warning(getAttenuatedR(.3, .7, .7, 8))
})

### test of outputs
testthat::test_that("Output correct", {
  set.seed(12345)
  testthat::expect_equal(getAttenuatedR(.9, .7, .7),
                         .63)
  testthat::expect_equal(getAttenuatedR(.7, .7, .8, 5),
                         .52383)
})
