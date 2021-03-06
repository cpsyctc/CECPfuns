### test the sanity checks
testthat::test_that("sanity checks work", {
  ### 1
  ### if (!is.numeric(SD) | length(SD) != 1 | SD <= 0 )
  testthat::expect_error(getRCIfromSDandAlpha(SD = "A"))
  testthat::expect_error(suppressWarnings(getRCIfromSDandAlpha(SD = 1:2)))
  testthat::expect_error(getRCIfromSDandAlpha(SD = 0))
  ### 2
  ### if (!is.numeric(rel) | length(rel) != 1 | rel >= 1 | rel < .05)
  testthat::expect_error(getRCIfromSDandAlpha(rel = "A"))
  testthat::expect_error(suppressWarnings(getRCIfromSDandAlpha(rel = 1:2)))
  testthat::expect_error(getRCIfromSDandAlpha(rel = 1))
  testthat::expect_error(getRCIfromSDandAlpha(rel = .01))
  ### 3
  ### if (!is.numeric(conf) | conf <= 0 | conf > .999 )
  testthat::expect_error(getRCIfromSDandAlpha(conf = "A"))
  testthat::expect_error(getRCIfromSDandAlpha(rel = 0))
  testthat::expect_error(getRCIfromSDandAlpha(rel = .9999))
})

### there are no warnings to test

### trivial tests of outputs
testthat::test_that("Output correct", {
  testthat::expect_equal(getRCIfromSDandAlpha(7.5, .8, conf = 0.95), 9.296925484568419051357)
})

### test comment:
### nothing to say!
