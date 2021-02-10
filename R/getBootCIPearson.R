#' Title
#' Function to return observed Pearson correlation between two variables with bootstrap CI
#'
#' @param formula1 formula
#' @param data data.frame
#' @param bootReps integer
#' @param conf numeric
#'
#' @return list
#' @export
#'
#' @examples
#' \dontrun{
#' library(tidyverse)
#' data %>%
#'    summarise(corr = list(getBootCIPearson(var1 ~ var2, cur_data()))) %>%
#'    unnest_wider(corr)
#'    }
getBootCIPearson <- function(formula1, data, bootReps = 1000, conf = .95) {
  ### function to return bootstrap CI around observed Pearson correlation
  ### between two variables fed in within a formula as variable1 ~ variable2
  ### and each within a data frame or tibble, data
  ### bootReps sets the number of bootstrap replications
  ### conf sets the width of the CI
  ### uses the boot() and boot.ci() functions from the package boot, hence ...
  invisible(stopifnot(requireNamespace("boot")))
  ### OK now some input sanity checking largely to get informative error messages
  ### if things go wrong
  ### sanity check 1: is formula1 a formula?!
  if (class(formula1) != "formula"){
    stop("first argument must be a simple formula of form dependent ~ predictor")
  }
  ### sanity check 2: it should have two terms
  if (length(formula1) != 3){
    stop("first argument must be a simple formula of form variable1 ~ variable2")
  }
  var1 <- formula1[[2]]
  var2 <- formula1[[3]]
  ### sanity check 3
  if (length(var1) != 1 | length(var2) != 1) {
    stop("formula input can only have one term on each side of the formula")
  }
  ### I think this will always work and just pulls the environment
  e <- environment(formula1)
  ### which can then be used to get the dependent out of data in that environment
  vecVar1 <- eval(var1, data, e)
  ### same for the predictor
  vecVar2 <- eval(var2, data, e)
  ### sanity check 4: variables must but numeric
  if (!is.numeric(vecVar1) | !is.numeric(vecVar2)) {
    stop("Variables must be numeric")
  }
  ### sanity check 5: R must be numeric and integer
  ### can't imagine we really need this but ...
  ### function from documentation of integer in base R
  is.wholenumber <-
    function(x, tol = .Machine$double.eps^0.5)  abs(x - round(x)) < tol
  if (!is.numeric(bootReps) | !is.wholenumber(bootReps) | bootReps < 20){
    stop("Bootreps must be integer and numeric and, even for testing, >= 20")
  }
  ### sanity check 6: conf must be sensible
  if (!is.numeric(conf) | conf <= 0 | conf > .999 ) {
    stop("conf must be numeric and 0 < conf < .999")
  }
  ### end of sanity checking
  ###
  ### now we need a function to feed into boot() to get Pearson correlation
  pearsonForBoot <- function(x,i) {
    ### expects x as two column structure
    stats::cor(x[i,1],
        x[i,2],
        method = "pearson",
        use = "pairwise.complete.obs")
  }
  ### make x
  x <- cbind(vecVar1, vecVar2)
  ### now use that to do the bootstrapping
  tmpBootRes <- boot::boot(x, statistic = pearsonForBoot, R = bootReps)
  print(cor(vecVar1, vecVar2))
  ### and now get the CI from that, I've used the percentile method
  tmpCI <- boot::boot.ci(tmpBootRes, type = "perc", conf = conf)
  list(obsCorrPears = as.numeric(tmpBootRes$t0),
       LCLPears = tmpCI$percent[4],
       UCLPears = tmpCI$percent[5])
}
