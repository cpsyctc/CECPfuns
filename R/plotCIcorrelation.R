#' Function outputting a plot of confidence interval around a correlation for a range of sample sizes
#'
#' @param corr numeric: observed correlation (assumes Pearson correlation, approximately OK for Spearman)
#' @param minN numeric: the smallest n for which you want the CI
#' @param maxN numeric: the largest n for which you want the CI
#' @param step numeric: the step by which you want n to increment (default is 1), with minN and maxN should give no more than 200 values of n
#' @param conf numeric: the confidence interval you want, defaults to .95
#' @param minY numeric: if you want to set the y axis limits input a number greater than -1 here
#' @param maxY numeric: if you want to set the y axis limits input a number smaller than 1 here
#'
#' @return a ggplot object so if you don't capture it it will plot to your default plot device
#' @export
#'
#' @section Background:
#' This is another function like \code{\link{plotBinconf}} which plots the width of confidence
#' intervals (CIs) for a range of sample/dataset sizes.
#'
#' @examples
#' \dontrun{
#' ### simple example for observed 95% confidence interval (CI) around observed correlation of .7
#' ### for sample sizes between 10 and 100
#' plotCIcorrelation(.7, 10, 100)
#'
#' ### similar but for dataset sizes between 10 and 500 by steps of 5
#' plotCIcorrelation(.7, 10, 500, 5)
#'
#' ### similar but asking for 99% CI
#' plotCIcorrelation(.7, 10, 500, 5, conf = .99)
#'
#' ### similar but setting lower y axis limit to -1
#' plotCIcorrelation(.7, 10, 500, 5, conf = .99, minY = -1)
#'
#' ### and you can set the upper y limit, observed R = 0 for a change
#' plotCIcorrelation(0, 10, 500, 5, conf = .99, minY = -1, maxY = 1)
#'
#' ### same but exporting to tmpPlot and then changing plot
#' plotCIcorrelation(0, 10, 500, 5, conf = .99, minY = -1, maxY = 1) -> tmpPlot
#' tmpPlot +
#'    ggtitle("95% CI around observed Pearson correlation of zero for n from 10 to 500") +
#'    theme_bw()
#'
#' }
#' @family confidence interval functions
#' @family demonstration functions
#'
#' @author Chris Evans
plotCIcorrelation <- function(corr, minN, maxN, step = 1, conf = .95, minY = NULL, maxY = NULL) {
  ### little function using Hmisc::binconf() to get CI around observed correlation and plot this
  ### sanity checks
  ###
  ### sanity check 1
  if (!is.numeric(corr) | length(corr) != 1 | corr < -1 | corr > 1) {
    stop("Argument corr must be numeric between -1 and 1 (inclusive) and length 1")
  }
  ###
  ### sanity check 2: conf must be sensible
  if (!is.numeric(conf) | conf <= 0 | conf > .999) {
    stop("conf must be numeric and 0 < conf < .999")
  }
  ###
  ### sanity check 3: minN must be sensible
  if (!is.numeric(minN) | length(minN) != 1 | minN < 5 | minN > 1000 | minN > maxN) {
    stop("Argument minN must be numeric between 5 and 1000 (inclusive), less than maxN and of length 1")
  }
  ###
  ### sanity check 4: maxN must be sensible
  if (length(maxN) != 1 | !is.numeric(maxN) | maxN < 10 | maxN > 10000) {
    stop("Argument maxN must be numeric between 10 and 10000 (inclusive) and length 1")
  }
  ###
  ### sanity check 5: step must be sensible
  if (!is.numeric(step) | length(step) != 1 | step < 1 | step > 100) {
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
  ###
  ### sanity check 7
  if (!is.null(minY)) {
    if (length(minY) != 1 | !is.numeric(minY) | minY < -1 | minY > .99) {
      stop("minY, which sets the bottom of the y axis, must be a single number between -1 and .99 inclusive")
      if (minY > maxY) {
        ###
        ### sanity check 10
        stop("minY, which sets the bottom of the y axis (if you want to) must be smaller than maxY")
      }
    }
  }
  ###
  ### sanity check 9
  if (!is.null(maxY)) {
    if (length(maxY) != 1 | !is.numeric(maxY) | maxY < -.99 | maxY > 1) {
      stop("maxY, which sets the top of the y axis, must be a single number between -.99 and 1 inclusive")
      if (minY > maxY) {
        ###
        ### sanity check 10
        stop("minY, which sets the bottom of the y axis (if you want to) must be smaller than maxY")
      }
    }
  }


  options(tidyverse.quiet = TRUE)

  ### declare variables to preempt complaints later
  n <- value <- LCL <- UCL <- CI <- NULL
  `...1` <- `...2` <- NULL

  getCIpearson <- function(r, n, ci = conf) {
    ### confidence interval of a Pearson correlation tweaked from almost the first S+ function I ever wrote!
    z <- atanh(r)
    norm <- qnorm((1 - ci) / 2)
    den <- sqrt(n - 3)
    zl <- z + norm / den
    zu <- z - norm / den
    rl <- tanh(zl)
    ru <- tanh(zu)
    ci <- c(rl, ru)
    return(ci)
  }
  suppressMessages(vecN %>%
    tibble::as_tibble() %>%
    dplyr::rename(n = value) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(CI = list(getCIpearson(corr, n, conf))) %>%
    dplyr::ungroup() %>%
    tidyr::unnest_wider(CI) %>%
    dplyr::rename(LCL = `...1`,
           UCL = `...2`)) -> tibDat

  ### get y axis limits
  if (is.null(minY)) {
    minY <- min(tibDat$LCL)
  }
  if (is.null(maxY)) {
    maxY <- max(tibDat$UCL)
  }

  ### now plot it

  ggplot2::ggplot(data = tibDat,
                  ggplot2::aes(x = n, y = corr)) +
    ggplot2::geom_point() +
    ggplot2::geom_linerange(ggplot2::aes(ymin = LCL, ymax = UCL)) +
    ggplot2::ylim(minY, maxY) +
    ggplot2::xlim(minN, maxN) +
    ggplot2::ylab("Correlation") -> p
  p
}
#'
#' @rdname plotCIcorrelation
#' @export
plotCIPearson <- plotCIcorrelation
