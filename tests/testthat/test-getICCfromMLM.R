# options(digits = 22)
# ### generate data
# set.seed(12345)
# n <- 6000
# list(y = rnorm(n),
#      baseline = rnorm(n),
#      service = sample(LETTERS[1:4], n, replace = TRUE),
#      therapist = paste0("Ther_", sample(1:8, n, replace = TRUE)),
#      nonsense = paste0("N_", sample(1:3, n, replace = TRUE))) %>%
#   dplyr::as_tibble() %>%
#   mutate(therapist = str_c(service, therapist),
#          nonsense = str_c(service, nonsense)) %>%
#   mutate(y = if_else(service == "A", y + .2 + rnorm(n), y),
#          y = if_else(therapist == "Ther_1", y + .4 + rnorm(n), y),
#          y = if_else(nonsense == "N_1", y + .5 + rnorm(n), y)) -> tmpDat
#
# nlme3level <- nlme::lme(fixed = y ~ 1,
#                         random = ~ 1 | service:therapist:nonsense,
#                         data = tmpDat)
# lmer3level <- lme4::lmer(y ~ 1 + (1 | service:therapist:nonsense),
#                          data = tmpDat)
#
# ### get results
# nlme2level <- nlme::lme(fixed = y ~ 1,
#                         random = ~ 1 | service/therapist,
#                         data = tmpDat)
# summary(nlme2level)
# nlme::VarCorr(nlme2level)
# getICCfromMLM(nlme2level)
#
# lmer2level <- lme4::lmer(y ~ 1 + (1 | therapist/service),
#                          data = tmpDat)
# summary(lmer2level)
# lme4::VarCorr(lmer2level)
# getICCfromMLM(lmer2level)
#
#
# ### test the sanity check
# testthat::test_that("sanity checks work", {
# # if (valClass != "lme" &
# #     valClass != "lmerMod" &
# #     valClass == "lmerModLmerTest")
#   testthat::expect_error(getICCfromMLM("sausages"))
# })
#
#
# testthat::test_that("three levels throw error", {
#   testthat::expect_error(getICCfromMLM(nlme3level))
#   testthat::expect_error(getICCfromMLM(lmer3level))
# })
#
# ### tidy up
# rm(list = ls(pattern = glob2rx("tmp*")))
#
# ### test comment:
# ###
