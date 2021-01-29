library(tidyverse)
library(DrugDiscoveryPanCan)
library(UpSetR)

meta_gene <- list.files(file.path("inst", "results"), pattern = "KD") %>%
  str_remove(".csv") %>%
  str_split("_", simplify = TRUE) %>%
  as.data.frame() %>%
  rename(gene = V1,
         sig_type = V2,
         threshold = V3,
         ispaired = V4,
         isconcordant = V5)

meta_pancan <- list.files(file.path("inst", "results"), pattern = "P") %>%
  str_remove(".csv") %>%
  str_split("_", simplify = TRUE) %>%
  as.data.frame() %>%
  rename(cancer = V1,
         threshold = V2,
         ispaired = V3,
         isconcordant = V4)

selected_gene_files <- meta_gene %>%
  filter(threshold == 0.85, ispaired == "paired", isconcordant == "concordant") %>%
  unite(col = "file") %>%
  pull(file) %>%
  str_c("csv", sep = ".") %>%
  file.path("inst", "results", .)

selected_cancer_files <- meta_pancan %>%
  filter(threshold == 0.5, ispaired == "paired", isconcordant == "discordant") %>%
  unite(col = "file") %>%
  pull(file) %>%
  str_c("csv", sep = ".") %>%
  file.path("inst", "results", .)

data_gene <- selected_gene_files %>%
  map_dfr(read_csv) %>%
  select(-X1) %>%
  write_csv(file.path("inst", "results", "combined_genes_0.85_paired_concordant.csv"))

cancers <- selected_cancer_files %>%
  str_extract("[A-Z0-9]+")

data_cancer <- selected_cancer_files %>%
  map(read_csv) %>%
  map(~ select(.x, -X1)) %>%
  map2_dfr(cancers, ~ mutate(.x, Source = {{ .y }})) %>%
  write_csv(file.path("inst", "results", "combined_pancan_0.5_paired_discordant.csv"))

