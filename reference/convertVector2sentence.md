# Function that converts a vector to an English language list: e.g. 1:3 becomes 1, 2 and 3

Function that converts a vector to an English language list: e.g. 1:3
becomes 1, 2 and 3

## Usage

``` r
convertVector2sentence(
  x,
  andChar = " and ",
  quoted = FALSE,
  quoteChar = "\"",
  italicY = FALSE
)

convertVectorToSentence(
  x,
  andChar = " and ",
  quoted = FALSE,
  quoteChar = "\"",
  italicY = FALSE
)
```

## Arguments

- x:

  input vector or one dimensional list to convert

- andChar:

  string to put between penultimate and last entry

- quoted:

  logical indicating whether each item should be quoted and hence

- quoteChar:

  string to put around each item to quote it

- italicY:

  logical to have items italicised

## Value

string

## History/development log

Started before 5.iv.21 10.iv.21: added synonym convertVectorToSentence

## See also

[`hyphenateWords`](https://cecpfuns.psyctc.org/reference/hyphenateWords.md)
for another utility function to convert numbers to English words, e.g.
"87" to "eighty-seven".

Other text utilities:
[`hyphenateWords()`](https://cecpfuns.psyctc.org/reference/hyphenateWords.md)

Other converting utilities:
[`convert2CEdate()`](https://cecpfuns.psyctc.org/reference/convert2CEdate.md)

## Author

Chris Evans

## Examples

``` r
### default behaviour
convertVector2sentence(1:4)
#> [1] "1, 2, 3 and 4"
### [1] "1, 2, 3 and 4"

### default behaviour
convertVector2sentence(1:4, quoted = TRUE)
#> [1] "\"1\", \"2\", \"3\" and \"4\""
### [1] "\"1\", \"2\", \"3\" and \"4\""

### change andChar (note the spaces,
###  I can't see why you wouldn't want them but ...)
convertVector2sentence(1:4, andChar = ' & ')
#> [1] "1, 2, 3 & 4"
### [1] "1, 2, 3 & 4"

### change the quoting character (note no spaces)
convertVector2sentence(1:4, quoted = TRUE, quoteChar = "'")
#> [1] "'1', '2', '3' and '4'"
### [1] "'1', '2', '3' and '4'"

convertVector2sentence(1:4, italicY = TRUE) # italicises the items
#> [1] "*1*, *2*, *3* and *4*"
### and now italics and quotation:
convertVector2sentence(1:4, italicY = TRUE, quoted = TRUE)
#> [1] "*\"1*\", \"*2*\", \"*3\"* and *\"4\"*"
```
