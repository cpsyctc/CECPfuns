# Function to return bootstrap CI around observed mean

Function to return bootstrap CI around observed mean

## Usage

``` r
getBootCImean(
  x,
  data = NULL,
  bootReps = 1000,
  conf = 0.95,
  bootCImethod = c("perc", "norm", "basic", "bca"),
  na.rm = TRUE,
  verbose = TRUE,
  nLT20err = TRUE,
  nGT10kerr = TRUE,
  zeroSDerr = FALSE
)
```

## Arguments

- x:

  name of variable in data, character or bare name, or simply a numeric
  vector if data is NULL, see examples

- data:

  data frame or tibble containing variable, NULL if x passed directly

- bootReps:

  integer for number of bootstrap replications

- conf:

  numeric confidence interval desired as fraction, e.g. .95

- bootCImethod:

  method of deriving bootstrap CI from "perc", "norm", "basic" or "bca"

- na.rm:

  logical, set to FALSE to ensure function will fail if there are
  missing data

- verbose:

  logical, FALSE suppresses the messages

- nLT20err:

  logical, throws error if length(na.omit(x)) \< 20, otherwise returns
  NA for CI

- nGT10kerr:

  logical, throws error if length(na.omit(x)) \> 10k to prevent very
  long rusn, override with FALSE

- zeroSDerr:

  logical, default is to return NA for CI if sd(x) is near zero or zero,
  zeroSDerr throws error

## Value

list of length 3: obsmean, LCLmean and UCLmean

## comment

I have tried to make this function as flexible as possible in two
particular ways.

1.  The variable on which to compute the bootstrapped CI of the mean can
    be fed in as a simple vector, or as a named column in a dataframe or
    tibble

2.  The function defaults to stop with an error where it might run for
    many hours. However, that can be overridden with nGT10kerr = FALSE.

3.  Where there are insufficient non-missing values the default is to
    stop but again nLT20err = FALSE overrides that and returns NA for
    the confidence limits.

4.  Where there is zero or near zero variance the function returns NA
    for the confidence limits but that can be made an error condition
    with zeroSDerr = TRUE.

5.  The function defaults (verbose = TRUE) to give quite a lot of
    information in messages. Those can be switched off.

6.  The width of the confidence interval and the method of computing it
    can be set, as can the number of bootstrap resamples to run.

As with almost all my functions in the CECPfuns package, getBootCImean()
is primarily designed for use in dplyr piping.

## History/development log

Started before 5.iv.21 Tweaked 11.iv.21 to fix error in examples.

## See also

Other bootstrap CI functions:
[`getBootCICSC()`](https://cecpfuns.psyctc.org/reference/getBootCICSC.md),
[`getBootCICorr()`](https://cecpfuns.psyctc.org/reference/getBootCICorr.md),
[`getBootCIalpha()`](https://cecpfuns.psyctc.org/reference/getBootCIalpha.md),
[`getBootCIgrpMeanDiff()`](https://cecpfuns.psyctc.org/reference/getBootCIgrpMeanDiff.md)

## Author

Chris Evans

## Examples

``` r
if (FALSE) { # \dontrun{
set.seed(12345) # get replicable results
library(magrittr)
### now make up some silly data
n <- 50
rnorm(n) %>% # get some random Gaussian data
  as_tibble() %>%
  ### create a spurious grouping variable
  mutate(food = sample(c("sausages", "carrots"), n, replace = TRUE),
         ### create variable with some missing data to test na.rm = FALSE
         y = if_else(value < -1, NA_real_, value)) -> tmpDat

### check that worked
tmpDat
### looks fine!

### default arguments, just supply variable
getBootCImean(tmpDat$value)

### default arguments, select variable by name as character
getBootCImean("value", tmpDat)

### default arguments, select variable by name as bare name
tmpDat %>%
  ### pick(everything()) has replaced cur_data(): more flexible but more verbose
  summarise(meanCI = list(getBootCImean(value, pick(everything())))) %>%
  unnest_wider(meanCI)

### default arguments, select variable by name as character
tmpDat %>%
  summarise(meanCI = list(getBootCImean("value", pick(everything())))) %>%
  unnest_wider(meanCI)

### default arguments, select variable by name as bare name
tmpDat %>%
  summarise(meanCI = list(getBootCImean(value, pick(everything())))) %>%
  unnest_wider(meanCI)

### default arguments, get mean of value by food
tmpDat %>%
  group_by(food) %>%
  summarise(meanCI = list(getBootCImean(value, pick(everything())))) %>%
  unnest_wider(meanCI)

### suppress messages
tmpDat %>%
  summarise(meanCI = list(getBootCImean(value,
                                        pick(everything()),
                                        verbose = FALSE))) %>%
  unnest_wider(meanCI)

### default silent omission of missing data, messages back
###  analysing variable y which has missing data
###  (see "Usable n")
tmpDat %>%
  summarise(meanCI = list(getBootCImean(y,
                                        pick(everything()),
                                        verbose = TRUE))) %>%
  unnest_wider(meanCI)

### use na.rm = FALSE to ensure call will fail if there are missing data
tmpDat %>%
  summarise(meanCI = list(getBootCImean(y,
                                        pick(everything()),
                                        verbose = TRUE,
                                        na.rm = FALSE))) %>%
  unnest_wider(meanCI)

### change bootstrap interval
tmpDat %>%
  summarise(meanCI = list(getBootCImean(y,
                                        pick(everything()),
                                        conf = .9))) %>%
  unnest_wider(meanCI)

### change bootstrap CI method ("perc" is default)
tmpDat %>%
  summarise(meanCI = list(getBootCImean(y,
                                        pick(everything()),
                                        verbose = TRUE,
                                        bootCImethod = "no"))) %>%
  unnest_wider(meanCI)

### should fail on impossible to decode choice of method in args
tmpDat %>%
  summarise(meanCI = list(getBootCImean(y,
                                        pick(everything()),
                                        verbose = TRUE,
                                        bootCImethod = "b"))) %>%
  unnest_wider(meanCI)
} # }
```
