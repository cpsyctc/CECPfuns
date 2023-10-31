#' Function to convert a number of 'Firstname Familyname' lines on the clipboard to 'Familyname, Firstname'
#'
#' @param toClipboard logical: default TRUE sends changed names back to clipboard
#' @param warn logical: prints warning(s)
#'
#' @return Character vector of changed names if toClipboard == FALSE
#' @export
#'
#' @importFrom clipr clipr_available
#' @importFrom clipr read_clip
#' @importFrom clipr write_clip
#'
#' @examples
#' \dontrun{
#' ### the default is that you have your data, e.g.
#' # Ravindra Khattree
#' # Zhidong Bai
#' # Paula Caligiuri
#' # Yasunori Fijikoshi
#' # Yuehua Wu
#' # Arni S.R.
#' # Srinivasa Rao
#' # Marepalli B. Rao
#' ### (Those are from the deeply moving obituary of C.R.Ra:
#' ###    Khattree, et al. (2023). Institute of Mathematical Statistics |
#' ###    Obituary: C.R. Rao 1920–2023.
#' ### https://imstat.org/2023/09/30/obituary-c-r-rao-1920-2023/)
#'
#' ### You copy that into the system clipboard and in an interactive R session you run:
#' convertClipboardAuthorNames()
#'
#' ### That default will try to rearrange the names to its limited extent, print a warning to you
#' ### and put the rearranged names back into the clipboard replacing what was there.
#'
#' ### It's way away from intelligent, hence by default it gives you a warning.
#' ### An example of things it can't handle is 'Arni, S.R.' in the above.
#' ### That is already in the format we want so the function will mess that
#' ### one up: always check the result after pasting it into Zotero (or wherever).
#' ### Nevertheless I think the function now saves me time despite its lack of intelligence.
#' ### I hope it does for you too.
#'
#' ### If you are fed up with the warning you can use:
#' convertClipboardAuthorNames(warn = FALSE)
#'
#' ### I can't think why but just in case you want the result to be returned to the R prompt
#' ### as a character vector and NOT copied back to the clipboard, use:
#'
#' convertClipboardAuthorNames(toClipboard = FALSE)
#' }
#'
#' @section Background:
#' This is a tiny and crude function to convert a number of 'Firstname Familyname' lines
#' on the clipboard to 'Familyname, Firstname'.  I wrote it because I was quite often
#' putting records into Zotero where I had a list of authors but in that
#' 'Firstname Familyname' format and I thought it would save me time to have this to do
#' a first, rough, conversion to 'Familyname, Firstname' which Zotero will then
#' suck in happily.
#'
#' Beware, this is crude, as the default warning say, it will mess up space separated
#' family names like 'Matte Blanco' splitting that to make 'Blanco' alone the family name.
#' It must also fail if there is a mix of ordering in what you feed it and in some other
#' messy challenges.  So always check what it has put in the clipboard.  However, I find
#' it helps me quite a lot of the time. But then I pretty well always have Rstudio open
#' and the CECPfuns package loaded so it's quick and easy for me to call.  As the geeks say
#' your mileage may vary!",
#'
#' @family utility functions
#' @family text utility functions

convertClipboardAuthorNames <- function(toClipboard = TRUE, warn = TRUE) {
  if (!interactive()) {
    ### mainly here in case I do ever get to CRAN
    stop("Function will only work in an interactive R session")
  }
  if (!clipr_available()) {
    stop("For some reason the function can't write to the clipboard on your system")
  }
  if (!toClipboard) {
    message(paste0("As you have selected 'toClipboard = FALSE' the function just returns the author names as an R vector."))
  }
  if (warn & toClipboard) {
    msg <- paste0("WARNING #1: This overwrites your clipboard.  That's what it's meant to do!\n\n",
                  "      WARNING #2: It's only a very crude little function.\n",
                  "      It simply takes the last part of each line after the last space and makes that the first part and adding a comma and space separator.\n",
                  "      So 'Chris Evans' will become 'Evans, Chris'.\n",
                  "      It will mess up space separated family names like 'Matte Blanco' splitting that to make 'Blanco' alone the family name.\n",
                  "      It must also fail if there is a mix of ordering in what you feed it and probably on other messy challenges.\n",
                  "      You have been warned: always check what it has put in the clipboard.  But it should help a lot of the time!\n\n",
                  "If you are fed up warnings from the function use `convertClipboardAuthorNames(warn = FALSE)` and you won't see it.")
    warning(msg)
  }
  if (warn & !toClipboard) {
    msg <- paste0("WARNING This is only a very crude little function.\n",
                  "      It simply takes the last part of each line after the last space and makes that the first part and adding a comma and space separator.\n",
                  "      So 'Chris Evans' will become 'Evans, Chris'.\n",
                  "      It will mess up space separated family names like 'Matte Blanco' splitting that to make 'Blanco' alone the family name.\n",
                  "      It must also fail if there is a mix of ordering in what you feed it and probably on other messy challenges.\n",
                  "      You have been warned: always check what it has put in the clipboard.  But it should help a lot of the time!\n\n",
                  "If you are fed up warnings from the function, use `convertClipboardAuthorNames(warn = FALSE)` and you won't see it.")
    warning(msg)
  }
  clipTxt <- read_clip()
  txt2 <- str_replace(clipTxt, "(.*) (.*)", "\\2, \\1")
  if (toClipboard){
    write_clip(txt2, "character")
  } else {
    return(txt2)
  }
}
