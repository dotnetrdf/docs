[[Home]] > [[User Guide|UserGuide]] > [[Extension Methods|Extension-Methods]]

# Extension Methods 

The library provides a number of extension methods that can be used to simplify some common tasks and marginally decrease the amount of code you have to write. These extension methods are located in several static class called [Extensions](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Extensions.htm), [LiteralExtensions](https://dotnetrdf.github.io/api/html/T_VDS_RDF_LiteralExtensions.htm), [GraphExtensions](https://dotnetrdf.github.io/api/html/T_VDS_RDF_GraphExtensions.htm) and [TripleStoreExtensions](https://dotnetrdf.github.io/api/html/T_VDS_RDF_TripleStoreExtensions.htm) in the `VDS.RDF` namespace so anywhere you reference `VDS.RDF` you have the option of using these methods.

Some of these methods are shorthand for other static methods in the API such as the `Tools.CopyNode()` and `Tools.CopyTriple()` methods which are described in more detail in the [[Utility Methods|Utility-Methods]] article.

## Assert 

The `Assert(this IGraph g, INode subj, INode pred, INode obj)` method is a shorthand way of asserting a single Triple in a Graph without having to instantiate a Triple object yourself e.g.

```csharp

//Create a Graph and set it's Base URI
IGraph g = new Graph();
g.BaseUri = new Uri("http://example.org");

//Create some Nodes
IUriNode thisGraph = g.CreateUriNode();
IUriNode rdfType = g.CreateUriNode("rdf:type");
IUriNode example = g.CreateUriNode("http://example.org/Example");

//Assert a Triple using the Graph's Assert method
g.Assert(new Triple(thisGraph, rdfType, example));

//Assert a Triple using the extension method
g.Assert(thisGraph, rdfType, example);
```

Note that these methods of asserting are semantically identical, they both assert the same Triple in the Graph.

## CopyNode 

The `CopyNode(this INode original, IGraph target)` method is used to copy Nodes from one Graph to another. See the [[Utility Methods|Utility-Methods]] article for a full description of the usage of this method.

## CopyTriple 

The `CopyTriple(this Triple t, IGraph target)` method is used to copy Triples from one Graph to another. See the [[Utility Methods|Utility-Methods]] article for a full description of the usage of this method.

## GetEnhancedHashCode 

The `GetEnhancedHashCode(this Uri u)` method is used to generate Hash Codes for Uri objects. This method is used internally in favour of the Uri classes own `GetHashCode()` method since the .Net implementationdoesn't account for fragement identifiers in computing hash codes.

In most applications this wouldn't matter since the fragment identifier is usually insignificant but in the case of the Semantic Web fragment identifiers are an important part of URIs. Therefore we provide our own hash code function which does use the fragment identifier in computing hash codes.

## LoadFromFile, LoadFromUri, LoadFromEmbeddedResource and LoadFromString 

These extension methods for `IGraph` instances all provide shortcuts for invoking the various static loader classes that can be used to load RDF from various common sources as detailed in the [[Reading RDF|Reading-RDF#reading-rdf-from-common-sources]] documentation.


## Retract 

The `Retract(this IGraph g, INode subj, INode pred, INode obj)` method the partner of the `Assert(...)` extension method and like that method is simply a shorthand way of retracting a Triple without having to explicitly instantiate it e.g.

```csharp
IGraph g = new Graph();

//Create some Nodes
IUriNode thisGraph = g.CreateUriNode();
IUriNode rdfType = g.CreateUriNode("rdf:type");
IUriNode example = g.CreateUriNode("http://example.org/Example");

//Retract a Triple using the Graph's Retract method
g.Retract(new Triple(thisGraph, rdfType, example));

//Retract a Triple using the extension method
g.Retract(thisGraph, rdfType, example);
```

Again both methods of retracting are semantically identical.

## ToLiteral 

The `ToLiteral(...)` methods are a whole family of methods which can be used to turn common .Net types into their equivalent `ILiteralNode` representations.  Methods are provided for `boolean`, `int`, `long`, `byte`, `sbyte`, `decimal`, `float`, `double`, `DateTime`, `DateTimeOffset`, `TimeSpan`.

Some overloads may allow for control over the exact literal generated, for example the `DateTime` has an overload which allows specifying whether to preserve precisely i.e. include fractional seconds

## WithSubject, WithPredicate and WithObject 

The //WithSegment(this IEnumerable<Triple>, INode Segment)// methods are used to filter any `IEnumerable<Triple>` to find only the Triples that have the matching Subject, Predicate or Object.