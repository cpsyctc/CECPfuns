### test the sanity checks
### pretty obsessional doing this but I like it!
testthat::test_that("sanity checks work", {
  ###
  ### sanity check 1
  # if(!is.numeric(proportion) | length(proportion) != 1 | proportion < 0 | proportion > 1) {
  testthat::expect_error(plotBinconf(proportion = "A"))
  testthat::expect_error(suppressWarnings(plotBinconf(proportion = 1:2)))
  testthat::expect_error(plotBinconf(proportion = -.1))
  testthat::expect_error(plotBinconf(proportion = 1.1))
  ###
  ### sanity check 2: conf must be sensible
  # if (!is.numeric(conf) | conf <= 0 | conf > .999) {
  testthat::expect_error(plotBinconf(conf = "a"))
  testthat::expect_error(plotBinconf(conf = 0))
  testthat::expect_error(plotBinconf(conf = .9999))
  ###
  ### sanity check 3: minN must be sensible
  # if(!is.numeric(minN) | length(minN) != 1 | minN < 5 | minN > 1000 | minN > maxN) {
  testthat::expect_error(plotBinconf(minN = "a"))
  testthat::expect_error(suppressWarnings(plotBinconf(minN = 1:2)))
  testthat::expect_error(plotBinconf(minN = 4))
  testthat::expect_error(plotBinconf(minN = 1001))
  testthat::expect_error(plotBinconf(minN = 20, maxN = 10))
  ###
  ### sanity check 4: maxN must be sensible
  # if(!is.numeric(maxN) | length(maxN) != 1 | maxN < 5 | maxN > 1000 | minN > maxN) {
  testthat::expect_error(plotBinconf(maxN = "a"))
  testthat::expect_error(suppressWarnings(plotBinconf(maxN = 1:2)))
  testthat::expect_error(plotBinconf(maxN = 4))
  testthat::expect_error(plotBinconf(maxN = 10001))
  testthat::expect_error(plotBinconf(minN = 20, maxN = 10))
  ###
  ### sanity check 5: step must be sensible
  # if(!is.numeric(step) | length(step) != 1 | step < 1 | step > 100) {
  testthat::expect_error(plotBinconf(step = "a"))
  testthat::expect_error(suppressWarnings(plotBinconf(step = 1:2)))
  testthat::expect_error(plotBinconf(step = 0.5))
  testthat::expect_error(plotBinconf(step = 101))
})

### there are no warnings to test
### I have not (as yet, perhaps never) created any test of the ggplot output
### feels too likely that it will change with tweaks of gpplot

### test comment:
### nothing to say!
