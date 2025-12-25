testthat::test_that("sanity checks work", {
  ### test pVal
  testthat::expect_error(getLastDateInMonth(2))
  testthat::expect_error(getLastDateInMonth("x"))
})


### test of outputs
testthat::test_that("Output correct", {
  testthat::expect_equal(getLastDateInMonth(as.Date(c("15/02/1975",  "15/02/1976"),
                                                    format = "%d/%m/%Y")),
                         c(1884, 2250))
})
