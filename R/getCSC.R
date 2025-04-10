#' Function to return Jacobson (et al.) Clinically Significant Change (CSC)
#' @description
#' Fairly trivial function to compute CSC, mainly useful if using group_by() piping to find CSCs for various groups/subsets in your data.
#' @param formula1 defines variables to use as score ~ grp where score has scores and grp has grouping
#' @param data is the data, typically a subset creatd with group_by() and pick(everything()) when called in tidyverse pipe
#'
#' @return A single numeric value for the CSC
#'
#' @section Background:
#' Like the CSC, the RCI comes out of the classic paper Jacobson, Follette & Revenstorf (1984).  The thrust of the paper
#' was about trying to bridge the gap between (quantitative) researchers who then, and still, tend to think in terms of
#' aggregated data about change in therapy, and clinicians who tend to think about individual client's change.
#'
#' The authors came up with two indices: the RCI, and the one here: the CSC or Clinically Significant Change (cut-off).
#'
#' The authors defined three methods to set a criterion between "clinical" and "non-clinical" scores.
#' Generally we prefer "help-seeking" and "non-help-seeking" to "clinical" and "non-clinical" to avoid automatically jumping into a disease/medical model.
#'
#' For a measure cued so that higher scores indicate more problems the methods were as follows.
#' * Method a: the score 2 SD below the mean in the help-seeking group.
#' * Method b: the score 2 SD above the mean in the non-help-seeking group.
#' * Method c: the score between the means of the two groups defined so that,
#' for Gaussian distributions of scores, the cutting point would misclassify the same proportions of each group.
#' This is often spoken of as the point halfway between the two means but the definition
#' is actually more subtle than that and will only be halfway between the means where
#' the two groups have the same score SD.  Where the groups have different SD the formula for
#' method c is this.
#'
#' \loadmathjax{}
#'
#' \mjdeqn{\frac{SD_{HS}*M_{notHS} + SD_{notHS}*M_{HS}}{SD_{HS}+SD_{notHS}}}{}
#'
#' (with SD for Standard Deviation (doh!) and M for Mean)
#'
#' @family RCSC functions
#' @seealso \code{\link{getBootCICSC}} for CSC and bootstrap CI around it
#'
#' @export
#'
#' @importFrom mathjaxr preview_rd
#' @importFrom stats qnorm
#' @importFrom tibble as_tibble
#' @importFrom magrittr %>%
#' @importFrom dplyr pull
#' @importFrom dplyr summarise
#' @importFrom dplyr group_by
#'
#' @examples
#' \dontrun{
#' # example uses very crude simulated data but illustrates utility of being able to pipe grouped
#' # data into getCSC()
#' library(tidyverse)
#' set.seed(12345)
#' n <- 250 # total sample size
#' scores <- rnorm(n) # get some random numbers
#' # now random allocation to help-seeking or non-help-seeking samples
#' grp <- sample(c("HS", "notHS"), n, replace = TRUE)
#' # and random allocation by gender
#' gender <- sample(c("F", "M"), n, replace = TRUE)
#' list(scores = scores,
#'     grp = grp,
#'     gender = gender) %>%
#'  as_tibble() %>%
#'  mutate(scores = if_else(gender == "F", scores + .13, scores), # make women .13 higher scoring
#'         ### then make help-seeking group score 1.1 higher
#'         scores = if_else(grp == "HS", scores + 1.1, scores)) -> tibDat
#'### now get CSC overall
#'tibDat %>%
#'  ### pick(everything()) has replaced cur_data() in dplyr: more flexible but more verbose
#'  summarise(CSC = getCSC(scores ~ grp, pick(everything())))
#'
#'### get CSC by gender
#'tibDat %>%
#'  group_by(gender) %>%
#'  summarise(CSC = getCSC(scores ~ grp, pick(everything())))
#' }
#'
#' @family RCSC functions
#'
#' @author Chris Evans
#'
#' @references
#' * Jacobson, N. S., Follette, W. C., & Revenstorf, D. (1984).
#' Psychotherapy outcome research: Methods for reporting variability and evaluating clinical significance.
#' Behavior Therapy, 15, 336–352.
#' * Evans, C., Margison, F., & Barkham, M. (1998). The contribution of reliable and clinically significant
#' change methods to evidence-based mental health. Evidence Based Mental Health, 1, 70–72. https://doi.org/0.1136/ebmh.1.3.70
#'
#' @section History/development log:
#' Started before 5.iv.21
#'
getCSC <- function(formula1, data) {
  ### function to return CSC
  ### takes to
  ### OK now some input sanity checking largely to get informative error messages
  ### if things go wrong
  if (!inherits(formula1, "formula")) {
    stop("Argument must be a simple formula of form scores ~ groups")
  }
  ###
  ### sanity check 2: it should have two terms
  if (length(formula1) != 3) {
    stop("first argument must be a simple formula of form scores ~ groups")
  }
  scores <- formula1[[2]]
  grp <- formula1[[3]]
  ###
  ### sanity check 3
  if (length(scores) != 1 | length(grp) != 1) {
    stop("formula must be a simple one with one dependent and one predictor")
  }
  ### I think this will always work and just pulls the environment
  e <- environment(formula1)
  ### which can then be used to get the dependent out of data in that environment
  scores <- eval(scores, data, e)
  ### same for the predictor
  grp <- eval(grp, data, e)
  ###
  ### sanity check 4: scores must but numeric
  if (!is.numeric(scores)) {
    stop("Scores must be numeric")
  }
  ###
  ### sanity check 5: length of grouping and of score must be the same
  if (length(scores) != length(grp)) {
    stop("Lengths of scores (scores) and of the grouping (grp) must be the same")
  }
  ### OK, now remove any missing data
  list(scores = scores,
       grp = grp) %>%
    as_tibble() %>%
    na.omit() -> tmpDat
  ###
  ### sanity check 6: must be only two values for grp in tmpDat
  if (dplyr::n_distinct(tmpDat$grp) != 2) {
    stop("Grouping variable (grp) must have two and only two values")
  }
  ###
  ### sanity check 7: not much point in computing a CSC with smallest group < 10
  tmpDat %>%
    group_by(grp) %>%
    summarise(n = n()) %>%
    summarise(minN = min(n)) %>%
    pull() -> tmpMinN
  if (tmpMinN < 10) {
    warning("Not a lot of point in computing CSC with smallest cell size < 10")
  }
  ###
  ### end of sanity checking of input
  ### get the CSC
  tmpDat %>%
    group_by(grp) %>%
    summarise(n = n(),
              mean = mean(scores),
              sd = sd(scores)) -> tibStats
  tibStats %>%
    summarise(denominator = sum(sd)) %>%
    pull() -> denominator
  numerator <- tibStats$mean[2] * tibStats$sd[1] + tibStats$mean[1] * tibStats$sd[2]
  ### CSC is numerator / denominator (doh!)
  numerator / denominator
}
