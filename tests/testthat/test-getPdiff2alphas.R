### testing getPdiff2alphas()
testthat::test_that("sanity checks", {
  ### test for arguments
  testthat::expect_error(getPdiff2alphas())
  ### test lengths
  testthat::expect_error(getPdiff2alphas(c(.7, .8), .7, 20, 200, 150))
  testthat::expect_error(getPdiff2alphas(.7, c(.7, .8), 20, 200, 150))
  testthat::expect_error(getPdiff2alphas(.7, .8, 20:21, 200, 150))
  testthat::expect_error(getPdiff2alphas(.7, .8, 20, 200:201, 150))
  testthat::expect_error(getPdiff2alphas(.7, .8, 20, 200, 150:151))
  ### test for numeric
  testthat::expect_error(getPdiff2alphas("A", .7, 20, 200, 150))
  testthat::expect_error(getPdiff2alphas(.8, "A", 20, 200, 150))
  testthat::expect_error(getPdiff2alphas(.7, .7, "A", 200, 150))
  testthat::expect_error(getPdiff2alphas(.7, .7, 20, "A", 150))
  testthat::expect_error(getPdiff2alphas(.7, .7, 20, 200, "A"))
  ### test alpha values
  testthat::expect_error(getPdiff2alphas(-7, .7, 34, 200, 150))
  testthat::expect_error(getPdiff2alphas(7, .7, 34, 200, 150))
  testthat::expect_error(getPdiff2alphas(.7, -7, 34, 200, 150))
  testthat::expect_error(getPdiff2alphas(.7, 7, 34, 200, 150))
  ### test k value
  testthat::expect_error(getPdiff2alphas(.7, .7, 3, 200, 150))
  testthat::expect_error(getPdiff2alphas(.7, .7, 3000, 200, 150))
  ### test n values
  testthat::expect_error(getPdiff2alphas(.7, .7, 34, 2, 150))
  testthat::expect_error(getPdiff2alphas(.7, .7, 34, 20000, 150))
  testthat::expect_error(getPdiff2alphas(.7, .7, 34, 20, 3))
  testthat::expect_error(getPdiff2alphas(.7, .7, 34, 20, 20000))
})

### test of warnings
testthat::test_that("check warnings", {
  ### test for arguments
  testthat::expect_warning(getPdiff2alphas(.7, .7, 34.5, 20, 200))
  testthat::expect_warning(getPdiff2alphas(.7, .7, 34, 20.5, 200))
  testthat::expect_warning(getPdiff2alphas(.7, .7, 34, 20, 200.5))
})


### test of outputs
testthat::test_that("Output correct", {
  testthat::expect_equal(getPdiff2alphas(.7, .7, 8, 200, 150),
                         expected = 0.502352468524279)
  testthat::test_that("Output correct",
    testthat::expect_equal(getPdiff2alphas(.7, .8, 8, 200, 150),
                           expected = 0.0073145138320746))
})
