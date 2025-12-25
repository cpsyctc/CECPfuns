# Bootstrapping

``` r
library(CECPfuns)
```

## Bootstrapping and confidence intervals

Since I first discovered confidence intervals (CIs) back in the 1980s,
and then discovered bootstrapping probably in the late 90s or early
naughties, the advantages they have respectively over traditional null
hypothesis significance testing (NHST) and over splitting analytic
methods into parametric and non-parametric in a very clumsy way have
been utterly persuasive for me. However, with a few exceptions both were
late to be implemented into SPSS which has been the dominant statistical
software used by psychologists and psychotherapy researchers until
recently.

R, mainly through the excellent `boot` package offered me a way to bring
the two together and I have leant on that for many papers for probably
15 years now. However,
[`boot::boot()`](https://rdrr.io/pkg/boot/man/boot.html) is not always
the friendliest of R functions and coupling it into the tidverse way of
doing things in R isn’t always easy as `boot` is firmly in the “base R”
tradition.

From the start of thinking about this CECPfuns package I wanted to pull
together the various bootstrap functions, often very clumsy ones, and
make sure I had the latest versions to hand and tested and documented so
I would remember how they worked and what I’d done inside them fairly
easily. As I started to think of making CECPfuns fairly public I
realised that these function should help non-statisticians and relative
R newcomers to use bootstrapping to get confidence intervals for typical
therapy data analyses research. At the moment the functions in the
package are:

- getBootCICorr()
- getBootCIalpha()
- getBootCImean()
- getBootCICSC()

Each, I think, has sufficient information for people to use them in
their help files and each has pretty extensive trapping of improbable or
impossible inputs so I hope their error messages and warnings will be
protective ([`boot::boot()`](https://rdrr.io/pkg/boot/man/boot.html) is
brilliant but not always transparently helpful when I try to something
stupid with it!)

Over the next few months more bootstrap functions for the sample
statistics we use a lot will be added and I will add these sections to
this vignette.

1.  Background on confidence intervals for those not (fully) happy they
    understand the ideas including some simple theory about the
    relationships between CIs and NHST. What CIs are and what they are
    not.
2.  A bit on the distinction between parametric statistical tests and
    non-parametric tests, how they relate to distibutions of continuous
    variables, and why the traditional way of choosing between them is
    problematical.
3.  An introduction to bootstrapping. Why we don’t need it to get a
    confidence interval around a proportion and why it’s useful for most
    other sample statistics that aren’t simple counts.
4.  Worked examples of CIs and bootstrapped CIs for commonly meaningful
    analyses of therapy data.
