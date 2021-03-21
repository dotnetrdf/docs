# Storage Providers 

This area of the User Guide covers the available [IStorageProvider](xref:VDS.RDF.Storage.IStorageProvider) and [IAsyncStorageProvider](xref:VDS.RDF.Storage.IAsyncStorageProvider) implementations.  Each provider has its own wiki page which details provider specific behaviour and any special functionality available for that provider.

You should read the [Triple Store Integration](../user_guide/Triple-Store-Integration.md) page for an overview of how to use the Storage API.

The available providers are as follows:

| Provider | Description |
| --- | --- |
| [Allegro Graph](Storage-AllegroGraph.md) | AllegroGraph 3.x and 4.x |
| [Blazegraph](Storage-Blazegraph.md) | Blazegraph |
| [Dataset Files](Storage-DatasetFile.md) | Read-only view over a NQuads/TriG/TriX file |
| [4store](Storage-4store.md) | 4store |
| [Fuseki](Storage-Fuseki.md) | Apache Jena Fuseki, access any Jena based store via Fuseki |
| [In-Memory](Storage-InMemory.md) | In-Memory store |
| [Sesame](Storage-Sesame.md) | Any Sesame based store is supported e.g. Sesame, OWLIM, BigData |
| [SPARQL Query Endpoints](Storage-SPARQL-Query.md) | Any SPARQL Query endpoint |
| [SPARQL Query and Update Endpoints](Storage-SPARQL-Query-And-Update.md) | Any store providing both a query and update endpoint |
| [SPARQL Graph Store Protocol](Storage-SPARQL-Graph-Store.md) | Any SPARQL Graph Store Protocol endpoint |
| [Stardog](Storage-Stardog.md) | Stardog |
| [Virtuoso](Storage-Virtuoso.md) | Virtuoso Universal Server |

There are also some useful wrappers available:

| Wrapper | Description |
| --- | --- |
| [ReadOnlyConnector](xref:VDS.RDF.Storage.ReadOnlyConnector) | Make any other provider read-only |
| [QueryableReadOnlyConnector](xref:VDS.RDF.Storage.QueryableReadOnlyConnector) | Make any queryable provider read-only |