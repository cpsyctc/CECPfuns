testthat::test_that("sanity checks work", {
  ### vecDat
  testthat::expect_error(getCIforQuantiles(vecDat = "a"))
  testthat::expect_error(getCIforQuantiles(vecDat = TRUE))
  testthat::expect_error(getCIforQuantiles(vecDat = 1:5))
  testthat::expect_warning(getCIforQuantiles(vecDat = 1:24,
                                             vecQuantiles = c(.1, .9),
                                             method = "e",
                                             ci = .95,
                                             R = 9999,
                                             type = 8))
  ### vecQuantiles
  testthat::expect_error(getCIforQuantiles(vecDat = 1:100, vecQuantiles = "A"))
  testthat::expect_error(getCIforQuantiles(vecDat = 1:100, vecQuantiles = NA))
  testthat::expect_error(getCIforQuantiles(vecDat = 1:100, vecQuantiles = -.5))
  testthat::expect_error(getCIforQuantiles(vecDat = 1:100, vecQuantiles = 1.5))
  ### method
  testthat::expect_error(getCIforQuantiles(vecDat = 1:100, vecQuantiles = c(.1, .9), method = "sausages"))
  ### ci
  testthat::expect_error(getCIforQuantiles(vecDat = 1:100, vecQuantiles = c(.1, .9), ci = NA))
  testthat::expect_error(getCIforQuantiles(vecDat = 1:100, vecQuantiles = c(.1, .9), ci = "A"))
  testthat::expect_error(getCIforQuantiles(vecDat = 1:100, vecQuantiles = c(.1, .9),ci = c(.5, .9)))
  testthat::expect_error(getCIforQuantiles(vecDat = 1:100, vecQuantiles = c(.1, .9), ci = 1.5))
  testthat::expect_error(getCIforQuantiles(vecDat = 1:100, vecQuantiles = c(.1, .9), ci = .5))
  ### bootstrap
  testthat::expect_error(getCIforQuantiles(vecDat = 1:100, vecQuantiles = c(.1, .9), method = "B", R = "A", type = 8))
  testthat::expect_error(getCIforQuantiles(vecDat = 1:100, vecQuantiles = c(.1, .9), method = "B", R = NA))
  testthat::expect_error(getCIforQuantiles(vecDat = 1:100, vecQuantiles = c(.1, .9), method = "B", R = 1:2))
  testthat::expect_error(getCIforQuantiles(vecDat = 1:100, vecQuantiles = c(.1, .9), method = "B", R = 5))
  testthat::expect_error(getCIforQuantiles(vecDat = 1:100, vecQuantiles = c(.1, .9), method = "B", R = 50000, type = 8))
  ### type
  testthat::expect_warning(getCIforQuantiles(vecDat = 1:100, vecQuantiles = c(.1, .9), type = NA))
  testthat::expect_warning(getCIforQuantiles(vecDat = 1:100, vecQuantiles = c(.1, .9), type = NULL))
  testthat::expect_warning(getCIforQuantiles(vecDat = 1:100, vecQuantiles = c(.1, .9), type = "A"))
  testthat::expect_warning(getCIforQuantiles(vecDat = 1:100, vecQuantiles = c(.1, .9), type = 1:2))
  testthat::expect_error(getCIforQuantiles(vecDat = 1:100, vecQuantiles = c(.1, .9), type = 0))
  testthat::expect_error(getCIforQuantiles(vecDat = 1:100, vecQuantiles = c(.1, .9), type = 10))
})

### test of outputs
testthat::test_that("Output correct", {
  if (system.file(package = "quantileCI") == "") {
    install_github("hoehleatsu/quantileCI")
  }
  library(quantileCI)
  ### make results
  structure(list(prob = c(0.1, 0.5, 0.95),
                 n = c(1000L, 1000L, 1000L),
                 nOK = c(1000L, 1000L, 1000L),
                 nMiss = c(0L, 0L, 0L),
                 quantile = c(`10%` = 100.366666666667, `50%` = 500.5, `95%` = 950.65),
                 LCL = c(82L, 469L, 936L),
                 UCL = c(120L, 532L, 964L)),
            class = c("tbl_df", "tbl", "data.frame"),
            row.names = c(NA, -3L)) -> tmpRes
  ###
  ###
  ###
  testthat::expect_equal(getCIforQuantiles(vecDat = 1:1000,
                                           vecQuantiles = c(.1, .5, .95),
                                           method = "e",
                                           ci = .95,
                                           R = 9999,
                                           type = 8), tmpRes)
  ###
  ###
  ###
  structure(list(prob = c(0.1, 0.5, 0.95),
                 n = c(1000L, 1000L, 1000L),
                 nOK = c(1000L, 1000L, 1000L),
                 nMiss = c(0L, 0L, 0L),
                 quantile = c(`10%` = 100.366666666667,
                              `50%` = 500.5,
                              `95%` = 950.65),
                 LCL = c(82.3245628695377, 469.533086601701, 936.616934380174),
                 UCL = c(119.434476280789, 531.466913398299, 963.518163381601)),
            class = c("tbl_df", "tbl", "data.frame"),
            row.names = c(NA, -3L)) -> tmpRes

  testthat::expect_equal(getCIforQuantiles(1:1000,
                                           c(.1, .5, .95),
                                           method = "n",
                                           ci = .95,
                                           R = 9999,
                                           type = 8), tmpRes)
  ###
  ###
  ###
  structure(list(prob = c(0.1, 0.5, 0.95),
                 n = c(1000L, 1000L, 1000L),
                 nOK = c(1000L, 1000L, 1000L),
                 nMiss = c(0L, 0L, 0L),
                 quantile = c(`10%` = 100.366666666667,
                              `50%` = 500.5,
                              `95%` = 950.65),
                 LCL = c(83, 469.5, 936),
                 UCL = c(120, 530.5, 963)),
            class = c("tbl_df", "tbl", "data.frame"),
            row.names = c(NA, -3L)) -> tmpRes
  set.seed(12345)
  testthat::expect_equal(getCIforQuantiles(vecDat = 1:1000,
                                          vecQuantiles =  c(.1, .5, .95),
                                           method = "b",
                                           ci = .95,
                                           R = 9999,
                                           type = 8), tmpRes)

})

### tidy up
rm(list = ls(pattern = glob2rx("tmp*")))

### test comment:
### nothing to say!
