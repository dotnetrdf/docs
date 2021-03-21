[[Home]] > [[User Guide|UserGuide]] > [[Storage API|Storage-API]] > [[Storage Providers|UserGuide/Storage/Providers]] > [[SPARQL Graph Store Protocol Endpoints|Storage-SPARQL-Graph-Store]]

# SPARQL Graph Store Protocol Endpoints 

Any store which provides a [SPARQL Graph Store Protocol](http://www.w3.org/TR/sparql11-http-rdf-update/) endpoint may be connected to via the [SparqlHttpProtocolConnector](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_SparqlHttpProtocolConnector.htm).  This protocol is different from the normal SPARQL query and update protocol, if you wish to connect to a store that uses them see the [[SPARQL Query Endpoints|Storage-SPARQL-Query]] documentation instead.

## Supported Capabilities 

* Load, Save, Delete and Additive Updates for Graphs

## Creating a Connection 

To connect to the server you need to know the Base URI at which it exposes the protocol:

```csharp

SparqlHttpProtocolConnector sparql = new SparqlHttpProtocolConnector(new Uri("http://example.org/sparql"));
```

Optionally you may provide a proxy server if necessary.