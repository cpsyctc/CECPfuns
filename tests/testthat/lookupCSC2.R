testthat::test_that("sanity checks work", {
  testthat::expect_error(lookupCSCgenderAndAge(showInternalLookup = "F"))
  testthat::expect_error(lookupCSCgenderAndAge(showInternalLookup = FALSE, lookupTableName = NULL))
  testthat::expect_error(lookupCSCgenderAndAge(showInternalLookup = FALSE, lookupTableName = sausages))
  testthat::expect_error(lookupCSCgenderAndAge(lookupRef = 1))
  testthat::expect_error(lookupCSCgenderAndAge(useClinScoring = "F"))
  testthat::expect_error(lookupCSCgenderAndAge(lookupGenderVarChar = 1))
  testthat::expect_error(lookupCSCgenderAndAge(lookupAgeVarChar = 1))
  testthat::expect_error(lookupCSCgenderAndAge(lookupCSCvarChar = 1))
  testthat::expect_error(lookupCSCgenderAndAge(lookupGenderF = 1))
  testthat::expect_error(lookupCSCgenderAndAge(lookupGenderM = 1))
  testthat::expect_error(lookupCSCgenderAndAge(dataGenderVarChar= 1))
  testthat::expect_error(lookupCSCgenderAndAge(dataAgeVarChar= 1))
  testthat::expect_error(lookupCSCgenderAndAge(dataGenderF = 1))
  testthat::expect_error(lookupCSCgenderAndAge(dataGenderF = ""))
  testthat::expect_error(lookupCSCgenderAndAge(dataGenderF = NA))
  testthat::expect_error(lookupCSCgenderAndAge(dataGenderM = 1))
  testthat::expect_error(lookupCSCgenderAndAge(dataGenderM = ""))
  testthat::expect_error(lookupCSCgenderAndAge(dataGenderM = NA))
  testthat::expect_error(lookupCSCgenderAndAge(dataGenderO = 1))
  testthat::expect_error(lookupCSCgenderAndAge(dataGenderO = ""))
  testthat::expect_error(lookupCSCgenderAndAge(dataGenderO = NA))
  testthat::expect_error(lookupCSCgenderAndAge(dataAgeNA = "s"))
  testthat::expect_error(lookupCSCgenderAndAge(outputCSCvarChar = 1))

  testthat::expect_error(lookupCSCgenderAndAge(useInternalLookup = 1))
  testthat::expect_error(lookupCSCgenderAndAge(useInternalLookup = "sausages"))
  testthat::expect_error(lookupCSCgenderAndAge(overwriteExistingVariable = "F"))
})
### test warnings
# testthat::test_that("sanity checks work", {
#   testthat::expect_warning(lookupCSCgenderAndAge(.5, 10))
# })

### test of outputs
# testthat::test_that("Output correct", {
#   set.seed(12345)
#   testthat::expect_equal(lookupCSCgenderAndAge(.5, 50),
#                          c(LCL = 0.233827406055309, UCL = 0.696452302146405))
# })


