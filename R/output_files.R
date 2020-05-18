# read in.
scihub <- readr::read_delim("data/data_clean/ancient.sci-hub.stats.tab",
                            delim = "\t",
                            col_names = c(
                                "datetime", "DOI", "url","truncated_ipadres", "userid", "country")
)
### write out
readr::write_rds(scihub, "data/scihub.rds")
fst::write_fst(scihub, "data/scihub.fst")
readr::write_csv(scihub, "data/scihub.csv")
zip(zipfile =  "data/scihubdownloads.zip", files = "data/scihub.csv")
# create a database in a file.
con <- DBI::dbConnect(RSQLite::SQLite(), "data/scihub.sqlite")
DBI::dbWriteTable(con, "scihub", scihub)
DBI::dbExecute(con, "CREATE INDEX doi_index ON scihub(DOI);")
