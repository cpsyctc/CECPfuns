detach("package:CECPfuns", unload = TRUE)
remove.packages("CECPfuns")

# crtl+shft+F10 (to restart R)

devtools::install(build=TRUE, build_vignettes=TRUE)
