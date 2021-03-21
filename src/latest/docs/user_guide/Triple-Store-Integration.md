[[Home]] > [[User Guide|UserGuide]] > [[Storage API|Storage-API]] > Triple Store Integration

# 3rd Party Triple Store Integration

While the API can represent Triple Stores as an in-memory collection of Graphs as discussed in Working with Triple Stores it also has the ability to integrate with a variety of 3rd party Triple Stores via our `VDS.RDF.Storage.IStorageProvider` and `VDS.RDF.Storage.IAsyncStorageProvider` interfaces. Both these interfaces extend the `VDS.RDF.IStorageCapabilities interface which provides information about what a specific implementation supports.

Some implementations may implement additional interfaces which provide extra features. See the async operations section for more detail on the asynchronous version of the API.

Take a look at the [[Storage Providers|Storage-Providers]] page for available implementations.

# General Usage

These interfaces provides a standard mechanism for using an external Triple Store in your applications and allows you to easily drop in and out different stores as required. So let's start by looking at what the interface provides:

## Informative Properties

The `IStorageCapabilities` interface has a set of properties which are used to indicate certain capabilities of the Store:

| Property | Description |
|----------|-------------|
| `DeleteSupported` | Indicates whether the deletion of Graphs is supported via the `DeleteGraph()` method |
| `IOBehaviour` | Indicates detailed information about the `VDS.RDF.Storage.IOBehaviour` that a store provides |
| `IsReadOnly` | Indicates whether the Store is read-only |
| `IsReady` | Indicates whether the Store is ready for use |
| `ListGraphsSupported` | Indicates whether the store supports listing of Graphs via the `ListGraphs()` method
| `UpdateSupported` | Indicates whether triple level updates to Graphs is supported via the `UpdateGraph()` method |

## Accessing the Default Graph

Many triple stores support a notion of a default graph and typically this graph may have no explicit name. Therefore dotNetRDF allows you to access the default graph of a store by passing either a `null` URI or an empty String for the Graph URI parameter of relevant methods.

If you wish to save a graph to the default graph you should ensure the `BaseUri` property of that graph instance is set to null prior to invoking the `SaveGraph()` method.

## Methods

The various methods of an `IStorageProvider` are used to perform actions on the store to read and write data to and from it as desired. This section discusses each method with an example of using each.

### DeleteGraph()

The `DeleteGraph()` method is used to delete a Graph from a Store. If the store does not support this operation it will indicate this by returning false for its `DeleteSupported` property, we recommend always checking this property before attempting to delete a Graph e.g.

```csharp

using System;
using VDS.RDF;
using VDS.RDF.Storage;

public class DeleteGraphExample
{
	public static void Main(String[] args)
	{
		//First connect to a store, in this example we use AllegroGraph
		AllegroGraphConnector agraph = new AllegroGraphConnector("http://your-server.com:9875","catalog","store");

		//Then Delete a Graph
		//Making sure that we check this feature is supported first
		if (agraph.DeleteSupported)
		{
			agraph.DeleteGraph("http://example.org/graph");
		}
		else
		{
			throw new Exception("Store does not support deleting graphs");
		}
	}
}
```

### ListGraphs()

The `ListGraphs()` method is used to retrieve the list of Graph URIs from the Store. This assumes of course that the store supports the notion of named graphs/quads and that it supports this feature as indicated by the `ListGraphsSupported` property e.g.

```csharp

using System;
using VDS.RDF;
using VDS.RDF.Storage;

public class ListGraphExample
{
	public static void Main(String[] args)
	{
		//First connect to a store, in this example we use 4store
		FourStoreConnector fourstore = new FourStoreConnector("http://your-server.com:8080");

		//Then List the Graphs
		//Making sure that we check this feature is supported first
		if (fourstore.ListGraphsSupported)
		{
			//Iterate over the Graph URIs and print them
			foreach (Uri u in fourstore.ListGraphs())
			{
				Console.WriteLine(u.ToString());
			}
		}
		else
		{
			throw new Exception("Store does not support listing graphs");
		}
	}
}
```

### LoadGraph()

The `LoadGraph()` method is used to load a Graph from the Store into an `IGraph` instance. This is the one method that must be supported by all implementations e.g.

```csharp

using System;
using VDS.RDF;
using VDS.RDF.Storage;

public class LoadGraphExample
{
	public static void Main(String[] args)
	{
		//First connect to a store, in this example we use Fuseki
		FusekiConnector fuseki = new FusekiConnector("http://your-server.com:3030/dataset/data");

		//Create a Graph and then load it with data from the store
		Graph g = new Graph();
		fuseki.LoadGraph(g, "http://example.org/graph");

		//Now do whatever you want with the loaded data...
	}
}
```

### SaveGraph()

The `SaveGraph()` method saves a Graph to a Store, the Graph is saved under the Graph URI set by its `BaseUri` property. This method cannot be used if the store is read-only as indicated by its `IsReadOnly` property.

**Important:** Different stores have different behaviours with regards to whether saving a Graph overwrites existing data in the same graph or is merged with it. Please check the documentation for the `IStorageProvider` implementation for your store to see what the behaviour is for that specific store.

```csharp
using System;
using VDS.RDF;
using VDS.RDF.Storage;

public class SaveGraphExample
{
	public static void Main(String[] args)
	{
		//First connect to a store, in this example we use Sesame
		SesameHttpProtocolConnector sesame = new SesameHttpProtocolConnector("http://your-server.com:8080","repository");

		//Create a Graph and fill it with data we want to save
		Graph g = new Graph();
		g.LoadFromFile("example.rdf");

		//Set its BaseUri property to the URI we want to save it as
		g.BaseUri = new Uri("http://example.org/graph");

		//Now save it to the store
		if (!sesame.IsReadOnly)
		{
			sesame.SaveGraph(g);
		}
		else
		{
			throw new Exception("Store is read-only");
		}
	}
}
```

### UpdateGraph()

The `UpdateGraph()` method is used to add and/remove Triples from a Graph in the Store. Whether this method is supported is indicated by the `UpdateSupported` property.

**Important:** Different stores have different behaviours regarding how they apply additions/removals. Please check the documentation for the `IStorageProvider` implementation for your store to see what the behaviour is for that specific store.

```csharp
using System;
using VDS.RDF;
using VDS.RDF.Parsing;
using VDS.RDF.Storage;

public class UpdateGraphExample
{
	public static void Main(String[] args)
	{
		//First connect to a store, in this example we use Virtuoso
		VirtuosoManager manager = new VirtuosoManager("localhost", VirtuosoManager.DefaultPort, VirtuosoManager.DefaultDB, "user", "password");

		//Construct the Triple we wish to add
		Graph g = new Graph();
		INode s = g.CreateBlankNode();
		INode p = g.CreateUriNode(new Uri(RdfSpecsHelper.RdfType));
		INode o = g.CreateUriNode(new Uri("http://example.org/Example"));
		Triple t = new Triple(s, p, o);

		//Now delete the Triple from a Graph in the Store
		if (virtuoso.UpdateSupported)
		{
			//UpdateGraph takes enumerables of Triples to add/remove or null to indicate none
			//Hence why we create a Triple array to pass in the Triple to be deleted
			virtuoso.UpdateGraph("http://example.org/graph", null, new Triple[] { t });
		}
		else
		{
			throw new Exception("Store does not support triple level updates");
		}
	}
}
```

## Additional Interfaces

Some Stores provide SPARQL Query and/or Update support and this support is indicated by the `IStorageProvider` implementation also implementing the `VDS.RDF.Storage.IQueryableStorage` and `VDS.RDF.IUpdateableStorage` interfaces. In addition those stores that support query-time reasoning may implement the `VDS.RDF.Storage.IReasoningQueryableStorage` interface.

There are also `VDS.RDF.Storage.IAsyncQueryableStorage` and `VDS.RDF.Storage.IAsyncUpdateableStorage` interfaces which are the async equivalents of the aforementioned interfaces.

### Query()

Stores which support SPARQL Query by implementing the `IQueryableStorage` interface provide an additional `Query()`` method.

```csharp
using System;
using VDS.RDF;
using VDS.RDF.Query;
using VDS.RDF.Storage;

public class SparqlQueryExample
{
	public static void Main(String[] args)
	{
		//First connect to a store, in this example we use a generic SPARQL connector
		SparqlConnector store = new SparqlConnector(new Uri("http://dbpedia.org/sparql"));

		//Make a SPARQL Query against the store
		Object results = store.Query("SELECT DISTINCT ?type WHERE { ?s a ?type } LIMIT 100");
		if (results is SparqlResultSet)
		{
			//Print the results
			SparqlResultSet rset = (SparqlResultSet)results;
			foreach (SparqlResult r in rset)
			{
				Console.WriteLine(r.ToString());
			}
		}
		else
		{
			throw new Exception("Did not get a SPARQL Result Set as expected");
		}
	}
}
```

Stores which implement the `IReasoningQueryableStorage` interface have an overload of the Query method which accepts a boolean parameter used to enable or disable query-time reasoning for the SPARQL query.

### Update()

Stores which support SPARQL Update by implementing the `IUpdateableStorage` interface provide an additional `Update()` method.

```csharp
using System;
using VDS.RDF;
using VDS.RDF.Storage;

public class SparqlUpdateExample
{
	public static void Main(String[] args)
	{
		//First connect to a store, in this example we use 4store
		FourStoreConnector fourstore = new FourStoreConnector("http://your-server.com:8080");

		//Apply a SPARQL Update to the Store
		fourstore.Update("LOAD <http://dbpedia.org/resource/Southampton> INTO GRAPH <http://example.org/soton>");
	}
}
```

## Async API 

The Async API essentially mirrors the synchronous API except that every method signature requires two additional parameters which are a `VDS.RDF.Storage.ASyncStorageCallback` and Object which can be used to pass some state information to the callback.

The callback signature simply returns a reference to the `IAsyncStorageProvider` that is invoking the callback, a set of `VDS.RDF.Storage.AsyncStorageCallbackArgs` and the state information passed when the method was originally invoked.

The advantage of the async API is that it means that HTTP based stores can be used on platforms where synchronous HTTP is not permitted (e.g. Windows Phone 7). Most of our `IStorageProvider` implementations also implement `IAsyncStorageProvider` as well.