options(digits = 22)

### test the sanity checks
testthat::test_that("sanity checks work", {
  ### 1
  testthat::expect_error(classifyRCIfromScores(verbose = "a"))
  ### sanity check 2
  ### if (length(RCI) != 1 | !is.numeric(RCI) | RCI < .Machine$double.eps)
  testthat::expect_error(suppressWarnings(classifyRCIfromScores(RCI = 1:2)))
  testthat::expect_error(classifyRCIfromScores(RCI = "A"))
  testthat::expect_error(classifyRCIfromScores(RCI = 0))
  ### sanity check 3
  ### nNulls <- is.null(scoreChange) + is.null(score1) + is.null(score2)
  ###  if (nNulls == 3)
  testthat::expect_error(classifyRCIfromScores())
  testthat::expect_error(classifyRCIfromScores(scoreChange = NULL))
  testthat::expect_error(classifyRCIfromScores(scoreChange = 1:5, score1 = 1:5))
  testthat::expect_error(classifyRCIfromScores(scoreChange = 1:5, score2 = 1:5))
  testthat::expect_error(classifyRCIfromScores(scoreChange = 1:5, score1 = 1:5, score2 = 1:5))
  ### sanity check 4
  ### if (nNulls == 1) {
  ###   if (!is.numeric(score1) | !is.vector(score1))
  testthat::expect_error(classifyRCIfromScores(score1 = letters[5], score2 = 1:5))
  testthat::expect_error(classifyRCIfromScores(score1 = 1, score2 = 1))
  testthat::expect_error(classifyRCIfromScores(score2 = letters[5], score1 = 1:5))
  ### sanity check 5
  ### if(length(score1) != length(score2))
  testthat::expect_error(classifyRCIfromScores(score2 = 1, score1 = 1:5))
  ### sanity check 6
  ### check scoreChange
  ### if (!is.numeric(scoreChange))
  testthat::expect_error(classifyRCIfromScores(scoreChange = letters))
  ### sanity check 6
  ### cueing <- match.arg(cueing, c("negative", "positive"))
  testthat::expect_error(classifyRCIfromScores(cueing = "sausages"))
  ### sanity check 7
  ### if (length(dp)!= 1 | !is.numeric(dp) | dp < 0)
  testthat::expect_error(classifyRCIfromScores(dp = "A"))
  testthat::expect_error(classifyRCIfromScores(dp = 1:2))
  testthat::expect_error(classifyRCIfromScores(dp = -1))
  ### sanity check 8
  ### if (length(returnTable) != 1 | !is.logical(returnTable))
  testthat::expect_error(classifyRCIfromScores(returnTable = c(FALSE, TRUE)))
  testthat::expect_error(classifyRCIfromScores(returnTable = "A"))
})



### test warnings
testthat::test_that("sanity checks work", {
  ### 1
  testthat::expect_warning(classifyRCIfromScores(scoreChange = c(1:5, NA, 1:5),
                                                 RCI = 2))
  testthat::expect_warning(classifyRCIfromScores(score1 = c(1:5, NA, 1:5),
                                                 score2 = 1:11,
                                                 RCI = 2))
  testthat::expect_warning(classifyRCIfromScores(score2 = c(1:5, NA, 1:5),
                                                 score1 = 1:11,
                                                 RCI = 2))
})


### test outputs
testthat::test_that("Output correct", {
  ### uses internal data stored in ./R/sysdata.rda
  testthat::expect_equal(suppressMessages(classifyRCIfromScores(scoreChange = scoreChange5to5,
                                               RCI = 1.5)), tibRCI5to5)
  testthat::expect_equal(suppressWarnings(classifyRCIfromScores(scoreChange = scoreChange5to5NA,
                                               RCI = 1.5)), tibRCI5to5NA)
})

