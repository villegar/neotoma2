#' @title pager
#' @description An internal helper function to count through all offsets/limits
#' @param response The result of the API call
#' @param response_url the url field of the http call
#' @param ... If TRUE, modify the response to contain all datapoints
#' @importFrom httr add_headers content GET stop_for_status
#' @importFrom jsonlite fromJSON
#' @export

pager <- function(response, response_url, ...) {

  responses <- c()
  cl <- as.list(match.call())

  clean_null <- function(x, fn = function(x) if (is.null(x)) NA else x) {
    if (is.list(x)) {
      lapply(x, clean_null, fn)
    }else{
      fn(x)
    }
  }

  if ("offset" %in% names(cl)) {
    param_offset <- cl$offset
  }else{
    param_offset <- 1
  }

  result <- response$data

  param_offset <- length(response$data)
  param_offset_old <- 0

  responses <- append(responses, result)

  while ((length(result) > 0) & param_offset_old != param_offset) {
    if (grepl("\\?", response_url)) {
      response <- httr::GET(paste0(response_url, "&offset=",
       param_offset, "&limit=500"))
    }else{
      response <- httr::GET(paste0(response_url, "?offset=",
       param_offset, "&limit=500"))
    }

    if (response$status_code == 200) {
      result <- jsonlite::fromJSON(httr::content(response, as = "text"),
                                   flatten = FALSE,
                                   simplifyVector = FALSE)
    }
    param_offset_old <- param_offset
    param_offset <- param_offset + length(result$data)
  }
    message(paste0("Your search returned ", param_offset, " objects."))
}