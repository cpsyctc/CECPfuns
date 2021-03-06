options(digits = 22)
### test the sanity checks
tmpVecx <- rnorm(20)
tmpVecxNA <- tmpVecx[c(5, 19)] <- NA
tmpVecx19 <- rnorm(19)
testthat::test_that("sanity checks work", {
  ### 1
  ### if (!is.numeric(x))
  testthat::expect_error(getBootCImean("a"))
  ### 2
  ### if (!na.rm & sum(is.na(x)) > 0)
  testthat::expect_error(getBootCImean(tmpVecxNA, n.rm = FALSE))
  ### 3
  ### sample smaller than 20 won't give to get stable bootstrap
  testthat::expect_error(getBootCImean(tmpVecx19))
  testthat::expect_error(getBootCImean(tmpVecxNA, n.rm = TRUE))
  ### 4
  ### R must be numeric and integer
  testthat::expect_error(getBootCImean(score ~ grp, data = tmpTib, bootReps = 15))
  testthat::expect_error(getBootCImean(score ~ grp, data = tmpTib, bootReps = 15.1))
  testthat::expect_error(getBootCImean(score ~ grp, data = tmpTib1))
  ### 5
  ### if (!is.numeric(conf) | conf <= 0 | conf > .999 ) {
  testthat::expect_error(getBootCImean(conf = "a"))
  testthat::expect_error(getBootCImean(conf = 0))
  testthat::expect_error(getBootCImean(conf = .9999))
  ### 6
  ### check bootCImethod, i.e. type of bootstrap CI to be used
  testthat::expect_error(getBootCImean(method = 1))
  testthat::expect_error(suppressWarnings(getBootCImean(method = letters[1:2])))
  testthat::expect_error(getBootCImean(method = "a"))
  testthat::expect_error(getBootCImean(score ~ grp, data = tmpTib3))
  ### 7
  ### if (nGT10kerr == TRUE & length(x) > 10000) {
  testthat::expect_error(getBootCImean(rep(1, 100000)))
  ### 8
  ### if (sd(x) < sqrt(.Machine$double.eps)) {
  testthat::expect_error(getBootCImean(c(rep(1, 10000000), .01), zeroSDerr = TRUE))
})

### warnings
testthat::test_that("test warnings", {
  testthat::expect_warning(getBootCImean(tmpVecx19, nLT20err = FALSE))
  testthat::expect_warning(getBootCImean(rnorm(10001),
                                         nGT10kerr = FALSE,
                                         zeroSDerr = FALSE))
  testthat::expect_warning(getBootCImean(c(rep(1, 10001), .01),
                                         nGT10kerr = FALSE,
                                         zeroSDerr = FALSE))
})





### test of outputs
testthat::test_that("Output correct", {
  ### make data and results for them
  base::requireNamespace("magrittr")
  ### now make up some silly data
  n <- 50
  set.seed(12345) # get replicable results
  rnorm(n) %>% # get some random Gaussian data
    as_tibble() %>%
    ### create a spurious grouping variable
    mutate(food = sample(c("sausages", "carrots"), n, replace = TRUE),
           ### create variable with some missing data to test na.rm = FALSE
           y = if_else(value < -1, NA_real_, value)) -> tmpDat

  ### default arguments, just supply variable
  set.seed(12345) # get replicable results
  getBootCImean(tmpDat$value,
                bootReps = 1000,
                bootCImethod = "pe") -> tmpRes

  set.seed(12345)
  tmpDat %>%
    summarise(meanCI = list(getBootCImean(value, cur_data()))) %>%
    unnest_wider(meanCI) -> tmpRes2

  ### default arguments, get mean of value by food
  set.seed(12345)
  tmpDat %>%
    group_by(food) %>%
    summarise(meanCI = list(getBootCImean(value, cur_data()))) %>%
    unnest_wider(meanCI) -> tmpRes3

  ### change bootstrap interval
  set.seed(12345)
  tmpDat %>%
    summarise(meanCI = list(getBootCImean(y,
                                          cur_data(),
                                          conf = .9))) %>%
    unnest_wider(meanCI) -> tmpRes4

  ### change bootstrap CI method ("perc" is default)
  set.seed(12345)
  tmpDat %>%
    summarise(meanCI = list(getBootCImean(y,
                                          cur_data(),
                                          verbose = TRUE,
                                          bootCImethod = "no"))) %>%
    unnest_wider(meanCI) -> tmpResNorm

  set.seed(12345)
  tmpDat %>%
    summarise(meanCI = list(getBootCImean(y,
                                          cur_data(),
                                          verbose = TRUE,
                                          bootCImethod = "ba"))) %>%
    unnest_wider(meanCI) -> tmpResBasic

  set.seed(12345)
  tmpDat %>%
    summarise(meanCI = list(getBootCImean(y,
                                          cur_data(),
                                          verbose = TRUE,
                                          bootCImethod = "bc"))) %>%
    unnest_wider(meanCI) -> tmpResBca

  set.seed(12345)
  testthat::expect_equal(getBootCImean(tmpDat$value,
                                       bootReps = 1000,
                                       ### "pe" in next line gets the percentile bootstrap CI
                                       bootCImethod = "pe"), tmpRes)
  set.seed(12345)
  testthat::expect_equal(getBootCImean(value,
                                       data = tmpDat,
                                       bootReps = 1000,
                                       ### "pe" in next line gets the percentile bootstrap CI
                                       bootCImethod = "pe"), tmpRes)
  set.seed(12345)
  testthat::expect_equal(getBootCImean("value", tmpDat), tmpRes)
  set.seed(12345)
  testthat::expect_equal(tmpDat %>%
                           summarise(meanCI = list(getBootCImean(value, cur_data()))) %>%
                           unnest_wider(meanCI), tmpRes2)
  set.seed(12345)
  testthat::expect_equal(tmpDat %>%
                           summarise(meanCI = list(getBootCImean("value", cur_data()))) %>%
                           unnest_wider(meanCI), tmpRes2)
  set.seed(12345)
  testthat::expect_equal(tmpDat %>%
                           group_by(food) %>%
                           summarise(meanCI = list(getBootCImean(value, cur_data()))) %>%
                           unnest_wider(meanCI),  tmpRes3)
  set.seed(12345)
  testthat::expect_equal(tmpDat %>%
                           summarise(meanCI = list(getBootCImean(y,
                                                                 cur_data(),
                                                                 conf = .9))) %>%
                           unnest_wider(meanCI), tmpRes4)
  set.seed(12345)
  testthat::expect_equal(tmpDat %>%
                           summarise(meanCI = list(getBootCImean(y,
                                                                 cur_data(),
                                                                 verbose = TRUE,
                                                                 bootCImethod = "no"))) %>%
                           unnest_wider(meanCI), tmpResNorm)
  set.seed(12345)
  testthat::expect_equal(tmpDat %>%
                           summarise(meanCI = list(getBootCImean(y,
                                                                 cur_data(),
                                                                 verbose = TRUE,
                                                                 bootCImethod = "ba"))) %>%
                           unnest_wider(meanCI), tmpResBasic)
  set.seed(12345)
  testthat::expect_equal(tmpDat %>%
                           summarise(meanCI = list(getBootCImean(y,
                                                                 cur_data(),
                                                                 verbose = TRUE,
                                                                 bootCImethod = "bc"))) %>%
                           unnest_wider(meanCI), tmpResBca)
})

### tidy up
rm(list = ls(pattern = glob2rx("tmp*")))

### test comment:
### nothing to say!
