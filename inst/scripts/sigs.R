library(tidyverse)
library(DrugDiscoveryPanCan)

inputs <- list.files("~/experiments/justin-rnaseq/results/",
                     pattern = "^dge-table-\\w*-unfiltered.csv",
                     full.names = T)

expr <- inputs %>%
  map(read_csv)


output_lib <- c("CP")
filter_threshold <- c(0, 0.26, 0.5, 0.85, 1)
paired <- c(TRUE, FALSE)
discordant <- c(TRUE, FALSE)
similarity_threshold <- 0

s <- expand_grid(inputs, output_lib, filter_threshold, similarity_threshold, paired, discordant)

filenames <- s %>%
  mutate(celline = str_extract(inputs, "P\\w+"),
    ispaired = if_else(paired, "paired", "unpaired"),
         isdiscordant = if_else(discordant, "discordant", "concordant")) %>%
  unite(file, celline, filter_threshold, ispaired, isdiscordant) %>%
  pull(file) %>%
  paste("csv", sep = ".") %>%
  file.path("inst", "results", .)

g <- s %>%
  mutate(expr = map(inputs, read_csv),
         source_name = str_extract(inputs, "P\\w+")) %>%
  select(-inputs)

g %>%
  pmap(investigate_signature) %>%
  walk2(filenames, ~ write.csv(.x, .y))
