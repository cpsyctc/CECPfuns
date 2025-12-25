# Gets the two-sided p value for the difference between two independent Cronbach alpha values

Gets the two-sided p value for the difference between two independent
Cronbach alpha values

## Usage

``` r
getPdiff2alphas(alpha1, alpha2, k, n1, n2)
```

## Arguments

- alpha1:

  first Cronbach alpha (order is irrelevant)

- alpha2:

  other Cronbach alpha value

- k:

  number of items (assumed same for both values)

- n1:

  first sample size (match to the alpha)

- n2:

  other sample size

## Value

numeric: two-sided p value for difference

## Background

This function provides a conventional null hypothesis significance test
(NHST) of the null hypothesis that two Cronbach alpha values from
independent datasets are so different that it is unlikely, given the
numbers of items and the two dataset sizes that you would have seen
differences as large or larger than you did on the null hypothesis that
the alpha values in the population(s) are the same.

I am very much against the overuse of the NHST in our fields but here I
think it is useful (whereas reporting that a Cronbach alpha is
statistically different from zero is really pretty meaningless).

Whereas testing that the population item correlation structure is
unlikely to have been purely random strikes me as useless when we are
exploring the psychometric properties of measures, rejecting the null of
no differences in the alpha values from the same measure in two
different samples is a bit more useful.

If you have raw data from two datasets I would recommend getting the
bootstrap confidence interval (CI) around your observed alpha values as
a more robust and sensibly descriptive/estimation approach. The
[getBootCIalpha](https://cecpfuns.psyctc.org/reference/getBootCIalpha.md)
will get for you. The current vogue if you have raw data is to jump to
fancy things like testing for "measurement invariance" in the
confirmatory factor analytic (CFA) framework and that's fine where
measures really do fit the CFA model but for most therapy measures that
fit is very dubious and looking at alpha values is a solid place to
start.

The maths comes from a 1969 paper by Feldt (Feldt 1969) and is based on
the assumption that the population distributions (i.e. of the item
scores) are all Gaussian. I've used the more complicated derivation of
the p value from Feldt's paper as his simpler version is not robust for
short measures. I suspect that the computations are fairly robust to
non-Gaussian distributions but I haven't explored that. I have simulated
things to show that it gets accurate p values for Gaussian null
populations.

Of course like all such NHST the other (non-distribution) assumptions
are

- infinite populations (probably not a real problem)

- genuinely independent "samples"/datasets (should be fine)

- genuinely independent observations (watch for nesting)

- random sampling (almost certainly violated)

- as ever, if you have huge datasets even tiny differences will be come
  out as statistically significant and if you have small datasets even
  quite large differences will not be statistically significant. So be
  honest about any of these issues if reporting p values (any, not just
  from this function!)

The maths allows for different numbers of items in the two datasets but
I haven't implemented that as I think that if you are comparing measures
that differ in length you are probably outside the realm in which the
NHST paradigm is helpful.

## History/development log

Created 12.xi.24 based on earlier SAS and S+ versions

## References

Feldt LS (1969). “A test of the hypothesis that cronbach's alpha or
kuder-richardson coefficent twenty is the same for two tests.”
*Psychometrika*, **34**, 363–373.

## Author

Chris Evans

## Examples

``` r
getPdiff2alphas(.7, .7, 8, 200, 150)
#> [1] 0.5023525
### should return 0.5023525: not a significant difference (doh!)

getPdiff2alphas(.7, .8, 8, 200, 150)
#> [1] 0.007314514
### should return 0.007314514 showing that it is unlikely at p < 05
### that that difference between those alpha levels arose by chance
### sampling from a population (or populations) where the population
### alpha values are the same
```
