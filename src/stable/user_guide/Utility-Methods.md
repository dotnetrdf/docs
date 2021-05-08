# Utility Methods

The library provides a number of useful Utility Methods embodied in a single static [VDS.RDF.Tools](xref:VDS.RDF.Tools) class which is part of the [VDS.RDF](xref:VDS.RDF) namespace. Anywhere you reference `VDS.RDF` you'll be able to use the static methods described in this article.

## CopyNode

The [CopyNode()](xref:VDS.RDF.Tools.CopyNode(VDS.RDF.INode,VDS.RDF.IGraph)) method is designed to be use to copy nodes between graphs. As explained in the [Library Overview](Library-Overview.md) when you create a triple all the nodes of that triple must come from the same graph. When you are working with multiple graphs and combining the information you may need to assert information from one graph into the other, the following example demonstrates this:

```csharp
using System;
using VDS.RDF;
using VDS.RDF.Query;

public class CopyNodeExample
{
	public static void Main(String[] args)
	{
		//First we load in the Graph we want to get information from
		Graph g = new Graph();
		UriLoader.Load(g, new Uri("http://example.org/animals"));

		//We're going to look for things that are carnivores from this Graph and make another Graph 
		//which just lists the carnivores but we're going to class them simply as animals
		//Need the Nodes for the lookup
		IUriNode rdfType = g.CreateUriNode("rdf:type");
		IUriNode carnivore = g.CreateUriNode("ex:Carnivore");

		//Get the animals which are carnivores
		HasPropertyValueSelector sel = new HasPropertyValueSelector(rdfType, carnivore);
		IEnumerable<Triple> carnivores = g.GetTriples(sel);

		//Now create our new Graph for listing them
		Graph ourlist = new Graph();
		ourlist.NamespaceMap.AddNamespace("ex",new Uri("http://example.org/"));

		//Create the Nodes for our new Graph
		IUriNode rdfType2 = ourlist.CreateUriNode("rdf:type");
		IUriNode animal = ourlist.CreateUriNode("ex:Animal");

		//Now copy the data across
		foreach (Triple t in carnivores)
		{
			//Have to copy the Subject since that's a node in the source Graph
			ourlist.Assert(new Triple(Tools.CopyNode(t.Subject, ourlist), rdfType2, animal));
		}
	}
}
```

The [CopyNode()](xref:VDS.RDF.Tools.CopyNode(VDS.RDF.INode,VDS.RDF.IGraph,System.Boolean)) method may also be invoked with a third boolean parameter which indicates whether or not the Graph URI currently associated with the Node should be preserved. This can be useful if you're combining several sources of information and working with them in-memory and want to preserve the provenance of where each Node came from.

## CopyTriple

The [CopyTriple()](xref:VDS.RDF.Tools.CopyTriple(VDS.RDF.Triple,VDS.RDF.IGraph)) method is similar to `CopyNode()` except it copies entire triples from one graph to another. Usage is functionally equivalent to the example for [CopyNode()](xref:VDS.RDF.Tools.CopyNode(VDS.RDF.INode,VDS.RDF.IGraph)) shown above.

**Note:** Both of these methods have [Extension Methods](Extension-Methods.md) defined which invoke them, in the above example the call to `Tools.CopyNode()` could be replaced with the following and still have the same meaning:

```csharp
t.Subject.CopyNode(ourlist);
```

## HttpDebugRequest

The [HttpDebugRequest(HttpWebRequest request)](xref:VDS.RDF.Tools.HttpDebugRequest(System.Net.HttpWebRequest)) method is a debugging method only available in debug builds that is used to do HTTP request debugging. It prints information about a HTTP request to the console standard out.

## HttpDebugResponse

The [HttpDebugResponse(HttpWebResponse response)](xref:VDS.RDF.Tools.HttpDebugResponse(System.Net.HttpWebResponse)) method is a debugging method only available in debug builds that is used to do HTTP response debugging. It prints information about a HTTP response to the console standard out.

## IsValidBaseUri

The [IsValidBaseUri(Uri baseUri)](xref:VDS.RDF.Tools.IsValidBaseUri(System.Uri)) method is used to determine whether a URI is valid to be used as a Base URI for resolving relative URIs against. In practise this means that the URI must be absolute and not using the mailto scheme.

Note that this method is only used when it is necessary to resolve a relative URI against a Base URI. It is perfectly acceptable to have a Base URI against which you cannot resolve relative URIs providing no relative URIs are used.

## ResolveQName

The [ResolveQName(String qname, INamespaceMapper nsmap, Uri baseUri)](xref:VDS.RDF.Tools.ResolveQName(System.String,VDS.RDF.INamespaceMapper,System.Uri)) function is used to resolve a prefixed name to a URI in the context of the given [VDS.RDF.INamespaceMapper](xref:VDS.RDF.INamespaceMapper) and Base URI. This is primarily used internally in some of the Parsers and in [IUriNode](xref:VDS.RDF.IUriNode) creation.

## ResolveUri

The [ResolveUri(String uriref, String baseUri)](xref:VDS.RDF.Tools.ResolveUri(System.String,System.String)) method is used to resolve a URI Reference (a relative/absolute URI or a fragment identifier) against a a given Base URI. It is used internally by most of the Parsers.

## ResolveUriOrQName

The [ResolveUriOrQName(IToken t, INamespaceMapper nsmap, Uri baseUri)](xref:VDS.RDF.Tools.ResolveUriOrQName(VDS.RDF.Parsing.Tokens.IToken,VDS.RDF.INamespaceMapper,System.Uri)) method is used to resolve a [UriToken](xref:VDS.RDF.Parsing.Tokens.UriToken) or a [QNameToken](xref:VDS.RDF.Parsing.Tokens.QNameToken) into a URI in the context of the given [INamespaceMapper](xref:VDS.RDF.INamespaceMapper) and Base URI. Again this method is used internally in some of the Parsers.
