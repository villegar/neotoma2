#' @title An S4 class for Neotoma publications
#' @export
author <- setClass("author",
                   representation(author = "contact",
                                  order = "numeric"),
                   prototype(author = NULL,
                             order = NA_integer_))

#' @title An S4 class for a set of Neotoma author objects.
#' @export
authors <- setClass("authors",
                    representation(authors = "list"),
                    validity = function(object) {
                      all(map(object@authors, function(x) {
                        class(x) == "author"}) %>%
                          unlist())
                    })

#' @title An S4 class for a single Neotoma publication.
#' @export
publication <- setClass("publication",
                        representation(publicationid = "numeric",
                                       publicationtypeid = "numeric",
                                       publicationtype = "character",
                                       year = "character",
                                       citation = "character",
                                       articletitle = "character",
                                       journal = "character",
                                       volume = "character",
                                       issue = "character",
                                       pages = "character",
                                       citationnumber = "character",
                                       doi = "character",
                                       booktitle = "character",
                                       numvolumes = "character",
                                       edition = "character",
                                       volumetitle = "character",
                                       seriestitle = "character",
                                       seriesvolume = "character",
                                       publisher = "character",
                                       url = "character",
                                       city = "character",
                                       state = "character",
                                       country = "character",
                                       originallanguage = "character",
                                       notes = "character",
                                       author = "authors"),
                        prototype(publicationid = NA_integer_,
                                  publicationtypeid = NA_integer_,
                                  publicationtype = NA_character_,
                                  year = NA_character_,
                                  citation = NA_character_,
                                  articletitle = NA_character_,
                                  journal = NA_character_,
                                  volume = NA_character_,
                                  issue = NA_character_,
                                  pages = NA_character_,
                                  citationnumber = NA_character_,
                                  doi = NA_character_,
                                  booktitle = NA_character_,
                                  numvolumes = NA_character_,
                                  edition = NA_character_,
                                  volumetitle = NA_character_,
                                  seriestitle = NA_character_,
                                  seriesvolume = NA_character_,
                                  publisher = NA_character_,
                                  url = NA_character_,
                                  city = NA_character_,
                                  state = NA_character_,
                                  country = NA_character_,
                                  originallanguage = NA_character_,
                                  notes = NA_character_,
                                  author = NULL))

#' @title
#'  An S4 class for multi-publication information
#'  from the Neotoma Paleoecology Database.
#' @export
publications <- setClass("publications",
                         representation(publications  = "list"),
                         validity = function(object) {
                           all(map(object@publications,
                                   function(x) {
                                     class(x) == "publication"
                                     }) %>%
                                 unlist())
                         })

#' @title Get slot names for a publication object.
#' @param x A \code{publication} object.
#' @importFrom methods slotNames
#' @export
setMethod(f = "names",
          signature = signature(x = "publication"),
          definition = function(x) {
            slotNames("publication")
          })

#' @title Get slot names for a publication object.
#' @param x A \code{publications} object.
#' @importFrom methods slotNames
#' @export
setMethod(f = "names",
          signature = signature(x = "publications"),
          definition = function(x) {
            slotNames("publication")
          })

#' @title Show the contents of a publication object.
#' @param object A \code{publications} object
#' @importFrom purrr map
#' @importFrom dplyr bind_rows
#' @export
setMethod(f = "show",
          signature = signature(object = "publications"),
          definition = function(object) {
            map(object@publications, function(x) {
              data.frame(publicationid = x@publicationid,
                         citation = x@citation,
                         doi = x@doi)
            }) %>%
              bind_rows() %>%
              print()
          })

#' @title Extract an element from a \code{publication}
#' @param x A \code{publication} object.
#' @param name The slot to obtain (e.g., \code{articletitle})
#' @importFrom methods slot
#' @export
setMethod(f = "$",
          signature = signature(x = "publication"),
          definition = function(x, name) {
            slot(x, name)
          })

# Currently errors out.
# setMethod(f = "$<-",
#          signature = signature(x = "publication"),
#          definition = function(x, name, y) {
#            slot(x, name) <- y
#          })

#' @title Obtain one of the elements within a publication list.
#' @export
setMethod(f = "[[",
          signature = signature(x = "publications", i = "numeric"),
          definition = function(x, i) {
            if (length(i) == 1) {
              out <- new("publication", x@publications[[i]])
            } else {
              out <- purrr::map(i, function(z) {
                new("publication", x@publications[[z]])
                })
              out <- new("publications", publications = out)
            }
            return(out)
          })

#' @title Assign value to an element in a publication list.
#' @export
setMethod(f = "[[<-",
          signature = signature(x = "publications"),
          definition = function(x, i, j, value) {
            if (length(i) == 1) {
              x@publications[[i]] <- new("publication", value)
              out <- x
              return(out)
            } else {
              warning("You can only reassign one publication at a time.")
            }
          })

#' @title Get the number of publications in a publications object.
#' @export
setMethod(f = "length",
          signature = signature(x = "publications"),
          definition = function(x) {
            length(x@publications)
          })

#' @title Combine publication objects.
#' @export
setMethod(f = "c",
          signature = signature(x = "publications"),
          definition = function(x, y) {
            new("publications",
                publications = unlist(c(x@publications,
                                       y@publications), recursive = FALSE))
          })

#' @title Print publications to screen.
#' @param object A \code{publication} object.
#' @export
setMethod(f = "show",
          signature = signature(object = "publication"),
          definition = function(object) {
            print(data.frame(publicationid = object@publicationid,
                             citation = object@citation,
                             doi = object@doi))
          })

#' @title Show matches for objects.
#' @export
setGeneric("showMatch", function(x) {
  standardGeneric("showMatch")
})

#' @title Show matched publication objects.
#' @param x A \code{publication} object.
#' @export
setMethod(f = "showMatch",
          signature = signature(x = "publication"),
          definition = function(x) {
            if (!is.null(attr(x, "matches"))) {
              print(attr(x, "matches"))
            }
          })

#' @title Obtain the DOI for publications.
#' @export
setGeneric("doi", function(x) {
  standardGeneric("doi")
})

#' @title Get a publication DOI.
#' @param x A \code{publication} object.
#' @importFrom methods slotNames
#' @export
setMethod(f = "doi",
          signature = signature(x = "publication"),
          definition = function(x) {
            x@doi
          })

#' @title Convert a publication author to a \code{data.frame}
#' @param x An author
#' @importFrom methods slotNames slot
#' @importFrom purrr map
#' @importFrom dplyr bind_cols
#' @export
setMethod(f = "as.data.frame",
          signature = signature(x = "authors"),
          definition = function(x) {
            authors <- x@authors %>%
              map(function(y) {
                paste0(y@author@familyname, ", ",
                       y@author@givennames)
                }) %>%
              paste0(collapse = "; ")
            return(authors)
          })

#' @title Convert a \code{publication} to a \code{data.frame}
#' @importFrom methods slotNames slot
#' @importFrom purrr map
#' @param x A \code{publication} object.
#' @export
setMethod(f = "as.data.frame",
          signature = signature(x = "publication"),
          definition = function(x) {
            slots <- slotNames(x)
            slots <- slots[!slots == "author"]
            table <- slots %>%
              purrr::map(function(s) {
                out <- data.frame(slot(x, s),
                                  stringsAsFactors = FALSE)
                colnames(out) <- s
                return(out)
              }) %>%
              bind_cols()
            table$authors <- as.data.frame(x@author)
            return(table)
          })

#' @title Convert publications to a \code{data.frame}
#' @param x A \code{publications} object.
#' @export
setMethod(f = "as.data.frame",
          signature = signature(x = "publications"),
          definition = function(x) {
            full <- x@publications %>%
            map(function(y) as.data.frame(y)) %>%
              bind_rows()
            return(full)
})

#' @title Select the best match for an object.
#' @export
setGeneric("selectMatch", function(x, n) {
  standardGeneric("selectMatch")
})

#' @title Select the best match (between a local record and a Neotoma match)
#' @param x A \code{publication} object
#' @param n The match number.
#' @export
setMethod(f = "selectMatch",
          signature = signature(x = "publication", n = "numeric"),
          definition = function(x, n) {
            if (is.null(attr(x, "matches"))) {
              stop("There are no existing matches.")
            } else if (n > length(attr(x, "matches"))) {
              stop("The requested match is not in the current list.")
            } else if (n <= length(attr(x, "matches"))) {
              return(attr(x, "matches")[[n]])
            }
          })

#' @title Select the best match (between a local record and a Neotoma match)
#' @param x A \code{publication} object
#' @param n The match number (in the case an NA is returned).
#' @export
setMethod(f = "selectMatch",
          signature = signature(x = "publication", n = "logical"),
          definition = function(x, n) {
            attr(x, "matches") <- NULL
            return(x)
          })