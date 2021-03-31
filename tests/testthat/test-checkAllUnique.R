### test the sanity checks

### set up data for tests
tmpDat <- as.data.frame(matrix(1:10, ncol = 2))

tmpDat %>%
  as_tibble() -> tmpTib

tmpDat2 <- tmpDat
tmpDat2[2, ] <- tmpDat[1, ] # make row 2 same as row 1

cbind(tmpDat, letters[1:5]) -> tmpDatMixedOK
cbind(tmpDat2, letters[1:5]) -> tmpDatMixed2

tmpDatMixedBad <- tmpDatMixed2
tmpDatMixedBad[2, 3] <- "a"

tmpDatNA <- tmpDat
tmpDatNA[2, 1] <- NA
tmpDatNA
### end of data generation

testthat::test_that("sanity check works", {
  ### sanity check 1
  ### if(allowMultipleColumns & !errIfNA){
  testthat::expect_error(checkAllUnique(allowMultipleColumns = TRUE, errIfNA = FALSE))
  ###
  ### sanity check 2
  ### if (length(dat) == 1) {
  testthat::expect_error(checkAllUnique(dat = 1))
  ###
  ### sanity check 3
  ### if (!is.data.frame(dat) & !is.vector(dat)) {
  testthat::expect_error(checkAllUnique(dat = list(1)))
  ###
  ### sanity check 4
  ### if(length(errIfNA) != 1 | !is.logical(errIfNA)) {
  testthat::expect_error(checkAllUnique(dat = 1:3, errIfNA = "A"))
  testthat::expect_error(suppressWarnings(checkAllUnique(dat = 1:3, errIfNA = 1:2)))
  ###
  ### sanity check 5
  ### if(length(allowJustOneNA) != 1 | !is.logical(allowJustOneNA)) {
  testthat::expect_error(checkAllUnique(dat = 1:3, allowJustOneNA = "A"))
  testthat::expect_error(suppressWarnings(checkAllUnique(dat = 1:3, allowJustOneNA = 1:2)))
  ###
  ### sanity check 6
  ### if(length(allowMultipleColumns) != 1 | !is.logical(allowMultipleColumns)) {
  testthat::expect_error(checkAllUnique(dat = 1:3, allowMultipleColumns = "A"))
  testthat::expect_error(suppressWarnings(checkAllUnique(dat = 1:3, allowMultipleColumns = 1:2)))
  ###
  ### now we have all the arguments can move to check input that isn't a vector
  ### sanity check 7
  testthat::expect_error(checkAllUnique(dat = tmpDat))
  testthat::expect_error(suppressWarnings(checkAllUnique(dat = tmpTib[, 1])))
  testthat::expect_error(suppressWarnings(checkAllUnique(dat = tmpTib[, 2])))
  ###
  ###
  testthat::expect_error(suppressWarnings(checkAllUnique(dat = tmpDatNA,
                                                         allowMultipleColumns = TRUE,
                                                         errIfNA = FALSE)))
})

### there are no warnings to test
testthat::test_that("warning works", {
  testthat::expect_warning(checkAllUnique(dat = tmpDat, allowMultipleColumns = TRUE))
})


### trivial tests of outputs
testthat::test_that("Output correct", {
  testthat::expect_equal(checkAllUnique(letters), TRUE)
  testthat::expect_equal(checkAllUnique(c("A", letters)), TRUE)
  testthat::expect_equal(checkAllUnique(c("a", letters)), FALSE)
  testthat::expect_equal(checkAllUnique(c(NA, letters)), FALSE)
  testthat::expect_equal(checkAllUnique(c(NA, letters), errIfNA = FALSE), TRUE)
  testthat::expect_equal(checkAllUnique(c(NA, letters, NA), errIfNA = FALSE), FALSE)
  testthat::expect_equal(checkAllUnique(c(NA, letters, NA), errIfNA = FALSE, allowJustOneNA = FALSE), TRUE)
  testthat::expect_equal(suppressWarnings(checkAllUnique(dat = tmpDat[, 1])), TRUE)
  testthat::expect_equal(suppressWarnings(checkAllUnique(dat = tmpDat[, 2])), TRUE)
  testthat::expect_equal(suppressWarnings(checkAllUnique(dat = tmpDat,
                                                         allowMultipleColumns = TRUE)), TRUE)
  testthat::expect_equal(suppressWarnings(checkAllUnique(dat = pull(tmpTib, 1))), TRUE)
  testthat::expect_equal(suppressWarnings(checkAllUnique(dat = pull(tmpTib, 2))), TRUE)
  testthat::expect_equal(suppressWarnings(checkAllUnique(dat = tmpDat2,
                                                         allowMultipleColumns = TRUE)), FALSE)
  testthat::expect_equal(suppressWarnings(checkAllUnique(dat = tmpDatMixedOK,
                                                         allowMultipleColumns = TRUE)), TRUE)
  testthat::expect_equal(suppressWarnings(checkAllUnique(dat = tmpDatMixed2,
                                                         allowMultipleColumns = TRUE)), TRUE)
  testthat::expect_equal(suppressWarnings(checkAllUnique(dat = tmpDatMixedBad,
                                                         allowMultipleColumns = TRUE)), FALSE)
  testthat::expect_equal(suppressWarnings(checkAllUnique(dat = tmpDatNA,
                                                         allowMultipleColumns = TRUE)), FALSE)
})
rm(list = ls(pattern = glob2rx("tmp*")))
