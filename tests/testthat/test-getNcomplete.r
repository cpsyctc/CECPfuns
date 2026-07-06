tmpVal <- 10

tibble(a = rnorm(tmpVal),
       b = rnorm(tmpVal),
       c = rnorm(tmpVal),
       aChar = rep("a", tmpVal),
       nums = 1:tmpVal) %>%
  mutate(a = if_else(row_number() == 1,
                     NA_real_,
                     a),
         b = if_else(row_number() == 2,
                     NA_real_,
                     b),
         c = if_else(row_number() == 3,
                     NA_real_,
                     c),
         aChar = if_else(row_number() == 4,
                         NA_character_,
                         aChar),
         nums = if_else(row_number() == 5,
                        NA_integer_,
                        nums)) -> tmpTib

testthat::test_that("sanity checks work", {
  ### data
  testthat::expect_error(getNcomplete())
  testthat::expect_error(getNcomplete(data = x))
  testthat::expect_error(getNcomplete(data = tmpVal))
  testthat::expect_error(getNcomplete(data = "a"))
  ### vars
  testthat::expect_error(getNcomplete(data = tmpTib))
  testthat::expect_error(getNcomplete(data = tmpTib, vars = z))
  testthat::expect_error(getNcomplete(data = tmpTib, vars = "z"))
  ### name
  testthat::expect_warning(getNcomplete(data = tmpTib, vars = a, name = 1))
  testthat::expect_error(getNcomplete(data = tmpTib, vars = "a", name = c("a", "b")))
  ### returnType
  testthat::expect_error(getNcomplete(data = tmpTib, vars = "a", returnType = 1))
  testthat::expect_error(getNcomplete(data = tmpTib, vars = "a", returnTypec("a", "b")))
})

### test of outputs
testthat::test_that("Output correct", {
  testthat::expect_equal(getNcomplete(tmpTib, vars = a : nums),
                         c(`a:nums` = 5L))
  testthat::expect_equal(getNcomplete(tmpTib, vars = a : c),
                         c(`a:c` = 7L))
  testthat::expect_equal(getNcomplete(tmpTib, vars = a : nums, name = "all"),
                         c(`all` = 5L))
  testthat::expect_equal(getNcomplete(tmpTib, vars = a : c, name = "all"),
                         c(`all` = 7L))
  testthat::expect_equal(getNcomplete(tmpTib, where(is.integer)),
                         c(`where(is.integer)` = 9L))
  testthat::expect_equal(getNcomplete(tmpTib, where(is.character)),
                         c(`where(is.character)` = 9L))
  ### raw number return type
  testthat::expect_equal(getNcomplete(tmpTib,
                                      vars = a : nums,
                                      returnType = "r"),
                         5L)
  testthat::expect_equal(getNcomplete(tmpTib,
                                      vars = a : c,
                                      returnType = "r"),
                         7L)
  testthat::expect_equal(getNcomplete(tmpTib,
                                      vars = a : nums,
                                      returnType = "r",
                                      name = "all"),
                         5L)
  testthat::expect_equal(getNcomplete(tmpTib,
                                      vars = a : c,
                                      returnType = "r",
                                      name = "all"),
                         7L)
  testthat::expect_equal(getNcomplete(tmpTib,
                                      where(is.integer),
                                      returnType = "r"),
                         9L)
  testthat::expect_equal(getNcomplete(tmpTib,
                                      where(is.character),
                                      returnType = "r"),
                         9L)
  ### list return type
  testthat::expect_equal(getNcomplete(tmpTib,
                                      vars = a : nums,
                                      returnType = "l"),
                         list(name = "a:nums", nComplete = 5L))
  testthat::expect_equal(getNcomplete(tmpTib,
                                      vars = a : c,
                                      returnType = "l"),
                         list(name = "a:c", nComplete = 7L))
  testthat::expect_equal(getNcomplete(tmpTib,
                                      vars = a : nums,
                                      returnType = "l",
                                      name = "all"),
                         list(name = "all", nComplete = 5L))
  testthat::expect_equal(getNcomplete(tmpTib,
                                      vars = a : c,
                                      returnType = "l",
                                      name = "all"),
                         list(name = "all", nComplete = 7L))
  testthat::expect_equal(getNcomplete(tmpTib,
                                      where(is.integer),
                                      returnType = "l"),
                         list(name = "where(is.integer)", nComplete = 9L))
  testthat::expect_equal(getNcomplete(tmpTib,
                                      where(is.character),
                                      returnType = "l"),
                         list(name = "where(is.character)", nComplete = 9L))
})

### tidy up
rm(list = ls(pattern = glob2rx("tmp*")))

### test comment:
### nothing to say!
