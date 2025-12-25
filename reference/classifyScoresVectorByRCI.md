# Function to classify changes using the RCI paradigm

Function to classify changes using the RCI paradigm

## Usage

``` r
classifyScoresVectorByRCI(
  scoreChange = NULL,
  score1 = NULL,
  score2 = NULL,
  RCI = NULL,
  cueing = "negative",
  verbose = TRUE,
  returnTable = TRUE,
  dp = 1,
  addCI = FALSE,
  returnNumeric = FALSE,
  CLsSeparate = FALSE,
  conf = 0.95
)
```

## Arguments

- scoreChange:

  numeric vector of score changes

- score1:

  numeric vector of baseline scores (if not giving scoreChange)

- score2:

  numeric vector of final scores (if not giving scoreChange)

- RCI:

  numeric value of the RCI

- cueing:

  whether measure is cued positively or negatively

- verbose:

  logical: suppresses messages if FALSE

- returnTable:

  logical: whether summary table returned (TRUE) or a tibble of
  classified scores (FALSE)

- dp:

  numeric: number of decimal places in percentages (if returnTable TRUE)

- addCI:

  logical: whether to add confidence intervals around observed
  percentages e.g. "69.6% to 87.5%"

- returnNumeric:

  logical: whether to return values as numeric or as nicely formatted
  strings (the default)

- CLsSeparate:

  logical: returns CI as two separate variables instead of that string

- conf:

  numeric, gives the width of the confidence interval (if addCI is TRUE)

## Value

a tibble, either of the summary breakdown with n and % by
classification, or a tibble of the data with classified change

## Warning

Function is still under development. Currently handles vector input. I
will be modifying it to handle data frame and tibble input but not sure
how best to do that yet. Currently heading for making that a separate
function: classifyScoresInDataByRCI()

## Background

The RCI is part of Jacobson, Follette and Revenstorf's "RCSC": Reliable
and Clinically Significant Change paradigm.

## History/development log

Started before 5.iv.21 Tweaked 11.iv.21 to fix error in examples.

## See also

[`getCSC`](https://cecpfuns.psyctc.org/reference/getCSC.md) for more
general information about the paradigm and

[`getRCIfromSDandAlpha`](https://cecpfuns.psyctc.org/reference/getRCIfromSDandAlpha.md)
for more detail about the RCI.

Note that by the logic of the criterion, change has to exceed the RCI,
not just equal it, for change to be deemed reliable.

### Details

Splitting change into three levels: reliable deterioration, no reliable
change, and reliable improvement is pretty trivial. However, as I worked
on this function it did seem to grow into something not so trivial that
probably will save people time. It can be used in two main ways:

1.  to return a tibble of the scoreChange or the score1, score2 and
    computed scoreChange with the RCI categories added (returnTable =
    FALSE).

2.  to return a tabulation of the categories (returnTable = TRUE).

I have given examples below but there are some aspects to option 2)
wthat can be adjusted by:

- using dp to determine the decimal places on the percentage breakdown
  (defaults to 1 decimal place)

- using addCI = TRUE to add a column giving the confidence interval (CI)
  around the observed percentage and perhaps ...

- using conf to choose something other than the default .95, i.e. a 95%
  interval ... though I can't really think of a good reason to do this!

Adding the CI is probably mainly useful when you want to compare the
breakdown from a particular set of data with some other data or some
published figure or even, though I hope not, some managerial or
political target.

Bear in mind that the three percentages must sum to 100% so they are not
independent of one another and the three CIs are therfore also not
independent.

### Technicality

The CI is calculated using
[`binconf`](https://rdrr.io/pkg/Hmisc/man/binconf.html) function from
Frank Harrell's Hmisc package of miscellaneous functions. That uses
Wilson's method to compute the CIs. See the documentation for
[`binconf`](https://rdrr.io/pkg/Hmisc/man/binconf.html) for a brief
discussion of that choice and references.

Other RCSC functions:
[`getBootCICSC()`](https://cecpfuns.psyctc.org/reference/getBootCICSC.md),
[`getCSC()`](https://cecpfuns.psyctc.org/reference/getCSC.md),
[`getRCIfromSDandAlpha()`](https://cecpfuns.psyctc.org/reference/getRCIfromSDandAlpha.md)

## Author

Chris Evans

## Examples

``` r
if (FALSE) { # \dontrun{

### start with some very simple change values:
scoreChanges <- -5:5
scoreChanges # is:
#  [1] -5 -4 -3 -2 -1  0  1  2  3  4  5

## so now apply an RCI value of 2 to that:
classifyScoresVectorByRCI(scoreChange = scoreChanges, RCI = 2)
## produces:
# You input 11 values for scoreChange.  There were no missing values.
## A tibble: 3 x 4
# RCIclass                   n percent valid_percent
# <ord>                  <int> <chr>   <chr>
#   1 Reliable deterioration     3 27.3%   27.3%
#   2 No reliable change         5 45.5%   45.5%
#   3 Reliable improvement       3 27.3%   27.3%

### you could pipe that to your R/tidyverse table formatting
### tool of choice, \code{pander}, \code{huxtable}, whatever.

### you can add the 95% CI:
### create some spurious scores
n <- 75
score1 <- rnorm(n) # random Gaussian scores
score2 <- score1 - rnorm(n, mean = .2, sd = .2) # and some random change
scoreChange <- score1 - score2 # get the change

classifyScoresVectorByRCI(scoreChange, RCI = .3)

classifyScoresVectorByRCI(score1 = score1, score2 = score2, RCI = .3)
} # }
```
