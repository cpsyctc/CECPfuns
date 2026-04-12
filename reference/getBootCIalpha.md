# function returning observed Cronbach alpha with bootstrap confidence interval around that value

function returning observed Cronbach alpha with bootstrap confidence
interval around that value

## Usage

``` r
getBootCIalpha(
  dat,
  verbose = TRUE,
  na.rm = TRUE,
  nLT20err = TRUE,
  nGT10kerr = TRUE,
  bootReps = 1000,
  conf = 0.95,
  bootCImethod = c("perc", "norm", "basic", "bca")
)
```

## Arguments

- dat:

  data, matrix, data frame or tibble and numeric item data as columns

- verbose:

  logical, if FALSE switches off messages

- na.rm:

  logical which causes function to throw error if there is missing data

- nLT20err:

  logical, throws error if length(na.omit(dat)) \< 20, otherwise returns
  NA for CI

- nGT10kerr:

  logical, throws error if length(na.omit(dat)) \> 10k to prevent very
  long rusn, override with FALSE

- bootReps:

  integer for number of bootstrap replications

- conf:

  numeric confidence interval desired as fraction, e.g. .95

- bootCImethod:

  method of deriving bootstrap CI from "perc", "norm", "basic" or "bca"

## Value

list of length 3: obsAlpha, LCLAlpha and UCLAlpha

## History/development log

Started before 5.iv.21 Improved help 12.iv.26

## See also

Other bootstrap CI functions:
[`getBootCICSC()`](https://cecpfuns.psyctc.org/reference/getBootCICSC.md),
[`getBootCICorr()`](https://cecpfuns.psyctc.org/reference/getBootCICorr.md),
[`getBootCIgrpMeanDiff()`](https://cecpfuns.psyctc.org/reference/getBootCIgrpMeanDiff.md),
[`getBootCImean()`](https://cecpfuns.psyctc.org/reference/getBootCImean.md)

Other Chronbach alpha functions:
[`getChronbachAlpha()`](https://cecpfuns.psyctc.org/reference/getChronbachAlpha.md)

## Author

Chris Evans

## Examples

``` r
if (FALSE) { # \dontrun{
### I will create some examples of how the function can be used,
### in base R or tidyverse modes.
### create some data: 200 rows, 10 variables
### Gaussian distribution
set.seed(12345) # just to get same data every time
matrix(rnorm(2000), ncol = 10) -> matDat
### now pipe that matrix into a data frame
matDat %>%
### this next line saves going through the rather
### laborious way of constructing variable
### names that you have to follow if
### you go direct to as_tibble() !
as.data.frame() %>%
as_tibble() %>%
### so now we have a 200x10 tibble (i.e. a
### tidyverse version of a data frame)
### let's make some of these participants
### young and some old
### make the odd numbered ones "young"
mutate(age = if_else(row_number() %% 2 == 1,
                       "young",
                       "old")) %>%
### get variables in a more sensible order
select(age, everything()) -> tibDat
### OK, we have some data, let's use it!

### As with all bootstrap functions, it's wise
### to set the random number generator (RNG) seed
### before running the function to ensure you see
### exactly the same results every time.
### That's a different issue from the one above
### about setting the RNG seed to get the same data
### every time when generating data.  Same principle
### different effect.
###
### this is base R idiom and using the function's default arguments
### to analyse a matrix
getBootCIalpha(matDat)
###
### this is base R analysing a tibble (or data frame)
getBootCIalpha(tibDat[ , -1])
###
### now tidyverse, still entire tibble
tibDat %>%
select(-age) %>%
summarise(alphaCI = list(getBootCIalpha(pick(everything())))) %>%
unnest_wider(alphaCI) # unnest to get the results


### more useful tidyverse, analysing the age groups separately
tibDat %>%
group_by(age) %>%
  summarise(alphaCI = list(getBootCIalpha(pick(everything())))) %>%
  ungroup %>%
  unnest_wider(alphaCI) # unnest again
} # }
```
