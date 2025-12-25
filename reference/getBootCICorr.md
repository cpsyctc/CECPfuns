# Function to return observed correlation between two variables with bootstrap CI

Function to return observed correlation between two variables with
bootstrap CI

## Usage

``` r
getBootCICorr(
  formula1,
  data,
  method = "p",
  bootReps = 1000,
  conf = 0.95,
  bootCImethod = "pe"
)
```

## Arguments

- formula1:

  formula defining the two variables to be correlated as var1 ~ var2

- data:

  data.frame or tibble with the data, often subset of the data created
  with group_by() and pick()

- method:

  string giving correlation method, can be single letter 'p', 's' or 'k'
  for pearson, spearman or kendall (in cor())

- bootReps:

  integer giving number of bootstrap replications

- conf:

  numeric value giving width of confidence interval, e.g. .95 (default)

- bootCImethod:

  string giving method to derive bootstrap CI, can be two letters 'pe',
  'no', 'ba' or 'bc' for percentile, normal, basic or bca

## Value

list of named values: obsCorr, LCLCorr and UCLCorr

## History/development log

Started before 5.iv.21

## See also

Other bootstrap CI functions:
[`getBootCICSC()`](https://cecpfuns.psyctc.org/reference/getBootCICSC.md),
[`getBootCIalpha()`](https://cecpfuns.psyctc.org/reference/getBootCIalpha.md),
[`getBootCIgrpMeanDiff()`](https://cecpfuns.psyctc.org/reference/getBootCIgrpMeanDiff.md),
[`getBootCImean()`](https://cecpfuns.psyctc.org/reference/getBootCImean.md)

## Author

Chris Evans

## Examples

``` r
if (FALSE) { # \dontrun{
library(tidyverse)
### create some data
set.seed(12345) # make this replicable
n <- 150
tibble(x = rnorm(n), y = rnorm(y)) %>%
   ### that's got us sample x and y from population in which they're uncorrelated
   ### make them correlated:
   mutate(y = y + .2 * x)  -> data

data %>%
   ### don't forget to prefix the call with "list(" to tell dplyr
   ### you are creating list output
   summarise(corr = list(getBootCICorr(x ~ y,
             pick(everything()),
             ### pick(everything()) is, to my mind, a rather verbose replacement for cur_data()
             method = "p", # gets the Pearson correlation
             bootReps = 1000,
             ### "pe" in next line gets the percentile bootstrap CI
             bootCImethod = "pe"))) %>%
   ### now unnest the list output to separate columns
   unnest_wider(corr)
} # }
```
