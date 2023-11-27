#' Function offering four methods to find the CI around an observed Spearman correlation
#'
#' @param rs numeric: the observed Spearman correlation
#' @param n numeric: the number of (paired) values for the correlation
#' @param ci numeric: the confidence interval you want, default .95, i.e. 95%
#' @param Gaussian logical: use the Gaussian lookup for the CI, defaults to FALSE
#' @param FHP logical: use the Fieller, Hartley & Pearson (1957) method, defaults to FALSE
#'
#' @return A named vector LCL and UCL
#' @export
#'
#' @importFrom stats qt
#'
#' @section Background:
#' This is very simple function to return the confidence limits of the confidence interval
#' around an observed Pearson correlation given the number of observations in the dataset (n)
#' and the confidence interval required (ci, defaults to .95).  There are four methods obtained
#' by using either the Bonett & White (2000) approximation to the SE of the correlation or the
#' the Fieller, Hartley & Pearson (1957) approximation and combining those with either looking
#' up the value of the Gaussian to get the desired CI coverage or using the value of the
#' t distribution with df = n - 2.  It is known that none of the methods work well, i.e. give
#' coverage matching that desired and without bias, when the n is below 25 and/or the absolute
#' population Spearman correlation is above .95 so use with caution if n < 25 and observed
#' correlation > .90.
#'
#' The function just returns a named vector of the LCL and UCL which should help using it in
#' tidyverse pipes.  See examples.
#'
#' There is more information about the function in my \href{https://www.psyctc.org/Rblog/}{Rblog} at
#' \href{https://www.psyctc.org/Rblog/posts/2023-11-27-cispearman/}{Confidence interval around Spearman correlation coefficient}.
#'
#' @examples
#' \dontrun{
#' getCISpearman(.5, 50)
#' # LCL       UCL
#' # 0.2338274 0.6964523
#' getCISpearman(.5, 50, Gaussian = TRUE)
#' # LCL       UCL
#' # 0.2412245 0.6923933
#' getCISpearman(.5, 50, Gaussian = TRUE, FHP = TRUE)
#' # LCL       UCL
#' # 0.2495794 0.6877365
#' getCISpearman(.5, 50, Gaussian = FALSE, FHP = TRUE)
#' # LCL       UCL
#' # 0.2424304 0.6917259
#'
#' ### imaginary correlations of CORE-OM scores against number of children by parental gender
#' ### create a tibble of the imaginary data
#' tribble(~pGender, ~rs, ~n,
#'         "M", .12, 643,
#'         "F", .57, 808) -> tibDat
#'
#' ### check it
#' tibDat
#'
#' ### use it
#' tibDat %>%
#'   rowwise() %>%
#'   ### need to use list() as we're getting a vector
#'   ### using the default arguments for getCISpearman()
#'   mutate(CISpearman = list(getCISpearman(rs, n))) %>%
#'   ### now get the values from the vectors
#'   unnest_wider(CISpearman)
#' # # A tibble: 2 × 5
#' # pGender    rs     n    LCL   UCL
#' # <chr>   <dbl> <dbl>  <dbl> <dbl>
#' # 1 M        0.12   643 0.0427 0.196
#' # 2 F        0.57   808 0.518  0.618
#' ### pretty clear that the correlation for the women is very different
#' ### from that for the men
#' }
#'
#' @section References/acknowledgements:
#'
#' \enumerate{
#' \item This started from finding the excellent answers from \code{onestop} \url{https://stats.stackexchange.com/users/449/onestop}
#'  and \code{retodomax} \url{https://stats.stackexchange.com/users/237402/retodomax}
#' to the question on CrossValidated \href{https://stats.stackexchange.com/}{How to calculate a confidence interval for Spearman's rank correlation?}
#' Also, as referenced in that page ...
#'
#' \item Bishara, A. J., & Hittner, J. B. (2017). Confidence intervals for correlations when data are not normal. Behavior Research Methods, 49(1),
#' 294–309. \url{https://doi.org/10.3758/s13428-016-0702-8}
#' gives extensive simulation work covering much more than these CIs.
#' I checked my code against the results from the R code given in Supplement A to that paper.  Then ...
#'
#' \item Bonett, D. G., & Wright, T. A. (2000). Sample size requirements for estimating pearson, kendall and spearman correlations.
#' Psychometrika, 65(1), 23–28. \url{https://doi.org/10.1007/BF02294183} is a classic (interesting to see how typesetting of equations
#' has improved since 2000!) and ...
#'
#' \item Ruscio, J. (2008). Constructing Confidence Intervals for Spearman’s Rank Correlation with Ordinal Data:
#' A Simulation Study Comparing Analytic and Bootstrap Methods. Journal of Modern Applied Statistical Methods,
#' 7(2), 416–434. \url{https://doi.org/10.22237/jmasm/1225512360} was another excellent paper on the topic.
#' }
#'
#' Thanks to all those authors.
#'
#' @family confidence interval functions
#'
#' @author Chris Evans
#'
#' @section History/development log:
#' Version 1: 27.xi.23
#'
getCISpearman <- function(rs, n, ci = .95, Gaussian = FALSE, FHP = FALSE){
  ### sanity checking arguments
  if (!is.numeric(rs)) {
    stop("rs must be a number between -1 and 1")
  }
  if (rs < -1 | rs > 1) {
    stop("r must be a number between -1 and 1")
  }
  if (!is.numeric(n)) {
    stop("n, dataset size, must be a number greater than 7")
  }
  if (n < 8) {
    stop("n, dataset size, must be a number greater than 7")
  }
  if (!is.numeric(ci)) {
    stop("ci, the CI width must be a number > .7 and < 1")
  }
  if (ci < .7 | ci >= 1) {
    stop("ci, the CI width must be a number > .7 and < 1")
  }

  ### warnings
  if (n < 25) {
    warning("The coverage of CIs from any of these methods is poor with n < 25. Interpret very cautiously!")
  }
  if (abs(rs) > .9) {
    warning("The coverage of CIs from any of these methods is poor with strong correlations. Interpret cautiously!")
  }

  ### OK proceed
  alpha <- 1 - ci
  if (Gaussian) {
    ### If Gaussian, use the Gaussian distribution
    if (!FHP){
      ### Not using the Fieller, Hartley & Pearson (1957) SE approximation so ...
      ### This is the Bonett & Wright (2000) SE approximation
      CI <- sort(tanh(atanh(rs) + c(-1,1) * sqrt((1 + rs^2 / 2)/(n - 3)) * qnorm(p = alpha / 2)))
    } else {
      ### using the Fieller, Hartley & Pearson (1957) SE approximation
      ### uses sqrt(1.06 / (n - 3)) as in Bishara & Hittner (2016) as opposed to 1.03 / sqrt(n - 3)
      ### difference is numerically tiny
      CI <- sort(tanh(atanh(rs) + c(-1,1) * sqrt(1.06 / (n - 3)) * qnorm(p = alpha / 2)))
    }
  } else {
    ### Not Gaussian so use the t distribution
    if (!FHP){
      CI <- sort(tanh(atanh(rs) + c(-1,1) * sqrt((1 + rs^2 / 2)/(n - 3)) * qt(p = alpha / 2, df = n - 2)))
    } else {
      CI <- sort(tanh(atanh(rs) + c(-1,1) * sqrt(1.06 / (n - 3)) * qt(p = alpha / 2, df = n - 2)))
    }
  }
  names(CI) <- c("LCL", "UCL")
  CI
}
