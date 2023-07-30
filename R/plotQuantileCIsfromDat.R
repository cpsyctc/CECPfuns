#' Title Function that plots ecdf of a vector of values with quantiles marked with their CIs
#'
#' @param vecDat Vector of the data
#' @param vecQuantiles Vector of quantiles wanted
#' @param method Method to compute the CIs
#' @param ci Width of CI wanted
#' @param R Number of bootstrap replications if bootstrap CI method invoked
#' @param type Type of quantile (defaults to 8)
#' @param xLab Label for x axis
#' @param yLab Label for y axis
#' @param colPoint Colour of quantile point (defaults to "black")
#' @param colLCL Colour of LCL point (defaults to "black")
#' @param colUCL Colour of UCL point (defaults to "black")
#' @param titleText Text for title
#' @param titleJust Justification for title (0, .5 or 1)
#' @param themeBW Logical: whether or not to use them_bw()
#' @param printPlot Logical: whether to print the plot (defaults to TRUE)
#' @param returnPlot Logical: whether to return the plot (defaults to FALSE)
#'
#' @return The plot as a ggplot object if returnPlot == TRUE
#' @export
#'
#' @importFrom dplyr filter
#' @importFrom ggplot2 theme_get
#' @importFrom ggplot2 theme_update
#' @importFrom ggplot2 theme_set
#' @importFrom ggplot2 theme_bw
#' @importFrom ggplot2 element_text
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 geom_linerange
#' @importFrom ggplot2 stat_ecdf
#' @importFrom ggplot2 xlab
#' @importFrom ggplot2 ylab
#' @importFrom ggplot2 ggtitle
#'
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
#' Started 30.vii.23
#'
plotQuantileCIsfromDat <- function(vecDat = NA, vecQuantiles = NA, method = c("Nyblom", "Exact", "Bootstrap"), ci = 0.95, R = 9999, type = NULL,
                                   xLab = "Value for probability (quantile)",
                                   yLab = "Probability",
                                   colPoint = "black",
                                   colLCL = "black",
                                   colUCL = "black",
                                   titleText = "ECDF with quantiles and CIs around quantiles",
                                   titleJust = .5,
                                   themeBW = TRUE,
                                   printPlot = TRUE,
                                   returnPlot = FALSE) {
  ### this is a trick to suppress notes about undefined global variables
  getCI <- NULL
  quantile_confint_nyblom <- NULL
  quantile_confint_exact <- NULL
  quantile_confint_boot <- NULL
  prob <- NULL
  value <- NULL
  quantileCI <- NULL
  LCL <- NULL
  UCL <- NULL
  getCIforQuantiles(vecDat, vecQuantiles, method = method, ci = ci, R = R, type = type) -> tibCIs
  vecDat %>%
    as_tibble() %>%
    filter(!is.na(value)) -> tibDat

  ### handle theme settings
  oldTheme <- theme_get()
  print(titleJust)
  if (themeBW) {
    theme_set(theme_bw())
  }
  theme_update(plot.title = element_text(hjust = titleJust),
               plot.subtitle = element_text(hjust = titleJust))

  ### OK, build the plot
  ggplot(data = tibCIs) +
    ### first plot the observed quantiles
    geom_point(aes(y = prob, x = quantile),
               colour = colPoint) +
    geom_point(aes(y = prob, x = LCL),
               colour = colLCL) +
    geom_point(aes(y = prob, x = UCL),
               colour = colUCL) +
    geom_linerange(aes(y = prob, xmin = LCL, xmax = UCL)) +
    stat_ecdf(data = tibDat,
              aes(x = value),
              geom = "step") +
    xlab(xLab) +
    ylab(yLab) +
    ggtitle(titleText) -> tmpPlot

  ### plot the plot
  if (printPlot) {
    plot(tmpPlot)
  }

  ### reset theme
  theme_set(oldTheme)

  ### return the plot
  if (returnPlot) {
    return(tmpPlot)
  }
}



# plotQuantileCIsfromDat(vecDat = 1:100, vecQuantiles = vecQuantiles, method = "N", ci = 0.95, R = 9999, type = 8,
#                        titleJust = 1, themeBW = TRUE)
# plotQuantileCIsfromDat(vecDat = 1:100, vecQuantiles = vecQuantiles, method = "N", ci = 0.95, R = 9999, type = 8,
#                        titleJust = .5, themeBW = TRUE) -> tmpPlot
#
# plotQuantileCIsfromDat(vecDat = 1:100, vecQuantiles = vecQuantiles, method = "N", ci = 0.95, R = 9999, type = 8,
#                        titleJust = .5, themeBW = FALSE, printPlot = FALSE, returnPlot = TRUE) -> tmpPlot
#
# print(tmpPlot)
#
# plotQuantileCIsfromDat(vecDat = 1:1000, vecQuantiles = vecQuantiles, method = "N", ci = 0.95, R = 9999, type = 8)
# plotQuantileCIsfromDat(vecDat = 1:10000, vecQuantiles = vecQuantiles, method = "N", ci = 0.95, R = 9999, type = 8)
# plotQuantileCIsfromDat(vecDat = rnorm(100), vecQuantiles = vecQuantiles, method = "N", ci = 0.95, R = 9999, type = 8)
# plotQuantileCIsfromDat(vecDat = rnorm(1000), vecQuantiles = vecQuantiles, method = "N", ci = 0.95, R = 9999, type = 8)
# plotQuantileCIsfromDat(vecDat = rnorm(10000), vecQuantiles = vecQuantiles, method = "N", ci = 0.95, R = 9999, type = 8,
#                        titleJust = .5, themeBW = TRUE)
