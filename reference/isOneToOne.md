# Data checking function to check if the contents of two variables have a 1:1 mapping

Data checking function to check if the contents of two variables have a
1:1 mapping

## Usage

``` r
isOneToOne(x, y)

checkIsOneToOne(x, y)
```

## Arguments

- x:

  first variable

- y:

  second variable

## Value

logical: TRUE if 1:1 mapping, FALSE otherwise

## Background

This is a little utility function that I use from time to time when I
want to check whether two variables have a one to one mapping they
should have. Typically this is where one of them is a short code say
variable x, for the other, say variable y. If you have two vectors, one
of the short codes, x, and one of the longer, y, they should have a
perfect 1:1 mapping, so for any value in x there must the same number of
its mapped value in y. For example:

|                                                       |        |
|-------------------------------------------------------|--------|
| x                                                     | y      |
| 1                                                     | Male   |
| 2                                                     | Female |
| 3                                                     | Other  |
| 2                                                     | Female |
| 2                                                     | Female |
| 1                                                     | Male   |
| 3                                                     | Other  |
| Has a perfect 1:1 mapping of x to y so, assuming that |        |
| I had x and y as vectors,                             |        |
| `isOneToOne(x, y)` will return TRUE.                  |        |

|                                                         |         |
|---------------------------------------------------------|---------|
| x                                                       | y       |
| 1                                                       | Male    |
| 2                                                       | Feemale |
| 3                                                       | Other   |
| 2                                                       | Female  |
| 2                                                       | Female  |
| 1                                                       | male    |
| 3                                                       | Other   |
| does not 1:1 (and isn't a completely mad example        |         |
| of typical messes in real world data, if perhaps a very |         |
| simple one!) Of course, here                            |         |
| `isOneToOne(x, y)` will return FALSE.                   |         |

## Acknowledgements

I found this nice way of doing this at
https://stackoverflow.com/questions/52399474/check-if-variables-are-in-a-one-to-one-mapping

## History/development log

Started before 5.iv.21

## See also

Other data checking functions:
[`checkAllUnique()`](https://cecpfuns.psyctc.org/reference/checkAllUnique.md),
[`getNNA()`](https://cecpfuns.psyctc.org/reference/getNNA.md),
[`getNOK()`](https://cecpfuns.psyctc.org/reference/getNOK.md)

## Author

Chris Evans

## Examples

``` r
if (FALSE) { # \dontrun{
### this should map OK
isOneToOne(1:5,letters[1:5])
### 1:1 doesn't actually mean just one of each,
### just that the mapping is 1:1!
isOneToOne(rep(1:5, 2), rep(letters[1:5], 2))
### should throw an error as unequal length
isOneToOne(1:26, letters[1:25])
### but this is OK
isOneToOne(1:26, c("1", letters[1:25]))
### but this is not as it's no longer 1:1
isOneToOne(c(1, 1:26), c("1", letters[1:25], "1"))
### same the other way around (essentially)
isOneToOne(1:26,c("a",letters[1:25]))
} # }

```
