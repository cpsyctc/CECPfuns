# Function to convert numbers to hyphenated (English) words, e.g. 87 to "eighty-seven"

Function to convert numbers to hyphenated (English) words, e.g. 87 to
"eighty-seven"

## Usage

``` r
hyphenateWords(x, capitalise = FALSE)
```

## Arguments

- x:

  numeric

- capitalise:

  logical

## Value

character

## History/development log

Started before 5.iv.21

## See also

[`convertVector2sentence`](https://cecpfuns.psyctc.org/reference/convertVector2sentence.md)
for another utility function for text, converts vectors to comma (or
other symbol), separated clauses, e.g. 1:3 to "1, 2 and 3".

Other text utilities:
[`convertVector2sentence()`](https://cecpfuns.psyctc.org/reference/convertVector2sentence.md)

## Author

Chris Evans

## Examples

``` r
hyphenateWords(87)
#> Loading required namespace: english
#> [1] "eighty-seven"
hyphenateWords(87, capitalise = TRUE)
#> [1] "Eighty-seven"
```
