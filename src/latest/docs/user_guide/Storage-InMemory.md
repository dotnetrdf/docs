[[Home]] > [[User Guide|UserGuide]] > [[Storage API|Storage-API]] > [[Storage Providers|UserGuide/Storage/Providers]] > [[In-Memory|Storage-InMemory]]

# In-Memory 

This is a wrapper over one of dotNetRDF's internal in-memory [IInMemoryQueryableStore](https://dotnetrdf.github.io/api/html/T_VDS_RDF_IInMemoryQueryableStore.htm) or [ISparqlDataset](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Query_Datasets_ISparqlDataset.htm) implementations.  It is primarily intended as a useful convenience for testing and prototyping prior to deploying the actual production store you intend to use.  This functionality is provided by the [InMemoryManager](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_InMemoryManager.htm) class.

## Supported Capabilities 

* Load, Save, Update, Delete and List Graphs
* SPARQL Query and Update

## Creating a connection 

You can create a connection to a completely fresh empty dataset like so:

```csharp

InMemoryManager mem = new InMemoryManager();
```

Or you can wrap an existing dataset/store:

```csharp

TripleStore store = new TripleStore();

//Assume we fill the store from somewhere

InMemoryManager mem = new InMemoryManager(store);
```