testthat::test_that("sanity checks work", {
  ### 1
  ### if (class(formula1) != "formula"){
  testthat::expect_error(getBootCICSC("a"))
  ### 2
  ### if (length(formula1) != 3)
  testthat::expect_error(getBootCICSC(y ~ x + z))
  testthat::expect_error(getBootCICSC(y))
  testthat::expect_error(getBootCICSC(~ x))
  ### 3
  ### if (length(var1) != 1 | length(var2) != 1) {
  testthat::expect_error(getBootCICSC(y + x + z ~ u))
  testthat::expect_error(getBootCICSC(y ~  + x + z))
  ### if (!is.numeric(vecVar1) | !is.numeric(vecVar2)) {
  testthat::expect_error(getBootCICSC("y" + x + z ~ u))
  testthat::expect_error(getBootCICSC(y + x + z ~ "u"))
  testthat::expect_error(getBootCICSC(score ~ grp, data = tmpTib2))
  ### 4
  ###  must have only 2 values in grp
  testthat::expect_error(getBootCICSC(score ~ grp, data = tmpTib1))
  ### 5
  ### if (!is.numeric(scores)) {
  testthat::expect_error(getBootCICSC(score ~ grp, data = tmpTib3))
  ### 5 & 6
  ### smallest sample must be > 20 to get stable bootstrap
  testthat::expect_error(getBootCICSC(score ~ grp, data = tmpTib4))
  ### 7
  ### R must be numeric and integer
  testthat::expect_error(getBootCICSC(score ~ grp, data = tmpTib, bootReps = 15))
  testthat::expect_error(getBootCICSC(score ~ grp, data = tmpTib, bootReps = 15.1))
  ### 8
  ### if (!is.numeric(conf) | conf <= 0 | conf > .999 )
  testthat::expect_error(getBootCICSC(conf = "a"))
  testthat::expect_error(getBootCICSC(conf = 0))
  testthat::expect_error(getBootCICSC(conf = .9999))
  ### 9
  ### if (!bootCImethod %in% c("no", "ba", "st", "pe", "bc"))
  testthat::expect_error(getBootCICSC(method = 1))
  testthat::expect_error(suppressWarnings(getBootCICSC(method = letters[1:2])))
  testthat::expect_error(getBootCICSC(method = "a"))
})

### there are no warnings to test



### test of outputs
testthat::test_that("Output correct", {
  ### make data and results for them
  set.seed(12345)
  list(score1 = rnorm(50),
       grp = sample(1:2, 50, replace = TRUE)) %>%
    dplyr::as_tibble() -> tmpTib
  set.seed(12345)
  getBootCICSC(score1 ~ grp,
               tmpTib,
               bootReps = 1000,
               ### "pe" in next line gets the percentile bootstrap CI
               bootCImethod = "pe") -> tmpRes
  ###
  ###
  ###
  set.seed(12345)
  testthat::expect_equal(getBootCICSC(score1 ~ grp,
                                       tmpTib,
                                       bootReps = 1000,
                                       ### "pe" in next line gets the percentile bootstrap CI
                                       bootCImethod = "pe"), tmpRes)
})

### tidy up
rm(list = ls(pattern = glob2rx("tmp*")))

### test comment:
### nothing to say!
