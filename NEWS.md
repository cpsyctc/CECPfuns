# Version 0.0.0.9064
Added trivial getSvalFromPval function.

# Version 0.0.0.9063
Hm.  This has been a bit of a silly day for the package with me wasting some hours as I'd forgotten how the github pages and pkgdown processes work.  This update is just to get the package numbering correct in both NEWS.md and DESCRIPTION!

# Version 0.0.0.9062
Now added correction to convertVectorToSentence to handle input of length 1 sensibly.  Also corrections to improve checkIsOneDim.R and checkIsVector.R.  Mostly I'm still trying to understand github and the gh-pages branch and why pkgdown seems to have stopped working to create https://cecpfuns.psyctc.org/.

# Version 0.0.0.9061
Tweak to convertVectorToSentence to throw warning not error if input is length 1. Also tweaked syntax in test-getPdiff2alphas.R.

# Version 0.0.0.9060
Silly little tweak adding "BuildManual: yes" to DESCRIPTION as I think it's needed now

# Version 0.0.0.9059
README.Rmd tweaked to include instructions about installing pandoc if installation fails and vignettes are wanted.

# Version 0.0.0.9058
Various tweaks to get reference to Feldt (1969) into getPdiff2alphas()

# Version 0.0.0.9057
Tweaks to man page for getPdiff2alphas()

# Version 0.0.0.9056
Added getPdiff2alphas()

# Version 0.0.0.9055
Added fixVarNames()

# Version 0.0.0.9054
Corrected typos in the latex formulae in getAttenuatedR() and getCorrectedR()

# Version 0.0.0.9053
Added getCorrectedR() and tweaks to getAttenuatedR().

# Version 0.0.0.9052
Added getAttenuatedR() and tweakes to whichSetOfN().

# Version 0.0.0.9051
Added whichSetOfN(), some cleaning and updating and resynchronised these version numbers between this file and DESCRIPTION.

# Version 0.0.0.9050
Fixed essentially cosmetic bug in plotQuantileCIsfromDat() (CI as percentage in plot label wrong: it showed .1 of what it should have been!) and more serious bug in getCIforQuantiles() that it was always using 95% for the CI not what was entered. Would only have affected things if someone wanted another CI so I think impact zero!

# Version 0.0.0.9049
Added first version of lookupCSCgenderAndAge().  Error checks probably not fully correct and no warning or output tests yet.

# Version 0.0.0.9048
Renamed plotCIcorrelation() to plotCIPearson() (which was an alias of plotCIcorrelation()) to allow for creation of plotCISpearman() soon.
While at that, tweaked the code to avoid irritating warning message caused by changes in tidyverse and to improve the code a bit. Created
getCIPearson() pulling that out of plotCIPearson().

# Version 0.0.0.9047
Added convertClipboardAuthorNames()

# Version 0.0.0.9046
Whoops, been forgetting to update this.  getCIforQuantiles has been improved and plotQuantileCIsfromDat added with full testing for getCIforQuantiles and testing of the sanity testing for plotQuantileCIsfromDat.  A few ancillary things removed on github as they had clearly aged beyond their "will work by dates".

# Version 0.0.0.9045
Improved sanity checking for getCIforQuantiles, added internalUtils.R for hidden functions, first one is isNothing() and added test-getScoreFromItems but getScoreFromItems still work in progress

# Version 0.0.0.9044
Realised that test-getCIforQuantiles had been lost in the github mess, reinstated it.  Creating getScoreFromItems in progress.

# Version 0.0.0.9043
Replaced class(arg) == "formula" tests with inherits(arg, "formula") in some functions as the class() test is deprecated.  On local machine I installed missing R packages covr & specr and the Linux command line utility qpdf (not to be confused with the R package qpdf!) to suppress check warnings/notes but those are just local changes.

# Version 0.0.0.9042
Added getCIforQuantiles.R  No tests on it yet and some other things need work to deal with changes in R and package building tools since I last updated package (a long time ago!)

# Version 0.0.0.9041
Just trying using "Build Source" to see if that gets me the vignettes up on GitHub.  Small tweaks to Introduction vignette.

# Version 0.0.0.9040
Yet another commit as I've realised that I have to run pkgdown::build_site() _BEFORE_ committing to get the pkgdown site
rebuilt.  Let's see if this works!

# Version 0.0.0.9039
A rebuild to see if I have got around the rather frustrating failure of Rstudio's build to rebuild the vignettes which had
resulted in them disappearing.  Also testing to see if usethis::use_github_action("pkgdown") has looked after getting the
pkgdown site rebuilt after any new push, like this one!

# Version 0.0.0.9038
Added internal functions checkIsVector() and checkIsOneDim() to get around some (easily done) misunderstanding of base::is.vector().
Tweaks to checkAllUnique(), classifyScoresVectorByRIC() and convertVector2sentence() to clean up handling of vectors with attributes
and to handle single dimensional lists.

# Version 0.0.0.9037
Merged code of conduct and contributors documents created on GitHub (and the GitHub repository now has issue templates).
Tweak to README to point to the pkgdown website for the package at https://cecpfuns.psyctc.org/.

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

