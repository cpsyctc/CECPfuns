# Function that gives the corrected R for an observed R and two reliability values

This just uses the conventional formula for the attenuation of a
(Pearson) correlation by unreliability.

## Usage

``` r
getCorrectedR(obsR, rel1, rel2, dp = 3)
```

## Arguments

- obsR:

  observed R

- rel1:

  reliability of first of the variables (order of variables is
  arbitrary)

- rel2:

  reliability of second of the variables (order of variables is
  arbitrary)

- dp:

  number of decimal places required for corrected R

## Value

numeric: corrected correlation

## Background

This is ancient psychometrics but still of some use. For more
information, see: [OMbook glossary entry for
attenuation](https://www.psyctc.org/psyctc/glossary2/attenuation-by-unreliability-of-measurement/)
The formula is simple:

\\correctedCorr=\frac{observedCorr}{\sqrt{rel\_{1}\*rel\_{2}}}\\

The short summary is that unreliability in the measurement of both
variables involved in a correlation always reduces the observed
correlation between the variables from what it would have been had the
variables been measured with no unreliability (which is essentially
impossible for any self-report measures and pretty much any measures
used in our fields. This uses that relationship to work back to an
assumed "corrected" correlation given an observed correlation and two
reliability values.

For even moderately high observed correlations and low reliabilities the
function can easily return values for the corrected correlation over
1.0. That's a clear indication that things other than unreliability and
classical test theory are at work. The function gives a warning in this
situation.

## History/development log

Started 13.x.24

## See also

Other utility functions:
[`convertClipboardAuthorNames()`](https://cecpfuns.psyctc.org/reference/convertClipboardAuthorNames.md),
[`fixVarNames()`](https://cecpfuns.psyctc.org/reference/fixVarNames.md),
[`getAttenuatedR()`](https://cecpfuns.psyctc.org/reference/getAttenuatedR.md),
[`getLastDateInMonth()`](https://cecpfuns.psyctc.org/reference/getLastDateInMonth.md),
[`getSvalFromPval()`](https://cecpfuns.psyctc.org/reference/getSvalFromPval.md),
[`whichSetOfN()`](https://cecpfuns.psyctc.org/reference/whichSetOfN.md)

## Author

Chris Evans

## Examples

``` r
getCorrectedR(.3, .7, .7)
#> [1] 0.429
### should return 0.428571428571429


```
