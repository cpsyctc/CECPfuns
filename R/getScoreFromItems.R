#' Title Function to convert a vector of item responses to a scale/measure score
#'
#' @param vec The item responses/scores
#' @param scoreAsMean Score is mean of item scores (as opposed to total/sum score)
#' @param propProrateMin Minimum proportion of missing item responses that allows prorating
#' @param nProrateMin Minimum number of missing item responses that allows prorating
#' @param roundToInteger Round to integer after prorating
#' @param replaceMissingWithFixed Replace missing item scores with a fixed value
#' @param replacementValue value with which to replace missing items
#' @param k Optional check on the number of items
#' @param checkItemScores logical, i.e. TRUE or FALSE, which says whether to check the item scores
#' @param minItemScore minimum allowed item score
#' @param maxItemScore maximum allowed item score
#'
#' @return The required score
#'
#' @export
#'
#' @section Background:
#' This function is designed to be used in the tidyverse dplyr function to get a single score
#' from a set of items apply a prorating rule (which may be that prorating is not allowed) and which returns
#' the mean of the item scores or the sum of those scores.  I recently added the option to round scores to
#' nearest integer using the argument roundToInteger set to TRUE as I discovered that some measures (SDQ)
#' require that.  I have also added the option not to rescale missing items according the mean of the
#' remaining items but by substituting a fixed value for the missing items (use the argument
#' replaceMissingWithFixed set to TRUE and give the argument replacementValue the value with which to replace missing
#' item scores. For example the Pediatric
#' Symptom Checklist (PSC-D) replaces missing items with the score of zero so would need replaceMissingWithFixed = TRUE
#' and replacementValue = 0.
#'
#' I have added the option to check the data.  If you give the number of items in the scale with the argument k the function will
#' stop with an error if the wrong number of scores is supplied.  If you set checkItemScores to TRUE and give values for
#' minItemScore and maxItemScore the function will again stop with a sensible error message if an item score is supplied that
#' is out of range.
#'
#' I first put the function here as I kept writing new functions to do this every time I needed one!  Since then
#' I think it has grown into a function that may be useful to others.  More usefully, I have built in the prorating but perhaps
#' most usefully of all, I have built in some sanity checks on the inputs and on the item scores.
#'
#' @examples
#' \dontrun{
#' ### will need tidyverse to run
#' library(tidyverse)
#'
#' k <- 6
#' n <- 4
#' set.seed(12345)
#' ### get 24 rows of individual item scores
#' tibble(ItemScore = sample(0 : 5, k * n, replace = TRUE)) %>%
#'   ### create an ID value
#'   mutate(Item = row_number() %% k,
#'         ID = row_number() %/% k,
#'         ID = if_else(Item == 0,
#'                      ID - 1,
#'                      ID),
#'         ID = ID + 1,
#'         Item = if_else(Item == 0,
#'                        k,
#'                        Item)) %>%
#'   ### put in some missingness
#'   mutate(ItemScore = if_else(ID == 1 & Item == 2,
#'                          NA_integer_,
#'                          ItemScore),
#'          ItemScore = if_else(ID == 3 & Item %in% 2:4,
#'                          NA_integer_,
#'                          ItemScore)) %>%
#'   select(ID, Item, ItemScore) -> tibLongDat
#'
#' ### look at that data
#' tibLongDat %>%
#'   print(n = Inf)
#'
#' ### make wide format data
#' tibLongDat %>%
#'   pivot_wider(id_cols = ID,
#'               names_from = Item,
#'               values_from = ItemScore,
#'               names_prefix = "Item") -> tibWideDat
#'
#' ### look at that data
#' tibWideDat
#'
#' ### let's start with wide format
#' tibWideDat %>%
#'   ### as that has the item scores in rows
#'   ### hence this rowwise() request
#'   rowwise() %>%
#'   mutate(Score = getScoreFromItems(c_across(Item1:Item6), # declare items
#'                                     ### next say that the score that is wanted is mean not sum
#'                                     scoreAsMean = TRUE,
#'                                     # prorating rule: here up to one missing item,
#'                                     nProrateMin = 1,
#'                                     # optional check that number of items is correct:
#'                                     #  here the number is 10
#'                                     k = 6,
#'                                     # next ask the function to check the item scores
#'                                     checkItemScores = TRUE,
#'                                     # so set the minimum allowed item score: here 0
#'                                     minItemScore = 0,
#'                                     # ... and set the maximum allowed score: here 5
#'                                     maxItemScore = 5)) %>%
#'            ### now we have to shift the data out of the rowwise() grouping:
#'            ungroup() ### you would probably save this as a new tibble: -> tibDataWithScores
#' ### that has returned the scores as mean scores and pro-rating for ID 1 which has only one missing value
#' ### so is pro-ratable given nProrateMin = 1 in the arguments
#'
#' tibWideDat %>%
#'   ### as that has the item scores in rows
#'   ### hence this rowwise() request
#'   rowwise() %>%
#'   mutate(Score = getScoreFromItems(c_across(Item1:Item6), # declare items
#'                                    ### next say that the score that is wanted is mean not sum
#'                                    scoreAsMean = FALSE, # get sum score instead of mean
#'                                    # prorating rule: here up to one missing item,
#'                                    nProrateMin = 1,
#'                                    # optional check that number of items is correct:
#'                                    #  here the number is 10
#'                                    k = 6,
#'                                    # next ask the function to check the item scores
#'                                    checkItemScores = TRUE,
#'                                    # so set the minimum allowed item score: here 0
#'                                    minItemScore = 0,
#'                                    # ... and set the maximum allowed score: here 5
#'                                    maxItemScore = 5)) %>%
#'   ungroup()
#' ### That has returned the scores as sum scores and we can see that for ID 1
#' ### prorating gives a non-integer score
#'
#'
#' tibWideDat %>%
#'   ### as that has the item scores in rows
#'   ### hence this rowwise() request
#'   rowwise() %>%
#'   mutate(Score = getScoreFromItems(c_across(Item1:Item6), # declare items
#'                                    ### next say that the score that is wanted is mean not sum
#'                                    scoreAsMean = FALSE, # get sum score instead of mean
#'                                    # prorating rule: here up to one missing item,
#'                                    nProrateMin = 1,
#'                                    # optional check that number of items is correct:
#'                                    #  here the number is 10
#'                                    k = 6,
#'                                    # next ask the function to check the item scores
#'                                    checkItemScores = TRUE,
#'                                    # so set the minimum allowed item score: here 0
#'                                    minItemScore = 0,
#'                                    # ... and set the maximum allowed score: here 5
#'                                    maxItemScore = 5,
#'                                    roundToInteger = TRUE)) %>%
#'   ungroup()
#' ### Using roundToInteger rounds that 16.8 prorated score to 17
#'
#'
#' tibWideDat %>%
#'   ### as that has the item scores in rows
#'   ### hence this rowwise() request
#'   rowwise() %>%
#'   mutate(Score = getScoreFromItems(c_across(Item1:Item6), # declare items
#'                                    ### next say that the score that is wanted is mean not sum
#'                                    scoreAsMean = FALSE, # get sum score instead of mean
#'                                    # prorating rule: here up to one missing item,
#'                                    nProrateMin = 1,
#'                                    # optional check that number of items is correct:
#'                                    #  here the number is 10
#'                                    k = 6,
#'                                    # next ask the function to check the item scores
#'                                    checkItemScores = TRUE,
#'                                    # so set the minimum allowed item score: here 0
#'                                    minItemScore = 0,
#'                                    # ... and set the maximum allowed score: here 5
#'                                    maxItemScore = 5,
#'                                    replaceMissingWithFixed = TRUE,
#'                                    replacementValue = 0)) %>%
#'   ungroup()
#' ### Using the, to my mind, unwise rule where missing values are replaced by a fixed
#' ### value, here zero, as for the Pediatric Symptom Checklist (PSC-D) can have a very
#' ### different effect from more orthodox pro-rating as is shown here
#'
#'
#' ### this is an example of using the function with long format data
#' tibLongDat %>%
#'   group_by(ID) %>% # to get scores per ID
#'   summarise(Score = getScoreFromItems(ItemScore, # declare item scores, now in column format
#'                                              # so just the one variable
#'                                       ### next say that the score that is wanted is mean not sum
#'                                       scoreAsMean = TRUE,
#'                                       # prorating rule: here up to one missing item,
#'                                       nProrateMin = 1,
#'                                       # optional check that number of items is correct:
#'                                       #  here the number is 10
#'                                       k = 6,
#'                                       # next ask the function to check the item scores
#'                                       checkItemScores = TRUE,
#'                                       # so set the minimum allowed item score: here 0
#'                                       minItemScore = 0,
#'                                       # ... and set the maximum allowed score: here 5
#'                                       maxItemScore = 5))
#' ### So that just returns the scores and the grouping variable, here just ID but you could
#' ### equally group by ID and occasion if you had occasion in your data
#'
#'}
#'
#'
getScoreFromItems <- function(vec,
                              scoreAsMean = TRUE,
                              propProrateMin = NULL,
                              nProrateMin = NULL,
                              roundToInteger=FALSE,
                              replaceMissingWithFixed=FALSE,
                              replacementValue=NULL,
                              k = NULL,
                              checkItemScores = FALSE,
                              minItemScore = NULL,
                              maxItemScore = NULL){
  ### function to get a score from a vector of item scores
  ### vector is often going to be a slice of a tibble hence this tweak as mean() throws a warning on non-vector input
  vec <- unlist(vec)
  ### test arguments
  if (!is.numeric(vec)) {
    stop("vec, i.e. the item scores, must be numeric")
  }
  if (length(vec) < 2) {
    paste0("The items in this row are: ",
           vec,
           ".  You must have at least two values to compute a score.  Something is wrong!") -> tmpMessage
    stop(tmpMessage)
  }
  if (!is.logical(scoreAsMean)) {
    stop("scoreAsMean, which says you want the score as a mean, must be logical, either TRUE or FALSE!")
  }
  if (is.null(propProrateMin)) {
    propProrateMin <- NA
  }
  if (is.null(nProrateMin)) {
    nProrateMin <-NA
  }
  if (is.na(propProrateMin) & is.na(nProrateMin)) {
    paste0("You must specify a value for one of propProrateMin (proportion of items missing allowed for pro-rating)",
           "or nProrateMin (number of items missing ditto).  To disallow prorating specify one of them as zero.") -> tmpMessage
    stop(tmpMessage)
  }
  if (!is.na(propProrateMin) & !is.na(nProrateMin)) {
    tmpMessg <- paste0("You have specified both propProrateMin (as ",
                       propProrateMin,
                       ") and nProrateMin (as ",
                       nProrateMin,
                       ").  That's either overkill or more likely it's a mistake in your arguments to the call so reset one to null or NA")
    stop(tmpMessg)
  }
  if (!is.na(propProrateMin) & propProrateMin > .5) {
    paste0("You have set propProrateMin as ",
           propProrateMin,
           "  That is allowing prorating even if more than half the items are meeting.  Are you sure?") -> tmpMessage
    warning(tmpMessage)
  }
  if (!is.na(propProrateMin) & propProrateMin > 1) {
    paste0("You have set propProrateMin as ",
           propProrateMin,
           "  You can't have more than all the items missing!  Rethink?!") -> tmpMessage
    warning(tmpMessage)
  }
  if(!is.logical(roundToInteger)){
    stop("You supplied a value for roundToInteger that wasn TRUE or FALSE.  Fix that!")
  }
  if(length(roundToInteger) > 1){
    paste0("You have set roundToInteger as ",
           roundToInteger,
           " but that must be a single logical value!  Rethink?!") -> tmpMessage
    stop(tmpMessage)
    }
  if(!is.logical(replaceMissingWithFixed)){
    stop("You supplied a value for replaceMissingWithFixed that wasn TRUE or FALSE.  Fix that!")
  }
  if(length(replaceMissingWithFixed) > 1){
    paste0("You have set replaceMissingWithFixed as ",
           replaceMissingWithFixed,
           " but that must be a single logical value!  Rethink?!") -> tmpMessage
    stop(tmpMessage)
  }
  if(!is.null(replacementValue) & !replaceMissingWithFixed) {
    stop("You supplied a non-null value for replacementValue but had replaceMissingWithFalse as FALSE: something wrong there!")
  }
  if(is.null(replacementValue) & replaceMissingWithFixed) {
    stop("You supplied a (default) null value for replacementValue but had replaceMissingWithFalse as TRUE: something wrong there!")
  }
  if(replaceMissingWithFixed) {
    if(!is.numeric(replacementValue)) {
      stop("You supplied replaceMissingWithFalse as TRUE but a non-numeric value for replacementValue: something wrong there!")
    }
    if(length(replacementValue) != 1) {
      paste0("You have set replacement value as ",
             replacementValue,
             " but that must be a single numeric value!  Rethink?!") -> tmpMessage
      stop(tmpMessage)
    }
  }
  ### k is an optional double check on the data
  if(!is.null(k)) {
    if(!(is.numeric(k))) {
      stop("Value of k, the expected number of items, must be numeric!")
    }
    if(length(k) > 1) {
      paste0("You entered k as ",
             k,
             ".  The value of k, the expected number of items, must be a single number!") -> tmpMessage
      stop(tmpMessage)
    }
    if(k < 2) {
      paste0("You entered k as ",
             k,
             ".  The value of k, the expected number of items, must be more than one!") -> tmpMessage
      stop(tmpMessage)
    }
  }
  if (!is.null(checkItemScores) & !is.logical(checkItemScores)) {
    stop("checkItemScores, which says you want the function to check the item scores, must be logical, either TRUE or FALSE!")
  }
  if (checkItemScores) {
    ### have asked to check the items so much have their limits
    if(is.na(minItemScore) |
       !is.numeric(minItemScore) |
       length(minItemScore) > 1) {
      paste0("You gave minItemScore as ",
             minItemScore,
             " this has to be a single number.  Correct it and try again please!") -> tmpMessage
      stop(tmpMessage)
    }
    if(is.na(maxItemScore) |
       !is.numeric(maxItemScore) |
       length(maxItemScore) > 1) {
      paste0("You gave maxItemScore as ",
             maxItemScore,
             " this has to be a single number.  Correct it and try again please!") -> tmpMessage
      stop(tmpMessage)
    }
    if(maxItemScore <= minItemScore) {
      paste0("You give minItemScore as ",
             minItemScore,
             " and maxItemScore as ",
             maxItemScore,
             " but maxItemScore must be bigger than minItemScore") -> tmpMessage
      stop(tmpMessage)
    }
  }

  ### test length of input (i.e. number of item scores)
  if (!is.null(k)) {
    if(length(vec) != k) {
      errText <- paste0("You have given k as ",
                        k,
                        " but the number of items supplied was ",
                        length(vec),
                        " so something is wrong!")
      stop(errText)
    }
  }

  ### work out prorating criterion using number rather than proportion, whichever was given
  if(is.na(nProrateMin)) {
    if (is.null(k)) {
      nProrateMin <- round(propProrateMin * length(vec), 1)
    } else {
      nProrateMin <- round(propProrateMin * k, 1)
    }
  }
  ### check whether the data can be prorated
  nMiss <- getNNA(vec)
  if (nMiss > nProrateMin) {
    return(NA)
  }

  ### got usable data of the correct length but do we check items, if so
  if(checkItemScores) {
    maxScore <- max(vec, na.rm = TRUE)
    minScore <- min(vec, na.rm = TRUE)
    if (minScore < minItemScore) {
      paste0("The smallest of your item scores in this line of data is ",
             minScore,
             " which is below the minimum you set for the item scores(",
             minItemScore,
             ").  You will have to correct that.") -> tmpMessage
      stop(tmpMessage)
    }
    if (maxScore > maxItemScore) {
      paste0("The largest of your item scores in this line of data is ",
             maxScore,
             " which is below the minimum you set for the item scores(",
             maxItemScore,
             ").  You will have to correct that.") -> tmpMessage
      stop(tmpMessage)
    }
  }

  ### deal with the fixed replacement
  if(replaceMissingWithFixed) {
    vec[is.na(vec)] <- replacementValue
  }

  ### OK.  Finally we can score the data!!
  tmpMean <- mean(vec, na.rm = TRUE)
  if (!scoreAsMean) {
    tmpMean * k -> tmpMean
  }
  if (roundToInteger) {
    round(tmpMean) -> tmpMean
  }
  tmpMean
}

