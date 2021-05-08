[[Home]] > [[User Guide|UserGuide]] > [[Working with Triple Stores|Working-With-Triple-Stores]]

# Working with Triple Stores 

Triples Stores in dotNetRDF are used to represent collections of graphs and to allow you to work with larger quantities of RDF easily. As stated in the [[Library Overview|Library-Overview]] our triple stores are designed to be less tangible than graphs since a triple store does not necessarily have to be in-memory and may simply represent an interface to or a partial view on some actual underlying store.

**Note:** This document primarily discusses Triple Stores in terms of their representation in-memory within the library. For details of working with external Triple Stores please see [[Triple Store Integration|UserGuide/Triple Store Integration]]

# Basic Properties 

Triple Stores are based on the [ITripleStore](https://dotnetrdf.github.io/api/html/T_VDS_RDF_ITripleStore.htm) interface which defines the basic properties of a triple store as follows:

## Graphs 

Gets the collection of graphs in the triple store which is a [BaseGraphCollection](https://dotnetrdf.github.io/api/html/T_VDS_RDF_BaseGraphCollection.htm) - this collection allows you to enumerate through and count the number of graphs in the triple store.

Note that this only returns graphs loaded in-memory for the triple store and does not necessarily represent the entire triple store.

## IsEmpty 

Gets whether a Triple Store is empty (contains no Graphs)

## Triples 

Gets the collection of triples from all the graphs currently in the triple store in-memory. This means it does not necessarily represent the entire triple store.

## Indexer Access 

Indexer access may be used to get a graph from the triple store with the given URI e.g.

```csharp

//Assuming we have a store already
IGraph g = store[new Uri("http://example.org/graph")];
```

# Basic Methods 

The `ITripleStore` interface defines the following methods for Triple Stores:

## HasGraph 

Checks whether a Graph with the given URI exists in the Triple Store e.g.

```csharp

if (store.HasGraph(new Uri("http://example.org/")) 
{
	Console.WriteLine("Graph exists");
}
else
{
	Console.WriteLine("Graph doesn't exist");
}
```

== Add and AddFromUri ===

Used to add graphs into the triple store, graphs can either by added by use of classes that implement `IGraph` or by specifying the URI of a graph. If you use the latter method then the triple store will attempt to retrieve the RDF located at that URI and then insert the resulting graph into the triple store. 

Using the IGraph versions of the methods allows you to insert any type of graph you want into the triple store.

```csharp

using System;
using VDS.RDF;
using VDS.RDF.Parsing;

public class TripleStoreLoadExample
{
	public static void Main(String[] args)
	{
		//First create a Triple Store
		TripleStore store = new TripleStore();

		//Next load a Graph from a File and add it to the Store
		Graph g = new Graph();
		TurtleParser ttlparser = new TurtleParser();
		ttlparser.Load(g, "Example.ttl");
		store.Add(g);

		//Next load a Graph from a URI into the Store
		store.AddFromUri(new Uri("http://dbpedia.org/resource/Barack_Obama"));

		//Load another Graph in from the same file
		//This will cause an error since the Graph will have the same Base URI
		//and you can't insert duplicate Graphs in a Triple Store
		Graph h = new Graph();
		ttlparser.Load(h, "Example.ttl");
		try {
			store.Add(h);
		} catch {
			//We get an error
		}

		//You can avoid this by using the second optional boolean parameter to specify behaviour 
		//when a Graph already exists
		//We try loading the same Graph again but we tell it to merge if it exists in the Store
		store.Add(h, true);

		//Try and load an empty Graph that has no Base URI
		//This Graph is then treated as being the default unnamed Graph of the store
		Graph i = new Graph();
		store.Add(i);
	}
}
```

As you'll see from the above example there are a couple of important things to remember when using an `ITripleStore`. Firstly that if you insert a graph that doesn't have a Base URI then it is treated as the default unnamed graph of the store. Secondly that you will encounter an error if you try and insert a graph that already exists unless you set the second parameter to true to indicate that the existing graph should be merged with the graph being loaded in.

## Remove 

The `Remove(Uri graphUri)` method is used to remove a graph that is in the triple store. Removing a graph that doesn't exist has no effect and does not cause an error.

# In-Memory Triple Stores 

As you have seen the basic triple store interface simply allows you to enumerate over a triple store and to add and remove graphs from it. While this is useful in itself you'll often want to make queries over the entire store and for this you'll need to use one of the classes that implement [IInMemoryQueryableStore](https://dotnetrdf.github.io/api/html/T_VDS_RDF_IInMemoryQueryableStore.htm).
One of the main things the `IInMemoryQueryableStore` does is to define equivalents of all the various `GetTriples()` methods from the `IGraph` interface for triple stores. It has two versions of each method, one which operates over all the triples in the triple Store and one which operates over a subset of the triples where the subset is defined by a list of Graph URIs.

Perhaps the more important feature of the interface is that it defines an `ExecuteQuery()` method which can be used to execute SPARQL queries in-memory over the Triple Store. There are two variants of this method, one which takes the raw SPARQL query as a String and one which takes a [SparqlQuery](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Query_SparqlQuery.htm) object e.g.

```csharp

using System;
using VDS.RDF;
using VDS.RDF.Parsing;
using VDS.RDF.Query;

public class InMemoryTripleStoreExample
{
	public static void Main(String[] args)
	{
		TripleStore store = new TripleStore();

		//Assume that we fill our Store with data from somewhere

		//Execute a raw SPARQL Query
		//Should get a SparqlResultSet back from a SELECT query
		Object results = store.ExecuteQuery("SELECT * WHERE { { GRAPH ?g { ?s ?p ?o } } UNION { ?s ?p ?o } }");
		if (results is SparqlResultSet)
		{
			//Print out the Results
			SparqlResultSet rset = (SparqlResultSet)results;
			foreach (SparqlResult result in rset)
			{
				Console.WriteLine(result.ToString());
			}
		}

		//Use the SparqlQueryParser to give us a SparqlQuery object
		//Should get an IGraph back from a CONSTRUCT query
		SparqlQueryParser sparqlparser = new SparqlQueryParser();
		SparqlQuery query = sparqlparser.ParseFromString("CONSTRUCT { ?s ?p ?o } WHERE { { GRAPH ?g { ?s ?p ?o } } UNION { ?s ?p ?o } }");
		results = store.ExecuteQuery(query);
		if (results is IGraph)
		{
			//Print out the Results
			IGraph g = I(Graph)results;
			foreach (Triple t in g.Triples)
			{
				Console.WriteLine(t.ToString());
			}
			//Print the time taken to make the query
			Console.WriteLine("Query took " + query.QueryExecutionTime.ToString());
		}
	}
}
```

One of the advantages of using the [SparqlQueryParser](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Parsing_SparqlQueryParser.htm) is that is implements the [ITraceableTokeniser](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Parsing_ITraceableTokeniser.htm) interface which means you can easily debug queries which won't parse. The other is that by getting an actual `SparqlQuery` object you can manipulate certain properties of the query to control how it gets executed. For example the `Timeout` property is used to set a timeout in milliseconds after which query execution is aborted. Combined with the `PartialResultsOnTimeout` boolean property you can control what happens when queries take too long to run. Another useful property is the `QueryExecutionTime` property shown in the above example which allows you to see how long the actual execution of a query took.

# Natively Queryable Stores 

The [INativelyQueryableStore](https://dotnetrdf.github.io/api/html/T_VDS_RDF_INativelyQueryableStore.htm) interface is another extension to the `ITripleStore` interface which is disjoint from the `IInMemoryQueryableStore` interface i.e. a Store cannot be both In-Memory and Natively Queryable. Natively Queryable Stores represents Stores which provide their own SPARQL implementations and so can be queried directly.

An `INativelyQueryableStore` defines only one additional method which is `ExecuteQuery(String query)` which takes a SPARQL query as a String and executes it against the underlying SPARQL implementation. Note that these stores may only be queryable read-only wrappers around an underlying store.

We provide a [PersistentTripleStore](https://dotnetrdf.github.io/api/html/T_VDS_RDF_PersistentTripleStore.htm) class which is an implementation of the `INativelyQueryableStore` that can be used with any of the backing stores we support with [IQueryableStorage](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_IQueryableStorage.htm) implementations. This class provides an in-memory view of an underlying store where changes to the in-memory view can be persisted to the underlying store (or discarded) as you desire.

```csharp

using System;
using VDS.RDF;
using VDS.RDF.Storage;

public class PersistentTripleStoreExample
{
	public static void Main(String[] args)
	{
		//Create a connection to 4store in this example
		FourStoreConnector 4store = new FourStoreConnector("http://example.com:8080/");
		PersistentTripleStore store = new PersistentTripleStore(4store);

		//See whether a Graph exists in the store
		//If the Graph exists in the underlying store this will cause it to be loaded into memory
		if (store.HasGraph(new Uri("http://example.org/someGraph")))
		{
			//Get the graph out of the in-memory view (note that if it changes in the underlying store in the meantime you will not see those changes)
			Graph g = store.Graph(new Uri("http://example.org/someGraph"));

			//Do something with the Graph...
		}

		//If you were to add a Graph to the store this would be added to the in-memory state only initially
		Graph toAdd = new Graph();
		toAdd.LoadFromUri(new Uri("http://example.org/newGraph"));
		store.Add(toAdd);

		//To ensure that the new graph is saved call Flush()
		store.Flush();

		//You can also use this class to make queries/updates against the underlying store
		//Note - If you've made changes to the in-memory state of the store making a query/update will throw an error unless you've
		//          persisted those changes
		//          Use Flush() or Discard() to ensure the state of the store is consistent for querying

		//Make a Query against the Store
		//Should get a SparqlResultSet back from a SELECT query
		Object results = store.ExecuteQuery("SELECT * WHERE {?s ?p ?o}");
		if (results is SparqlResultSet)
		{
			//Print out the Results
			SparqlResultSet rset = (SparqlResultSet)results;
			foreach (SparqlResult result in rset)
			{
				Console.WriteLine(result.ToString());
			}
		}
	}
}
```

# Loading and Saving Triple Stores 

Often you want the information you place into an in-memory Triple Store to be persisted over time and be able to load/save that triple store as required. Currently we provide the means to save/load a Triple Store in the following ways:

* As a file in a RDF dataset format - TriG, TriX or NQuads
* As explained in [[Working with Graphs|Working-With-Graphs|]] you can also load/save individual Graphs from arbitrary stores for which there is an `IStorageProvider` defined.

## RDF Dataset Storage 

RDF Dataset formats are single file formats which allow storing an RDF dataset represents as a set of named graphs in a single file. We currently support TriG, TriX and NQuads with classes for saving and loading from each format.

For example in TriG (Turtle with Named Graphs) you would can save and load a Triple Store using the [TriGParser](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Parsing_TriGParser.htm) and [TriGWriter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_TriGWriter.htm) classes as follows:

```csharp

using System;
using VDS.RDF;
using VDS.RDF.Parsing;
using VDS.RDF.Storage.Params;
using VDS.RDF.Writing;

public class TriGExample
{
	public static void Main(String[] args)
	{
		//Read a Store from the TriG file
		TripleStore store = new TripleStore();
		TriGParser trigparser = new TriGParser();
		trigparser.Load(store, "input.trig");

		//Now we want to save to another TriG file
		TriGWriter trigwriter = new TriGWriter();
		trigwriter.Save(store, "output.trig");
	}
}
```

# Standard ITripleStore Implementations 

The Library contains the following standard `ITripleStore` implementations:

| Implementation | Description |
| --- | --- |
| [DiskDemandTripleStore](https://dotnetrdf.github.io/api/html/T_VDS_RDF_DiskDemandTripleStore.htm) | Represents an in-memory store where Graphs are loaded on-demand from the local file system if they are not already in memory and provided the Graph Names are file URIs |
| [PersistentTripleStore](https://dotnetrdf.github.io/api/html/T_VDS_RDF_PersistentTripleStore.htm) | Represents an in-memory view of some store provided by a IStorageProvider instance. |
| [TripleStore](https://dotnetrdf.github.io/api/html/T_VDS_RDF_TripleStore.htm) | In-memory Triple Store representation. |
| [WebDemandTripleStore](https://dotnetrdf.github.io/api/html/T_VDS_RDF_WebDemandTripleStore.htm) | Represents an in-memory Store where Graphs are loaded on-demand from the Web if they are not already in-memory |

# Standard RDF Dataset Parsers & Writers 

The Library contains the following standard `IStoreReader` and `IStoreWriter` implementations for RDF dataset formats:

| Implementation | Description |
| --- | --- |
| [NQuadsParser](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Parsing_NQuadsParser.htm) | Parses NQuads |
| [NQuadsWriter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_NQuadsWriter.htm) | Writes NQuads |
| [TriGParser](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Parsing_TriGParser.htm) | Parses TriG |
| [TriGWriter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_TriGWriter.htm) | Writes TriG |
| [TriXParser](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Parsing_TriXParser.htm) | Parses TriX |
| [TriXWriter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_TrixWriter.htm) | Writes TriX |

In addition we also provide a [GraphMLWriter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_GraphMLWriter.htm) class. This writer does not output RDF, but instead [GraphML](http://graphml.graphdrawing.org/) and XML representation of the graphs structure of the store. This file can be loaded into suitable tools for graph visualization.

----

# Tutorial Navigation 

The previous topic was [[Typed Values and Lists|Typed-Values-And-Lists]], the next topic is [[Building SPARQL|Building-SPARQL]]

Users wishing to learn more may wish to jump straight to one of the following pages:

* [[Triple Store Integration|UserGuide/Triple Store Integration]]