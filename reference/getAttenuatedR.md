# Function that gives the attenuated R for an unattenuated R and two reliability values

This is just the conventional formula for the attenuation of a (Pearson)
correlation by unreliability.

## Usage

``` r
getAttenuatedR(unattR, rel1, rel2, dp = 3)
```

## Arguments

- unattR:

  unattenuated R

- rel1:

  reliability of first of the variables (order of variables is
  arbitrary)

- rel2:

  reliability of second of the variables (order of variables is
  arbitrary)

- dp:

  number of decimal places required for attenuated R

## Value

numeric: attenuated correlation

## Background

This is ancient psychometrics but still of some use. For more
information, see: [OMbook glossary entry for
attenuation](https://www.psyctc.org/psyctc/glossary2/attenuation-by-unreliability-of-measurement/)
The formula is simple:

\\attenuatedCorr=unattenuatedCorr\*\sqrt{rel\_{1}\*rel\_{2}}\\

The short summary is that unreliability in the measurement of both
variables involved in a correlation always reduces the observed
correlation between the variables from what it would have been had the
variables been measured with no unreliability (which is essentially
impossible for any self-report measures and pretty much any measures
used in our fields.

## History/development log

Started 12.x.24

## See also

Other utility functions:
[`convertClipboardAuthorNames()`](https://cecpfuns.psyctc.org/reference/convertClipboardAuthorNames.md),
[`fixVarNames()`](https://cecpfuns.psyctc.org/reference/fixVarNames.md),
[`getCorrectedR()`](https://cecpfuns.psyctc.org/reference/getCorrectedR.md),
[`getLastDateInMonth()`](https://cecpfuns.psyctc.org/reference/getLastDateInMonth.md),
[`getSvalFromPval()`](https://cecpfuns.psyctc.org/reference/getSvalFromPval.md),
[`whichSetOfN()`](https://cecpfuns.psyctc.org/reference/whichSetOfN.md)

## Author

Chris Evans

## Examples

``` r
getAttenuatedR(.9, .7, .8)
#> [1] 0.673


```
