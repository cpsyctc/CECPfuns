testthat::test_that("sanity checks work", {
  ### vecDat
  testthat::expect_error(getScoreFromItems(vecDat = "a"))
  testthat::expect_error(getScoreFromItems(vecDat = TRUE))
  testthat::expect_error(getScoreFromItems(vecDat = 1:5))
  ### scoreAsMean
  testthat::expect_error(getScoreFromItems(scoreAsMean = "a"))
  testthat::expect_error(getScoreFromItems(scoreAsMean = 1:5))
  ### propProrateMin
  testthat::expect_error(getScoreFromItems(propProrateMin = NULL))
  testthat::expect_error(getScoreFromItems(propProrateMin = 1:5))
  testthat::expect_error(getScoreFromItems(propProrateMin = NA))
  testthat::expect_error(getScoreFromItems(propProrateMin = 0.1))
  testthat::expect_error(getScoreFromItems(propProrateMin = 1.2))
})

### test of outputs
# testthat::test_that("Output correct", {
#   library(quantileCI)
#   ### make results
#   structure(list(prob = c(0.1, 0.5, 0.95),
#                  n = c(1000L, 1000L, 1000L),
#                  nMiss = c(0L, 0L, 0L),
#                  quantile = c(`10%` = 100.366666666667,
#                               `50%` = 500.5,
#                               `95%` = 950.65),
#                  LCL = c(82L, 469L, 936L),
#                  UCL = c(120L, 532L, 964L)),
#             class = c("tbl_df", "tbl", "data.frame"),
#             row.names = c(NA, -3L)) -> tmpRes
#   ###
#   ###
#   ###
#   testthat::expect_equal(getScoreFromItems(vecDat = 1:1000,
#                                            vecQuantiles = c(.1, .5, .95),
#                                            method = "e",
#                                            ci = .95,
#                                            R = 9999,
#                                            type = 8), tmpRes)
#
# })

### tidy up
rm(list = ls(pattern = glob2rx("tmp*")))

### test comment:
### nothing to say!
