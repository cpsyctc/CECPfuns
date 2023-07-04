## code to prepare `classifyScoresVectorByRCI` dataset goes here
scoreChange5to5 <- -5:5
classifyScoresVectorByRCI(scoreChange = scoreChange5to5, RCI = 1.5) -> tibRCI5to5

scoreChange5to5NA <- scoreChange5to5
scoreChange5to5NA[5] <- NA # set one value to NA
classifyScoresVectorByRCI(scoreChange = scoreChange5to5NA, RCI = 1.5) -> tibRCI5to5NA

## this creates the internal data
usethis::use_data(scoreChange5to5,
                  tibRCI5to5,
                  scoreChange5to5NA,
                  tibRCI5to5NA,
                  overwrite = TRUE,
                  internal = TRUE)
