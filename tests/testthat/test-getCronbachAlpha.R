options(digits = 22)
### test the sanity checks

set.seed(12345)
tmpMat <- matrix(rnorm(200), ncol = 10)
tmpDat <- as.data.frame(tmpMat)
tmpTib <- as_tibble(tmpDat)

testthat::test_that("sanity checks work", {
  ### sanity check 1: correct class of data
  testthat::expect_error(getChronbachAlpha(1:20))
  ### sanity check 2: at least 3 columns of data
  testthat::expect_error(getChronbachAlpha(tmpMat[, 1:2]))
  ### sanity check 3: data numeric
  tmpDat2 <- tmpDat
  tmpDat2$V2 <- as.character(tmpDat2)
  testthat::expect_error(getChronbachAlpha(as.character(tmpMat)))
  testthat::expect_error(getChronbachAlpha(tmpDat2))
  testthat::expect_error(getChronbachAlpha(as_tibble(tmpDat2)))
  ### sanity check 4: at least three rows of data
  testthat::expect_error(getChronbachAlpha(tmpMat[1:2, ]))
  ### sanity check 5: need variance in all columns
  tmpMat2 <- tmpMat
  tmpMat2[, 3] <- 3
  testthat::expect_error(getChronbachAlpha(tmpMat2))
  tmpMat2[, 5] <- 5
  testthat::expect_error(getChronbachAlpha(tmpMat2))
  ### sanity check 6
  testthat::expect_error(getChronbachAlpha(tmpMat2, verbose = "A"))
  ### sanity check 7
  testthat::expect_error(getChronbachAlpha(tmpMat2, na.rm = "A"))
  ### test action of na.rm == FALSE
  tmpMat2 <- tmpMat
  tmpMat2[5, 4] <- NA
  testthat::expect_error(getChronbachAlpha(tmpMat2, na.rm = FALSE))
})

### no warnings in the function to test

### test outputs

set.seed(12345)
tmpVec <- rnorm(50)
tmpVec2 <- rnorm(500, sd = .1)
tmpVec3 <- tmpVec2 + rep(tmpVec, 10)
tmpMat2 <- matrix(tmpVec3, ncol = 10)
getChronbachAlpha(tmpMat2) # 0.9991783599470590582214
testthat::test_that("Output correct", {
  testthat::expect_equal(getChronbachAlpha(tmpMat, verbose = FALSE), -0.0591636462463945231316)
  testthat::expect_equal(getChronbachAlpha(tmpMat2, verbose = FALSE), 0.9991783599470590582214)
})
rm(list = ls(pattern = glob2rx("tmp*")))
