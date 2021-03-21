[[Home]] > [[User Guide|UserGuide]] > [[Storage API|Storage-API]] > [[Storage Providers|UserGuide/Storage/Providers]] > [[4store|Storage-4store]]

# 4store 

[4store](http://4store.org) the open source triple store originally developed at Garlik may be connected to using the [FourStoreConnector](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_FourStoreConnector.htm).

## Supported Capabilities 

* Load, Save, Update, Delete and List Graphs
* SPARQL Query and Update

## Creating a Connection 

Connecting to 4store requires only knowing the URL:

```csharp

FourStoreConnector fourStore = new FourStoreConnector("http://localhost:8080");
```

You may optionally specify a proxy server if necessary.

If using an old version of 4store that does not support updates you can connect to 4store in read-only mode like so:

```csharp

FourStoreConnector fourStore = new FourStoreConnector("http://localhost:8080", false);
```