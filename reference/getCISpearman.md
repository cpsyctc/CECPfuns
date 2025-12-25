# Function offering four methods to find the CI around an observed Spearman correlation

Function offering four methods to find the CI around an observed
Spearman correlation

## Usage

``` r
getCISpearman(rs, n, ci = 0.95, Gaussian = FALSE, FHP = FALSE)
```

## Arguments

- rs:

  numeric: the observed Spearman correlation

- n:

  numeric: the number of (paired) values for the correlation

- ci:

  numeric: the confidence interval you want, default .95, i.e. 95%

- Gaussian:

  logical: use the Gaussian lookup for the CI, defaults to FALSE

- FHP:

  logical: use the Fieller, Hartley & Pearson (1957) method, defaults to
  FALSE

## Value

A named vector LCL and UCL

## Background

This is very simple function to return the confidence limits of the
confidence interval around an observed Pearson correlation given the
number of observations in the dataset (n) and the confidence interval
required (ci, defaults to .95). There are four methods obtained by using
either the Bonett & White (2000) approximation to the SE of the
correlation or the the Fieller, Hartley & Pearson (1957) approximation
and combining those with either looking up the value of the Gaussian to
get the desired CI coverage or using the value of the t distribution
with df = n - 2. It is known that none of the methods work well, i.e.
give coverage matching that desired and without bias, when the n is
below 25 and/or the absolute population Spearman correlation is above
.95 so use with caution if n \< 25 and observed correlation \> .90.

The function just returns a named vector of the LCL and UCL which should
help using it in tidyverse pipes. See examples.

There is more information about the function in my
[Rblog](https://www.psyctc.org/Rblog/) at [Confidence interval around
Spearman correlation
coefficient](https://www.psyctc.org/Rblog/posts/2023-11-27-cispearman/).

There is also a shiny app using this function at
<https://shiny.psyctc.org/apps/CISpearman/>

## References/acknowledgements

1.  This started from finding the excellent answers from `onestop`
    <https://stats.stackexchange.com/users/449/onestop> and `retodomax`
    <https://stats.stackexchange.com/users/237402/retodomax> to the
    question on [CrossValidated](https://stats.stackexchange.com/)
    specifically [How to calculate a confidence interval for Spearman's
    rank
    correlation?](https://stats.stackexchange.com/questions/18887/how-to-calculate-a-confidence-interval-for-spearmans-rank-correlation)
    Also, as referenced in that page ...

2.  Bishara, A. J., & Hittner, J. B. (2017). Confidence intervals for
    correlations when data are not normal. Behavior Research Methods,
    49(1), 294–309. <https://doi.org/10.3758/s13428-016-0702-8> gives
    extensive simulation work covering much more than these CIs. I
    checked my code against the results from the R code given in
    Supplement A to that paper. Then ...

3.  Bonett, D. G., & Wright, T. A. (2000). Sample size requirements for
    estimating pearson, kendall and spearman correlations.
    Psychometrika, 65(1), 23–28. <https://doi.org/10.1007/BF02294183> is
    a classic (interesting to see how typesetting of equations has
    improved since 2000!) and ...

4.  Ruscio, J. (2008). Constructing Confidence Intervals for Spearman’s
    Rank Correlation with Ordinal Data: A Simulation Study Comparing
    Analytic and Bootstrap Methods. Journal of Modern Applied
    Statistical Methods, 7(2), 416–434.
    <https://doi.org/10.22237/jmasm/1225512360> was another excellent
    paper on the topic.

Thanks to all those authors.

## History/development log

Version 1: 27.xi.23

## See also

Other confidence interval functions:
[`getCIPearson()`](https://cecpfuns.psyctc.org/reference/getCIPearson.md),
[`plotBinconf()`](https://cecpfuns.psyctc.org/reference/plotBinconf.md),
[`plotCIPearson()`](https://cecpfuns.psyctc.org/reference/plotCIPearson.md)

## Author

Chris Evans

## Examples

``` r
if (FALSE) { # \dontrun{
getCISpearman(.5, 50)
# LCL       UCL
# 0.2338274 0.6964523
getCISpearman(.5, 50, Gaussian = TRUE)
# LCL       UCL
# 0.2412245 0.6923933
getCISpearman(.5, 50, Gaussian = TRUE, FHP = TRUE)
# LCL       UCL
# 0.2495794 0.6877365
getCISpearman(.5, 50, Gaussian = FALSE, FHP = TRUE)
# LCL       UCL
# 0.2424304 0.6917259

### imaginary correlations of CORE-OM scores against number of children by parental gender
### create a tibble of the imaginary data
tribble(~pGender, ~rs, ~n,
        "M", .12, 643,
        "F", .57, 808) -> tibDat

### check it
tibDat

### use it
tibDat %>%
  rowwise() %>%
  ### need to use list() as we're getting a vector
  ### using the default arguments for getCISpearman()
  mutate(CISpearman = list(getCISpearman(rs, n))) %>%
  ### now get the values from the vectors
  unnest_wider(CISpearman)
# # A tibble: 2 × 5
# pGender    rs     n    LCL   UCL
# <chr>   <dbl> <dbl>  <dbl> <dbl>
# 1 M        0.12   643 0.0427 0.196
# 2 F        0.57   808 0.518  0.618
### pretty clear that the correlation for the women is very different
### from that for the men
} # }
```
