### test the sanity checks
### pretty obsessional doing this but I like it!
tmpMat <- matrix(1:8, ncol = 4) # to check that matrix input throws error
testthat::test_that("sanity checks work", {
  ### 1
  ### if(!is.vector(x) | length(x) == 1 | is.list(x))
  testthat::expect_error(convertVector2sentence(list(NULL)))
  testthat::expect_error(convertVector2sentence(1))
  testthat::expect_error(convertVector2sentence(tmpMat))
  ### 2
  ###  if(!is.character(andVal) | length(andVal) > 1){
  testthat::expect_error(convertVector2sentence(andVal = 1))
  testthat::expect_error(convertVector2sentence(andVal = 1:2))
  ### 3
  ###  if(!is.character(quoteChar) | length(quoteChar) > 1){
  testthat::expect_error(convertVector2sentence(quoteChar = 1))
  testthat::expect_error(convertVector2sentence(quoteChar = 1:2))
  ### 4
  ### if (!is.logical(quoted)) {
  testthat::expect_error(convertVector2sentence(quoted = 1))
  ### 5
  ### if (!is.logical(italicY))
  testthat::expect_error(convertVector2sentence(italicY = 1))
})

### there are no warnings to test

### trivial tests of outputs
testthat::test_that("Output correct", {
  testthat::expect_equal(convertVector2sentence(1:4), "1, 2, 3 and 4")
  testthat::expect_equal(convertVector2sentence(1:4, italicY = TRUE), "*1*, *2*, *3* and *4*")
  testthat::expect_equal(convertVector2sentence(1:4, quoted = TRUE), "\"1\", \"2\", \"3\" and \"4\"")
  testthat::expect_equal(convertVector2sentence(1:4, quoted = TRUE, italicY = TRUE),"*\"1*\", \"*2*\", \"*3\"* and *\"4\"*")
  testthat::expect_equal(convertVector2sentence(1:4, andChar = ' & '), "1, 2, 3 & 4")
  testthat::expect_equal(convertVector2sentence(1:4, quoted = TRUE, quoteChar = "'"), "'1', '2', '3' and '4'")
  testthat::expect_equal(convertVector2sentence(1:4, quoted = TRUE, quoteChar = "'"), "'1', '2', '3' and '4'")
})

### clean up
rm(tmpMat)
### test comment:
### nothing to say!
