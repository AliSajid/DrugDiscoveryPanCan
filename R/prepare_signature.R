#' Prepare an L1000 Signature froma given differential gene expression output
#'
#' This function takes a differential gene expression output from any pipeline
#' like edgeR or DeSeq2 or any that give you the gene symbol, log_2 fold-change and p-value
#' and transforms that into an L1000 signature for later processing.
#'
#' @param dge A dataframe-like object that has the differential gene expression information
#' @param gene_column The name of the column that has gene symbols
#' @param logfc_column The name of the column that has log_2 fold-change values
#' @param pval_column  The name of the column that has p-values
#'
#' @return A tibble with the L1000 signature.
#' @export
#'
#' @importFrom dplyr filter select any_of inner_join rename mutate
#' @importFrom rlang .data
#'
#' @examples
#' TRUE
prepare_signature <- function(dge, gene_column = "Symbol",
                               logfc_column = "logFC", pval_column = "PValue") {
  filtered_l1000 <- dge %>%
    dplyr::filter(.data[[gene_column]] %in% l1000$SYMBOL) %>%
    dplyr::select(dplyr::any_of(c(gene_column, logfc_column, pval_column)))

  signature <- l1000 %>%
    dplyr::inner_join(filtered_l1000, by = c(SYMBOL = gene_column)) %>%
    dplyr::rename(
      ID_geneid = .data$ENTREZID,
      Name_GeneSymbol = .data$L1000,
      Value_LogDiffExp = .data[[logfc_column]],
      Significance_pvalue = .data[[pval_column]]
    ) %>%
    dplyr::mutate(signatureID = "InputSig") %>%
    dplyr::select(.data$signatureID, .data$ID_geneid, .data$Name_GeneSymbol,
                  .data$Value_LogDiffExp, .data$Significance_pvalue) %>%
    unique

  signature
}
