#' Get ICC for levels in multilevel models
#'
#' @param modelOutput output from nlme::lme(), lme4::lmer() or lmerTest::lmer()
#' @param percent logical determining whether or to output percentage of variance as well as ICC
#'
#' @return a tibble containing the ICCs for each level in the MLM model output and, if percent == TRUE, the percentages of variance too
#' @export
#'
#' @importFrom stringr str_split
#' @importFrom stringr str_replace
#' @importFrom stringr str_trim
#' @importFrom stringr str_c
#' @importFrom dplyr arrange
#' @importFrom dplyr desc
#' @importFrom dplyr row_number
#' @importFrom stringr fixed
#'
#' @section Background:
#' 6.iii.21: Do not use with nlme::lme().  This works for lme4::lmer() or lmerTest::lmer() but I
#' cannot sort out issues about results in out of nlme::lme() differing from those of lme4::lmer()
#'
#' The ICC gives the proportion of all variance on dependent variable in Multi-Level Models (MLMs).  I my field
#' multilevel models typically have levels of measurements points for individual participants and participants
#' can be nested within therapist, service, organisation or perhaps area.  Crucially the MLM handles the
#' non-independence of observations within the "level".  Typically, again, there may be fixed predictors
#' on which all participants have a value, e.g. gender, age, social deprivation, previous therapy.  Apart
#' from handling non-independence of observations so that Standard Errors of estimates, or (sometimes, not
#' with lme4::lmer()) p-values are robust to the non-independence, the other huge power of MLMs is that
#' they can have random effects, so that instead of assuming that all participants have the same starting
#' score on a measure they can be allowed to have different starting scores which the MLM algorithm will
#' estimate.  Perhaps even more importantly, they can fit a model in which it is not assumed that every
#' participant's score will change at the same rate but that slope of score against time can be another
#' random variable.
#'
#' ICCs are important where you have multiple levels in your model and help you decide how much variance
#' is shared within the level.  A good way to think about the ICC, as described in help for the
#' specr::icc_specs() help is that the ICC is the mean correlation across any possible pairs of scores
#' on the dependent variable within the level.  Typically, fitting MLMs to therapy change score
#' trajectories the participant level will have a much higher ICC than, say, the service level.  However,
#' it may be clear that there is similarity between participants within services with a non-trivial ICC
#' for the service level.
#'
#' The specr::icc_specs() function, which I leant on heavily in writing my own function, only works for
#' MLM output from lme4::lmer() so all this function adds really is that it handles output from nlme::lme()
#' which actually structures its output substantially differently from that of lme4::lmer().
#'
#' @section Cautionary note:
#' This is really not my expert area and I think there are quite varied views of what ICCs with multiple
#' fixed predictors mean, and even more varied views even about whether ICCs can be meaningful for MLMs
#' with random predictors so this function is only designed for intercept only MLMs, i.e. with no
#' fixed predictors nor random predictors.  For typical therapy change data I think this is probably all
#' we need: it tells us about the partitioning of scores within participants and within whatever other
#' levels you have: therapists, services etc.
#'
#' On cursory testing the function gives the same results as specr::icc_specs() for two level and
#' three level MLMs from lme4::lmer() and the same results when the same data are put through
#' analysis using the same models in nlme::lme().  As ever, there is no warranty on this function!
#'
#' @examples
#' \dontrun{
#' getICCfromMLM(model2nlmer)
#' getICCfromMLM(model2lme4)
#' ### check against specr::icc_specs()
#' specr::icc_specs(model2lme4)
#' }
#'
#' @author Chris Evans
#'
#' @section History/development log:
#' Started before 5.iv.21
#'
getICCfromMLM <- function(modelOutput, percent = TRUE) {
  ### function modelled on specr::icc_specs()
  ### but extended to handle model output from lme4::lmer() (as specr::icc_specs() does)
  ### and from nlme::lme()
  ### a bit of a mess as the two packages both have the vital VarCorr() function we
  ### need for the ICC, but nlme::VarCorr() and lme4::VarCorr() have quite different
  ### structures
  ###
  ### this is a trick to suppress notes about undefined global variables
  ICC <- Variance <- grp <- perc <- vcov <- NULL
  ###
  ### now start by creating a fork based on what function created the output
  valClass <- class(modelOutput)
  ### sanity check
  if (valClass != "lme" &
      valClass != "lmerMod" &
      valClass == "lmerModLmerTest") {
    stop("Your input to getICCfromMLM() doesn't appear to have come from nlme::lme(), lme4::lmer() or lmerTest::lmer() so I'm stumped.")
  }
  ###
  ### OK, that's the end of the sanity checking!
  ###
  if (valClass == "lme") {
    ### so output is from nlme::lme()
    tmpValTest <- str_split(as.character(modelOutput$call)[4], stringr::fixed("|"))[[1]][1]
    if (tmpValTest != "~1 ") {
      print(modelOutput$call)
      print(tmpValTest)
      stop("Sorry, I haven't fixed ICClme2 to handle random predictors")
    }
    tmpVarCorr <- nlme::VarCorr(modelOutput)
    print(tmpVarCorr)
    class(tmpVarCorr) <- "matrix"
    print(tmpVarCorr)
    tmpVarCorr %>%
      tibble::as_tibble(rownames = "grp") %>%
      ### now sort out the names
      dplyr::mutate(grp = dplyr::if_else(grp == "(Intercept)",
                                         dplyr::lag(grp),
                           grp),
             grp = stringr::str_replace(grp, stringr::fixed("="), ""),
             grp = stringr::str_trim(grp)) %>%
      dplyr::filter(Variance != "pdLogChol(1)") %>%
      dplyr::mutate(Variance = as.numeric(Variance)) -> tmpVarCorr
    ### now get the total variance
    tmpVarCorr %>%
      dplyr::summarise(totVar = sum(Variance)) %>%
      dplyr::pull() -> totVar
    if (percent) {
      tmpVarCorr %>%
        dplyr::filter(grp != "Residual") %>%
        dplyr::mutate(ICC = Variance / totVar,
               perc = paste0(round(100 * ICC, 1), "%")) %>%
        dplyr::select(grp, ICC, perc) -> retVal
    } else {
      tmpVarCorr %>%
        dplyr::filter(grp != "Residual") %>%
        dplyr::mutate(ICC = Variance / totVar) %>%
        dplyr::select(grp, ICC, perc) -> retVal
    }
    ### now get the grps labelled as in output from lme4::lmer()
    retVal %>%
      dplyr::mutate(grp = dplyr::if_else(dplyr::row_number() == 2,
                           stringr::str_c(grp,
                                 ":",
                                 dplyr::lag(grp)),
                           grp)) %>%
      ### now reverse the order to match that from lme4::lmer()
      dplyr::arrange(dplyr::desc(dplyr::row_number())) -> retVal
    ################################
    ### end of nlme::lme() block ###
    ################################
  } else {
    ###########################################################
    ### so output is from lme::lmer() (or lmerTest::lmer()) ###
    ###########################################################
    if (valClass == "lmerMod" | valClass == "lmerModLmerTest") {
      ### got output from lme4::lmer() or from lmerTest::lmer()
      lme4::VarCorr(modelOutput) %>%
        tibble::as_tibble -> varEsts
      ### check that we don't have random predictors
      if (sum(is.na(varEsts$var2)) != nrow(varEsts)) {
        stop("Sorry, I haven't fixed ICClme2 to handle random predictors")
      }
      print(varEsts)
      varEsts %>%
        summarise(totVar = sum(vcov)) %>%
        pull() -> totVar
      if (percent) {
        varEsts %>%
          dplyr::filter(grp != "Residual") %>%
          dplyr::mutate(ICC = vcov / totVar,
                 perc = paste0(round(100 * ICC, 1), "%")) %>%
          dplyr::select(grp, ICC, perc) -> retVal
      } else {
        varEsts %>%
          dplyr::filter(grp != "Residual") %>%
          dplyr::mutate(ICC = vcov / totVar) %>%
          dplyr::select(grp, ICC, perc) -> retVal
      }
    }
  }
  retVal
}
