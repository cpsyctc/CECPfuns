testthat::test_that("sanity checks work", {
  ### vec
  testthat::expect_error(getScoreFromItems(vec = "a"))
  testthat::expect_error(getScoreFromItems(vec = TRUE))
  testthat::expect_error(getScoreFromItems(vec = 1))
  ### scoreAsMean
  testthat::expect_error(getScoreFromItems(scoreAsMean = "a"))
  testthat::expect_error(getScoreFromItems(scoreAsMean = 1:5))
  ### propProrateMin
  testthat::expect_error(getScoreFromItems(propProrateMin = NULL))
  testthat::expect_error(getScoreFromItems(propProrateMin = 1:5))
  testthat::expect_error(getScoreFromItems(propProrateMin = NA))
  testthat::expect_error(getScoreFromItems(propProrateMin = 0.1))
  testthat::expect_error(getScoreFromItems(propProrateMin = 1.2))
  testthat::expect_error(getScoreFromItems(nProrateMin = NULL))
  testthat::expect_error(getScoreFromItems(nProrateMin = 1:5))
  testthat::expect_error(getScoreFromItems(nProrateMin = NA))
  testthat::expect_error(getScoreFromItems(nProrateMin = 0.1))
  testthat::expect_error(getScoreFromItems(nProrateMin = 1.2))
  testthat::expect_error(getScoreFromItems(nProrateMin = 1, propProrateMin = .1))
  ### roundToInteger
  testthat::expect_error(getScoreFromItems(c(1,1, NA, 1, 1, 1, 0, 0), propProrateMin = .2, roundToInteger = "a"))
  testthat::expect_error(getScoreFromItems(c(1,1, NA, 1, 1, 1, 0, 0), propProrateMin = .2, roundToInteger = 1:2))
  ### replaceMissingWithFixed
  testthat::expect_error(getScoreFromItems(c(1,1, NA, 1, 1, 1, 0, 0), propProrateMin = .2, replaceMissingWithFixed = "a"))
  testthat::expect_error(getScoreFromItems(c(1,1, NA, 1, 1, 1, 0, 0), propProrateMin = .2, replaceMissingWithFixed = 1:2))
  testthat::expect_error(getScoreFromItems(c(1,1, NA, 1, 1, 1, 0, 0), propProrateMin = .2, replaceMissingWithFixed = T))
  testthat::expect_error(getScoreFromItems(c(1,1, NA, 1, 1, 1, 0, 0), propProrateMin = .2,
                                           replaceMissingWithFixed = T, replacementValue = "a"))
  testthat::expect_error(getScoreFromItems(c(1,1, NA, 1, 1, 1, 0, 0), propProrateMin = .2,
                                           replaceMissingWithFixed = T, replacementValue = 1:2))
  ### k
  testthat::expect_error(getScoreFromItems(k = "A"))
  testthat::expect_error(getScoreFromItems(k = 1))
  testthat::expect_error(getScoreFromItems(k = 2:3))
  ### k and vec
  testthat::expect_error(getScoreFromItems(vec = 1:10, k = 11))
  ### checkItemScores
  testthat::expect_error(getScoreFromItems(checkItemScores = "A", minItemScore = 0, maxItemScore = 6))
  testthat::expect_error(getScoreFromItems(checkItemScores = 1:2, minItemScore = 0, maxItemScore = 6))
  testthat::expect_error(getScoreFromItems(checkItemScores = TRUE, minItemScore = 6, maxItemScore = 0))
  testthat::expect_error(getScoreFromItems(checkItemScores = TRUE, minItemScore = 6, maxItemScore = 6))
  testthat::expect_error(getScoreFromItems(checkItemScores = TRUE, minItemScore = NA, maxItemScore = 0))
  testthat::expect_error(getScoreFromItems(checkItemScores = TRUE, minItemScore = 6, maxItemScore = NA))
  testthat::expect_error(getScoreFromItems(checkItemScores = TRUE, minItemScore = NULL, maxItemScore = 0))
  testthat::expect_error(getScoreFromItems(checkItemScores = TRUE, minItemScore = 6, maxItemScore = NULL))
})

### test of outputs
testthat::test_that("Output correct", {
  testthat::expect_equal(getScoreFromItems(vec = rep(1, 10),
                                           scoreAsMean = TRUE,
                                           nProrateMin = 1,
                                           k = 10,
                                           checkItemScores = TRUE,
                                           minItemScore =  1,
                                           maxItemScore = 5), 1)
  testthat::expect_equal(getScoreFromItems(vec = c(rep(1, 9), NA),
                                           scoreAsMean = TRUE,
                                           nProrateMin = 1,
                                           k = 10,
                                           checkItemScores = TRUE,
                                           minItemScore =  1,
                                           maxItemScore = 5), 1)
  testthat::expect_equal(getScoreFromItems(vec = 1:10,
                                           scoreAsMean = TRUE,
                                           nProrateMin = 1,
                                           k = 10,
                                           checkItemScores = TRUE,
                                           minItemScore =  1,
                                           maxItemScore = 10), 5.5)
  testthat::expect_equal(getScoreFromItems(vec = c(rep(1, 9), NA),
                                           scoreAsMean = TRUE,
                                           nProrateMin = 1,
                                           k = 10,
                                           checkItemScores = TRUE,
                                           minItemScore =  1,
                                           maxItemScore = 9), 1)
  testthat::expect_equal(getScoreFromItems(vec = c(rep(1, 8), NA, NA),
                                           scoreAsMean = TRUE,
                                           nProrateMin = 1,
                                           k = 10,
                                           checkItemScores = TRUE,
                                           minItemScore =  1,
                                           maxItemScore = 9), NA)
  testthat::expect_equal(getScoreFromItems(c(1, 1, NA, 1, 1, 1, 0, 0),
                                           propProrateMin = .2,
                                           roundToInteger = T), 1)
  testthat::expect_equal(getScoreFromItems(c(1,1, NA, 1, 1, 1, 0, 0),
                                           propProrateMin = .2,
                                           replaceMissingWithFixed = T,
                                           replacementValue = 0), .625)
  testthat::expect_equal(getScoreFromItems(c(1,1, NA, 1, 1, 1, 0, 0),
                                           scoreAsMean = FALSE,
                                           propProrateMin = .2,
                                           replaceMissingWithFixed = T,
                                           replacementValue = 0), 5)
})

### tidy up
rm(list = ls(pattern = glob2rx("tmp*")))

### test comment:
### nothing to say!
