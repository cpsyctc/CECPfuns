### test the sanity checks
### pretty obsessional doing this but I like it!
testthat::test_that("sanity checks work", {
  ###
  ### sanity check 1
  # if(!is.numeric(corr) | length(corr) != 1 | corr < 0 | corr > 1) {
  testthat::expect_error(plotCIPearson(corr = "A"))
  testthat::expect_error(suppressWarnings(plotCIPearson(corr = 1:2)))
  testthat::expect_error(plotCIPearson(corr = -.1))
  testthat::expect_error(plotCIPearson(corr = 1.1))
  ###
  ### sanity check 2: conf must be sensible
  # if (!is.numeric(conf) | conf <= 0 | conf > .999) {
  testthat::expect_error(plotCIPearson(conf = "a"))
  testthat::expect_error(plotCIPearson(conf = 0))
  testthat::expect_error(plotCIPearson(conf = .9999))
  ###
  ### sanity check 3: minN must be sensible
  # if(!is.numeric(minN) | length(minN) != 1 | minN < 5 | minN > 1000 | minN > maxN) {
  testthat::expect_error(plotCIPearson(minN = "a"))
  testthat::expect_error(suppressWarnings(plotCIPearson(minN = 1:2)))
  testthat::expect_error(plotCIPearson(minN = 4))
  testthat::expect_error(plotCIPearson(minN = 1001))
  testthat::expect_error(plotCIPearson(minN = 20, maxN = 10))
  ###
  ### sanity check 4: maxN must be sensible
  # if(!is.numeric(maxN) | length(maxN) != 1 | maxN < 5 | maxN > 1000 | minN > maxN) {
  testthat::expect_error(plotCIPearson(maxN = "a"))
  testthat::expect_error(suppressWarnings(plotCIPearson(maxN = 1:2)))
  testthat::expect_error(plotCIPearson(maxN = 4))
  testthat::expect_error(plotCIPearson(maxN = 10001))
  testthat::expect_error(plotCIPearson(minN = 20, maxN = 10))
  ###
  ### sanity check 5: step must be sensible
  # if(!is.numeric(step) | length(step) != 1 | step < 1 | step > 100) {
  testthat::expect_error(plotCIPearson(step = "a"))
  testthat::expect_error(suppressWarnings(plotCIPearson(step = 1:2)))
  testthat::expect_error(plotCIPearson(step = 0.5))
  testthat::expect_error(plotCIPearson(step = 101))
  ###
  ### sanity check 6: number of points on x axis must be sensible
  testthat::expect_error(plotCIPearson(minN = 5, maxN = 900))
  ###
  ### sanity check 7
  ### if (!is.null(minY)) {
  ###  if (length(minY) != 1 | !is.numeric(minY) | minY < -1 | minY > .99) {
  testthat::expect_error(suppressWarnings(plotCIPearson(minY = 1:2)))
  testthat::expect_error(plotCIPearson(minY = "A"))
  testthat::expect_error(plotCIPearson(minY < -1))
  testthat::expect_error(plotCIPearson(minY > .99))
  ###
  ### sanity check 9
  ### if (!is.null(maxY)) {
  ###  if (length(maxY) != 1 | !is.numeric(maxY) | maxY < -.99 | maxY > 1) {
  testthat::expect_error(suppressWarnings(plotCIPearson(maxY = 1:2)))
  testthat::expect_error(plotCIPearson(maxY = "A"))
  testthat::expect_error(plotCIPearson(maxY < -.99))
  testthat::expect_error(plotCIPearson(maxY > 1))
  ###
  ### sanity check 10
  testthat::expect_error(plotCIPearson(minY = .1, maxY = -.1))
})

### there are no warnings to test
### I have not (as yet, perhaps never) created any test of the ggplot output
### feels too likely that it will change with tweaks of gpplot

### test comment:
### nothing to say!
