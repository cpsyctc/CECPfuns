# Function using the Spearman-Brown formula to predict reliability for new length or get length for desired reliability

Function using the Spearman-Brown formula to predict reliability for new
length or get length for desired reliability

## Usage

``` r
getRelBySpearmanBrown(
  oldRel,
  lengthRatio = NULL,
  newRel = NULL,
  verbose = TRUE
)
```

## Arguments

- oldRel:

  numeric: the reliability you have

- lengthRatio:

  numeric: the ratio of the new length to the old length

- newRel:

  numeric: the desired reliability

- verbose:

  logical: whether to give messages explaining the function

## Value

numeric: either predicted reliability or desired length ratio (whichever
was input as NULL)

## background

This is ancient psychometrics but still of some use. It has been checked
against two functions in the psychometric package with gratitude. For
more information, see:  

<https://www.psyctc.org/Rblog/posts/2021-04-09-spearman-brown-formula/>  

  
The formula is simple:

\\{\rho^{\*}}=\frac{n\rho}{1 + (n-1)\rho}\\

The short summary is that any multi-item measure will have overall
internal reliability/consistency that is a function of the mean
inter-item correlations and the number of items and, for any mean
inter-item correlation, a longer measure will have a higher reliability.
The formula for the relationship was published separately by both
Spearman in 1910 and in the same year by Brown, who was working for Karl
Pearson, who had a running feud with Spearman. See:  

<https://en.wikipedia.org/wiki/Spearman%E2%80%93Brown_prediction_formula#History>  

  
That also gives some arguments that the formula should really be termed
the Brown-Spearman formula but I am bowing to historical precedent here.

## related_resources

1.  In my [OMbook
    glossary](https://www.psyctc.org/psyctc/book/glossary/): entry
    [here](https://www.psyctc.org/psyctc/glossary2/spearman-brown-formula/).

2.  In my [Rblog](https://www.psyctc.org/Rblog/index.html): entry
    [here](https://www.psyctc.org/Rblog/posts/2021-04-09-spearman-brown-formula/).

3.  In my [online shiny apps](https://shiny.psyctc.org/): app that uses
    this function to give predicted reliabilities given length of
    existing measure and its internal reliability
    [here](https://shiny.psyctc.org/apps/Spearman-Brown/).

## History/development log

Started before 5.iv.21, updated help page 10.iv.21.

## Author

Chris Evans

## Examples

``` r
if (FALSE) { # \dontrun{
### if you had a reliability of .8 from a measure of, say 10, items,
###   what reliability might you expect from one of 34 items?
getRelBySpearmanBrown(.8, 3.4)

### if you had a reliability of .7 from 10 items how much lower
###  would you expect the reliability to be from a measure of only 5 items?
### from examples for psychometric::SBrel() with respect and gratitude!
getRelBySpearmanBrown(.7, .5, verbose = FALSE)

### if you have a reliability of .7, how much longer a measure do you expect
###    to need for a reliability of .9?
###    again with acknowledgement to psychometric::SBlength() with respect and gratitude!
getRelBySpearmanBrown(.7, lengthRatio = NULL, .9)
} # }
```
