#' Function returns RCI given baseline score SD, reliability and confidence sought
#'
#' @param SD single number giving the baseline score standard deviation
#' @param rel reliability of the measure, typically, and sensibly, Cronbach's alpha
#' @param conf the expectation/confidence interval, almost always .95
#'
#' @return single number giving the RCI
#' @export
#'
#' @section Background:
#' Like the CSC, the RCI comes out of the classic paper Jacobson, Follette & Revenstorf (1984).  The thrust of the paper
#' was about trying to bridge the gap between (quantitative) researchers who then, and still, tend to think in terms of
#' aggregated data about change in therapy, and clinicians who tend to think about individual client's change.
#'
#' The authors came up with two indices: the CSC, and the one here: the RCI or Reliable Change Index.
#'
#'
#' \loadmathjax{}
#' \mjdeqn{RCI = \varphi(conf)\! \times\! \sqrt{2}\! \times SD\times\sqrt{1 - rel}}{}
#'
#' Where

#' * *SD* is the Standard Deviation (doh!) at baseline/t1,
#' * \(\\varphi(conf)\) is the value of Gaussian distribution for *conf* coverage with *conf*, usually .95 and hence \mjeqn{\varphi(conf)}{} = 1.96
#' * and *rel* is the reliability of the measures, usually from Cronbach's alpha.
#'
#' The logic of the this is that this bit:
#' \mjdeqn{\sqrt{2}\! \times SD\times\sqrt{1 - rel}}{}
#'
#' is the standard error (SE) of a difference between two scores in Classical Test Theory (CTT)  In fact the 1984 paper omitted the \(\\sqrt(2)\) term
#' and that was corrected by a subsequent letter from Christensen & Menoza (1986).  If we accept the model of CTT in which all these
#' distributions are Gaussian then multiplying the SE by \(\\varphi(conf)\) gives you a range of scores that would include a proportion *conf* of change
#' that would arise from unreliability of measurement alone.
#'
#' There is a very widespread misunderstanding that the RCI is a generic benchmark, in fact it's a coverage expectation based on the SD of the baseline
#' scores so it's a calculation to be done for any sample.  Computing the RCI for your dataset allows you to designate change as "reliable improvement",
#' "reliable deterioration" or "no reliable change". This is perhaps useful for three particular sets of clients:
#' * those with very high starting scores who might have improvement but not enough to drop below the CSC criterion, so not achieving "clinically
#' significant change", being able to see that some of them improve more than would be expected by unreliability of measurement alone
#' * those who started just above the CSC and crossed the CSC but whose change falls in the "no reliable change" range
#' * those who started below the CSC who of course therefore can't show clinically significant change but may still show reliable improvement.
#'
#' There's also an issue that Jacobson and his colleagues were looking for criteria with which to categorise individual change, sadly, too often the
#' RCSC paradigm seems to have become just another way aggregate scores but my counting.
#'
#' @examples
#' \dontrun{
#'
#' getRCIfromSDandAlpha(7.5, .8, conf = 0.95) # from Jacobson & Truax (1991)
#' }
#'
#' @family RCSC functions
#'
#' @references
#' * Christensen, L., & Mendoza, J. L. (1986). A method of assessing change in a single subject:
#' An alteration of the RC index. Behavior Therapy, 17, 305–308.
#' * Jacobson, N. S., Follette, W. C., & Revenstorf, D. (1984).
#' Psychotherapy outcome research: Methods for reporting variability and evaluating clinical significance.
#' Behavior Therapy, 15, 336–352.
#' * Jacobson, N. S., & Truax, P. (1991). Clinical significance: A statistical approach to defining meaningful change
#' in psychotherapy research. Journal of Consulting and Clinical Psychology, 59(1), 12–19.
#' * Evans, C., Margison, F., & Barkham, M. (1998). The contribution of reliable and clinically significant
#' change methods to evidence-based mental health. Evidence Based Mental Health, 1, 70–72. https://doi.org/0.1136/ebmh.1.3.70
#'
#' @author Chris Evans
#'
#' @section History:
#' Started before 5.iv.21
#'
getRCIfromSDandAlpha <- function(SD, rel, conf = .95) {
  ### trivial function to return RCI given baseline score SD
  ### and sensible estimate of reliability, usually Cronbach alpha
  ### sanity check 1: SD
  if (!is.numeric(SD) | length(SD) != 1 | SD <= 0) {
    stop("SD input must be single positive number larger than zero")
  }
  ### sanity check 2: rel
  if (!is.numeric(rel) | length(rel) != 1 | rel >= 1 | rel < .05) {
    stop("reliability (rel) input must be single number between .1 and 1.0")
  }
  ### sanity check 3: conf must be sensible
  if (!is.numeric(conf) | conf <= 0 | conf > .999) {
    stop("conf must be numeric and 0 < conf < .999")
  }
  ### OK, we can go ahead
  retVal <- qnorm(1 - (1 - conf) / 2) # get the correct multiplier for desired confidence
  retVal <- retVal * sqrt(2) * SD * sqrt(1 - rel) # get the rest of the equation
  retVal # return the answer (doh!)
}
