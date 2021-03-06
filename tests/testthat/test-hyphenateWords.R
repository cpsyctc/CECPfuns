### test the sanity checks
### pretty obsessional doing this but I like it!
testthat::test_that("sanity checks work", {
  ### 1
  ### if (!is.logical(capitalise))
  testthat::expect_error(hyphenateWords(capitalise = "A"))
  ### 2
  ### if (!is.numeric(x))
  testthat::expect_error(hyphenateWords(x = "A"))
})

### there are no warnings to test

### trivial tests of outputs
testthat::test_that("Output correct", {
  testthat::expect_equal(hyphenateWords(1:4), c("one", "two", "three", "four") )
  testthat::expect_equal(hyphenateWords(1:4, capitalise = TRUE), c("One", "Two", "Three", "Four") )
})

### test comment:
### nothing to say!
