set.seed(12345)
tmpVecScore20 <- rnorm(20)
tmpVecGrp18 <- rep(1:2, 8)
list(x = rnorm(80),
     grp = rep(1:2, 40)) %>%
  dplyr::as_tibble() -> tmpDat

list(x = letters,
     grp = rep(1:2, 13)) %>%
  dplyr::as_tibble() -> tmpSillyDat

list(x = rnorm(12),
     grp = rep(1:2, 6)) %>%
  dplyr::as_tibble() -> tmpSmallDat

testthat::test_that("sanity checks work", {
  ### 1
  ### if (class(formula1) != "formula"){
  testthat::expect_error(getCSC("a"))
  ### 2
  ### if (length(formula1) != 3)
  testthat::expect_error(getCSC(y ~ x + z))
  ### 3
  ### if (length(var1) != 1 | length(var2) != 1) {
  testthat::expect_error(getCSC(y))
  testthat::expect_error(getCSC(~ x))
  testthat::expect_error(getCSC(y + x + z ~ u))
  testthat::expect_error(getCSC(y ~  + x + z))
  ### 4
  ### if (!is.numeric(scores))
  testthat::expect_error(getCSC(x ~ grp, tmpSillyDat))
  ### 5
  ### if (length(scores) != length(grp))
  testthat::expect_error(getCSC(tmpVecScore20 ~ tmpVecGrp18, data = tmpDat))
  ### 6
  ###  must have only 2 values in grp
  testthat::expect_error(getCSC(score ~ grp, data = tmpTib1))
})

### test warnings
testthat::test_that("check for warning", {
  testthat::expect_warning(getCSC(x ~ grp, tmpSmallDat))
})


### make data and results for them
set.seed(12345)
list(score1 = rnorm(50),
     grp = rep(1:2, 25)) %>%
  dplyr::as_tibble() -> tmpTib
set.seed(12345)
getCSC(score1 ~ grp,
             tmpTib) -> tmpRes

### test of outputs
testthat::test_that("Output correct", {
  set.seed(12345)
  testthat::expect_equal(getCSC(score1 ~ grp,
                                      tmpTib), tmpRes)
})

### tidy up
rm(list = ls(pattern = glob2rx("tmp*")))

### test comment:
### could add more tests for good output, not sure there's any need
