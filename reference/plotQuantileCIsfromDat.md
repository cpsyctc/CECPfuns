# Title Function that plots ecdf of a vector of values with quantiles marked with their CIs

Title Function that plots ecdf of a vector of values with quantiles
marked with their CIs

## Usage

``` r
plotQuantileCIsfromDat(
  vecDat = NA,
  vecQuantiles = NA,
  method = c("Nyblom", "Exact", "Bootstrap"),
  ci = 0.95,
  R = 9999,
  type = NULL,
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
  titleJust = 0.5,
  themeBW = TRUE,
  printPlot = TRUE,
  returnPlot = FALSE
)
```

## Arguments

- vecDat:

  Vector of the data

- vecQuantiles:

  Vector of quantiles wanted

- method:

  Method to compute the CIs

- ci:

  Width of CI wanted

- R:

  Number of bootstrap replications if bootstrap CI method invoked

- type:

  Type of quantile (defaults to 8)

- xLab:

  Label for x axis

- yLab:

  Label for y axis

- percent:

  Logical: whether to show quantile as % instead of proportion (defaults
  to FALSE)

- colPoint:

  Colour of quantile point (defaults to "black")

- colLCL:

  Colour of LCL point (defaults to "black")

- colUCL:

  Colour of UCL point (defaults to "black")

- vertQuantiles:

  Whether to drop vertical line from quantiles (defaults to TRUE)

- vertCLs:

  Whether to drop vertical line from confidence limits (defaults to
  FALSE)

- shadeCI:

  Whether to shade area of CI (defaults to TRUE)

- addAnnotation:

  Whether to add informative annotation (defaults to TRUE)

- titleText:

  Text for title

- subtitleText:

  Text for subtitle

- titleJust:

  Justification for title (0, .5 or 1, defaults to .05, centred)

- themeBW:

  Logical: whether or not to use them_bw()

- printPlot:

  Logical: whether to print the plot (defaults to TRUE)

- returnPlot:

  Logical: whether to return the plot (defaults to FALSE)

## Value

The plot as a ggplot object if returnPlot == TRUE

## Background

The empirical cumulative distribution function is an alternative to the
histogram to show the distribution of a set of scores. It plots the
proportion of the sample set of scores below any observed score against
that score. The proportion (or percentage) is plotted on the y axis and
the score on the x axis. It's particularly useful for our typical mental
health (MH) change/outcome measures as we're interested in how where
someone's score lies in a possible population distribution of scores.

ECDFs complement quantiles as a quantile (a.k.a. centile, percentile,
decile), is the score (on that x axis) that maps the percentage, so for
the 95% percentile that percentile is the score that only 5% of the
sample scored above, and 95% scored below.

This function takes a set of scores/values and plots their ECDF with the
quantiles you ask for with their confidence intervals of the width that
wanted (typically 95%, i.e. .95).

See the help page for getCIforQuantiles() to learn more about the
computation of the confidence intervals.

## History

Started 30.vii.23

## References

- Nyblom, J. (1992). Note on interpolated order statistics. Statistics &
  Probability Letters, 14(2), 129–131.
  https://doi.org/10.1016/0167-7152(92)90076-H

- https://github.com/mhoehle/quantileCI

## See also

Other CI functions, quantile functions:
[`getCIforQuantiles()`](https://cecpfuns.psyctc.org/reference/getCIforQuantiles.md)

## Author

Chris Evans

## Examples

``` r
if (FALSE) { # \dontrun{
### will need tidyverse to run
library(tidyverse)
### will need quantileCI to run
### if you don't have quantileCI package you need to get it from github:
# devtools::install_github("hoehleatsu/quantileCI")
library(quantileCI)

### define the quantiles you want
### here I'm going for the 5th, 10th, 90th and 95% (per)centiles and the quartiles and median
vecQuantiles <- c(.05, .1, .25, .5, .75, .9, .95)

### looking at 100 scores from 1 to 100
plotQuantileCIsfromDat(vecDat = 1:100, vecQuantiles = vecQuantiles,
                     method = "N", ci = 0.95, R = 9999, type = 8,
                     titleJust = 1, # right justify the title and subtitle
                     themeBW = TRUE) # use theme_bw()

### same data
plotQuantileCIsfromDat(vecDat = 1:100, vecQuantiles = vecQuantiles,
                     method = "N", ci = 0.95, R = 9999, type = 8,
                     titleJust = .5, # centre the title and subtitle
                     themeBW = TRUE)

### same data
plotQuantileCIsfromDat(vecDat = 1:100, vecQuantiles = vecQuantiles,
                     method = "N", ci = 0.95, R = 9999, type = 8,
                     titleJust = .5, themeBW = FALSE,
                     printPlot = FALSE, # this time don't plot from within the function call but
                     ## this next argument ask the function the plot object
                     returnPlot = TRUE) -> tmpPlot
### so plot it! (plot() and print() will both work,
### you can also manipulate the plot before printing)
print(tmpPlot)

### this illustrates the CIs getting tighter as the dataset size goes up
plotQuantileCIsfromDat(vecDat = 1:1000, vecQuantiles = vecQuantiles,
                     method = "N", ci = 0.95, R = 9999, type = 8)

### and even more data, tighter CIs again
plotQuantileCIsfromDat(vecDat = 1:10000, vecQuantiles = vecQuantiles,
                     method = "N", ci = 0.95, R = 9999, type = 8)

### now a Gaussian ("Normal") distribution of scores
plotQuantileCIsfromDat(vecDat = rnorm(100), vecQuantiles = vecQuantiles,
                     method = "N", ci = 0.95, R = 9999, type = 8)

### larger dataset
plotQuantileCIsfromDat(vecDat = rnorm(1000), vecQuantiles = vecQuantiles,
                     method = "N", ci = 0.95, R = 9999, type = 8)

### and larger again
plotQuantileCIsfromDat(vecDat = rnorm(10000), vecQuantiles = vecQuantiles,
                     method = "N", ci = 0.95, R = 9999, type = 8,
                     titleJust = .5, themeBW = TRUE)
} # }
```
