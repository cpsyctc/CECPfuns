# Simple function to return Cronbach's alpha

Simple function to return Cronbach's alpha

## Usage

``` r
getChronbachAlpha(dat, na.rm = TRUE, verbose = TRUE)
```

## Arguments

- dat:

  data, matrix, data frame or tibble and numeric item data as columns

- na.rm:

  logical which causes function to throw error if there is missing data

- verbose:

  logical, if FALSE switches off message about n(items) and number of
  usable rows

## Value

Cronbach as numeric

## Background

Very simple function that does a fair bit of sanity checking on the
input and returns Cronbach's alpha which was first described
comprehensively in the classic paper Cronbach (1951). There is an
extensive literature criticising alpha as an index of internal
consistency/reliability often, to my reading, failing to note that
Cronbach's original paper was quite clear about the issues. Alpha is not
a measure of unidimensionality but a measure of shared covariance and
there are strong arguments that it is not the best indicator of internal
reliability when there are marked differences in variance between items.
The various arguments have led many to recommend McDonald's omega as a
better measure than alpha. Perhaps partly because the canonical
reference to McDonald's omega is to his book (McDonald, 1999) and not to
a paper, the literature on this is, to my mind again, a bit complicated.
There is good coverage in the help for omega() in Revelle's package
psych omega. Despite the complexities alpha remains the most reported
statistic for internal relability of multi-item measures with some good
reasons: it is simple, robust and never claimed to be doing things it
doesn't do!

## History/development log

Started before 5.iv.21

## References

Cronbach, L. J. (1951). Coefficient alpha and the internal structure of
tests. Psychometrika, 16(3), 297–334. McDonald R. P. (1999) Test Theory:
A Unified Treatment. Mahwah, NJ: Erlbaum

## See also

Other Chronbach alpha functions:
[`getBootCIalpha()`](https://cecpfuns.psyctc.org/reference/getBootCIalpha.md)

## Author

Chris Evans

## Examples

``` r
if (FALSE) { # \dontrun{
### make some nonsense data
tmpMat <- matrix(rnorm(200), ncol = 10)
### default call
getChronbachAlpha(tmpMat)
### switch off message with dimensions of non-missing data
getChronbachAlpha(tmpMat, verbose = FALSE)
} # }
```
