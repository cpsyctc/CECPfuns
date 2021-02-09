#' Title
#' Function to convert numbers to hyphenated (English) words, e.g. 87 to "eighty-seven"
#' @param x numeric
#' @param capitalise logical
#'
#' @return character
#' @export
#'
#' @examples
#' hyphenateWords(87)
#' hyphenateWords(87, capitalise = TRUE)
hyphenateWords <- function(x, capitalise = FALSE) {
  ### this is an almost shameful copy of a suggestion from Bill Venables <Bill.Venables@gmail.com>
  ### Bill is the maintainer of the english package as well as a key man in R
  ### his beautifully simple function replaces a much more clumsy approach I had written
  ### Bill named this as hyphen but I'm keeping my name to save changes and
  ### because I think "hyphen" might collide with other things, particularly
  ### if searching through a Rmarkdown file with a mix of English and code
  ### as you can see, it uses english::words() to convert single digits to English words
  ### and I think it hyphenates to UK English conventions
  ###
  ### capitalise is used to get capitalised word, e.g. "Eighty-seven"
  invisible(stopifnot(requireNamespace("english")))
  ### sanity check input
  if (!is.logical(capitalise)) {
    stop("capitalise argument must be a logical: TRUE, FALSE or (deprecated) T or F")
  }
  if (!is.numeric(x)) {
    stop("argument x must be numeric")
  }

  if (capitalise) {
    gsub("y (one|two|three|four|five|six|seven|eight|nine)", "y-\\1", english::Words(x))
  } else {
    gsub("y (one|two|three|four|five|six|seven|eight|nine)", "y-\\1", english::words(x))
  }
}