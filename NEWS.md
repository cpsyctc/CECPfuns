# Version 0.0.0.9036
Used pkgdown to make a web site for the package.  The process checks all the examples so some tweaks to examples in getBootCImean, 
classifyScoresVectorsByRCI and checkAllUnique so they run correctly.

# Version 0.0.0.9035
Improved help page for getRelBySpearmanBrown and linked it to new Rblog page https://www.psyctc.org/Rblog/posts/2021-04-09-spearman-brown-formula/.
All help page "History" sections renamed to "History/development log" to avoid confusion with other use of "History".  Functions convertVector2sentence and convert2CEdate got synonyms convertVectorToSentence and convertToCEdate: more congruent with my general naming conventions.

# Version 0.0.0.9034
All help pages now have a "History" section for their function to keep an updating record.

# Version 0.0.0.9033
Tiny tweaks to Description in light of rhub checking.  Small improvements to plotBinconf and gave it synonym plotCIproportion. 
Added plotCIcorrelation (with synonym plotCIPearson).

# Version 0.0.0.9032
Hm.  Tweaked "pak_install_extra(upgrade = FALSE)" to "pak::pak_install_extra(upgrade = FALSE)"

# Version 0.0.0.9031
Added "pak_install_extra(upgrade = FALSE)" to R-CMD-check.yaml to see if that will 
run and perhaps solve the failure on R 3.5 on Ubuntu.
Split "Introduction" vignette into "Introduction" and "Background", added basics of 
"Bootstrapping" (and CIs) vignette and one for the RCSC framework.

# Version 0.0.0.9030
Minor improvements to classifyScoresVectorByRCI.

# Version 0.0.0.9029
Added checkAllUnique()

# Version 0.0.0.9028
Some tweaks to classifyScoresVectorByRCI() and plotBinconf() to please lintR!  R-CMD-check.yaml 
tweaked to get R 3.5.0 checked on windows to see if error report from 3.5 in Ubuntu is replicated.
Added isOneToOne().

# Version 0.0.0.9027
Tweaked ./.github/workflows/R-CMD-check.yaml to removing checking on R < 3.5, tests added for 
classifyScoresVectorByRCI() and plotBinconf(), introductory vignette fleshed out and 
package help page now largely replaced by a link to that vignette.

# Version 0.0.0.9026
Corrected mistake in classifyScoresVectorByRCI() help examples.  
Added suppressMessages to plotBinconf() to get rid of irritating messages from dplyr.

# Version 0.0.0.9025
Added classifyScoresVectorByRCI() and plotBinconf(). 
Both still need work on help and tests but usable.

# Version 0.0.0.9024
Renamed classifyRCIfromScores to classifyScoresByRCI.  Some dependency hunting. 

# Version 0.0.0.9023
More work to get continuous integration testing on github with github actions running.
Moved linting off GitHub, some linting of some of the code.

# Version 0.0.0.9021
Added classifyRCIfromScores() which at first seemed a trivial function, 
it is really, but it turned into a huge amount of work bizarrely.
Added internal data directory data-raw for test data and hence
sysdata.rda.  Some R style improvements.

# Version 0.0.0.9020

I have skipped updating here through 12 changes.  The 9000 came
in as it's a convention that says the version is alpha/testing.
Latest change was adding classifyRCIfromScores() and a lot of
tweaking and trying to improve lint checking complaints.

# Version 0.0.0.8

Added getCSC() and some more tweaks to documentation and help.

# Version 0.0.0.7

Improved documentation, building README.Rd from README.Rmd just by 
knitting it in Rstudio.

