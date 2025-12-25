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

Started before 5.iv.21

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
set.seed(12345)
tmpMat <- matrix(rnorm(200), ncol = 10)
tmpDat <- as.data.frame(tmpMat)
tmpTib <- as_tibble(tmpDat)

### all default arguments
getBootCIalpha (tmpMat)
} # }
```
