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
#' @param percent Logical: whether to show quantile as % instead of proportion (defaults to FALSE)
#' @param colPoint Colour of quantile point (defaults to "black")
#' @param colLCL Colour of LCL point (defaults to "black")
#' @param colUCL Colour of UCL point (defaults to "black")
#' @param vertQuantiles Whether to drop vertical line from quantiles (defaults to TRUE)
#' @param vertCLs Whether to drop vertical line from confidence limits (defaults to FALSE)
#' @param shadeCI Whether to shade area of CI (defaults to TRUE)
#' @param addAnnotation Whether to add informative annotation (defaults to TRUE)
#' @param titleText Text for title
#' @param subtitleText Text for subtitle
#' @param titleJust Justification for title (0, .5 or 1, defaults to .05, centred)
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
#' @importFrom ggplot2 annotate
#' @importFrom ggplot2 geom_rect
#' @importFrom ggplot2 scale_y_continuous
#'
#'
#' @section Background:
#' The empirical cumulative distribution function is an
#' alternative to the histogram to show the distribution
#' of a set of scores.  It plots the proportion of the
#' sample set of scores below any observed score against
#' that score.  The proportion (or percentage) is plotted
#' on the y axis and the score on the x axis.  It's
#' particularly useful for our typical mental health (MH)
#' change/outcome measures as we're interested in how where
#' someone's score lies in a possible population distribution
#' of scores.
#'
#' ECDFs complement quantiles as a quantile (a.k.a. centile,
#' percentile, decile), is the score (on that x axis) that
#' maps the percentage, so for the 95% percentile that
#' percentile is the score that only 5% of the sample scored
#' above, and 95% scored below.
#'
#' This function takes a set of scores/values and plots their
#' ECDF with the quantiles you ask for with their confidence
#' intervals of the width that wanted (typically 95%, i.e. .95).
#'
#' See the help page for getCIforQuantiles() to learn more about
#' the computation of the confidence intervals.
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
#' ### define the quantiles you want
#' ### here I'm going for the 5th, 10th, 90th and 95% (per)centiles and the quartiles and median
#' vecQuantiles <- c(.05, .1, .25, .5, .75, .9, .95)
#'
#' ### looking at 100 scores from 1 to 100
#' plotQuantileCIsfromDat(vecDat = 1:100, vecQuantiles = vecQuantiles,
#'                      method = "N", ci = 0.95, R = 9999, type = 8,
#'                      titleJust = 1, # right justify the title and subtitle
#'                      themeBW = TRUE) # use theme_bw()
#'
#' ### same data
#' plotQuantileCIsfromDat(vecDat = 1:100, vecQuantiles = vecQuantiles,
#'                      method = "N", ci = 0.95, R = 9999, type = 8,
#'                      titleJust = .5, # centre the title and subtitle
#'                      themeBW = TRUE)
#'
#' ### same data
#' plotQuantileCIsfromDat(vecDat = 1:100, vecQuantiles = vecQuantiles,
#'                      method = "N", ci = 0.95, R = 9999, type = 8,
#'                      titleJust = .5, themeBW = FALSE,
#'                      printPlot = FALSE, # this time don't plot from within the function call but
#'                      ## this next argument ask the function the plot object
#'                      returnPlot = TRUE) -> tmpPlot
#' ### so plot it! (plot() and print() will both work,
#' ### you can also manipulate the plot before printing)
#' print(tmpPlot)
#'
#' ### this illustrates the CIs getting tighter as the dataset size goes up
#' plotQuantileCIsfromDat(vecDat = 1:1000, vecQuantiles = vecQuantiles,
#'                      method = "N", ci = 0.95, R = 9999, type = 8)
#'
#' ### and even more data, tighter CIs again
#' plotQuantileCIsfromDat(vecDat = 1:10000, vecQuantiles = vecQuantiles,
#'                      method = "N", ci = 0.95, R = 9999, type = 8)
#'
#' ### now a Gaussian ("Normal") distribution of scores
#' plotQuantileCIsfromDat(vecDat = rnorm(100), vecQuantiles = vecQuantiles,
#'                      method = "N", ci = 0.95, R = 9999, type = 8)
#'
#' ### larger dataset
#' plotQuantileCIsfromDat(vecDat = rnorm(1000), vecQuantiles = vecQuantiles,
#'                      method = "N", ci = 0.95, R = 9999, type = 8)
#'
#' ### and larger again
#' plotQuantileCIsfromDat(vecDat = rnorm(10000), vecQuantiles = vecQuantiles,
#'                      method = "N", ci = 0.95, R = 9999, type = 8,
#'                      titleJust = .5, themeBW = TRUE)
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
                                   percent = FALSE,
                                   colPoint = "black",
                                   colLCL = "black",
                                   colUCL = "black",
                                   vertQuantiles = TRUE,
                                   vertCLs = FALSE,
                                   shadeCI = TRUE,
                                   addAnnotation = TRUE,
                                   titleText = "ECDF with quantiles and CIs around quantiles",
                                   subtitleText = "",
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

  ### sanity checks (only for arguments not checked by getCIforQuantiles())
  if (!is.character(xLab)) {
    stop("xLab must be a string")
  }
  if (length(xLab) != 1){
    stop("xLab must be a single string")
  }
  if (!is.character(yLab)) {
    stop("yLab must be a string")
  }
  if (length(yLab) != 1){
    stop("yLab must be a single string")
  }
  if (!is.character(titleText)) {
    stop("titleText must be a string")
  }
  if (length(titleText) != 1){
    stop("titleText must be a single string")
  }
  if (!is.character(subtitleText)) {
    stop("subtitleText must be a string")
  }
  if (length(subtitleText) != 1){
    stop("subtitleText must be a single string")
  }
  if (!is.character(colPoint)) {
    stop("colPoint must be a string")
  }
  if (length(colPoint) != 1){
    stop("colPoint must be a single string")
  }
  if (!is.character(colLCL)) {
    stop("colLCL must be a string")
  }
  if (length(colLCL) != 1){
    stop("colLCL must be a single string")
  }
  if (!is.character(colUCL)) {
    stop("colUCL must be a string")
  }
  if (length(colUCL) != 1){
    stop("colUCL must be a single string")
  }
  if (is.na(percent) | !is.logical(percent)) {
    stop("percent must be logical value, TRUE or FALSE")
  }
  if (length(percent) != 1){
    stop("percent must be a single logical value")
  }
  if (is.na(vertQuantiles) | !is.logical(vertQuantiles)) {
    stop("vertQuantiles must be logical value, TRUE or FALSE")
  }
  if (length(vertQuantiles) != 1){
    stop("vertQuantiles must be a single logical value")
  }
  if (is.na(vertCLs) | !is.logical(vertCLs)) {
    stop("vertCLs must be logical value, TRUE or FALSE")
  }
  if (length(vertCLs) != 1){
    stop("vertCLs must be a single logical value")
  }
  if (is.na(shadeCI) | !is.logical(shadeCI)) {
    stop("shadeCI must be logical value, TRUE or FALSE")
  }
  if (length(shadeCI) != 1){
    stop("shadeCI must be a single logical value")
  }
  if (is.na(addAnnotation) | !is.logical(addAnnotation)) {
    stop("addAnnotation must be logical value, TRUE or FALSE")
  }
  if (length(addAnnotation) != 1){
    stop("addAnnotation must be a single logical value")
  }
  if (is.na(themeBW) | !is.logical(themeBW)) {
    stop("themeBW must be logical value, TRUE or FALSE")
  }
  if (length(themeBW) != 1){
    stop("themeBW must be a single logical value")
  }
  if (is.na(printPlot) | !is.logical(printPlot)) {
    stop("printPlot must be logical value, TRUE or FALSE")
  }
  if (length(printPlot) != 1){
    stop("printPlot must be a single logical value")
  }
  if (is.na(returnPlot) | !is.logical(returnPlot)) {
    stop("returnPlot must be logical value, TRUE or FALSE")
  }
  if (length(returnPlot) != 1){
    stop("returnPlot must be a single logical value")
  }
  if(!(titleJust %in% c(0, .5, 1))) {
    stop("titleJust must be one of 0, .5 or 1 for left, centre or right justification of the title and subtitle")
  }

  nAll <- length(vecDat)
  nMiss <- getNNA(vecDat)
  vecDat <- na.omit(vecDat)
  nOK <- length(vecDat)
  minVal <- min(vecDat)
  maxVal <- max(vecDat)
  rangeVal <- maxVal - minVal

  getCIforQuantiles(vecDat, vecQuantiles, method = method, ci = ci, R = R, type = type) -> tibCIs

  # if (percent) {
  #   tibCIs %>%
  #     mutate(prob = round(100 * prob)) -> tibCIs
  #   yLab <- "Percent"
  # }
  vecDat %>%
    as_tibble() %>%
    filter(!is.na(value)) -> tibDat

  ### handle theme settings
  oldTheme <- theme_get()
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
    xlab(xLab) +
    ylab(yLab) +
    ggtitle(titleText,
            subtitle = subtitleText) -> tmpPlot

  if (percent) {
    tmpPlot +
      # scale_y_continuous(labels = function(x) paste0(round(x), "%")) -> tmpPlot
      scale_y_continuous(labels = paste0(seq(0, 100, 25), "%")) -> tmpPlot
  }

  if (shadeCI) {
    tmpPlot +
      geom_rect(aes(xmin = LCL, xmax = UCL, ymin = 0, ymax = prob),
                fill = "grey80") -> tmpPlot
  }

  if (vertQuantiles) {
    tmpPlot +
      geom_linerange(aes(ymin = 0, ymax = prob, x = quantile),
                     colour = "grey40") -> tmpPlot
  }
  if (vertCLs) {
    tmpPlot +
      geom_linerange(aes(ymin = 0, ymax = prob, x = LCL),
                     colour = "grey70") +
      geom_linerange(aes(ymin = 0, ymax = prob, x = UCL),
                     colour = "grey70") -> tmpPlot
  }

  ### now add the ecdf
  if (!percent) {
    tmpPlot +
      stat_ecdf(data = tibDat,
                aes(x = value),
                geom = "step",
                ### and don't pad to infinity:
                pad = FALSE) -> tmpPlot
  } else {
    ### use suppressMessages() to override the warning about having already got a scale
    suppressMessages(tmpPlot +
                       stat_ecdf(data = tibDat,
                                 aes(x = value),
                                 geom = "step",
                                 pad = FALSE) + # don't pad to infinity
                       scale_y_continuous(name = "Percent",
                                          labels = paste0(seq(0, 100, 25), "%")) -> tmpPlot
    )
  }

  if (addAnnotation) {
    annotateText <- paste0("n(total) = ", nAll, "\n",
                           "n(missing) = ", nMiss, "\n",
                           "n(usable) = ", nOK, "\n",
                           "ci = ", ci, " i.e. ", paste0(100 * ci), "%\n",
                           "quantiles = ", convertVectorToSentence(vecQuantiles))
    tmpPlot +
      annotate("text",
               x = minVal + .015 * rangeVal,
               y = .9,
               label = annotateText,
               hjust = 0) -> tmpPlot
  }

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
