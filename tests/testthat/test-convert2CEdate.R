### test the sanity checks

testthat::test_that("sanity check works", {
### 1
### if (!lubridate::is.Date(date)) {
  testthat::expect_error(convert2CEdate("a"))
})

### there are no warnings to test

### trivial tests of outputs
testthat::test_that("Output correct", {
  testthat::expect_equal(convert2CEdate(as.Date("1/1/2021", format = "%d/%m/%Y")), "1.i.2021")
  testthat::expect_equal(convert2CEdate(as.Date("2/1/2021", format = "%d/%m/%Y")), "2.i.2021")
})

### test comment:
### nothing to say!
