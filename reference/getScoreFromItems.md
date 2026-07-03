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
  roundToInteger = FALSE,
  replaceMissingWithFixed = FALSE,
  replacementValue = NULL,
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

- roundToInteger:

  Round to integer after prorating

- replaceMissingWithFixed:

  Replace missing item scores with a fixed value

- replacementValue:

  value with which to replace missing items

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

This function is designed to be used in the tidyverse dplyr function to
get a single score from a set of items apply a prorating rule (which may
be that prorating is not allowed) and which returns the mean of the item
scores or the sum of those scores. I recently added the option to round
scores to nearest integer using the argument roundToInteger set to TRUE
as I discovered that some measures (SDQ) require that. I have also added
the option not to rescale missing items according the mean of the
remaining items but by substituting a fixed value for the missing items
(use the argument replaceMissingWithFixed set to TRUE and give the
argument replacementValue the value with which to replace missing item
scores. For example the Pediatric Symptom Checklist (PSC-D) replaces
missing items with the score of zero so would need
replaceMissingWithFixed = TRUE and replacementValue = 0.

I have added the option to check the data. If you give the number of
items in the scale with the argument k the function will stop with an
error if the wrong number of scores is supplied. If you set
checkItemScores to TRUE and give values for minItemScore and
maxItemScore the function will again stop with a sensible error message
if an item score is supplied that is out of range.

I first put the function here as I kept writing new functions to do this
every time I needed one! Since then I think it has grown into a function
that may be useful to others. More usefully, I have built in the
prorating but perhaps most usefully of all, I have built in some sanity
checks on the inputs and on the item scores.

Thanks to Maren Rogawski for making me aware of measures that use the,
to my mind, rather bizarre, fixed value replacement of missing item
values rather than what I regard as more defensible pro-rating using the
mean of the completed items.

## Examples

``` r
if (FALSE) { # \dontrun{
### will need tidyverse to run
library(tidyverse)

k <- 6
n <- 4
set.seed(12345)
### get 24 rows of individual item scores
tibble(ItemScore = sample(0 : 5, k * n, replace = TRUE)) %>%
  ### create an ID value
  mutate(Item = row_number() %% k,
        ID = row_number() %/% k,
        ID = if_else(Item == 0,
                     ID - 1,
                     ID),
        ID = ID + 1,
        Item = if_else(Item == 0,
                       k,
                       Item)) %>%
  ### put in some missingness
  mutate(ItemScore = if_else(ID == 1 & Item == 2,
                         NA_integer_,
                         ItemScore),
         ItemScore = if_else(ID == 3 & Item %in% 2:4,
                         NA_integer_,
                         ItemScore)) %>%
  select(ID, Item, ItemScore) -> tibLongDat

### look at that data
tibLongDat %>%
  print(n = Inf)

### make wide format data
tibLongDat %>%
  pivot_wider(id_cols = ID,
              names_from = Item,
              values_from = ItemScore,
              names_prefix = "Item") -> tibWideDat

### look at that data
tibWideDat

### let's start with wide format
tibWideDat %>%
  ### as that has the item scores in rows
  ### hence this rowwise() request
  rowwise() %>%
  mutate(Score = getScoreFromItems(c_across(Item1:Item6), # declare items
                                    ### next say that the score that is wanted is mean not sum
                                    scoreAsMean = TRUE,
                                    # prorating rule: here up to one missing item,
                                    nProrateMin = 1,
                                    # optional check that number of items is correct:
                                    #  here the number is 10
                                    k = 6,
                                    # next ask the function to check the item scores
                                    checkItemScores = TRUE,
                                    # so set the minimum allowed item score: here 0
                                    minItemScore = 0,
                                    # ... and set the maximum allowed score: here 5
                                    maxItemScore = 5)) %>%
           ### now we have to shift the data out of the rowwise() grouping:
           ungroup() ### you would probably save this as a new tibble: -> tibDataWithScores
### that has returned the scores as mean scores and pro-rating for ID 1 which has only one missing value
### so is pro-ratable given nProrateMin = 1 in the arguments

tibWideDat %>%
  ### as that has the item scores in rows
  ### hence this rowwise() request
  rowwise() %>%
  mutate(Score = getScoreFromItems(c_across(Item1:Item6), # declare items
                                   ### next say that the score that is wanted is mean not sum
                                   scoreAsMean = FALSE, # get sum score instead of mean
                                   # prorating rule: here up to one missing item,
                                   nProrateMin = 1,
                                   # optional check that number of items is correct:
                                   #  here the number is 10
                                   k = 6,
                                   # next ask the function to check the item scores
                                   checkItemScores = TRUE,
                                   # so set the minimum allowed item score: here 0
                                   minItemScore = 0,
                                   # ... and set the maximum allowed score: here 5
                                   maxItemScore = 5)) %>%
  ungroup()
### That has returned the scores as sum scores and we can see that for ID 1
### prorating gives a non-integer score


tibWideDat %>%
  ### as that has the item scores in rows
  ### hence this rowwise() request
  rowwise() %>%
  mutate(Score = getScoreFromItems(c_across(Item1:Item6), # declare items
                                   ### next say that the score that is wanted is mean not sum
                                   scoreAsMean = FALSE, # get sum score instead of mean
                                   # prorating rule: here up to one missing item,
                                   nProrateMin = 1,
                                   # optional check that number of items is correct:
                                   #  here the number is 10
                                   k = 6,
                                   # next ask the function to check the item scores
                                   checkItemScores = TRUE,
                                   # so set the minimum allowed item score: here 0
                                   minItemScore = 0,
                                   # ... and set the maximum allowed score: here 5
                                   maxItemScore = 5,
                                   roundToInteger = TRUE)) %>%
  ungroup()
### Using roundToInteger rounds that 16.8 prorated score to 17


tibWideDat %>%
  ### as that has the item scores in rows
  ### hence this rowwise() request
  rowwise() %>%
  mutate(Score = getScoreFromItems(c_across(Item1:Item6), # declare items
                                   ### next say that the score that is wanted is mean not sum
                                   scoreAsMean = FALSE, # get sum score instead of mean
                                   # prorating rule: here up to one missing item,
                                   nProrateMin = 1,
                                   # optional check that number of items is correct:
                                   #  here the number is 10
                                   k = 6,
                                   # next ask the function to check the item scores
                                   checkItemScores = TRUE,
                                   # so set the minimum allowed item score: here 0
                                   minItemScore = 0,
                                   # ... and set the maximum allowed score: here 5
                                   maxItemScore = 5,
                                   replaceMissingWithFixed = TRUE,
                                   replacementValue = 0)) %>%
  ungroup()
### Using the, to my mind, unwise rule where missing values are replaced by a fixed
### value, here zero, as for the Pediatric Symptom Checklist (PSC-D) can have a very
### different effect from more orthodox pro-rating as is shown here


### this is an example of using the function with long format data
tibLongDat %>%
  group_by(ID) %>% # to get scores per ID
  summarise(Score = getScoreFromItems(ItemScore, # declare item scores, now in column format
                                             # so just the one variable
                                      ### next say that the score that is wanted is mean not sum
                                      scoreAsMean = TRUE,
                                      # prorating rule: here up to one missing item,
                                      nProrateMin = 1,
                                      # optional check that number of items is correct:
                                      #  here the number is 10
                                      k = 6,
                                      # next ask the function to check the item scores
                                      checkItemScores = TRUE,
                                      # so set the minimum allowed item score: here 0
                                      minItemScore = 0,
                                      # ... and set the maximum allowed score: here 5
                                      maxItemScore = 5))
### So that just returns the scores and the grouping variable, here just ID but you could
### equally group by ID and occasion if you had occasion in your data

} # }

```
