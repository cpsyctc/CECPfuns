#' Function outputting a plot of confidence of a proportion for a range of sample sizes
#'
#' @param proportion numeric: the proportion sought (actual proportion will be nearest possible for each n)
#' @param conf numeric: confidence interval width, usually .95
#' @param minN numeric: the smallest sample size, n, to estimate and plot
#' @param maxN numeric: the largest n
#' @param step numeric: the steps to use between minN and maxN, defaults to 1 but set higher if plotting a wide range of n
#'
#' @return a ggplot object, by default that will print but you can save it and modify it as you like
#' @export
#'
#' @examples
#' \dontrun{
#'
#' ### 95% CI around proportion .5 for n from 10 to 70
#' plotBinconf(.5, .95, 10, 70)
#'
#' ### same exporting to tmpPlot and then changing plot
#' plotBinconf(.5, .95, 10, 70) -> tmpPlot
#' tmpPlot +
#'    ggtitle("95% CI around proportion .5 for n from 10 to 70") +
#'    theme_bw()
#'
#' ### other inputs
#' plotBinconf(0, .95, 10, 70)
#' plotBinconf(1, .95, 10, 70)
#' plotBinconf(.7, .95, 100, 200)
#' plotBinconf(.3, .95, 100, 700, 5)
#' }
#'
plotBinconf <- function(proportion, conf, minN, maxN, step = 1){
  ### little function using Hmisc::binconf() to get CI around observed proportion and plot this
  ### sanity checks
  ###
  ### sanity check 1
  if(!is.numeric(proportion) | length(proportion) != 1 | proportion < 0 | proportion > 1) {
    stop("Argument proportion must be numeric between 0 and 1 (inclusive) and length 1")
  }
  ###
  ### sanity check 2: conf must be sensible
  if (!is.numeric(conf) | conf <= 0 | conf > .999) {
    stop("conf must be numeric and 0 < conf < .999")
  }
  ###
  ### sanity check 3: minN must be sensible
  if(!is.numeric(minN) | length(minN) != 1 | minN < 5 | minN > 1000 | minN > maxN) {
    stop("Argument minN must be numeric between 5 and 1000 (inclusive), less than maxN and of length 1")
  }
  ###
  ### sanity check 4: maxN must be sensible
  if(!is.numeric(maxN) | length(maxN) != 1 | maxN < 10 | maxN > 10000) {
    stop("Argument maxN must be numeric between 10 and 10000 (inclusive) and length 1")
  }
  ###
  ### sanity check 5: step must be sensible
  if(!is.numeric(step) | length(step) != 1 | step < 1 | step > 100) {
    stop("Argument minN must be numeric between 1 and 100 (inclusive) and length 1")
  }
  ###
  ### sanity check 6: combination of minN, maxN and step must be sensible
  minN <- round(minN) # get to integers
  maxN <- round(maxN)
  step <- round(step)
  vecN <- seq(minN, maxN, step)
  if (length(vecN) > 200) {
    stop("Your minN, maxN and step give more than 200 CIs to plot: too many!")
  }

  ### declare variables to preempt complaints later
  n <- value <- obsProp <- LCL <- UCL <- CI <- NULL
  `...1` <- `...2` <- `...3` <- NULL
  vecN %>%
    tibble::as_tibble() %>%
    dplyr::rename(n = value) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(CI = list(Hmisc::binconf(round(proportion * n), n))) %>%
    dplyr::ungroup() %>%
    tidyr::unnest_wider(CI) %>%
    dplyr::rename(obsProp = `...1`,
           LCL = `...2`,
           UCL = `...3`) -> tibDat

  ggplot2::ggplot(data = tibDat,
                  ggplot2::aes(x = n, y = obsProp)) +
    ggplot2::geom_point() +
    ggplot2::geom_linerange(ggplot2::aes(ymin = LCL, ymax = UCL)) +
    ggplot2::xlim(minN, maxN) +
    ggplot2::ylab("Proportion") -> p
  p
}
