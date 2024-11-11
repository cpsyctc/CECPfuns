#' Gets the two-sided p value for the difference between two independent Cronbach alpha values
#'
#' @param alpha1 first Cronbach alpha (order is irrelevant)
#' @param alpha2 other Cronbach alpha value
#' @param k number of items (assumed same for both values)
#' @param n1 first sample size (match to the alpha)
#' @param n2 other sample size
#'
#' @return numeric: two-sided p value for difference
#' @export
#'
#' @importFrom stats pf
#'
#' @family p-value functions
#'
#' @section Background:
#' This function provides a conventional null hypothesis significance test
#' (NHST) of the null hypothesis that two Cronbach alpha values from
#' independent datasets are so different that it is unlikely, given the
#' numbers of items and the two dataset sizes that you would have seen
#' differences as large or larger than you did on the null hypothesis that
#' the alpha values in the population(s) are the same.
#'
#' I am very much against the overuse of the NHST in our fields but here I
#' think it is useful (whereas reporting that a Cronbach alpha is statistically
#' different from zero is really pretty meaningless).
#'
#' Whereas testing that the population item correlation structure is unlikely
#' to have been purely random strikes me as useless when we are exploring the
#' psychometric properties of measures, rejecting the null of no differences
#' in the alpha values from the same measure in two different samples is a bit
#' more useful.
#'
#' If you have raw data from two datasets I would recommend getting the
#' bootstrap confidence interval (CI) around your observed alpha values as a
#' more robust and sensibly descriptive/estimation approach.  The
#' \link[CECPfuns]{getBootCIalpha} will get for you.  The
#' current vogue if you have raw data is to jump to fancy things like testing
#' for "measurement invariance" in the confirmatory factor analytic (CFA)
#' framework and that's fine where measures really do fit the CFA model but
#' for most therapy measures that fit is very dubious and looking at alpha
#' values is a solid place to start.
#'
#' The maths comes from a 1969 paper by Feldt and is based on the assumption
#' that the population distributions (i.e. of the item scores) are all
#' Gaussian.  I've used the more complicated derivation of the p value from
#' Feldt's paper as his simpler version is not robust for short measures.
#' I suspect that the computations are fairly robust to non-Gaussian
#' distributions but I haven't explored that.  I have simulated things to
#' show that it gets accurate p values for Gaussian null populations.
#'
#' Of course like all such NHST the other (non-distribution) assumptions are
#' * infinite populations (probably not a real problem)
#' * genuinely independent "samples"/datasets (should be fine)
#' * genuinely independent observations (watch for nesting)
#' * random sampling (almost certainly violated)
#' * as ever, if you have huge datasets even tiny differences will be come
#'   out as statistically significant and if you have small datasets even
#'   quite large differences will not be statistically significant.
#' So be honest about any of these issues if reporting p values (any, not
#' just from this function!)
#'
#' The maths allows for different numbers of items in the two datasets but I
#' haven't implemented that as I think that if you are comparing measures
#' that differ in length you are probably outside the realm in which the NHST
#' paradigm is helpful.
#'
#'
#' @examples
#' getPdiff2alphas(.7, .7, 8, 200, 150)
#' ### should return 0.5023525: not a significant difference (doh!)
#'
#' getPdiff2alphas(.7, .8, 8, 200, 150)
#' ### should return 0.007314514 showing that it is unlikely at p < 05
#' ### that that difference between those alpha levels arose by chance
#' ### sampling from a population (or populations) where the population
#' ### alpha values are the same
#'
#' @author Chris Evans
#' @section History/development log:
#' Created 21.xi.24 based on earlier SAS and S+ versions
#'
getPdiff2alphas <- function(alpha1, alpha2, k, n1, n2) {
  ### program translated from SAS program I wrote, Feldt2.sas
  ### tests significance of difference between two alpha values
  ### alpha1 and alpha2
  ### assumes same number of items in the measures:
  ### n1 and n2 supply sample sizes
  ### sanity checking
  if (length(alpha1) > 1) {
    stop("Sorry, you entered more than one value for alpha1, this function only handles single values.")
  }
  if (length(alpha2) > 1) {
    stop("Sorry, you entered more than one value for alpha2, this function only handles single values.")
  }
  if (length(k) > 1) {
    stop("Sorry, you entered more than one value for k, this function only handles single values.")
  }
  if (length(n1) > 1) {
    stop("Sorry, you entered more than one value for n1, this function only handles single values.")
  }
  if (length(n2) > 1) {
    stop("Sorry, you entered more than one value for n2, this function only handles single values.")
  }
  if (!is.numeric(alpha1)) {
    stop(paste0("You input ",
                alpha1,
                " for the first alpha: it must be numeric. Fix it!!"
    ))
  }
  if (!is.numeric(alpha2)) {
    stop(paste0("You input ",
                alpha2,
                " for the first alpha: it must be numeric. Fix it!!"
    ))
  }
  if (!is.numeric(k)) {
    stop(paste0("You input ",
                k,
                " for k, it must be numeric. Fix it!!"
    ))
  }
  if (!is.numeric(n1)) {
    stop(paste0("You input ",
                n1,
                " for n1, it must be numeric. Fix it!!"
    ))
  }
  if (!is.numeric(n2)) {
    stop(paste0("You input ",
                n2,
                " for n2, it must be numeric. Fix it!!"
    ))
  }
  if (alpha1 < -1 | alpha1 > 1) {
    stop("alpha1 must be between -1 and +1.")
  }
  if (alpha2 < -1 | alpha2 > 1) {
    stop("alpha1 must be between -1 and +1.")
  }
  if (abs(k) - round(k) > .1) {
    warning(paste0("You entered ",
                   k,
                   " for k, the number of items.  That's not an integer.  Something wrong there?"))
  }
  if(k < 5 | k > 500) {
    stop(paste0("You input ",
                k,
                " for k. I have only allowed realistic values which I see as between 5 and 500.  Fix it!!"
    ))
  }
  if(n1 < 10 | n1 > 5000) {
    stop(paste0("You input ",
                n1,
                " for n1. I have only allowed realistic values which I see as between 10 and 5,000.  Fix it!!"
    ))
  }
  if(n2 < 10 | n2 > 5000) {
    stop(paste0("You input ",
                n2,
                " for n2. I have only allowed realistic values which I see as between 10 and 5,000.  Fix it!!"
    ))
  }
  if (n1 - round(n1) > .1) {
    warning(paste0("You entered ",
                   n1,
                   " for n1, the first sample size.  That's not an integer.  Something wrong there?"))
  }
  if (n2 - round(n2) > .1) {
    warning(paste0("You entered ",
                   n2,
                   " for n2, the second sample size.  That's not an integer.  Something wrong there?"))
  }


  ### OK, do it!
  ### It's doing a two-sided test of any difference hence ...
  if (alpha1 > alpha2) {
    # necessary to reverse everything
    tmp    <- alpha1
    alpha1 <- alpha2
    alpha2 <- tmp

    tmp <- n1
    n1  <- n2
    n2  <- tmp
  }
  ### get the key statistic
  w <- (1 - alpha2)/(1 - alpha1)
  ### get the df using the Feldt(1969) numbering
  df1 <- n1 - 1
  df4 <- n2 - 1
  df3 <- (n2 - 1) * (k - 1)
  df2 <- (n1 - 1) * (k - 1)
  A <- df4 * df2 / ((df4 - 2)*(df2 - 2))
  B <- (df1 + 2)*(df3 + 2) * df4^2 * df2^2 / ((df4 -2) * (df4 - 4) * df1 * (df2 - 2) * (df2 - 4) * df3)
  v2 <- 2*A / (A - 1)
  v1 <- 2*A^2 / (2*B - A*B - A^2)
  ### return the p value
  pf(w, v2, v1)
}
