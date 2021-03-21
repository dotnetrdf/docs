[[Home]] > [[User Guide|UserGuide]] > [[Configuration API|Configuration-API]] > [[Triple Stores|Configuration-Triple-Stores]]

# Configuration Triple Stores 

Triple Stores can be specified using the Configuration Vocabulary in a number of ways. The [ConfigurationLoader](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Configuration_ConfigurationLoader.htm) is capable of loading a variety of types of Triple Store from configuration.

Triple Stores are loaded from configuration in the following way:

1. Create an instance of the relevant ITripleStore implementation based on the dnr:type property
1. Any automated loading that the implementation does starts occurring now
1. Read in any data sources in the following order
   1. Graphs
   1. Dataset Files
1. Apply reasoners

# Basic Configuration 

At it's most basic a Triple Store is configured as follows:

```turtle

@prefix dnr: <http://www.dotnetrdf.org/configuration#> .

_:store a dnr:TripleStore ;
  dnr:type "VDS.RDF.TripleStore" .
```

## Data Source Configuration 

There are only 2 ways to specify Graphs to be loaded into a Triple Store but since 1 of these is from other Graphs specified in the configuration file you can actually use any of the data sources supported by Graphs as described in [[Configuration API - Graphs|Configuration-Graphs]].

### Other Graphs 

Using the `dnr:usingGraph` property any number of Graphs can be loaded into a Triple Store. Note that each graph must have a unique Base URI or the Triple Store will throw an error, as described in [[Configuration API - Graphs|Configuration-Graphs]] you can use the `dnr:assignUri` property to ensure this.

The following example shows loading two graphs into a Triple Store

```turtle

@prefix dnr: <http://www.dotnetrdf.org/configuration#> .

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

### Dataset Files 

You can populate a Triple Store using a RDF dataset file which is in one of the dataset formats dotNetRDF understands (NQuads, TriG or TriX) which you specify with the `dnr:fromFile` property. File paths can either be absolute or may be relative. In the case of relative paths the resolution of the path can be controlled by introducing an [IPathResolver](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Configuration_IPathResolver.htm) implementation by setting the `PathResolver` property of the `ConfigurationLoader`.

The following example loads a dataset from a file:

```turtle

@prefix dnr: <http://www.dotnetrdf.org/configuration#> .

_:store a dnr:TripleStore ;
  dnr:type "VDS.RDF.TripleStore" ;
  dnr:fromFile "example.trig" .
```

## Applying Reasoners 

You can also apply reasoners to Triple Stores loaded in this way with the triples that the reasoner produces being materialised into a special Graph in the Triple Store. To learn how to configure a reasoner see [[Configuration API - Reasoners|Configuration-Reasoners]].

Linking a reasoner to a Triple Store is as easy as using the dnr:reasoner property as the following example in which an RDF Schema reasoner is applied to the Triple Store.

```turtle

@prefix dnr: <http://www.dotnetrdf.org/configuration#> .

_:store a dnr:TripleStore ;
  dnr:type "VDS.RDF.TripleStore" ;
  dnr:reasoner _:rdfs .

_:rdfs a dnr:Reasoner ;
  dnr:type "VDS.RDF.Query.Inference.RdfsReasoner" .
```

When you apply a reasoner to a Store then that reasoner gets applied over all existing Graphs in the Store and then if any additional Graphs are added to the Store the reasoner gets applied to newly added Graphs.

# Configuring Complex Triple Stores 

It is possible to configure a number of more complex [ITripleStore](https://dotnetrdf.github.io/api/html/T_VDS_RDF_ITripleStore.htm) instances beyond the basic `TripleStore` demonstrated so far. This section of the document describes additional types of Triple Store that can be configured.

## Web Demand Triple Store 

The [WebDemandTripleStore](https://dotnetrdf.github.io/api/html/T_VDS_RDF_WebDemandTripleStore.htm) is a Triple Store which attempts to load Graphs from the web whenever a Graph with a URI which is not currently in the Store is requested. Configuring this is as simple as altering the value of the dnr:type property like so:

```turtle

@prefix dnr: <http://www.dotnetrdf.org/configuration#> .

_:store a dnr:TripleStore ;
  dnr:type "VDS.RDF.WebDemandTripleStore" .
```

## Persistent Triple Store 

The [PersistentTripleStore](https://dotnetrdf.github.io/api/html/T_VDS_RDF_PersistentTripleStore.htm) provides a view of an arbitrary store for which there is an [IStorageProvider](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_IStorageProvider.htm) provided. The Triple Store can then be used for query and update operations on the underlying store. This is configured by setting the `dnr:type` property appropriately and then using the `dnr:storageProvider` property to point to a storage provider to be used e.g.

```turtle

@prefix dnr: <http://www.dotnetrdf.org/configuration#> .

_:store a dnr:TripleStore ;
  dnr:type "VDS.RDF.PersistentTripleStore" ;
  dnr:storageProvider _:agraph .

_:agraph a dnr:StorageProvider ;
  dnr:type "VDS.RDF.Storage.AllegroGraphConnector" ;
  dnr:server "http://localhost:9875" ;
  dnr:catalogID "catalog" ;
  dnr:storeID "repository" .
```