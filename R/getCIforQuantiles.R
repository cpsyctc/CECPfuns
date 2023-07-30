#' Function returns a tibble of quantiles and confidence interval of quantiles for a range of probabilities.
#' '
#' @param vecDat Vector of the data
#' @param vecQuantiles Vector of the quantiles you want
#' @param method Method you want to use to get the confidence intervals
#' @param ci Confidence interval (default .95)
#' @param R Number of bootstrap replications if using bootstrap method
#' @param type Type of quantile (default is 8)
#'
#' @return A tibble of the results
#' @export
#'
#' @importFrom stats quantile
#' @importFrom stringr str_to_sentence
#' @importFrom dplyr rename
#' @importFrom devtools install_github
#'
#' @section Background:
#' Quantiles, like percentiles, can be a very useful way of
#' understanding a distribution, in MH research, typically a
#' distribution of scores, often either help-seeking sample
#' distribution or a non-help-seeking sample.
#'
#' For example, you might want to see if a score you have for
#' someone is above the 95% (per)centile, i.e. above the .95
#' quantile of the non-help-seeking sample distribution.
#'
#' The catch is that, like any sample statistic, a
#' quantile/percentile is generally being used as an estimate
#' of a population value.  That is to say we are really interested
#' in whether the score we have is above the 95% percentile of a
#' non-help-seeking population.  That means that the
#' quantiles/percentiles from a sample are only approximate guides
#' to the population values.
#'
#' As usual, a confidence interval (CI) around an observed quantile
#' is a way of seeing how precisely, assuming random sampling of
#' course, the sample quantile can guide us about the population
#' quantile.
#'
#' Again as usual, the catch is that there are different ways of
#' compute the CI around a quantile.  This function is a wrapper
#' around three methods from Michael Höhle's quantileCI package:
#'
#' * the Nyblom method
#' * the "exact" method
#' * the bootstrap method
#'
#' As I understand the quantileCI package the classic paper by
#' Nyblom, generally the Nyblom method will be as good or better
#' than the exact method and much faster than bootstrapping
#' so the Nyblom method is the default here but I have put the
#' others in for completeness.
#'
#' @examples
#' \dontrun{
#' ### will need tidyverse to run
#' library(tidyverse)
#' ### will need quantileCI to run
#' ### if you don't have quantileCI package you need to get it from github:
#' # devtools::install_github("hoehleatsu/quantileCI")
#' library(quantileCI)
#'
#' ### use the exact method
#' getCIforQuantiles(1:1000, c(.1, .5, .95), "e", ci = .95, R = 9999, type = 8)
#' ### use the Nyblom method
#' getCIforQuantiles(1:1000, c(.1, .5, .95), "n", ci = .95, R = 9999, type = 8)
#' ### use the bootstrap method
#' getCIforQuantiles(1:1000, c(.1, .5, .95), "b", ci = .95, R = 9999, type = 8)
#' }
#'
#' @family CI functions, quantile functions
#'
#' @references
#'
#' * Nyblom, J. (1992). Note on interpolated order statistics.
#'  Statistics & Probability Letters, 14(2), 129–131.
#'  https://doi.org/10.1016/0167-7152(92)90076-H

#' * https://github.com/mhoehle/quantileCI
#'
#' @author Chris Evans
#'
#' @section History:
#' Started 4.vii.23
#'
getCIforQuantiles <- function(vecDat = NA,
                              vecQuantiles = NA,
                              method = c("Nyblom", "Exact", "Bootstrap"),
                              ci = .95,
                              R = 9999,
                              type = NULL) {
  ### function to get CI around observed quantiles
  ### vecDat is data
  ### vecQuantiles is vector of desired quantiles
  ### method gives desired method
  ### ci is desired confidence interval
  ### R is number of bootstrap replications (if using bootstrap method)
  ### type is the type of the quantile
  ### this is a trick to suppress notes about undefined global variables
  getCI <- NULL
  quantile_confint_nyblom <- NULL
  quantile_confint_exact <- NULL
  quantile_confint_boot <- NULL
  prob <- NULL
  value <- NULL
  quantileCI <- NULL
  ###
  ### get quantileCI
  if (system.file(package = "quantileCI") == "") {
    warning("You didn't have the required package, quantileCI installed, installing it now.")
    install_github("hoehleatsu/quantileCI")
  }
  ### sanity checking
  vecDat <- unlist(vecDat) # in case this is coming from a tibble
  if (!is.numeric(vecDat)) {
    stop("The data, vecDat, must be numeric")
  }
  # if(isNothing(vecDat)) {
  #   paste0("Your data, vecDat, is ",
  #          vecDat,
  #          "  You must give the data from which to get the quantiles!") -> tmpMessage
  #   stop(tmpMessage)
  # }
  nMiss <- getNNA(vecDat)
  if(nMiss > 0 ) {
    warning(paste0("You have ", nMiss, " missing values in your data."))
  }
  if (length(vecDat) < 10) {
    paste0("You have data of length ",
           length(vecDat),
           ".  You won't get any precision about quantiles with so few observations.") -> tmpMessage
    stop(tmpMessage)
  }
  if (length(vecDat) < 25) {
    paste0("You have data of length ",
           length(vecDat),
           ".  You won't get much precision about quantiles with so few observations.") -> tmpMessage
    warning(tmpMessage)
  }
  if(isNothing(vecQuantiles)) {
    paste0("Your vector of quantiles, vecQuantiles, is ",
           vecQuantiles,
           "  You must give the quantiles you want!") -> tmpMessage
    stop(tmpMessage)
  }
  if (!is.numeric(vecQuantiles)) {
    stop("The quantiles you want, vecQuantiles, must be numeric")
  }
  if (sum(is.na(vecQuantiles)) > 0) {
    stop("You have a missing value in vecQuantiles: makes no sense.  Correct it please!")
  }
  if (min(vecQuantiles) <= 0) {
    paste0("Your smallest quantile is ",
           min(vecQuantiles),
           "  The quantiles you want must be positive, negative or zero makes no sense. Correct that please!") -> tmpMessage
    stop(tmpMessage)
  }
  if (max(vecQuantiles) >= 1) {
    paste0("Your largest quantile is ",
           max(vecQuantiles),
           "  The quantiles you want must be smaller than 1.0. Correct that please!") -> tmpMessage
    stop(tmpMessage)
  }
  method <- str_to_sentence(method) # deals with capitalisation
  method <- match.arg(method) # matches partial fits
  if (!is.numeric(ci)) {
    stop("The CI you want must be numeric.")
  }
  if (is.na(ci) | length(ci) > 1) {
    stop("You have a missing value for ci, the CI you want.  Must be single numeric value .7 <= ci <= .99")
  }
  if (ci < .7 | ci > .99) {
    paste0("You have input ",
           ci,
           " for the CI you want.  Must be single numeric value .7 <= ci <= .99.  Please correct that!") -> tmpMessage
    stop(tmpMessage)
  }
  if (method == "Bootstrap") {
    if (!is.numeric(R)) {
      stop("R, the number of bootstrap replications you want, must be numeric.")
    }
    if (is.na(R) | length(R) > 1) {
      stop("R, the number of bootstrap replications you want, must be as single integer, 999 < R < 10000.")
    }
    if (R < 999 | R > 10000) {
      paste0("You have input ",
             R,
             " for R, the number of bootstrap replications you want.",
             "  Must be single numeric value 999 <= R <= 10000.  Please correct that!") -> tmpMessage
      stop(tmpMessage)
    }
  }
  if (isNothing(type) || !is.numeric(type) || length(type) > 1) {
    paste0("You have a missing, non-numeric or vector value for type, the type of quantile you want",
           " or you have given more than one value. Must be single numeric value 1 <= type <= 9.",
           " Type 8 will be used.  Change your input if that's not what you want.") -> tmpMessage
    type <- 8
    warning(tmpMessage)
  }
  if (type < 1 | type > 9) {
    paste0("You have input ",
           type,
           " for the type of quantile you want.  Must be single numeric value 1 <= type <= 9.  Please correct that!") -> tmpMessage
    stop(tmpMessage)
  }
  vecDat <- na.omit(vecDat)
  n <- length(vecDat)
  paste0("You are asking for the ",
         method,
         " method ",
         round(100 * ci),
         "% CI and you have ",
         nMiss,
         " missing data and ",
         n,
         " usable data.  The quantile type is ",
         type) -> tmpMessage
  message(tmpMessage)
  ###
  getCI <- function(vecDat, prob, method, R = R, type = type) {
    if(method == "Nyblom") {
      tmpVec <- quantileCI::quantile_confint_nyblom(vecDat, prob)
      names(tmpVec) = c("LCL", "UCL")
    }
    if(method == "Exact") {
      tmpVec <- quantileCI::quantile_confint_exact(vecDat, prob)
      names(tmpVec) = c("LCL", "UCL")
    }
    if(method == "Bootstrap") {
      tmpVec <- quantileCI::quantile_confint_boot(vecDat, prob, R = R, type = type)
      names(tmpVec) = c("LCL", "UCL")
    }
    tmpVec
  }
  vecQuantiles %>%
    as_tibble() %>%
    rename(prob = value) %>%
    rowwise() %>%
    mutate(n = n,
           nMiss = nMiss,
           quantile = quantile(vecDat, prob, type = type),
           quantileCI = list(getCI(vecDat, prob, method = method, R = R, type = type))) %>%
    ungroup() %>%
    unnest_wider(quantileCI) -> tmpTib
  tmpTib
}
### test that
# args(getCIforQuantiles)
# getCIforQuantiles(1:1000, c(.1, .5, .95), "e", ci = .95, R = 9999, type = 8)
# getCIforQuantiles(1:1000, c(.1, .5, .95), "n", ci = .95, R = 9999, type = 8)
# getCIforQuantiles(1:1000, c(.1, .5, .95), "b", ci = .95, R = 9999, type = 8)
