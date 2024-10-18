testthat::test_that("sanity checks work", {
  ### test nameTxt
  testthat::expect_error(fixVarNames(1, 27))
  ### test width
  testthat::expect_error(fixVarNames("V1", "1"))
  testthat::expect_error(fixVarNames(1, 1:2))
  testthat::expect_error(fixVarNames("V1", 27))
  ### test newText
  testthat::expect_error(fixVarNames("V1", 2, 1))
  testthat::expect_error(fixVarNames(1, c("A", "B")))
  testthat::expect_error(fixVarNames(1, 27,
                                     paste(paste(letters, collapse = ""),
                                           paste(LETTERS, collapse = ""),
                                           collapse = "")))
})

### test of outputs
testthat::test_that("Output correct", {
  testthat::expect_equal(fixVarNames(c("YP1", "YP2")),
                         expected = c("YP01", "YP02"))
  testthat::expect_equal(fixVarNames(c("YP1", "YP2"), 3),
                         c("YP001", "YP002"))
  testthat::expect_equal(fixVarNames(c("YP1", "YP2"), 2, "YPCORE_"),
                         c("YPCORE_01", "YPCORE_02"))
})
