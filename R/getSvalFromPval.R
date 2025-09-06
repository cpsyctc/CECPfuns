#' Function that takes a p value and returns the s value (Shannon entropy, surprisal value)
#' @description
#' This uses the trivial calculation that converts a probability to its s value
#'
#' @param pVal observed p value
#' @param dp number of decimal places required for corrected R
#'
#' @return numeric: s value
#'
#' @family utility functions
#'
#' @section Background:
#' This is basic information theory.  For more information, see:
#' \href{https://en.wikipedia.org/wiki/Entropy_(information_theory)}{wikipedia entry}
#' The formula is simple:
#' \loadmathjax{}
#'
#' \mjdeqn{s=-log_{2}(p)}{s = -log(p) where log is to base 2}
#'
#' There are strong arguments for expressing the value of new findings in terms of this s value
#' rather than a p value (or a confidence interval though I do think they are better than p values!)
#'
#'
#' An s value is the unexpectedness (hence *surprisal*) of a finding against some model.  An s value of
#' sausages
#' 1 will not change your information or expectations at all so if you toss a coin many times and the
#' rate of it coming down heads (or tails) is .5 then the s value is 1 (-log(.5, base = 2)) and your
#' expectation that the coin is fair is unchanged.
#'
#' However, if you toss the coin four times and you predicted heads and saw heads the probability of
#' this if the coin is fair is .5^2 = .0625 and the s value is 4 so you may be starting to feel that
#' the hypothesis that the coin is fair is going down (it is!).  The s value of information is the
#' same as that of getting the side you wanted that many times tossing a fair coin.  That is arguably
#' easier to understand than a p value or a confidence interval and its a continuous measure not a
#' very arbitrary cutting point as a null hypothesis test is.
#'
#' For what it is worth the s value of p = .05 is 4.322.
#'
#'
#' @export
#'
#' @examples
#' getCorrectedR(.3, .7, .7)
#' ### should return 0.428571428571429
#' ### yes, that's a silly number of decimal places!
#'
#' ### return an s value for p = .05 to three decimal places
#' getSvalFromPval(.05, 3)
#' ### should return 4.322
#'
#' ### return s value for throwing four heads in a row when you wanted heads
#' getSvalFromPval(.5^4, 3)
#' ### should return 4 which is pretty much the definition of what an s value is, see background
#'
#' ### the function is vectorised so can handle a vector of p values:
#' getSvalFromPval(c(.5, .05, .01, .005, .001))
#' ### should return 1.000 4.322 6.644 7.644 9.966
#'
#'
#' @author Chris Evans
#' @section History/development log:
#' Started 31.viii.25.
#' Tweaked 6.ix.25 vectorizing the function.
#'
getSvalFromPval <- function(pVal, dp = 3) {
  ### sanity checking
  if (!is.numeric(pVal)) {
    stop(paste0("You input ",
                pVal,
                " for pVal, it must be numeric. Fix it!!"
    ))
  }
  if (!is.numeric(dp)) {
    stop(paste0("You input ",
                dp,
                " for dp, the number of decimal places.  It must be numeric. Fix it!!"
    ))
  }
  if (pVal > 1 | pVal < 0) {
    stop("pVal must be positive and less than 1.0")
  }
  if (length(pVal) > 1) {
    stop("Sorry, you entered more than one value for pVal, this function only handles single values.")
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
  sVal <- -log(pVal, base = 2)

  round(sVal, dp)
}

getSvalFromPval <- Vectorize(getSvalFromPval, vectorize.args = "pVal")

