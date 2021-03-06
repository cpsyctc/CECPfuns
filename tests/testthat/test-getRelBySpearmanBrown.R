### test the sanity checks
### pretty obsessional doing this but I like it!
testthat::test_that("sanity checks work", {
  ### 1
  ### if (!is.numeric(oldRel) | length(oldRel) != 1 | oldRel <= 0 | oldRel >= 1){
  testthat::expect_error(suppressWarnings(getRelBySpearmanBrown(oldRel = 1:2))) # suppressWarnings() as warning precedes error
  testthat::expect_error(getRelBySpearmanBrown("A"))
  testthat::expect_error(getRelBySpearmanBrown(0))
  testthat::expect_error(getRelBySpearmanBrown(1))
  testthat::expect_error(getRelBySpearmanBrown(-1))
  testthat::expect_error(getRelBySpearmanBrown(NA))
  ### 2
  ### if (sum(is.null(lengthRatio), is.null(newRel)) != 1)
  testthat::expect_error(getRelBySpearmanBrown(lengthRatio = NULL, newRel = NULL))
  ### 3
  #### if (!is.numeric(lengthRatio) | length(lengthRatio) != 1 | lengthRatio <=0) {
  testthat::expect_error(getRelBySpearmanBrown(lengthRatio = "A"))
  testthat::expect_error(suppressWarnings(getRelBySpearmanBrown(oldRel = .7, lengthRatio = 1:2))) # suppressWarnings() as warning precedes error
  testthat::expect_error(getRelBySpearmanBrown(lengthRatio = 0))
  ### 4
  ### if (!is.numeric(newRel) | length(newRel) != 1 | newRel <=0)
  testthat::expect_error(getRelBySpearmanBrown(newRel = "A"))
  testthat::expect_error(getRelBySpearmanBrown(newRel = 1:2))
  testthat::expect_error(getRelBySpearmanBrown(newRel = 0))
  testthat::expect_error(getRelBySpearmanBrown(newRel = -1))
  ### 5
  ### if (!is.logical(verbose))
  testthat::expect_error(getRelBySpearmanBrown(verbose = "A"))
})

### there are no warnings to test!

### finally, test the output
testthat::test_that("Output correct", {
  testthat::expect_equal(getRelBySpearmanBrown(.8, 3.4), 0.931506849315068552464)
  testthat::expect_equal(getRelBySpearmanBrown(.7, .5), 0.5384615384615384359179)
  testthat::expect_equal(getRelBySpearmanBrown(.7, lengthRatio = NULL, .9), 3.857142857142859426745)
})

### test comment:
### those last tests were cross checked with psychometric::SBrel() and psychometric::SBlength()
