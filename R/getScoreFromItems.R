#' Title Function to convert a vector of item responses to a scale/measure score
#'
#' @param vec The item responses/scores
#' @param scoreAsMean Score is mean of item scores (as opposed to total/sum score)
#' @param propProrateMin Minimum proportion of missing item responses that allows prorating
#' @param nProrateMin Minimum number of missing item responses that allows prorating
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
#' This is a very simple function designed to be used in the tidyverse dplyr function to get a single score
#' from a set of items apply a prorating rule (which may be that prorating is not allowed) and which returns
#' the mean of the item scores or the mean of those scores.  I have put it here as I kept writing new
#' functions to do this every time I needed one!  More usefully, I have built in the prorating but perhaps
#' most usefully of all, I have built in some sanity checks on the inputs and on the item scores.
#'
#' @examples
#' \dontrun{
#' ### will need tidyverse to run
#' library(tidyverse)
#'
#' ### take your data
#' tibData %>%
#'    ### need to process the data row by row,
#'    ### hence this rowwise() request
#'    rowwise() %>%
#'       mutate(score = getScoreFromItems(c_across(item1:item10, # declare items
#'                                        ### next say that the score that is wanted is mean not sum
#'                                                 scoreAsMean = TRUE,
#'                                                 # prorating rule: here up to one missing item,
#'                                                 nProrateMin = 1,
#'                                                 # optional check that number of items is correct:
#'                                                 #  here the number is 10
#'                                                 k = 10,
#'                                                 # next ask the function to check the item scores
#'                                                 checkItemScores = TRUE,
#'                                                 # so set the minimum allowed item score: here 0
#'                                                 minItemScore = 0,
#'                                                 # ... and set the maximum allowed score: here 6
#'                                                 maxItemScore = 6)) %>%
#'      ### now we have to shift the data out of the rowwise() grouping:
#'      ungroup() -> tibDataWithScores
#'
#' }
getScoreFromItems <- function(vec,
                              scoreAsMean = TRUE,
                              propProrateMin = NULL,
                              nProrateMin = NULL,
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
      nProrateMin <- round(propProrateMin * length(vec))
    } else {
      nProrateMin <- round(propProrateMin * k)
    }
  }
  ### check whether the data can be prorated
  nMiss <- getNNA(vec)
  if (nMiss > nProrateMin) {
    return(NA)
  }

  ### got usable data of the correct length but do we check items
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

  ### OK.  Finally we can score the data!!
  tmpMean <- mean(vec, na.rm = TRUE)
  if (scoreAsMean){
    return(tmpMean)
  } else {
    return(tmpMean * k)
  }
}

