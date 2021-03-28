options(digits = 22)
### Warning: needs considerable extension to check different forms of output
###   and to add missing sanity checks

### test the sanity checks
testthat::test_that("sanity checks work", {
  ### 1
  testthat::expect_error(classifyScoresVectorByRCI(verbose = "a"))
  ### sanity check 2
  ### if (length(RCI) != 1 | !is.numeric(RCI) | RCI < .Machine$double.eps)
  testthat::expect_error(suppressWarnings(classifyScoresVectorByRCI(RCI = 1:2)))
  testthat::expect_error(classifyScoresVectorByRCI(RCI = "A"))
  testthat::expect_error(classifyScoresVectorByRCI(RCI = 0))
  ### sanity check 3
  ### nNulls <- is.null(scoreChange) + is.null(score1) + is.null(score2)
  ###  if (nNulls == 3)
  testthat::expect_error(classifyScoresVectorByRCI())
  testthat::expect_error(classifyScoresVectorByRCI(scoreChange = NULL))
  testthat::expect_error(classifyScoresVectorByRCI(scoreChange = 1:5, score1 = 1:5))
  testthat::expect_error(classifyScoresVectorByRCI(scoreChange = 1:5, score2 = 1:5))
  testthat::expect_error(classifyScoresVectorByRCI(scoreChange = 1:5, score1 = 1:5, score2 = 1:5))
  ### sanity check 4
  ### if (nNulls == 1) {
  ###   if (!is.numeric(score1) | !is.vector(score1))
  testthat::expect_error(classifyScoresVectorByRCI(score1 = letters[5], score2 = 1:5))
  testthat::expect_error(classifyScoresVectorByRCI(score1 = 1, score2 = 1))
  testthat::expect_error(classifyScoresVectorByRCI(score2 = letters[5], score1 = 1:5))
  ### sanity check 5
  ### if(length(score1) != length(score2))
  testthat::expect_error(classifyScoresVectorByRCI(score2 = 1, score1 = 1:5))
  ### sanity check 6
  ### check scoreChange
  ### if (!is.numeric(scoreChange))
  testthat::expect_error(classifyScoresVectorByRCI(scoreChange = letters))
  ### sanity check 6
  ### cueing <- match.arg(cueing, c("negative", "positive"))
  testthat::expect_error(classifyScoresVectorByRCI(cueing = "sausages"))
  ### sanity check 7
  ### if (length(dp)!= 1 | !is.numeric(dp) | dp < 0)
  testthat::expect_error(classifyScoresVectorByRCI(dp = "A"))
  testthat::expect_error(classifyScoresVectorByRCI(dp = 1:2))
  testthat::expect_error(classifyScoresVectorByRCI(dp = -1))
  ### sanity check 8
  ### if (length(returnTable) != 1 | !is.logical(returnTable))
  testthat::expect_error(classifyScoresVectorByRCI(returnTable = c(FALSE, TRUE)))
  testthat::expect_error(classifyScoresVectorByRCI(returnTable = "A"))
})



### test warnings
testthat::test_that("sanity checks work", {
  ### 1
  testthat::expect_warning(classifyScoresVectorByRCI(scoreChange = c(1:5, NA, 1:5),
                                                 RCI = 2))
  testthat::expect_warning(classifyScoresVectorByRCI(score1 = c(1:5, NA, 1:5),
                                                 score2 = 1:11,
                                                 RCI = 2))
  testthat::expect_warning(classifyScoresVectorByRCI(score2 = c(1:5, NA, 1:5),
                                                 score1 = 1:11,
                                                 RCI = 2))
})


### test outputs
testthat::test_that("Output correct", {
  ### uses internal data stored in ./R/sysdata.rda
  testthat::expect_equal(suppressMessages(classifyScoresVectorByRCI(scoreChange = scoreChange5to5,
                                               RCI = 1.5)), tibRCI5to5)
  testthat::expect_equal(suppressWarnings(classifyScoresVectorByRCI(scoreChange = scoreChange5to5NA,
                                               RCI = 1.5)), tibRCI5to5NA)
})
