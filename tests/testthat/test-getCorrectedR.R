testthat::test_that("sanity checks work", {
  ### test obsR
  testthat::expect_error(getCorrectedR("A", .7, .7))
  testthat::expect_error(getCorrectedR(c(.9, .7), .7, .7))
  testthat::expect_error(getCorrectedR(-2, .7, .7))
  testthat::expect_error(getCorrectedR(1.2, .7, .7))
    ### test rel1
  testthat::expect_error(getCorrectedR(.9, "A", .7))
  testthat::expect_error(getCorrectedR(.9, c(.7, .8), .7))
  testthat::expect_error(getCorrectedR(.8, .0001, .7))
  testthat::expect_error(getCorrectedR(.8, 1.2, .7))
    ### test rel2
  testthat::expect_error(getCorrectedR(.9, .7, "A"))
  testthat::expect_error(getCorrectedR(.9, .7, c(.7, .8)))
  testthat::expect_error(getCorrectedR(.8, .7, .0001))
    testthat::expect_error(getCorrectedR(.8, .7, 1.2))
  ### test dp
  testthat::expect_error(getCorrectedR(.8, .7, 1.2, "A"))
  testthat::expect_error(getCorrectedR(.8, .7, 1.2, 1:2))
})

## test warnings
testthat::test_that("Test warning", {
  testthat::expect_warning(getCorrectedR(.9, .7, .7))
  testthat::expect_warning(getCorrectedR(.3, .7, .7, 8))
})


### test of outputs
testthat::test_that("Output correct", {
  set.seed(12345)
  testthat::expect_equal(getCorrectedR(.3, .7, .7),
                         0.429)
  testthat::expect_equal(getCorrectedR(.3, .7, .7, 4),
                         0.4286)
})
