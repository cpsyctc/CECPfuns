# Title Function designed for use in dplyr (tidyverse) piping to return CSC and bootstrap CI around that

Title Function designed for use in dplyr (tidyverse) piping to return
CSC and bootstrap CI around that

## Usage

``` r
getBootCICSC(formula1, data, bootReps = 1000, conf = 0.95, bootCImethod = "pe")
```

## Arguments

- formula1:

  formula defining the two variables to be correlated as scores ~ group

- data:

  data.frame or tibble with the data, often constructed with pick() in
  dplyr

- bootReps:

  integer giving number of bootstrap replications

- conf:

  numeric value giving width of confidence interval, e.g. .95 (default)

- bootCImethod:

  string giving method to derive bootstrap CI, minimum two letters 'pe',
  'no', 'ba' or 'bc' for percentile, normal, basic or bca

## Value

list of named values obsCSC, LCLCSC and UCLCSC

## Background

For general information about the CSC (Clinically Significant Change
criterion), see
[`getCSC`](https://cecpfuns.psyctc.org/reference/getCSC.md)

## History/development log

Started before 5.iv.21

## See also

[`getCSC`](https://cecpfuns.psyctc.org/reference/getCSC.md) provides
just the CSC if you don't need the CI around it. Much faster of course!

Other RCSC functions:
[`classifyScoresVectorByRCI()`](https://cecpfuns.psyctc.org/reference/classifyScoresVectorByRCI.md),
[`getCSC()`](https://cecpfuns.psyctc.org/reference/getCSC.md),
[`getRCIfromSDandAlpha()`](https://cecpfuns.psyctc.org/reference/getRCIfromSDandAlpha.md)

Other bootstrap CI functions:
[`getBootCICorr()`](https://cecpfuns.psyctc.org/reference/getBootCICorr.md),
[`getBootCIalpha()`](https://cecpfuns.psyctc.org/reference/getBootCIalpha.md),
[`getBootCIgrpMeanDiff()`](https://cecpfuns.psyctc.org/reference/getBootCIgrpMeanDiff.md),
[`getBootCImean()`](https://cecpfuns.psyctc.org/reference/getBootCImean.md)

## Author

Chris Evans

## Examples

``` r
if (FALSE) { # \dontrun{
### will need tidyverse to run
library(tidyverse)
### create some data
n <- 120
set.seed(12345) # to get replicable sample and results from the bootstrap
list(scores = rnorm(n), # Gaussian random base for scores
  ### now add a grouping variable: help-seeking or not
  grp = sample(c("HS", "not"), n, replace = TRUE),
  ### now add gender
  gender = sample(c("F", "M"), n, replace = TRUE)) %>%
  as_tibble() %>%
  ### next add a gender effect nudging women's scores up by .4
  mutate(scores = if_else(gender == "F", scores + .4, scores),
  ### next add the crucial help-seeking effect of 1.1
        scores = if_else(grp == "HS", scores + 1.1, scores)) -> tmpDat

### have a look at that
tmpDat

### this just computes the CSC and CI(CSC) for the whole dataset
tmpDat %>%
  ### don't forget to prefix the call with "list(" to tell dplyr
  ### you are creating list output
  ### Also pick(everything()) has replaced the deprecated cur_data() that I used
  ### earlier I see the flexibility of pick() but it's ugly when used to replace
  ### the simpler cur_data() for this sort of thing.  Not my choice!
  summarise(CSC = list(getBootCICSC(scores ~ grp, pick(everything())))) %>%
  ### now unnest the list to columns
  unnest_wider(CSC)

### now an example of how this becomes useful: same but by grouping by gender
tmpDat %>%
  group_by(gender) %>%
  ### remember the list output again!
  summarise(CSC = list(getBootCICSC(scores ~ grp, pick(everything())))) %>%
  ### remember to unnnest again!
  unnest_wider(CSC)
} # }
```
