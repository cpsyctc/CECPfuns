# Fix variable names e.g. YP1, YP2 ... YP10 to YP01, YP02 ... YP10

Fix variable names e.g. YP1, YP2 ... YP10 to YP01, YP02 ... YP10

## Usage

``` r
fixVarNames(nameTxt, width = 2, newText = "")
```

## Arguments

- nameTxt:

  character vector of variable names

- width:

  number, restricted to 2 or 3

- newText:

  character, to replace the existing character part of the names

## Value

vector of the zero padded names, perhaps with new text element

## Background

This is just a utility function that comes in useful if you want to
change a vector of variable names that have the format xxxx# where
"xxxx" is a character component and "#" is a number component. The
function is vectorized, i.e. you can give it a vector of names or a
single name. It can be used within the tidyverse dplyr pipeline with
"rename_with()" which will apply the function to

## History/development log

Started 17.x.24

## See also

Other utility functions:
[`convertClipboardAuthorNames()`](https://cecpfuns.psyctc.org/reference/convertClipboardAuthorNames.md),
[`getAttenuatedR()`](https://cecpfuns.psyctc.org/reference/getAttenuatedR.md),
[`getCorrectedR()`](https://cecpfuns.psyctc.org/reference/getCorrectedR.md),
[`getLastDateInMonth()`](https://cecpfuns.psyctc.org/reference/getLastDateInMonth.md),
[`getSvalFromPval()`](https://cecpfuns.psyctc.org/reference/getSvalFromPval.md),
[`whichSetOfN()`](https://cecpfuns.psyctc.org/reference/whichSetOfN.md)

## Author

Chris Evans

## Examples

``` r
### these show the function acting on single values (unusual use case but ...!)
fixVarNames("YP1")
#> [1] "YP01"
fixVarNames("YP10")
#> [1] "YP10"
fixVarNames("YP1", 3) # if you want that to become YP010, i.e. three digits
#> [1] "YP001"
fixVarNames("YP10", 3) # same
#> [1] "YP010"
fixVarNames("YP10", 3, "YPCORE_") # replaces "YP" with "YPCORE_"
#> [1] "YPCORE_010"

### same but with vector (two element vector is hardly more sensible use case!)
fixVarNames(c("YP1", "YP2"))
#> [1] "YP01" "YP02"
fixVarNames(c("YP10", "YP11"))
#> [1] "YP10" "YP11"
fixVarNames(c("YP1", "YP2"), 3)
#> [1] "YP001" "YP002"
fixVarNames(c("YP10", "YP11"), 3)
#> [1] "YP010" "YP011"
fixVarNames(c("YP10", "YP11"), 3, "YPCORE_")
#> [1] "YPCORE_010" "YPCORE_011"


### create a dataset
### library(tidyverse) # to get the tidyverse functionality including tribble()
library(tidyr)
library(tibble)
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
tribble(~ID, ~I1, ~I2, ~I3, ~I4, ~I5, ~I6, ~I7, ~I8, ~I9, ~I10,
         "P1", 4, 0, 2, 3, 1, 1, 0, 2, 3, 2,
         "P2", 2, 3, 4, 2, 1, 2, 4, 3, 1, 2,
         "P3", 4, 1, 1, 2, 3, 1, 0, 4, 0, 3) -> tmpTib

### simple example, the "-ID" says "don't do this to the ID variable"
tmpTib %>%
  rename_with(fixVarNames, -ID)
#> # A tibble: 3 × 11
#>   ID      I01   I02   I03   I04   I05   I06   I07   I08   I09   I10
#>   <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 P1        4     0     2     3     1     1     0     2     3     2
#> 2 P2        2     3     4     2     1     2     4     3     1     2
#> 3 P3        4     1     1     2     3     1     0     4     0     3

### this next uses column indices to select the variables to recode
tmpTib %>%
  rename_with(fixVarNames, 2:10)
#> # A tibble: 3 × 11
#>   ID      I01   I02   I03   I04   I05   I06   I07   I08   I09   I10
#>   <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 P1        4     0     2     3     1     1     0     2     3     2
#> 2 P2        2     3     4     2     1     2     4     3     1     2
#> 3 P3        4     1     1     2     3     1     0     4     0     3

### this next uses explicit selection
tmpTib %>%
  rename_with(fixVarNames, .cols = I1 : I10)
#> # A tibble: 3 × 11
#>   ID      I01   I02   I03   I04   I05   I06   I07   I08   I09   I10
#>   <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 P1        4     0     2     3     1     1     0     2     3     2
#> 2 P2        2     3     4     2     1     2     4     3     1     2
#> 3 P3        4     1     1     2     3     1     0     4     0     3

### this illustrates passing arguments to fixVarNames() as trailing arguments
tmpTib %>%
  rename_with(fixVarNames, .cols = I1 : I10, width = 3, newText = "YP")
#> # A tibble: 3 × 11
#>   ID    YP001 YP002 YP003 YP004 YP005 YP006 YP007 YP008 YP009 YP010
#>   <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 P1        4     0     2     3     1     1     0     2     3     2
#> 2 P2        2     3     4     2     1     2     4     3     1     2
#> 3 P3        4     1     1     2     3     1     0     4     0     3

### new dataset so ID coding doesn't start with "I" so I can illustrate
### selecting with "starts_with()"
tribble(~P_ID, ~I1, ~I2, ~I3, ~I4, ~I5, ~I6, ~I7, ~I8, ~I9, ~I10,
        "P1", 4, 0, 2, 3, 1, 1, 0, 2, 3, 2,
        "P2", 2, 3, 4, 2, 1, 2, 4, 3, 1, 2,
        "P3", 4, 1, 1, 2, 3, 1, 0, 4, 0, 3) -> tmpTib

### select using starts_with()
tmpTib %>%
rename_with(fixVarNames, starts_with("I"))
#> # A tibble: 3 × 11
#>   P_ID    I01   I02   I03   I04   I05   I06   I07   I08   I09   I10
#>   <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 P1        4     0     2     3     1     1     0     2     3     2
#> 2 P2        2     3     4     2     1     2     4     3     1     2
#> 3 P3        4     1     1     2     3     1     0     4     0     3

### as before, put arguments after selection of the variables/columns
tmpTib %>%
rename_with(fixVarNames, starts_with("I"), width = 3, newText = "YP")
#> # A tibble: 3 × 11
#>   P_ID  YP001 YP002 YP003 YP004 YP005 YP006 YP007 YP008 YP009 YP010
#>   <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 P1        4     0     2     3     1     1     0     2     3     2
#> 2 P2        2     3     4     2     1     2     4     3     1     2
#> 3 P3        4     1     1     2     3     1     0     4     0     3

```
