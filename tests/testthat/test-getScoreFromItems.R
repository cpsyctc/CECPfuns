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


})

### tidy up
rm(list = ls(pattern = glob2rx("tmp*")))

### test comment:
### nothing to say!
