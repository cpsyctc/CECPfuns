# Function outputting a plot of confidence interval around a correlation for a range of sample sizes

Function outputting a plot of confidence interval around a correlation
for a range of sample sizes

## Usage

``` r
plotCIPearson(
  corr,
  minN,
  maxN,
  step = 1,
  conf = 0.95,
  minY = NULL,
  maxY = NULL
)
```

## Arguments

- corr:

  numeric: Pearson correlation

- minN:

  numeric: the smallest n for which you want the CI

- maxN:

  numeric: the largest n for which you want the CI

- step:

  numeric: the step by which you want n to increment (default is 1),
  with minN and maxN should give no more than 200 values of n

- conf:

  numeric: the confidence interval you want, defaults to .95

- minY:

  numeric: if you want to set the y axis limits input a number greater
  than -1 here

- maxY:

  numeric: if you want to set the y axis limits input a number smaller
  than 1 here

## Value

a ggplot object so if you don't capture it it will plot to your default
plot device

## Background

This is another function like
[`plotBinconf`](https://cecpfuns.psyctc.org/reference/plotBinconf.md)
which plots the width of confidence intervals (CIs) for a range of
sample/dataset sizes.

## History/development log

Version 1: 5.iv.21 Version 2: 25.xi.23 Renamed to plotCIPearson to allow
for addition of plotCISpearman soon.

## See also

Other confidence interval functions:
[`getCIPearson()`](https://cecpfuns.psyctc.org/reference/getCIPearson.md),
[`getCISpearman()`](https://cecpfuns.psyctc.org/reference/getCISpearman.md),
[`plotBinconf()`](https://cecpfuns.psyctc.org/reference/plotBinconf.md)

Other demonstration functions:
[`plotBinconf()`](https://cecpfuns.psyctc.org/reference/plotBinconf.md)

## Author

Chris Evans

## Examples

``` r
if (FALSE) { # \dontrun{
### simple example for observed 95% confidence interval (CI) around observed correlation of .7
### for sample sizes between 10 and 100
plotCIPearson(.7, 10, 100)

### similar but for dataset sizes between 10 and 500 by steps of 5
plotCIPearson(.7, 10, 500, 5)

### similar but asking for 99% CI
plotCIPearson(.7, 10, 500, 5, conf = .99)

### similar but setting lower y axis limit to -1
plotCIPearson(.7, 10, 500, 5, conf = .99, minY = -1)

### and you can set the upper y limit, observed R = 0 for a change
plotCIPearson(0, 10, 500, 5, conf = .99, minY = -1, maxY = 1)

### same but exporting to tmpPlot and then changing plot
plotCIPearson(0, 10, 500, 5, conf = .99, minY = -1, maxY = 1) -> tmpPlot
tmpPlot +
   ggtitle("95% CI around observed Pearson correlation of zero for n from 10 to 500") +
   theme_bw()

} # }
```
