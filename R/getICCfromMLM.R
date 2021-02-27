#' Get ICC for levels in multilevel models
#'
#' @param modelOutput output from nlme::lme(), lme4::lmer() or lmerTest::lmer()
#' @param percent logical determining whether or to output percentage of variance as well as ICC
#'
#' @return a tibble containing the ICCs for each level in the MLM model output and, if percent == TRUE, the percentages of variance too
#' @export
#'
#' @section Background:
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
getICCfromMLM <- function(modelOutput, percent = TRUE){
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
  if (valClass == "lme"){
    ### so output is from nlme::lme()
    if (str_split(as.character(modelOutput$call)[4], fixed("|"))[[1]][1] != "~1 ") {
      stop("Sorry, I haven't fixed ICClme2 to handle random predictors")
    }
    tmpVarCorr <- nlme::VarCorr(modelOutput)
    class(tmpVarCorr) <- "matrix"
    tmpVarCorr %>%
      as_tibble(rownames = "grp") %>%
      ### now sort out the names
      mutate(grp = if_else(grp == "(Intercept)",
                           lag(grp),
                           grp),
             grp = str_replace(grp, fixed("="), ""),
             grp = str_trim(grp)) %>%
      filter(Variance != "pdLogChol(1)") %>%
      mutate(Variance = as.numeric(Variance)) -> tmpVarCorr
    ### now get the total variance
    tmpVarCorr %>%
      summarise(totVar = sum(Variance)) %>%
      pull() -> totVar
    if (percent) {
      tmpVarCorr %>%
        filter(grp != "Residual") %>%
        mutate(ICC = Variance / totVar,
               perc = paste0(round(100 * ICC, 1), "%")) %>%
        select(grp, ICC, perc) -> retVal
    } else {
      tmpVarCorr %>%
        filter(grp != "Residual") %>%
        mutate(ICC = Variance / totVar) %>%
        select(grp, ICC, perc) -> retVal
    }
    ### now get the grps labelled as in output from lme4::lmer()
    retVal %>%
      mutate(grp = if_else(row_number() == 2,
                           str_c(grp,
                                 ":",
                                 lag(grp)),
                           grp)) %>%
      ### now reverse the order to match that from lme4::lmer()
      arrange(desc(row_number())) -> retVal
    ################################
    ### end of lmer::lme() block ###
    ################################
  } else {
    ###########################################################
    ### so output is from lme::lmer() (or lmerTest::lmer()) ###
    ###########################################################
    if (valClass == "lmerMod" | valClass == "lmerModLmerTest") {
      ### got output from lme4::lmer() or from lmerTest::lmer()
      lme4::VarCorr(modelOutput) %>%
        as_tibble -> varEsts
      ### check that we don't have random predictors
      if (sum(is.na(varEsts$var2)) != nrow(varEsts)){
        stop("Sorry, I haven't fixed ICClme2 to handle random predictors")
      }
      varEsts %>%
        summarise(totVar = sum(vcov)) %>%
        pull() -> totVar
      if (percent) {
        varEsts %>%
          filter(grp != "Residual") %>%
          mutate(ICC = vcov / totVar,
                 perc = paste0(round(100 * ICC, 1), "%")) %>%
          select(grp, ICC, perc) -> retVal
      } else {
        varEsts %>%
          filter(grp != "Residual") %>%
          mutate(ICC = vcov / totVar) %>%
          select(grp, ICC, perc) -> retVal
      }
    }
  }
  retVal
}
