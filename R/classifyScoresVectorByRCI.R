#' Function to classify changes using the RCI paradigm
#'
#' @param scoreChange numeric vector of score changes
#' @param score1 numeric vector of baseline scores (if not giving scoreChange)
#' @param score2 numeric vector of final scores (if not giving scoreChange)
#' @param RCI numeric value of the RCI
#' @param cueing whether measure is cued positively or negatively
#' @param verbose logical: suppresses messages if FALSE
#' @param returnTable logical: whether summary table returned (TRUE) or a tibble of classified scores (FALSE)
#' @param dp numeric: number of decimal places in percentages (if returnTable TRUE)
#' @param addCI logical: whether to add confidence intervals around observed percentages e.g. "69.6% to 87.5%"
#' @param returnNumeric logical: whether to return values as numeric or as nicely formatted strings (the default)
#' @param CLsSeparate logical: returns CI as two separate variables instead of that string
#' @param conf numeric, gives the width of the confidence interval (if addCI is TRUE)
#'
#' @return a tibble, either of the summary breakdown with n and % by classification, or a tibble of the data with classified change
#' @export
#'
#' @importFrom dplyr left_join
#' @importFrom dplyr if_else
#' @importFrom dplyr rowwise
#' @importFrom dplyr ungroup
#'
#' @section Warning:
#' Function is still under development.  Currently handles vector input.
#' I will be modifying it to handle data frame and tibble input but not sure how best to do that yet.
#' Currently heading for making that a separate function: classifyScoresInDataByRCI()
#'
#' @section Background:
#' The RCI is part of Jacobson, Follette and Revenstorf's "RCSC":
#' Reliable and Clinically Significant Change paradigm.
#' @seealso \code{\link{getCSC}} for more general information about the paradigm and
#' @seealso \code{\link{getRCIfromSDandAlpha}} for more detail about the RCI.
#'
#' Note that by the logic of the criterion, change has to exceed the RCI,
#' not just equal it, for change to be deemed reliable.
#'
#' ## Details
#'
#' Splitting change into three levels: reliable deterioration, no reliable change,
#' and reliable improvement is pretty trivial.  However, as I worked on this
#' function it did seem to grow into something not so trivial that probably will
#' save people time.  It can be used in two main ways:
#' 1) to return a tibble of the scoreChange or the score1, score2 and computed
#'    scoreChange with the RCI categories added (returnTable = FALSE).
#' 2) to return a tabulation of the categories (returnTable = TRUE).
#'
#' I have given examples below but there are some aspects to option 2) wthat
#' can be adjusted by:
#' * using dp to determine the decimal places on the percentage breakdown
#'      (defaults to 1 decimal place)
#' * using addCI = TRUE to add a column giving the confidence interval (CI)
#'      around the observed percentage and perhaps ...
#' * using conf to choose something other than the default .95, i.e.
#'      a 95% interval ... though I can't really think of a good reason
#'      to do this!
#'
#' Adding the CI is probably mainly useful when you want to compare the
#' breakdown from a particular set of data with some other data or some
#' published figure or even, though I hope not, some managerial or
#' political target.
#'
#' Bear in mind that the three percentages must sum to 100% so they
#' are not independent of one another and the three CIs are therfore
#' also not independent.
#'
#' ## Technicality
#' The CI is calculated using \code{\link[Hmisc]{binconf}}
#' function from Frank Harrell's Hmisc package of miscellaneous
#' functions.  That uses Wilson's method to compute the CIs.  See
#' the documentation for \code{\link[Hmisc]{binconf}} for a brief
#' discussion of that choice and references.
#'
#' @examples
#' \dontrun{
#'
#' ### start with some very simple change values:
#' scoreChanges <- -5:5
#' scoreChanges # is:
#' #  [1] -5 -4 -3 -2 -1  0  1  2  3  4  5
#'
#' ## so now apply an RCI value of 2 to that:
#' cclassifyScoresVectorByRCI(scoreChange = scoreChanges, RCI = 2)
#' ## produces:
#' # You input 11 values for scoreChange.  There were no missing values.
#' ## A tibble: 3 x 4
#' # RCIclass                   n percent valid_percent
#' # <ord>                  <int> <chr>   <chr>
#' #   1 Reliable deterioration     3 27.3%   27.3%
#' #   2 No reliable change         5 45.5%   45.5%
#' #   3 Reliable improvement       3 27.3%   27.3%
#'
#' ### you could pipe that to your R/tidyverse table formating
#' tool of choice, \code{pander}, \code{huxtable}, whatever.
#'
#' ### you can add the 95% CI:
#'
#'
#'
#' ### create some spurious scores
#' n <- 75
#' score1 <- rnorm(n) # random Gaussian scores
#' score2 <- score1 - rnorm(n, mean = .2, sd = .2) # and some random change
#' scoreChange <- score1 - score2 # get the change
#'
#' cclassifyScoresVectorByRCI(scoreChange, RCI = .3)
#'
#' cclassifyScoresVectorByRCI(score1 = score1, score2 = score2, RCI = .3)
#' }
#'
#' @family RCSC functions
#'
#' @author Chris Evans
#'
#'
classifyScoresVectorByRCI <- function(scoreChange = NULL,
                                score1 = NULL,
                                score2 = NULL,
                                RCI = NULL,
                                cueing = "negative",
                                verbose = TRUE,
                                returnTable = TRUE,
                                dp = 1,
                                addCI = FALSE,
                                returnNumeric = FALSE,
                                CLsSeparate = FALSE,
                                conf = .95) {
  ### simple little function that gives the RCI classification
  ### against an RCI input as RCI (doh!)
  ### can be classifying change score: scoreChange
  ### or by computing change from first score, score1 and
  ### last score, score2
  ### cueing, says whether the measure has more problems
  ### scoring higher ("negative") or
  ### fewer problems scoring higher ("positive")

  ### declare variables to preempt complaints later
  RCIclassN <- RCIclass <- value <- percent <- percentChar <- valid_percent <- valid_percentChar <- NULL
  percCI <- LCLperc <- UCLperc <- CI <- LCLpercChar <- UCLpercChar <- NULL
  `...1` <- `...2` <- `...3` <- NULL

  ###
  ### sanity check inputs
  ###
  ### sanity check 1
  if (!is.logical(verbose)) {
    stop("Argument verbose must be logical")
  }
  ###
  ### sanity check 2
  if (is.null(RCI)) {
    stop("You haven't input a value for the RCI:
         value must be numeric, length 1 and non-zero")
  } else {
    if (length(RCI) != 1 | !is.numeric(RCI) | RCI < .Machine$double.eps) {
      stop("RCI input must be numeric, length 1 and non-zero")
    }
  }
  ###
  ### sanity check 3
  nNulls <- is.null(scoreChange) + is.null(score1) + is.null(score2)
  if (nNulls == 3) {
    stop("You don't seem to have input any scores, you must input
         either scoreChange or both of baseline (score1) and last scores (score2")
  }
  ###
  ### sanity check 4
  if (nNulls == 1) {
    if (!is.numeric(score1) | !is.vector(score1)) {
      stop("You have input score1, the baseline score,
           but it's not a numeric vector")
    }
    if (!is.numeric(score2) | !is.vector(score2)) {
      stop("You have input score2, the last score,
           but it's not a numeric vector")
    }
    ### got score1 and score2
    ### sanity check 5
    if (length(score1) != length(score2)) {
      stop("You have input score1, baseline score, and score2,
           last score, but they are not the same length")
    }
    ### input score1 and score2
  }
  if (nNulls == 2) {
    ### sanity check 6
    ### check scoreChange
    if (!is.numeric(scoreChange)) {
      stop("You have input scoreChange but it's not numeric")
    }
  }
  ###
  ### sanity check 6
  cueing <- match.arg(cueing, c("negative", "positive"))
  ###
  ### sanity check 7
  if (length(dp) != 1 | !is.numeric(dp) | dp < 0) {
    stop("Argument dp dictating number of decimal places in
         the percentages must be length 1 and numeric and zero or positive")
  }
  ###
  ### sanity check 8
  if (length(returnTable) != 1 | !is.logical(returnTable)) {
    stop("Argument returnTable must be length 1 and logical")
  }
  ###
  ### sanity check 9
  if (length(addCI) != 1 | !is.logical(addCI)) {
    stop("Argument addCI must be length 1 and logical")
  }
  ###
  ### sanity check 10
  if (length(CLsSeparate) != 1 | !is.logical(CLsSeparate)) {
    stop("Argument CLsSeparate must be length 1 and logical")
  }
  ###
  ### sanity check 11
  if (length(returnNumeric) != 1 | !is.logical(returnNumeric)) {
    stop("Argument returnNumeric must be length 1 and logical")
  }
  ###
  ### sanity check 12: conf must be sensible
  if (!is.numeric(conf) | conf <= 0 | conf > .999) {
    stop("conf must be numeric and 0 < conf < .999")
  }
  ### OK if we have got here we have all we need

  ### deal with missing data
  if (!is.null(scoreChange)) {
    ### have scoreChange values
    nNA <- sum(is.na(scoreChange))
    nTot <- length(scoreChange)
    if (verbose) {
      if (nNA > 0) {
        if (nNA > 1) {
          warning(paste0("You input ",
                         nTot,
                         " values for scoreChange.  There were ",
                         nNA,
                         " missing values which were ignored."))
        } else {
          warning(paste0("You input ",
                         nTot,
                         " values for scoreChange.",
                         "  One missing value was ignored."))
        }
      } else {
        message(paste0("You input ",
                       nTot,
                       " values for scoreChange.",
                       "  There were no missing values."))
      }
    }
  } else {
    ### got score1 and score2
    nTot <- length(score1)
    scoreChange <- na.omit(score1 - score2)
    nOK <- length(scoreChange)
    if (verbose) {
      if (nOK == nTot) {
        message(paste0("You input ",
                       nTot,
                       " values for score1 and for score2.",
                       "  There were no missing values."))
      } else {
        ### have got missing values
        nNA <- nTot - nOK
        if (nNA > 1) {
          warning(paste0("You input ",
                         nTot,
                         " values for score1, baseline and for",
                         " score2, the final scores.  There were ",
                         nTot - nOK,
                         " missing values which were ignored."))
        } else {
          warning(paste0("You input ",
                         nTot,
                         " values for score1, baseline and for score2,",
                         " the final scores.  There was one missing value",
                         " which was ignored."))
        }
      }
    }
  }

  ### deal with cueing
  if (cueing == "positive") {
    scoreChange <- 0 - scoreChange
  }
  suppressMessages(scoreChange %>%
    tibble::as_tibble() %>%
    dplyr::rename(scoreChange = value) %>%
    dplyr::mutate(RCIclassN = dplyr::if_else(abs(scoreChange) <= abs(RCI),
                                             0,
                                             NA_real_),
           RCIclassN = dplyr::if_else(scoreChange > RCI,
                                      1,
                                      RCIclassN),
           RCIclassN = dplyr::if_else(scoreChange < -RCI,
                                      -1,
                                      RCIclassN),
           RCIclass = dplyr::if_else(RCIclassN == 0,
                                     "No reliable change",
                                     NA_character_),
           RCIclass = dplyr::if_else(RCIclassN == 1,
                                     "Reliable improvement",
                                     RCIclass),
           RCIclass = dplyr::if_else(RCIclassN == -1,
                                     "Reliable deterioration",
                                     RCIclass)) -> tmpTib)

  if (returnTable) {
    ### setting things up to deal with missing categories
    RCIcats <- c("Reliable deterioration",
                 "No reliable change",
                 "Reliable improvement")
    ### this is so I can format the decimal places
    fmt <- paste0("%2.", dp, "f")
    nTot <- nrow(tmpTib) # get the denominator including any missing
    nValid <- sum(!is.na(scoreChange)) # number of valid change scores
    tmpTib %>%
      group_by(RCIclass) %>%
      ### to get the categories in sensible order
      dplyr::mutate(RCIclass = ordered(RCIclass,
                                levels = RCIcats,
                                labels = RCIcats)) %>%
      dplyr::summarise(n = n(),
                percent = 100 * n / nTot,
                percentChar = sprintf(fmt, percent),
                percentChar= paste0(percentChar, "%"),
                valid_percent = 100 * n / nValid,
                valid_percentChar = sprintf(fmt, valid_percent),
                valid_percentChar = paste0(valid_percentChar, "%")) %>%
      dplyr::rowwise() %>%
      dplyr::mutate(valid_percent = if_else(is.na(RCIclass),
                                            NA_real_,
                                            valid_percent),
                    valid_percentChar = if_else(is.na(RCIclass),
                                                NA_character_,
                                                valid_percentChar)) %>%
      ungroup() -> tmpTib
    if (addCI){
      suppressMessages(
      tmpTib %>%
        dplyr::rowwise() %>%
        dplyr::mutate(percCI = if_else(!is.na(RCIclass),
                                       list(Hmisc::binconf(n, nValid)),
                                       list(rep(0, 3)))) %>%
        dplyr::ungroup() %>%
        tidyr::unnest_wider(percCI) %>%
        dplyr::select(-`...1`) %>%
        dplyr::rename(LCLperc = `...2`,
                      UCLperc = `...3`) %>%
        ### get CLs as nicely formatted percentages
        dplyr::mutate(LCLpercChar = if_else(!is.na(RCIclass),
                                        paste0(sprintf(fmt, 100 * LCLperc), "%"),
                                               ""),
                      UCLpercChar = if_else(!is.na(RCIclass),
                                        paste0(sprintf(fmt, 100 * UCLperc), "%"),
                                        ""),
                      CI = if_else(!is.na(RCIclass),
                                   paste0(LCLpercChar,
                                  " to ",
                                  UCLpercChar),
                                  ""))) -> tmpTib
    }
    ###
    if (nrow(tmpTib) - sum(is.na(tmpTib$RCIclass)) < 3) {
      ### we've got an empty, row so
      ### now create an empty tibble so we can fill in any missing categories
      RCIord <- ordered(RCIcats,
                        levels = RCIcats,
                        labels = RCIcats)
      suppressMessages(RCIord %>%
        tibble::as_tibble() %>%
        dplyr::rename(RCIclass = value) %>%
        dplyr::left_join(tmpTib, by = "RCIclass") %>%
          dplyr::mutate(n = dplyr::if_else(is.na(n), 0L, n),
                        percent = dplyr::if_else(is.na(n), 0, percent),
                        percentChar = dplyr::if_else(n == 0,
                                                     paste0(sprintf(fmt, 0), "%"),
                                                     percentChar),
                        valid_percent = percent,
                        valid_percentChar = percentChar) -> tmpTib)
      if (addCI) {
        suppressMessages(tmpTib %>%
                           dplyr::mutate(CI = if_else(n == 0,
                                                      "",
                                                      CI)) -> tmpTib)
      }
    }
  }
  ### sort out whether returning character or numeric results
  ### CLsSeparate always returns numeric results
  if (returnNumeric | CLsSeparate) {
    tmpTib %>%
      dplyr::select(-c(percentChar, valid_percentChar, CI)) -> tmpTib
  } else {
    tmpTib %>%
      dplyr::select(-c(percent, valid_percent)) -> tmpTib
  }
  ### sort out whether to return CI (if requested) as character string
  ### or as separate numeric limits
  if (CLsSeparate) {
    tmpTib %>%
      dplyr::select(-c(CI, LCLpercChar, UCLpercChar)) -> tmpTib
  } else {
    tmpTib %>%
      dplyr::select(-c(LCLperc, UCLperc, LCLpercChar, UCLpercChar)) -> tmpTib
  }
  return(tmpTib)
}



