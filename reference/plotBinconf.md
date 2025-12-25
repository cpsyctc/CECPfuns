# Function outputting a plot of confidence interval around a proportion for a range of sample sizes

Function outputting a plot of confidence interval around a proportion
for a range of sample sizes

## Usage

``` r
plotBinconf(proportion, minN, maxN, step = 1, conf = 0.95, fixYlim = FALSE)

plotCIProportion(
  proportion,
  minN,
  maxN,
  step = 1,
  conf = 0.95,
  fixYlim = FALSE
)
```

## Arguments

- proportion:

  numeric: the proportion sought (actual proportion will be nearest
  possible for each n)

- minN:

  numeric: the smallest sample size, n, to estimate and plot

- maxN:

  numeric: the largest n

- step:

  numeric: the steps to use between minN and maxN, defaults to 1 but set
  higher if plotting a wide range of n

- conf:

  numeric: confidence interval width, usually .95

- fixYlim:

  logical: if FALSE, ggplot finds sensible y limits, if TRUE, y axis
  runs from 0 to 1

## Value

a ggplot object, by default that will print but you can save it and
modify it as you like

## Background

This little function just plots confidence intervals (CIs) for a
proportion for a range of sample sizes. I wrote it after writing
[`classifyScoresVectorByRCI`](https://cecpfuns.psyctc.org/reference/classifyScoresVectorByRCI.md)
which will give CIs around observed proportions and I thought that for
people not entirely familiar with and comfortable with CIs it might be
useful for them to be able to see a plot of how intervals around
observed proportions change with sample size. \#'

## History/development log

Started before 5.iv.21

## See also

Other confidence interval functions:
[`getCIPearson()`](https://cecpfuns.psyctc.org/reference/getCIPearson.md),
[`getCISpearman()`](https://cecpfuns.psyctc.org/reference/getCISpearman.md),
[`plotCIPearson()`](https://cecpfuns.psyctc.org/reference/plotCIPearson.md)

Other demonstration functions:
[`plotCIPearson()`](https://cecpfuns.psyctc.org/reference/plotCIPearson.md)

## Author

Chris Evans

## Examples

``` r
if (FALSE) { # \dontrun{

### 95% CI around proportion .5 for n from 10 to 70
plotBinconf(.5, 10, 70, conf = .95) # don't have to declare conf, defaults to .95
### notice that the observed proportion wiggles up and down as n increases as
### you can only have integer counts so functions gets nearest to the desired
### proportion, here .5, possible for that n, so for n = 10, we can have perfect .5
### but for n = 11 6/11 is .545454..

### 90% CI around proportion .5 for n from 10 to 70
plotBinconf(.5, 10, 70, conf = .90)

### 90% CI around proportion .5 for n from 100 to 200
plotBinconf(.5, 10, 70, conf = .90)

### same but fixing y limits to 0 and 1
plotBinconf(.5, 10, 70, conf = .90, fixYlim = TRUE)

### default 95% CI, exporting to tmpPlot and then changing plot
plotBinconf(.5, 10, 70) -> tmpPlot
tmpPlot +
   ggtitle("95% CI around proportion .5 for n from 10 to 70") +
   theme_bw()

### other inputs
plotBinconf(0, .95, 10, 70)
plotBinconf(1, .95, 10, 70)
plotBinconf(.7, .95, 100, 200)
plotBinconf(.3, .95, 100, 700, 5)

} # }
```
