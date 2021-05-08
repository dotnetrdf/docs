# dotNetRDF Library Overview

dotNetRDF is a .Net library written in C# designed to provide a simple but powerful API for working with Resource Description Framework (RDF) data.  As such it provides a large variety of classes for performing all the common tasks from reading & writing RDF data to querying over it.

The Library is designed to be highly extensible and allow for users to add in support for additional features (e.g. custom RDF Triple Stores) as required.

The Library operates primarily at the level of Triples, Graphs and Triple Stores and provides very limited support for Inference and no direct support for OWL (see [How To: Load OWL](../howto/Load-OWL.md)).

# Core Concepts

The core classes of the Library can be found in the `VDS.RDF` namespace. All of the core classes are based either on interfaces or abstract classes to make the library as extensible as possible. These key interfaces are as follows:

| Interface | Purpose |
|-----------|----------|
| `INode`   | Represents a node in a RDF Graph, represents the value of a RDF term |
| `IGraph`  | Interface for Graphs, an RDF document forms a Graph in the mathematical sense - see [RDF Concepts and Abstract Syntax (W3C Specification)](http://www.w3.org/TR/rdf-concepts/) - so we represents sets of Triples as Graphs |
| `ITripleStore` | A Triple Store is a collection of one/more Graphs |

*NB* All code examples presented in this section require you to add the `using VDS.RDF;` statement to the start of your code file.

## Graphs

An RDF Document can be considered to form a mathematical graph and so we represent sets of RDF triples as graphs. All graphs in the library are implementations of the `IGraph` interface and generally derive from the abstract BaseGraph class which implements some of the core methods of the interface allowing specific implementations to concentrate on specifics such as persistence to storage/thread safety.
An IGraph implementation is an in-memory representation of an RDF document.

The most commonly used IGraph implementation is the Graph class. It can be used as follows:

```csharp
//Get a new Graph and set it's Base URI
IGraph g = new Graph();
g.BaseUri = new Uri("http://example.org/");
```

Triples can be added to a Graph using the `Assert(...)` method, the method takes a single Triple or an array/list/enumerable of Triples. Examples of using this method are given in the section of this page on Triples.

Once your Graph contains some data you can enumerate through it using a foreach loop:

```csharp
//Loop through Triples
foreach (Triple t in g.Triples)
{
    Console.WriteLine(t.ToString());
}
```

Any `IGraph` implements `IEnumerable<Triple>` and so can be used with all the LINQ extension methods for `IEnumerable<T>`.


## Nodes

An `INode` represents a node in a RDF graph, this is sometimes referred to as a RDF term.  The interface is quite sparse providing primarily information about the type of the node and the graph it is associated with.  There are then a number of specialized interfaces which extend the basic interface to provide node type specific information:

| Interface | Node Type |
|-----------|------------|
| `IBlankNode` | Blank Node, an anonymous node |
| `ILiteralNode` | Literal Node, a node with a textual value and optionally a datatype or language tag |
| `IUriNode` | URI Node |
| `IGraphLiteralNode` | Graph Literal Node, represents a sub-graph |
| `IVariableNode` | Variable Node, represents a variable |

*NB* The latter two go beyond the basic RDF model and are rarely used.

As stated each RDF term can be treated as a node in a graph. As such all RDF terms are modeled as concrete implementations of the `INode` interface and of a relevant sub-interface from the list above e.g. `IUriNode`.

Currently all nodes are scoped to a particular graph and so must be created through a `INodeFactory`, an `IGraph` is by definition an `INodeFactory`.

### URI Nodes

The core of RDF is the use of URIs to refer to resources so you will find that you use the `IUriNode` interface the majority of the time.

An URI node can be constructed in three ways as follows:

```csharp
//We need a graph first
IGraph g = new Graph();
g.BaseUri = UriFactory.Create("http://example.org/");

//Create a URI Node that refers to the Base URI of the Graph
//Only valid when the Graph has a non-null Base URI
IUriNode thisGraph = g.CreateUriNode();

//Create a URI Node that refers to some specific URI
IUriNode dotNetRDF = g.CreateUriNode(UriFactory.Create("http://www.dotnetrdf.org"));

//Create a URI Node using a Prefixed Name
//Need to define a Namespace first
g.NamespaceMap.AddNamespace("ex", UriFactory.Create("http://example.org/namespace/"));
IUriNode pname = g.CreateUriNode("ex:demo");
//Resulting URI is http://example.org/namespace/demo
```

Note that because we use the standard .Net `Uri` class to store URIs .Net will automatically normalise URIs for us ensuring that equivalent URIs are equal.

Notice that we use the `Create()` method of the `UriFactory` class to create URIs since this takes advantage of dotNetRDF's URI interning feature to reduce memory usage and speed up equality comparisons on URIs.

### Blank Nodes

Blank Nodes are used to refer to anonymous resources or to resources where it is unnecessary to assign a URI to identify some resource. Blank Nodes may either have an automatically assigned ID (truly anonymous) or may be given a user assigned ID.

A `IBlankNode` may be constructed as follows:

```csharp

//Need a Graph first
IGraph g = new Graph();

//Create an anonymous Blank Node
//Each call to this method generates a Blank Node with a new unique identifier within the Graph
IBlankNode anon = g.CreateBlankNode();

//Create a named Blank Node
//Reusing the same ID results in the same Blank Node within the Graph
//Note that if the ID refers to an automatically assigned ID that is already in use the returned
//Blank Node will be given an alternative ID
IBlankNode named = g.CreateBlankNode("ID");
```

*Note:* Be careful of the above proviso about ID collisions between automatically assigned Blank Node IDs (those created with `CreateBlankNode()`) and those created with an explicit ID. If you try and create a Blank Node with the same explicit ID as an automatically assigned ID you will get back a different Blank Node ID. If you create an anonymous Blank Node you need to hold onto the reference to it as long as you want to use that Blank Node. You can get around this by using `GetBlankNode(String id)` to return the Blank Node with the given ID provided it exists in the Graph

### Literal Nodes

Literal Nodes are used to refer to actual data values. Values may be plain, language specific or typed. A plain literal is simply textual content while a language specific literal is textual content with a language specified in the form of a country code eg. en-GB, en-US, fr. Finally a typed literal is textual content associated with a Data Type URI which indicates the type of the data represented by the literal. Note that a typed literals Data Type does not guarantee that the content of that literal will be of that type.

A `ILiteralNode` is constructed as follows:

```csharp
//Need a Graph first
IGraph g = new Graph();

//Create a Plain Literal
ILiteralNode plain = g.CreateLiteralNode("some value");

//Create some Language Specified Literal
ILiteralNode hello = g.CreateLiteralNode("hello","en");
ILiteralNode bonjour = g.CreateLiteralNode("bonjour","fr");

//Create some typed Literals
//You'll need to be using the VDS.RDF.Parsing namespace to reference the constants used here
ILiteralNode number = g.CreateLiteralNode("1", UriFactory.Create(XmlSpecsHelper.XmlSchemaDataTypeInteger));
ILiteralNode t = g.CreateLiteralNode("true", UriFactory.Create(XmlSpecsHelper.XmlSchemaDataTypeBoolean));
```

## Triples

A Triple is the basic unit of RDF data, nodes on their own have no meaning but used in a Triple form a statement which asserts some knowledge. A Triple is formed of a Subject, Predicate and Object. It is interpreted as stating that some Subject is related to some Object by a relationship specified by the Predicate. The components of the Triple class are Nodes which means that any of the Node classes discussed in the previous section can be used in any of the positions.

In practice the RDF specification restricts which types of Node can appear in which position but since some advanced RDF syntaxes like Notation 3 extend the specification and relax these rules so we allow for any Node type in any position.

A Triple can be constructed and asserted into a Graph as follows, note that the Nodes must all originate from the same Graph or an error will be thrown:

```csharp

//Need a Graph first
IGraph g = new Graph();

//Create some Nodes
IUriNode dotNetRDF = g.CreateUriNode(UriFactory.Create("http://www.dotnetrdf.org"));
IUriNode createdBy = g.CreateUriNode(UriFactory.Create("http://example.org/createdBy"));
ILiteralNode robVesse = g.CreateLiteralNode("Rob Vesse");

//Assert this Triple
Triple t = new Triple(dotNetRDF, createdBy, robVesse);
g.Assert(t);
```

If you wish to remove a Triple from a Graph you create it in the same manner shown above and call the `Retract(...)` method which like the `Assert(...)` method takes a single Triple or an enumerable of Triples.

Triples contain a reference to the Graph that they were created for (though not necessarily the Graph they are asserted in) - this reference is retrieved from the Nodes that the Triple is instantiated with. Triples also have a property named `Context` which can be used to store arbitrary application specific data in a class which implements the `ITripleContext` interface.

## Triple Store

A Triple Store represents a collection of Graphs and is used to work with larger quantities of RDF. Triple Stores are designed to be less tangible than Graphs in terms of their interface and implementations. While a specific implementation may represent some Triple Store it does not necessarily provide direct access to all the data in that Store i.e. a Triple Store is not necessarily in-memory.

Triple Stores are actually based on several interfaces, the base interface for them is `ITripleStore`. This interface defines properties and methods relating to adding & removing Graphs and the retrieval of Graphs and Triples contained in the Store.

If you have a Store that is partially/fully in-memory then it will implement the `IInMemoryQueryableStore` interface which is an extension of `ITripleStore`. The `IInMemoryQueryableStore` interface defines a swathe of additional methods which provide for various forms of selection of Triples from the Store, it also provides two query methods which allow for executing SPARQL queries on the Triple Store using the libraries in-memory SPARQL implementation. The library contains a class called `TripleStore` which is the basic implementation of this interface.

If you have a Store which is a representation of some backing Store which provides its own SPARQL implementation and where the data will not be loaded in-memory (by dotNetRDF at least) then it will implement the `INativelyQueryableStore` interface. This interface also extends `ITripleStore` but it only provides a single query method for executing SPARQL queries on the Store.

----

# Tutorial Navigation

The next topic in the tutorial is [Hello World](Hello-World.md), the previous topic was [Getting Started](Getting-Started.md).

Users wishing to learn more may want to jump straight to one of the following topics:

* [Working with Graphs](Working-With-Graphs.md)
* [Working with Triple Stores](Working-With-Triple-Stores.md)
* [Equality and Comparison](../user_guide/Equality-And-Comparison.md)