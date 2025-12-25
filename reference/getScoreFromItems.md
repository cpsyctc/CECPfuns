# Title Function to convert a vector of item responses to a scale/measure score

Title Function to convert a vector of item responses to a scale/measure
score

## Usage

``` r
getScoreFromItems(
  vec,
  scoreAsMean = TRUE,
  propProrateMin = NULL,
  nProrateMin = NULL,
  k = NULL,
  checkItemScores = FALSE,
  minItemScore = NULL,
  maxItemScore = NULL
)
```

## Arguments

- vec:

  The item responses/scores

- scoreAsMean:

  Score is mean of item scores (as opposed to total/sum score)

- propProrateMin:

  Minimum proportion of missing item responses that allows prorating

- nProrateMin:

  Minimum number of missing item responses that allows prorating

- k:

  Optional check on the number of items

- checkItemScores:

  logical, i.e. TRUE or FALSE, which says whether to check the item
  scores

- minItemScore:

  minimum allowed item score

- maxItemScore:

  maximum allowed item score

## Value

The required score

## Background

This is a very simple function designed to be used in the tidyverse
dplyr function to get a single score from a set of items apply a
prorating rule (which may be that prorating is not allowed) and which
returns the mean of the item scores or the mean of those scores. I have
put it here as I kept writing new functions to do this every time I
needed one! More usefully, I have built in the prorating but perhaps
most usefully of all, I have built in some sanity checks on the inputs
and on the item scores.

## Examples
