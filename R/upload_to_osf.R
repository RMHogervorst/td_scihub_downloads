library(osfr)
link <- "https://osf.io/cphtu/" # I created it manually.
project <- osf_retrieve_node(link)


# This did not really work as I wanted.
# I think if you follow the instructions on the ropensci page and
# spend more than 2 minutes thinking about the project. This is an
# awesome tool. But I did not, so I had to fight it a bit.
data_file  <- osf_upload(project, path = list.files(pattern = "scihub*", recursive = TRUE))
r_files <- osf_upload(project, path = "R/")
osf_upload(project, path = c("README.md","README.Rmd"))
