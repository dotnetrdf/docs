[[Home]] > [[Developer Guide|DeveloperGuide]] > [[Notes for Silverlight and WP7 Developers|DeveloperGuide-Notes-For-Silverlight-And-WP7-Developers]]

# Notes for Silverlight and Windows Phone Developers

This page attempts to cover the differences between the Core API on standard .Net and the Core API when run under Silverlight or Windows Phone 7.

## No ASP.Net Support

Firstly there is obviously no ASP.Net support on these platforms as this would not make any sense and required libraries (`System.Web`) are not supported.

## Storage APIs

Secondly there is a partial storage layer included on this platform. This is because many of the supported stores use synchronous HTTP and this is not supported on these platforms, most stores that require HTTP are accessible via the new `VDS.RDF.Storage.IAsyncStorageProvider` API instead.

## HTTP Issues

The main functional change between the standard and Silverlight/Windows Phone API is that any method that relies on HTTP must be accessed via an async callback pattern rather than via a synchronous call because only async HTTP is supported on these platforms.

## Thread Safety

The remaining API changes are primarily just in terms of minor functionality differences e.g. no thread safe versions of some implementations since there is no `ReaderWriterLockSlim` on these platforms.