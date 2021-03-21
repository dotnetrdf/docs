[[Home]] > [[User Guide|UserGuide]] > [[Configuration API|Configuration-API]] > [[SPARQL Datasets|Configuration-SPARQL-Datasets]]

# Configuring SPARQL Datasets 

SPARQL Datasets are an abstraction dotNetRDF which separates the Leviathan engine (our in-memory SPARQL engine) from the data so that arbitrary datasets can be plugged into it. This allows for datasets which don't have to be in-memory themselves though they do have to materialise triples in-memory as needed by the engine.

As a general rule anywhere you could have used a Triple Store (see [[Configuration API - Triple Stores|Configuration-Triple-Stores]]) via the `dnr:usingStore` property you can use a Dataset instead via the `dnr:usingDataset` property.

Datasets are configured using the [Configuration Vocabulary](http://www.dotnetrdf.org/configuration#) in a number of ways, as each dataset is different each has its own unique configuration.

# In-Memory Datasets 

The in-memory dataset represents pure in-memory data which is the default operation mode for Leviathan. Any [IInMemoryQueryableStore](https://dotnetrdf.github.io/api/html/T_VDS_RDF_IInMemoryQueryableStore.htm) instance can be wrapped in a [InMemoryDataset](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Query_Datasets_InMemoryDataset.htm).

The following example shows a Triple Store configuration being specified as the underlying source for a Dataset configuration:

```turtle

@prefix dnr: <http://www.dotnetrdf.org/configuration#> .

_:dataset a dnr:SparqlDataset ;
  dnr:type "VDS.RDF.Query.Datasets.InMemoryDataset" ;
  dnr:usingStore _:store .

_:store a dnr:TripleStore ;
  dnr:type "VDS.RDF.TripleStore" ;
  dnr:usingGraph _:a ;
  dnr:usingGraph _:b .

_:a a dnr:Graph ;
  dnr:type "VDS.RDF.Graph" ;
  dnr:fromFile "example.rdf" .

_:b a dnr:Graph ;
  dnr:type "VDS.RDF.Graph" ;
  dnr:fromUri <http://dbpedia.org/resource/Southampton> .
```

As you can see for an in-memory dataset you simply connect it to a `dnr:TripleStore` definition using the `dnr:usingStore` property.

You may alternatively use the [InMemoryQuadDataset](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Query_Datasets_InMemoryQuadDataset.htm) just by changing the value of the `dnr:type` property appropriately. The quad dataset may be more performant if your queries access named graphs frequently.

# Web Demand Datasets 

The [WebDemandDataset](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Query_Datasets_WebDemandDataset.htm) is a wrapper around another dataset that allows the dataset to load missing graphs on demand from the web.  It can be configured simply like so:

```turtle

@prefix dnr: <http://www.dotnetrdf.org/configuration#> .

_:dataset a dnr:SparqlDataset ;
  dnr:type "VDS.RDF.Query.Datasets.WebDemandDatset" ;
  dnr:usingDataset _:memDataset .

_:memDataset a dnr:SparqlDataset ;
  dnr:type "VDS.RDF.Query.Datasets.InMemoryQuadDataset" .
```