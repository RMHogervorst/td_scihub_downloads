library(osfr)
link <- "https://osf.io/cphtu/"
project <- osf_retrieve_node(link)

# list all relevant files


data_file  <- osf_upload(project, path = list.files(pattern = "scihub*", recursive = TRUE))
r_files <- osf_upload(project, path = "R/")
osf_upload(project, path = c("README.md","README.Rmd"))
