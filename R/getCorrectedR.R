#' Function that gives the corrected R for an observed R and two reliability values
#' @description
#' This just uses the conventional formula for the attenuation of a (Pearson) correlation by unreliability.
#'
#' @param obsR observed R
#' @param rel1 reliability of first of the variables (order of variables is arbitrary)
#' @param rel2 reliability of second of the variables (order of variables is arbitrary)
#' @param dp number of decimal places required for corrected R
#'
#' @return numeric: corrected correlation
#'
#' @family utility functions
#'
#' @section Background:
#' This is ancient psychometrics but still of some use.  For more information, see:
#' \href{https://www.psyctc.org/psyctc/glossary2/attenuation-by-unreliability-of-measurement/}{OMbook glossary entry for attenuation}
#' The formula is simple:
#' \loadmathjax{}
#'
#' \mjdeqn{correctedCorr=\frac{observedCorr}{\sqrt{rel_{1}*rel_{2}}}}{correctedR = obsR / sqrt(rel1 * rel2)}
#'
#' The short summary is that unreliability in the measurement of both variables involved in a correlation
#' always reduces the observed correlation between the variables from what it would have been had the
#' variables been measured with no unreliability (which is essentially impossible for any self-report measures
#' and pretty much any measures used in our fields.  This uses that relationship to work back to an
#' assumed "corrected" correlation given an observed correlation and two reliability values.
#'
#' For even moderately high observed correlations and low reliabilities the function can easily return
#' values for the corrected correlation over 1.0.  That's a clear indication that things other than
#' unreliability and classical test theory are at work.  The function gives a warning in this situation.
#'
#'
#' @export
#'
#' @examples
#' getCorrectedR(.3, .7, .7)
#' ### should return 0.428571428571429
#'
#'
#'
#' @author Chris Evans
#' @section History/development log:
#' Started 13.x.24
#'
getCorrectedR <- function(obsR, rel1, rel2, dp = 3) {
  ### sanity checking
  if (!is.numeric(obsR)) {
    stop(paste0("You input ",
                obsR,
                " for obsR, it must be numeric. Fix it!!"
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
  if (!is.numeric(dp)) {
    stop(paste0("You input ",
                dp,
                " for dp, the number of decimal places.  It must be numeric. Fix it!!"
    ))
  }
  if (obsR < -1 | obsR > 1) {
    stop("obsR must be between -1 and +1.")
  }
  if (rel1 < .01 | rel1 >= 1) {
    stop("For this function rel1 must be between .01 and 1.0.")
  }
  if (rel2 < .01 | rel2 >= 1) {
    stop("For this function rel2 must be between .01 and 1.0.")
  }
  if (length(obsR) > 1) {
    stop("Sorry, you entered more than one value for obsR, this function only handles single values.")
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
  correctedR <- obsR / sqrt(rel1 * rel2)

  if (correctedR > 1){
    warning(paste0("The corrected R is ",
                   correctedR,
                   " which is over 1.0 and clearly impossible. I think this can happen for many reasons. Beware!"))
  }
  round(correctedR, dp)
}

