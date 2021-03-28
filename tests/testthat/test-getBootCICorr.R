### test the sanity checks
testthat::test_that("sanity checks work", {
  ### 1
  ### if (class(formula1) != "formula") {
  testthat::expect_error(getBootCICorrSD("a"))
  ### 2
  ### if (length(formula1) != 3)
  testthat::expect_error(getBootCICorrSD(y ~ x + z))
  testthat::expect_error(getBootCICorrSD(y))
  testthat::expect_error(getBootCICorrSD(~ x))
  ### 3
  ### if (length(var1) != 1 | length(var2) != 1) {
  testthat::expect_error(getBootCICorrSD(y + x + z ~ u))
  testthat::expect_error(getBootCICorrSD(y ~  + x + z))
  ### 4
  ### if (!is.numeric(vecVar1) | !is.numeric(vecVar2)) {
  testthat::expect_error(getBootCICorrSD("y" + x + z ~ u))
  testthat::expect_error(getBootCICorrSD(y + x + z ~ "u"))
  ### 5
  ### R must be numeric and integer
  ### if (!is.numeric(bootReps) | !is.wholenumber(bootReps) | bootReps < 20) {
  testthat::expect_error(getBootCICorrSD(bootReps = "a"))
  testthat::expect_error(getBootCICorrSD(bootReps = 10))
  testthat::expect_error(getBootCICorrSD(bootReps = 50.1))
  ### 6
  ### if (!is.numeric(conf) | conf <= 0 | conf > .999 )
  testthat::expect_error(getBootCICorrSD(conf = "a"))
  testthat::expect_error(getBootCICorrSD(conf = 0))
  testthat::expect_error(getBootCICorrSD(conf = .9999))
  ### 7
  ### if (!is.character(method) | length(method) != 1) {
  ### if (!method %in% c("p", "s", "k"))
  testthat::expect_error(getBootCICorrSD(method = 1))
  testthat::expect_error(suppressWarnings(getBootCICorrSD(method = letters[1:2])))
  testthat::expect_error(getBootCICorrSD(method = "a"))
  ### 8
  ### if (!is.character(method) | length(method) != 1)
  ### if (!bootCImethod %in% c("no", "ba", "st", "pe", "bc"))
  testthat::expect_error(getBootCICorrSD(method = 1))
  testthat::expect_error(suppressWarnings(getBootCICorrSD(method = letters[1:2])))
  testthat::expect_error(getBootCICorrSD(method = "a"))
})

### there are no warnings to test

### make data and results for them
set.seed(12345)
list(score1 = rnorm(50),
     score2 = rnorm(50)) %>%
  dplyr::as_tibble() -> tmpTib
# getBootCICorr(score1 ~ score2,
#               tmpTib,
#               method = "p", # gets the Pearson correlation
#               bootReps = 1000,
#               ### "pe" in next line gets the percentile bootstrap CI
#               bootCImethod = "pe") -> tmp
# dput(tmp)

tmpRes <- list(obsCorr = -0.00170735054720914, LCLCorr = -0.303274967702902,
               UCLCorr = 0.283094333272494)

### trivial tests of outputs
testthat::test_that("Output correct", {
  testthat::expect_equal(getBootCICorr(score1 ~ score2,
                                       tmpTib,
                                       method = "p", # gets the Pearson correlation
                                       bootReps = 1000,
                                       ### "pe" in next line gets the percentile bootstrap CI
                                       bootCImethod = "pe"), tmpRes)
})

### test comment:
### nothing to say!
