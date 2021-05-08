[[Home]] > [[Developer Guide|DeveloperGuide]] > URI Interning

# URI Interning

URI Interning is an advanced feature of the API that gives the following benefits:

* Reduce memory usage by avoiding redundant duplicate Uri instances representing the same URIs
* Improves equality comparison speed because many comparisons will become fast reference equality checks

You can leverage this feature yourself by calling the `Create()` method of the `VDS.RDF.UriFactory` rather than using the `Uri` constructor. It is safe to do this even if you disable this feature as detailed later on this page since when the feature is disabled calling this method just calls the `Uri` constructor instead.

## Possible problems associated with URI Interning

While this feature is very powerful it may have adverse affects on memory usage in some scenarios. Over long periods of time this may have the same appearance as a memory leak since large amounts of memory get allocated but are never released.

This is particularly true in scenarios where you will not manipulate RDF in memory for long periods or where you wish to do stream processing and keep memory usage low.

## Disabling the Feature

In such scenarios it may be desirable to disable the interning behavior which may be done by setting the `InternUris` property of the `VDS.RDF.Options` class. With the property set to false even if the code calls the `Create()` method of the `UriFactory` the URI will just be created rather than interned.

## Freeing Memory

Note that you can also periodically force the interned URIs to be cleared by calling the `Clear()` method of the `UriFactory`. This will release the library's references to the memory and this will then get cleaned up over time by the normal .Net GC process.