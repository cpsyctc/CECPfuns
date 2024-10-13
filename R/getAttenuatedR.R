#' Function that gives the attenuated R for an unattenuated R and two reliability values
#' @description
#' This is just the conventional formula for the attenuation of a (Pearson) correlation by unreliability.
#'
#' @param unattR unattenuated R
#' @param rel1 reliability of first of the variables (order of variables is arbitrary)
#' @param rel2 reliability of second of the variables (order of variables is arbitrary)
#' @param dp number of decimal places required for attenuated R
#'
#' @return numeric: attenuated correlation
#'
#' @family utility functions
#'
#' @section Background:
#' This is ancient psychometrics but still of some use.  For more information, see:
#' \href{https://www.psyctc.org/psyctc/glossary2/attenuation-by-unreliability-of-measurement/}{OMbook glossary entry for attenuation}
#' The formula is simple:
#' \loadmathjax{}
#'
#' \mjdeqn{attenuatedCorr=unattenuatedCorr*\sqrt{rel_{1}*rel_{2}}}{attenuatedR = unattR * sqrt(rel1 * rel2)}
#'
#' The short summary is that unreliability in the measurement of both variables involved in a correlation
#' always reduces the observed correlation between the variables from what it would have been had the
#' variables been measured with no unreliability (which is essentially impossible for any self-report measures
#' and pretty much any measures used in our fields.
#'
#'
#' @export
#'
#' @examples
#' getAttenuatedR(.9, .7, .8)
#'
#'
#'
#' @author Chris Evans
#' @section History/development log:
#' Started 12.x.24
#'
getAttenuatedR <- function(unattR, rel1, rel2, dp = 3) {
  ### sanity checking
  if (!is.numeric(unattR)) {
    stop(paste0("You input ",
                unattR,
                " for unattR, it must be numeric. Fix it!!"
    ))
  }
  if (!is.numeric(rel1)) {
    stop(paste0("You input ",
                rel1,
                " for rel1, it must be numeric. Fix it!!"
    ))
  }
  if (!is.numeric(rel2)) {
    stop(paste0("You input ",
                rel2,
                " for rel2, it must be numeric. Fix it!!"
    ))
  }
  if (unattR < -1 | unattR > 1) {
    stop("unattr must be between -1 and +1.")
  }
  if (rel1 < .01 | rel1 >= 1) {
    stop("For this function rel1 must be between .01 and 1.0.")
  }
  if (rel2 < .01 | rel2 >= 1) {
    stop("For this function rel2 must be between .01 and 1.0.")
  }
  if (length(unattR) > 1) {
    stop("Sorry, you entered more than one value for unattr, this function only handles single values.")
  }
  if (length(rel1) > 1) {
    stop("Sorry, you entered more than one value for rel, this function only handles single values.")
  }
  if (length(rel2) > 1) {
    stop("Sorry, you entered more than one value for rel2, this function only handles single values.")
  }
  if (length(dp) > 1) {
    stop("Sorry, you entered more than one value for dp, the number of decimal places.  This function only handles single values.")
  }
  if (dp < 1){
    stop(paste0("You entered ",
                dp,
                " for dp, the number of decimal places wanted. That must be 1 or higher.  Fix it!!"))
  }
  if (dp > 5) {
    warning(paste0("You entered ",
                   dp,
                   " for dp, the number of decimal places wanted.  That is highly unlikely to be meaningful precision."))
  }
  if (abs(dp[1]) - round(dp[1]) > .1) {
    warning(paste0("You entered ",
                   dp,
                   " for dp, the number of decimal places wanted.  That's not an integer.  Something wrong there?"))
  }

  ### OK, do it!
  round(unattR * sqrt(rel1 * rel2), dp)
}

