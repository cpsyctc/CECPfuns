# Trivial function to count number of non-NA values in input

Trivial function to count number of non-NA values in input

## Usage

``` r
getNOK(x)
```

## Arguments

- x:

  is a vector of values

## Value

numeric: the number of non-NA values in x

## History/development log

Started before 5.iv.21

## See also

[`getNNA`](https://cecpfuns.psyctc.org/reference/getNNA.md) for count of
missing values

Other counting functions:
[`getNNA()`](https://cecpfuns.psyctc.org/reference/getNNA.md)

Other data checking functions:
[`checkAllUnique()`](https://cecpfuns.psyctc.org/reference/checkAllUnique.md),
[`getNNA()`](https://cecpfuns.psyctc.org/reference/getNNA.md),
[`isOneToOne()`](https://cecpfuns.psyctc.org/reference/isOneToOne.md)

## Author

Chris Evans

## Examples

``` r
getNOK(c(1:5, NA, 7:10))
#> [1] 9
```
