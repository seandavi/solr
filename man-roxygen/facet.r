#' @param q Query terms. See examples.
#' @param facet.query This param allows you to specify an arbitrary query in the
#' Lucene default syntax to generate a facet count. By default, faceting returns
#' a count of the unique terms for a "field", while facet.query allows you to
#' determine counts for arbitrary terms or expressions. This parameter can be
#' specified multiple times to indicate that multiple queries should be used as
#' separate facet constraints. It can be particularly useful for numeric range
#' based facets, or prefix based facets -- see example below (i.e. price:[* TO 500]
#' and  price:[501 TO *]).
#' @param facet.field This param allows you to specify a field which should be
#' treated as a facet. It will iterate over each Term in the field and generate a
#' facet count using that Term as the constraint. This parameter can be specified
#' multiple times to indicate multiple facet fields. None of the other params in
#' this section will have any effect without specifying at least one field name
#' using this param.
#' @param facet.prefix Limits the terms on which to facet to those starting with
#' the given string prefix. Note that unlike fq, this does not change the search
#' results -- it merely reduces the facet values returned to those beginning with
#' the specified prefix. This parameter can be specified on a per field basis.
#' @param facet.sort See Details.
#' @param facet.limit This param indicates the maximum number of constraint counts
#' that should be returned for the facet fields. A negative value means unlimited.
#' Default: 100. Can be specified on a per field basis.
#' @param facet.offset This param indicates an offset into the list of constraints
#' to allow paging. Default: 0. This parameter can be specified on a per field basis.
#' @param facet.mincount This param indicates the minimum counts for facet fields
#' should be included in the response. Default: 0. This parameter can be specified
#' on a per field basis.
#' @param facet.missing Set to "true" this param indicates that in addition to the
#' Term based constraints of a facet field, a count of all matching results which
#' have no value for the field should be computed. Default: FALSE. This parameter
#' can be specified on a per field basis.
#' @param facet.method See Details.
#' @param facet.enum.cache.minDf This param indicates the minimum document frequency
#' (number of documents matching a term) for which the filterCache should be used
#' when determining the constraint count for that term. This is only used when
#' facet.method=enum method of faceting. A value greater than zero will decrease
#' memory usage of the filterCache, but increase the query time. When faceting on
#' a field with a very large number of terms, and you wish to decrease memory usage,
#' try a low value of 25 to 50 first. Default: 0, causing the filterCache to be used
#' for all terms in the field. This parameter can be specified on a per field basis.
#' @param facet.threads This param will cause loading the underlying fields used in
#' faceting to be executed in parallel with the number of threads specified. Specify
#' as facet.threads=# where # is the maximum number of threads used. Omitting this
#' parameter or specifying the thread count as 0 will not spawn any threads just as
#' before. Specifying a negative number of threads will spin up to Integer.MAX_VALUE
#' threads. Currently this is limited to the fields, range and query facets are not
#' yet supported. In at least one case this has reduced warmup times from 20 seconds
#' to under 5 seconds.
#' @param facet.date Specify names of fields (of type DateField) which should be
#' treated as date facets. Can be specified multiple times to indicate multiple
#' date facet fields.
#' @param facet.date.start The lower bound for the first date range for all Date
#' Faceting on this field. This should be a single date expression which may use
#' the DateMathParser syntax. Can be specified on a per field basis.
#' @param facet.date.end The minimum upper bound for the last date range for all
#' Date Faceting on this field (see facet.date.hardend for an explanation of what
#' the actual end value may be greater). This should be a single date expression
#' which may use the DateMathParser syntax. Can be specified on a per field basis.
#' @param facet.date.gap The size of each date range expressed as an interval to
#' be added to the lower bound using the DateMathParser syntax. Eg:
#' facet.date.gap=+1DAY. Can be specified on a per field basis.
#' @param facet.date.hardend A Boolean parameter instructing Solr what to do in the
#' event that facet.date.gap does not divide evenly between facet.date.start and
#' facet.date.end. If this is true, the last date range constraint will have an
#' upper bound of facet.date.end; if false, the last date range will have the smallest
#' possible upper bound greater then facet.date.end such that the range is exactly
#' facet.date.gap wide. Default: FALSE. This parameter can be specified on a per
#' field basis.
#' @param facet.date.other See Details.
#' @param facet.date.include See Details.
#' @param facet.range Indicates what field to create range facets for. Example:
#' facet.range=price&facet.range=age
#' @param facet.range.start The lower bound of the ranges. Can be specified on a
#' per field basis. Example: f.price.facet.range.start=0.0&f.age.facet.range.start=10
#' @param facet.range.end The upper bound of the ranges. Can be specified on a per
#' field basis. Example: f.price.facet.range.end=1000.0&f.age.facet.range.start=99
#' @param facet.range.gap The size of each range expressed as a value to be added
#' to the lower bound. For date fields, this should be expressed using the
#' DateMathParser syntax. (ie: facet.range.gap=+1DAY). Can be specified
#' on a per field basis. Example: f.price.facet.range.gap=100&f.age.facet.range.gap=10
#' @param facet.range.hardend A Boolean parameter instructing Solr what to do in the
#' event that facet.range.gap does not divide evenly between facet.range.start and
#' facet.range.end. If this is true, the last range constraint will have an upper
#' bound of facet.range.end; if false, the last range will have the smallest possible
#' upper bound greater then facet.range.end such that the range is exactly
#' facet.range.gap wide. Default: FALSE. This parameter can be specified on a
#' per field basis.
#' @param facet.range.other See Details.
#' @param facet.range.include See Details.
#' @param start Record to start at, default to beginning.
#' @param rows Number of records to return.
#' @param key API key, if needed.
#' @param base URL endpoint
#' @param wt (character) Data format to return. One of xml or json (default).
#' @param raw (logical) If TRUE (default) raw json or xml returned. If FALSE,
#' 		parsed data returned.
#' @param callopts Call options passed on to httr::GET
#' @param verbose If TRUE (default) the url call used printed to console.
#' @param ... Further args, usually per field arguments for faceting.
#' @details
#' A number of fields can be specified multiple times, in which case you can separate
#' them by commas, like \code{facet.field='journal,subject'}. Those fields are:
#' \itemize{
#'  \item facet.field
#'  \item facet.query
#'  \item facet.date
#'  \item facet.date.other
#'  \item facet.date.include
#'  \item facet.range
#'  \item facet.range.other
#'  \item facet.range.include
#' }
#'
#' \strong{Options for some parameters}:
#'
#' \strong{facet.sort}: This param determines the ordering of the facet field constraints.
#' \itemize{
#'   \item {count} sort the constraints by count (highest count first)
#'   \item {index} to return the constraints sorted in their index order (lexicographic
#'   by indexed term). For terms in the ascii range, this will be alphabetically sorted.
#' }
#' The default is count if facet.limit is greater than 0, index otherwise. This
#' parameter can be specified on a per field basis.
#'
#' \strong{facet.method}:
#' This parameter indicates what type of algorithm/method to use when faceting a field.
#' \itemize{
#'   \item {enum} Enumerates all terms in a field, calculating the set intersection of
#'   documents that match the term with documents that match the query. This was the
#'   default (and only) method for faceting multi-valued fields prior to Solr 1.4.
#'   \item {fc} (Field Cache) The facet counts are calculated by iterating over documents
#'   that match the query and summing the terms that appear in each document. This was
#'   the default method for single valued fields prior to Solr 1.4.
#'   \item {fcs} (Field Cache per Segment) works the same as fc except the underlying
#'   cache data structure is built for each segment of the index individually
#' }
#' The default value is fc (except for BoolField which uses enum) since it tends to use
#' less memory and is faster then the enumeration method when a field has many unique
#' terms in the index. For indexes that are changing rapidly in NRT situations, fcs may
#' be a better choice because it reduces the overhead of building the cache structures
#' on the first request and/or warming queries when opening a new searcher -- but tends
#' to be somewhat slower then fc for subsequent requests against the same searcher. This
#' parameter can be specified on a per field basis.
#'
#' \strong{facet.date.other}: This param indicates that in addition to the counts for each date
#' range constraint between facet.date.start and facet.date.end, counts should also be
#' computed for...
#' \itemize{
#'   \item {before} All records with field values lower then lower bound of the first
#'   range
#'   \item {after} All records with field values greater then the upper bound of the
#'   last range
#'   \item {between} All records with field values between the start and end bounds
#'   of all ranges
#'   \item {none} Compute none of this information
#'   \item {all} Shortcut for before, between, and after
#' }
#' This parameter can be specified on a per field basis. In addition to the all option,
#' this parameter can be specified multiple times to indicate multiple choices -- but
#' none will override all other options.
#'
#' \strong{facet.date.include}: By default, the ranges used to compute date faceting between
#' facet.date.start and facet.date.end are all inclusive of both endpoints, while
#' the "before" and "after" ranges are not inclusive. This behavior can be modified
#' by the facet.date.include param, which can be any combination of the following
#' options...
#' \itemize{
#'   \item{lower} All gap based ranges include their lower bound
#'   \item{upper} All gap based ranges include their upper bound
#'   \item{edge} The first and last gap ranges include their edge bounds (ie: lower
#'   for the first one, upper for the last one) even if the corresponding upper/lower
#'   option is not specified
#'   \item{outer} The "before" and "after" ranges will be inclusive of their bounds,
#'   even if the first or last ranges already include those boundaries.
#'   \item{all} Shorthand for lower, upper, edge, outer
#' }
#' This parameter can be specified on a per field basis. This parameter can be specified
#' multiple times to indicate multiple choices.
#'
#' \strong{facet.date.include}: This param indicates that in addition to the counts for each range
#' constraint between facet.range.start and facet.range.end, counts should also be
#' computed for...
#' \itemize{
#'   \item{before} All records with field values lower then lower bound of the first
#'   range
#'   \item{after} All records with field values greater then the upper bound of the
#'   last range
#'   \item{between} All records with field values between the start and end bounds
#'   of all ranges
#'   \item{none} Compute none of this information
#'   \item{all} Shortcut for before, between, and after
#' }
#' This parameter can be specified on a per field basis. In addition to the all option,
#' this parameter can be specified multiple times to indicate multiple choices -- but
#' none will override all other options.
#'
#' \strong{facet.range.include}: By default, the ranges used to compute range faceting between
#' facet.range.start and facet.range.end are inclusive of their lower bounds and
#' exclusive of the upper bounds. The "before" range is exclusive and the "after"
#' range is inclusive. This default, equivalent to lower below, will not result in
#' double counting at the boundaries. This behavior can be modified by the
#' facet.range.include param, which can be any combination of the following options...
#' \itemize{
#'   \item{lower} All gap based ranges include their lower bound
#'   \item{upper} All gap based ranges include their upper bound
#'   \item{edge} The first and last gap ranges include their edge bounds (ie: lower
#'   for the first one, upper for the last one) even if the corresponding upper/lower
#'   option is not specified
#'   \item{outer} The "before" and "after" ranges will be inclusive of their bounds,
#'   even if the first or last ranges already include those boundaries.
#'   \item{all} Shorthand for lower, upper, edge, outer
#' }
#' Can be specified on a per field basis. Can be specified multiple times to indicate
#' multiple choices. If you want to ensure you don't double-count, don't choose both
#' lower & upper, don't choose outer, and don't choose all.
