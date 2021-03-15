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
#'
#' @return a tibble, either of the summary breakdown with n and % by classification, or a tibble of the data with classified change
#' @export
#'
#' @importFrom dplyr left_join
#' @importFrom dplyr if_else
#' @importFrom dplyr rowwise
#' @importFrom dplyr ungroup
#'
#'
#' @examples
#'
#' ### create some spurious scores
#' n <- 75
#' score1 <- rnorm(n) # random Gaussian scores
#' score2 <- score1 - rnorm(n, mean = .2, sd = .2) # and some random change
#' scoreChange <- score1 - score2 # get the change
#'
#' classifyRCIfromScores(scoreChange, RCI = .3)
#'
#' classifyRCIfromScores(score1 = score1, score2 = score2, RCI = .3)
#'
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
#' @family RCSC functions
#'
#' @author Chris Evans
#'
#'
classifyRCIfromScores <- function(scoreChange = NULL,
                                  score1 = NULL,
                                  score2 = NULL,
                                  RCI = NULL,
                                  cueing = "negative",
                                  verbose = TRUE,
                                  returnTable = TRUE,
                                  dp = 1) {
  ### simple little function that gives the RCI classification
  ### against an RCI input as RCI (doh!)
  ### can be classifying change score: scoreChange
  ### or by computing change from first score, score1 and
  ### last score, score2
  ### cueing, says whether the measure has more problems
  ### scoring higher ("negative") or
  ### fewer problems scoring higher ("positive")

  RCIclassN <- RCIclass <- value <- percent <- valid_percent <- NULL
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
    if(length(score1) != length(score2)) {
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
  if (length(dp)!= 1 | !is.numeric(dp) | dp < 0) {
    stop("Argument dp dictating number of decimal places in
         the percentages must be length 1 and numeric and zero or positive")
  }
  ###
  ### sanity check 8
  if (length(returnTable) != 1 | !is.logical(returnTable)) {
    stop("Argument returnTable must be length 1 and logical")
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
    nNA1 <- sum(is.na(score1))
    nNA2 <- sum(is.na(score2))
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
    scoreChange = 0 - scoreChange
  }
  scoreChange %>%
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
                                     RCIclass)) -> tmpTib

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
                percent = sprintf(fmt, percent),
                percent = paste0(percent, "%"),
                valid_percent = 100 * n / nValid,
                valid_percent = sprintf(fmt, valid_percent),
                valid_percent = paste0(valid_percent, "%")) %>%
      dplyr::rowwise() %>%
      dplyr::mutate(valid_percent = if_else(is.na(RCIclass),
                                            NA_character_,
                                            valid_percent)) %>%
      ungroup() -> tmpTib
    ###
    if (nrow(tmpTib) - sum(is.na(tmpTib$RCIclass)) < 3) {
      ### we've got an empty, row so
      ### now create an empty tibble so we can fill in any missing categories
      RCIord <- ordered(RCIcats,
                        levels = RCIcats,
                        labels = RCIcats)
      RCIord %>%
        tibble::as_tibble() %>%
        dplyr::rename(RCIclass = value) %>%
        dplyr::left_join(tmpTib, by = "RCIclass") %>%
        dplyr::mutate(n = dplyr::if_else(is.na(n), 0L, n),
               percent = dplyr::if_else(n == 0,
                                 paste0(sprintf(fmt, 0), "%"),
                                 percent),
               valid_percent = percent) -> tmpTib
    }
  }
  return(tmpTib)
}
