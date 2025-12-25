# Function that takes an index number and gives which sequential set of N it is in

Finds the sequential number of sets of data when reading fixed size
multirow blocks of rows.

## Usage

``` r
whichSetOfN(x, n)
```

## Arguments

- x:

  object to test

- n:

  size of set

## Value

integer: the number of the set, 1,2,3 ...

## Background

I am quite often importing data with a multirow nested structure so I
may have data from participants with different ID values and with
different occasions per participant and then some fixed number of rows
of data per person per occasion. For one set of data I might have say
four rows of medication data per participant per occasion per actual
medication prescribed. I use whichSetOfN(row_number(), 4) to tell me the
sequential number of the prescription this row (found by row_number()
inside a group_by()).

## History/development log

Started 12.x.24

## See also

Other utility functions:
[`convertClipboardAuthorNames()`](https://cecpfuns.psyctc.org/reference/convertClipboardAuthorNames.md),
[`fixVarNames()`](https://cecpfuns.psyctc.org/reference/fixVarNames.md),
[`getAttenuatedR()`](https://cecpfuns.psyctc.org/reference/getAttenuatedR.md),
[`getCorrectedR()`](https://cecpfuns.psyctc.org/reference/getCorrectedR.md),
[`getLastDateInMonth()`](https://cecpfuns.psyctc.org/reference/getLastDateInMonth.md),
[`getSvalFromPval()`](https://cecpfuns.psyctc.org/reference/getSvalFromPval.md)

## Author

Chris Evans

## Examples

``` r
whichSetOfN(1:7, 3)
#> [1] 1 1 1 2 2 2 3
### shows that 1:3 belong to set 1, 4:6 to set 2 and 7 to set 3

```
