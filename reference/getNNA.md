# Trivial function to count number of NA values in input

Trivial function to count number of NA values in input

## Usage

``` r
getNNA(x)
```

## Arguments

- x:

  vector containing the values to check for NAs

## Value

numeric: the number of NA values in

## History/development log

Started before 5.iv.21

## See also

[`getNOK`](https://cecpfuns.psyctc.org/reference/getNOK.md) for count of
non-missing values

Other counting functions:
[`getNOK()`](https://cecpfuns.psyctc.org/reference/getNOK.md)

Other data checking functions:
[`checkAllUnique()`](https://cecpfuns.psyctc.org/reference/checkAllUnique.md),
[`getNOK()`](https://cecpfuns.psyctc.org/reference/getNOK.md),
[`isOneToOne()`](https://cecpfuns.psyctc.org/reference/isOneToOne.md)

## Author

Chris Evans

## Examples

``` r
getNNA(c(1:5, NA, 7:10))
#> [1] 1
getNNA(c(1:5, NA, 7:10))
#> [1] 1
```
