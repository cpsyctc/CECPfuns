#' Function outputting a plot of confidence interval around a proportion for a range of sample sizes
#'
#' @param proportion numeric: the proportion sought (actual proportion will be nearest possible for each n)
#' @param conf numeric: confidence interval width, usually .95
#' @param minN numeric: the smallest sample size, n, to estimate and plot
#' @param maxN numeric: the largest n
#' @param step numeric: the steps to use between minN and maxN, defaults to 1 but set higher if plotting a wide range of n
#' @param fixYlim logical: if FALSE, ggplot finds sensible y limits, if TRUE, y axis runs from 0 to 1
#'
#' @return a ggplot object, by default that will print but you can save it and modify it as you like
#' @export
#'
#' @section Background:
#' This little function just plots confidence intervals (CIs) for a proportion for a range of sample sizes.  I wrote
#' it after writing \code{\link{classifyScoresVectorByRCI}} which will give CIs around observed proportions and
#' I thought that for people not entirely familiar with and comfortable with CIs it might be useful for them to be
#' able to see a plot of how intervals around observed proportions change with sample size.
#'#'
#' @examples
#' \dontrun{
#'
#' ### 95% CI around proportion .5 for n from 10 to 70
#' plotBinconf(.5, 10, 70, conf = .95) # don't have to declare conf, defaults to .95
#' ### notice that the observed proportion wiggles up and down as n increases as
#' ### you can only have integer counts so functions gets nearest to the desired
#' ### proportion, here .5, possible for that n, so for n = 10, we can have perfect .5
#' ### but for n = 11 6/11 is .545454..
#'
#' ### 90% CI around proportion .5 for n from 10 to 70
#' plotBinconf(.5, 10, 70, conf = .90)
#'
#' ### 90% CI around proportion .5 for n from 100 to 200
#' plotBinconf(.5, 10, 70, conf = .90)
#'
#' ### same but fixing y limits to 0 and 1
#' plotBinconf(.5, 10, 70, conf = .90, fixYlim = TRUE)
#'
#' ### default 95% CI, exporting to tmpPlot and then changing plot
#' plotBinconf(.5, 10, 70) -> tmpPlot
#' tmpPlot +
#'    ggtitle("95% CI around proportion .5 for n from 10 to 70") +
#'    theme_bw()
#'
#' ### other inputs
#' plotBinconf(0, .95, 10, 70)
#' plotBinconf(1, .95, 10, 70)
#' plotBinconf(.7, .95, 100, 200)
#' plotBinconf(.3, .95, 100, 700, 5)
#'
#' }
#'
#' @family confidence interval functions
#' @family demonstration functions
#'
#' @author Chris Evans
#'
#' @section History/development log:
#' Started before 5.iv.21
#'
plotBinconf <- function(proportion, minN, maxN, step = 1, conf = .95, fixYlim = FALSE) {
  ### little function using Hmisc::binconf() to get CI around observed proportion and plot this
  ### sanity checks
  ###
  ### sanity check 1
  if (!is.numeric(proportion) | length(proportion) != 1 | proportion < 0 | proportion > 1) {
    stop("Argument proportion must be numeric between 0 and 1 (inclusive) and length 1")
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
  if (length(fixYlim) != 1 | !is.logical(fixYlim)) {
    stop("fixYlim, which imposes a 0 to 1 limit on y axis, must be logical and length one")
  }

  options(tidyverse.quiet = TRUE)

  ### declare variables to preempt complaints later
  n <- value <- obsProp <- LCL <- UCL <- CI <- NULL
  `...1` <- `...2` <- `...3` <- NULL
  suppressMessages(vecN %>%
    tibble::as_tibble() %>%
    dplyr::rename(n = value) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(CI = list(Hmisc::binconf(round(proportion * n), n))) %>%
    dplyr::ungroup() %>%
    tidyr::unnest_wider(CI) %>%
    dplyr::rename(obsProp = `...1`,
           LCL = `...2`,
           UCL = `...3`)) -> tibDat

  if (fixYlim) {
    # y limits to be fixed at 0 and 1
    minY <- 0
    maxY <- 1
  } else {
    minY <- min(tibDat$LCL)
    maxY <- max(tibDat$UCL)
  }

  ggplot2::ggplot(data = tibDat,
                  ggplot2::aes(x = n, y = obsProp)) +
    ggplot2::geom_point() +
    ggplot2::geom_linerange(ggplot2::aes(ymin = LCL, ymax = UCL)) +
    ggplot2::ylim(minY, maxY) +
    ggplot2::xlim(minN, maxN) +
    ggplot2::ylab("Proportion") -> p
  p
}
#'
#' @rdname plotBinconf
#' @export
plotCIProportion <- plotBinconf
