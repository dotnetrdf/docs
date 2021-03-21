[[Home]] > [[User Guide|UserGuide]] > [[Storage API|Storage-API]] > [[Storage Providers|UserGuide/Storage/Providers]] > [[SPARQL Query Endpoints|Storage-SPARQL-Query]]

# SPARQL Query Endpoints 

You can treat any publicly accessible SPARQL Query endpoint as a read-only store using the [SparqlConnector](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_SparqlConnector.htm).

**Note:** If you were looking for documentation on querying a SPARQL endpoint please see [[Querying with SPARQL|Querying-With-SPARQL]]

## Supported Capabilities 

* Load and List Graphs
* SPARQL Query

## Creating a Connection 

You can create a connection either just by providing the endpoint URI like so:

```csharp

SparqlConnector sparql = new SparqlConnector(new Uri("http://example.org/sparql"));
```

Or you can provide a [SparqlRemoteEndpoint](https://dotnetrdf.github.io/api/html/T_VDS_RDF_SparqlRemoteEndpoint.htm) instance like so:

```csharp

SparqlRemoteEndpoint endpoint = new SparqlRemoteEndpoint(new Uri("http://example.org/sparql"), "http://default-graph-uri");

SparqlConnector sparql = new SparqlConnector(endpoint);
```

In both cases there is an overload which takes a [SparqlConnectorLoadMethods](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_SparqlConnectorLoadMethod.htm) which determines whether the `LoadGraph()` method operates by making a `CONSTRUCT` or a `DESCRIBE` query, the default is `CONSTRUCT`