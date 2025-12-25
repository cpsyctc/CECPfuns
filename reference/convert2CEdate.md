# Function to convert Dates to my date format strings

Function to convert Dates to my date format strings

## Usage

``` r
convert2CEdate(date)

convertToCEdate(date)
```

## Arguments

- date:

  Date

## Value

string

## Background

I like to write dates in the format dd.mm.yyyy but doing the months, mm,
in Roman numerals, i.e. i = January, xii = December. This, unless
someone has never met the Roman's weird numbering system seems always to
promote initial bemusement but then recognition and I've never had
anyone say "but why not use Roman numerals for the days?" so I think it
does disambiguate dates. It is a trivial function and perhaps I'm the
only person who will ever use it but here it is. It expects input as a
Date and can handle a vector of dates.

## History/development log

Started before 5.iv.21 10.iv.21: tweaked to add synonym convertToCEdate

## See also

Other converting utilities:
[`convertVector2sentence()`](https://cecpfuns.psyctc.org/reference/convertVector2sentence.md)

## Author

Chris Evans

## Examples

``` r
date1 <- as.Date("1/1/2021", format = "%d/%m/%Y")
convert2CEdate(date1)
#> [1] "1.i.2021"
date2 <- as.Date("2/1/2021", format = "%d/%m/%Y")
dates12 <- c(date1, date2)
convert2CEdate(dates12)
#> [1] "1.i.2021" "2.i.2021"
```
