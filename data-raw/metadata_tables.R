## code to prepare `metadata_tables` dataset goes here

library(tidyverse)

rename_columns <- function(input_names) {
  if ("Perturbagen" %in% input_names) {
    col_names <- c("SourceSignature", "Source", "SourceConcentration",
                   "SourceCellLine", "SourceTime")
  } else {
    col_names <- c("SourceSignature", "Source",
                   "SourceCellLine", "SourceTime")
  }

  col_names
}

oe_metadata <- read_tsv("raw/LINCS-OE-Metadata.xls") %>%
  select(-CGSID, -is_exemplar) %>%
  rename_with(rename_columns)

kd_metadata <- read_tsv("raw/LINCS-KD-Metadata.xls") %>%
  select(-CGSID, -is_exemplar) %>%
  rename_with(rename_columns)

cp_metadata <- read_tsv("raw/LINCS-Perturbagen-Metadata.xls") %>%
  select(-GeneTargets, -is_exemplar) %>%
  rename_with(rename_columns)

l1000 <- read_tsv("raw/l1000-list.tsv")

usethis::use_data(oe_metadata, kd_metadata, cp_metadata, l1000,
                  internal = TRUE, overwrite = TRUE)
