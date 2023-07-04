options(digits = 22)
### test the sanity checks

### generate some replicable nonsense data
set.seed(12345)
tmpMat <- matrix(rnorm(200), ncol = 10)
tmpDat <- as.data.frame(tmpMat)
tmpTib <- as_tibble(tmpDat)

getBootCIalpha(tmpMat)

testthat::test_that("sanity checks work", {
  ### sanity check 1: correct class of data
  testthat::expect_error(getBootCIalpha(1:20))
  ### sanity check 2: at least 3 columns of data
  testthat::expect_error(getBootCIalpha(tmpMat[, 1:2]))
  ### sanity check 3: data numeric
  tmpDat2 <- tmpDat
  tmpDat2$V2 <- as.character(tmpDat2)
  testthat::expect_error(getBootCIalpha(as.character(tmpMat)))
  testthat::expect_error(getBootCIalpha(tmpDat2))
  testthat::expect_error(getBootCIalpha(as_tibble(tmpDat2)))
  ### sanity check 4: at least three rows of data
  testthat::expect_error(getBootCIalpha(tmpMat[1:2, ]))
  ### sanity check 5: need variance in all columns
  tmpMat2 <- tmpMat
  tmpMat2[, 3] <- 3
  testthat::expect_error(getBootCIalpha(tmpMat2))
  tmpMat2[, 5] <- 5
  testthat::expect_error(getBootCIalpha(tmpMat2))
  ### sanity check 6
  testthat::expect_error(getBootCIalpha(tmpMat2, verbose = "A"))
  ### sanity check 7
  testthat::expect_error(getBootCIalpha(tmpMat2, na.rm = "A"))
  ### sanity check 8
  testthat::expect_error(getBootCIalpha(tmpMat2, nLT20err = "A"))
  ### sanity check 9
  testthat::expect_error(getBootCIalpha(tmpMat2, nGT10kerr = "A"))
  ### sanity check 10
  testthat::expect_error(getBootCIalpha(tmpMat2, bootCImethod = TRUE))
  ### sanity check 11
  testthat::expect_error(getBootCIalpha(tmpMat2, bootCImethod = "sausages"))
})

### test warnings
testthat::test_that("Warning correct", {
  testthat::expect_warning(getBootCIalpha(tmpMat[1:10, ], nLT20err = FALSE))
})


### test outputs

set.seed(12345)
tmpMat <- matrix(rnorm(200), ncol = 10)
tmpDat <- as.data.frame(tmpMat)
tmpTib <- as_tibble(tmpDat)

set.seed(12345)
# dput(getBootCIalpha(tmpMat))
set.seed(12345)
# dput(getBootCIalpha(tmpMat, bootCImethod = "norm"))
set.seed(12345)
# dput(getBootCIalpha(tmpMat, bootCImethod = "basic"))
set.seed(12345)
# dput(getBootCIalpha(tmpMat, bootCImethod = "bca"))
set.seed(12345)
# dput(getBootCIalpha(tmpMat, conf = .9))

testthat::test_that("Output correct", {
  set.seed(12345)
  testthat::expect_equal(getBootCIalpha(tmpMat, verbose = FALSE),
                         list(obsAlpha = -0.0591636462463945,
                              LCLAlpha = -1.04276842871031,
                              UCLAlpha = 0.371572233930582))
  set.seed(12345)
  testthat::expect_equal(getBootCIalpha(tmpDat, verbose = FALSE),
                         list(obsAlpha = -0.0591636462463945,
                              LCLAlpha = -1.04276842871031,
                              UCLAlpha = 0.371572233930582))
  set.seed(12345)
  testthat::expect_equal(getBootCIalpha(tmpTib, verbose = FALSE),
                         list(obsAlpha = -0.0591636462463945,
                              LCLAlpha = -1.04276842871031,
                              UCLAlpha = 0.371572233930582))
  set.seed(12345)
  testthat::expect_equal(getBootCIalpha(tmpTib, verbose = FALSE, bootCImethod = "norm"),
                         list(obsAlpha = -0.0591636462463945,
                              LCLAlpha = -0.719990833926003,
                              UCLAlpha = 0.762398795802003))
  set.seed(12345)
  testthat::expect_equal(getBootCIalpha(tmpTib, verbose = FALSE, bootCImethod = "basic"),
                         list(obsAlpha = -0.0591636462463945,
                              LCLAlpha = -0.489899526423371,
                              UCLAlpha = 0.924441136217521))
  set.seed(12345)
  testthat::expect_equal(getBootCIalpha(tmpTib, verbose = FALSE, bootCImethod = "bca"),
                         list(obsAlpha = -0.0591636462463945,
                              LCLAlpha = -0.933126402298807,
                              UCLAlpha = 0.409231501105833))
  set.seed(12345)
  testthat::expect_equal(getBootCIalpha(tmpTib, verbose = FALSE, conf = .9),
  list(obsAlpha = -0.0591636462463945,
       LCLAlpha = -0.830658040202846,
       UCLAlpha = 0.329777136311532))
})
rm(list = ls(pattern = glob2rx("tmp*")))
