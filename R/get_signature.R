#' Get the L1000 Signature from iLINCS
#'
#' @param sig_id character. The ilincs signature_id
#'
#' @return a tibble with the L1000 Signature
#' @export
#'
#' @importFrom httr POST content status_code
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom tibble tibble as_tibble
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom dplyr select
#' @importFrom purrr map_dfr
#'
#' @examples
#' TRUE
get_signature <- function(sig_id) {
  url <- "http://www.ilincs.org/api/ilincsR/downloadSignature"
  query = list(sigID = sig_id, noOfTopGenes = 978)

  request <- httr::POST(url, query = query)

  if (httr::status_code(request) == 200) {
    signature <- httr::content(request) %>%
      purrr::map_dfr("signature") %>%
      dplyr::select(-.data$PROBE)
  } else {
    signature <- tibble::tibble(
      signatureID = NA,
      ID_geneid = NA,
      Name_GeneSymbol = NA,
      Value_LogDiffExp = NA,
      Significance_pvalue = NA
    )
  }

  signature
}
