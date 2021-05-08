# Reading RDF with dotNetRDF

So one of the main things you'll want to do when working with RDF is to be able to read it in from Files, URIs and other sources in order to work with it using dotNetRDF. All the classes related to this are contained within the [`VDS.RDF.Parsing`](xref:VDS.RDF.Parsing) namespace. So when you want to read RDF you'll need the following statements at the start of your code file:

```csharp
using VDS.RDF;
using VDS.RDF.Parsing;
```

dotNetRDF currently supports reading RDF files in all of the following RDF serialisations:

* NTriples
* Turtle
* Notation 3
* RDF/XML
* RDF/JSON (Talis Specification)
* RDFa 1.0 (Limited RDFa 1.1 support)
* TriG (Turtle with Named Graphs)
* TriX (Named Graphs in XML)
* NQuads (NTriples plus Context)
* JSON-LD (1.0 and 1.1)

Several of these serialisations have multiple variants of them with differing syntax rules.  Where multiple variants are supported dotNetRDF will default to accepting the most recent supported variant for input *but* will use the oldest supported variant for output.  This is [Postel's Law](http://en.wikipedia.org/wiki/Robustness_principle) in action - we are liberal in what we accept and conservative in what we send.

# Graph Parsers

Graph Parsers implement the [`IRdfReader`](xref:VDS.RDF.IRdfReader) interface which defines a `Load(…)` method which takes an [`IGraph`](xref:VDS.RDF.IGraph) or a [`IRdfHandler`](xref:VDS.RDF.IRdfHandler) and either a `TextReader`, `StreamReader` or a `String`. Basic usage is as follows:

```csharp
IGraph g = new Graph();
IGraph h = new Graph();
TurtleParser ttlparser = new TurtleParser();

//Load using a Filename
ttlparser.Load(g, "Example.ttl");

//Load using a StreamReader
ttlparser.Load(h, new StreamReader("Example.ttl"));
```

While the above is a slightly contrived example you'll note that parsers are reusable, once instantiated you can use them as many times as you need. Another useful feature is that parsers are designed to be thread safe so multiple threads can use the same instance of a parser to parse different inputs simultaneously without interfering with each other.

Parsers are typically capable of throwing [`RdfParseException`](xref:VDS.RDF.Parsing.RdfParseException) and [`RdfException`](xref:VDS.RDF.RdfException) so you should always use Try Catch blocks around Parser usage e.g.

```csharp
try 
{
	IGraph g = new Graph();
	NTriplesParser ntparser = new NTriplesParser();

	//Load using Filename
	ntparser.Load(g, "Example.nt");
} 
catch (RdfParseException parseEx) 
{
        //This indicates a parser error e.g unexpected character, premature end of input, invalid syntax etc.
	Console.WriteLine("Parser Error");
	Console.WriteLine(parseEx.Message);
} 
catch (RdfException rdfEx)
{
        //This represents a RDF error e.g. illegal triple for the given syntax, undefined namespace
	Console.WriteLine("RDF Error");
	Console.WriteLine(rdfEx.Message);
}
```

## Reading RDF from Common Sources

Often it is not necessary to invoke a parser directly since you can use a helper class to achieve the same effect without having to create the appropriate parser yourself, the following subsections detail available helper classes for reading RDF.

Note that several of the sources detailed here also have helper [Extension Methods](Extension-Methods.md) that can be used to further simplify the code examples shown here.

### Reading RDF from Files

If you just want to quickly read RDF from a file without having to decide which parser you need you can use the static [`FileLoader`](xref:VDS.RDF.Parsing.FileLoader) class which provides a [`Load(IGraph g, String file)`](xref:VDS.RDF.Parsing.FileLoader.Load(VDS.RDF.IGraph,System.String)) method:

```csharp
IGraph g = new Graph();
FileLoader.Load(g, "somefile.rdf");
```

The [`FileLoader`](xref:VDS.RDF.Parsing.FileLoader) will try to select the correct Parser based on the file extension of the file if it corresponds to a standard file extension, if this is not possible it will use the [`StringParser`](xref:VDS.RDF.Parsing.StringParser) class which attempts to detect the format using simple heuristics.

You can also force the loader to use a specific parser by using the 3 argument form [`Load(IGraph g, String file, IRdfReader parser)`](xref:VDS.RDF.Parsing.FileLoader.Load(VDS.RDF.IGraph,System.String,VDS.RDF.IRdfReader).

### Reading RDF from URIs

Often you will want to read some RDF from a URI, to do this we provide the static [`UriLoader`](xref:VDS.RDF.Parsing.UriLoader) class which provides a [`Load(IGraph g, Uri u)`](xref:VDS.RDF.Parsing.UriLoader.Load(VDS.RDF.IGraph,System.Uri)) method.

```csharp
IGraph g = new Graph();
UriLoader.Load(g, new Uri("http://dbpedia.org/resource/Barack_Obama"));
```

The `UriLoader` will automatically select the correct Parser to use based on the returned `Content-Type` header of the HTTP Response. In addition to the normal errors thrown by parsers the `UriLoader` may also throw a [`RdfException`](xref:VDS.RDF.Parsing.UriLoader) if the input URI is not valid or a `WebException` if an error occurs in retrieving the URI using HTTP.

You can also force the loader to use a specific parser by using the 3 argument form [`Load(IGraph g, Uri u, IRdfReader parser)`](xref:VDS.RDF.Parsing.UriLoader.Load(VDS.RDF.IGraph,System.Uri,VDS.RDF.IRdfReader)).

### Reading RDF from Embedded Resources

If you choose to embed RDF files in your assemblies you can read RDF from these using the static [`EmbeddedResourceLoader`](xref:VDS.RDF.Parsing.EmbeddedResourceLoader) class which provides a [`Load(IGraph g, String resource)`](xref:VDS.RDF.Parsing.EmbeddedResourceLoader.Load(VDS.RDF.IGraph,System.String)) method.

```csharp
Graph g = new Graph();
EmbeddedResourceLoader.Load(g, "Your.Namespace.EmbeddedFile.n3, YourAssembly");
```

Note that the Resource Name must be an assembly qualified name. Like the other loaders this attempts to select the correct Parser based on the resource name.

You can also force the loader to use a specific parser by using the 3 argument form [`Load(IGraph g, String resourceName, IRdfReader parser)`](xref:VDS.RDF.Parsing.EmbeddedResourceLoader.Load(VDS.RDF.IGraph,System.String,VDS.RDF.IRdfReader).

### Reading RDF from Strings

Occasionally you may have a fragment of RDF in a string which you wish to parse. To do this you can use the static [`StringParser`](xref:VDS.RDF.Parsing.StringParser) class and it's [`Parse(IGraph g, String data)`](xref:VDS.RDF.Parsing.StringParser.Parse(VDS.RDF.IGraph,System.String)) method.

```csharp
Graph g = new Graph();
StringParser.Parse(g, "<http://example.org/a> <http://example.org/b> <http://example.org/c>.");
```

The `StringParser` uses some simple heuristics to try and determine the format of the RDF fragment which is passed to it.

### Reading RDF from String (Alternate Method)

Alternatively since you can read RDF from any `TextReader` you can simply invoke a parser on a String directly using a `StringReader` e.g.

```csharp
Graph g = new Graph();
NTriplesParser parser = new NTriplesParser();
parser.Load(g, new StringReader("<http://example.org/a> <http://example.org/b> <http://example.org/c>."));
```

This is roughly equivalent to how the `StringParser` works internally except this method requires you to know the format of the RDF in advance.

### Reading RDF as a stream

Sometimes you may wish to read RDF in a stream oriented fashion, please see the Advanced Parsing section of this page for how to do that.

## Serialization Variants

Several of the supported RDF serialisations have multiple variants of them with differing syntax rules.  Where multiple variants are supported dotNetRDF will default to accepting the most recent supported variant for input *but* will use the oldest supported variant for output.  This is [Postel's Law](http://en.wikipedia.org/wiki/Robustness_principle) in action - we are liberal in what we accept and conservative in what we send.

However in some cases you may want to directly decide which syntax variant you use, in this case typically you construct a parser and provide a value from the relevant syntax enumeration e.g.

```csharp
// Create a NTriples parser that uses the older stricter syntax
NTriplesParser parser = new NTriplesParser(NTriplesSyntax.Original);
```

Consult the documentation for a specific parser to see if multiple serialisation variants are supported.

## Parser Configuration

Some Parsers have additional configuration which can be used to change their behaviour. For example if a Parser implements the [`ITraceableTokeniser`](xref:VDS.RDF.Parsing.ITraceableTokeniser) interface then the [`TraceTokeniser`](xref:VDS.RDF.Parsing.ITraceableTokeniser.TraceTokeniser) property can be used to ask for Tokeniser Trace to be output to the Console. Similarly if it implements [`ITraceableParser`](xref:VDS.RDF.Parsing.ITraceableParser) then the [`TraceParsing`](xref:VDS.RDF.Parsing.ITraceableParser.TraceParsing) property can be used to ask for Parsing Trace to be output. These features are often useful when debugging to discover why an RDF document is failing to parse since you can see how the input is being tokenised and parsed.

Additionally some Parsers allow you to instantiate them with a [`TokenQueueMode`](xref:VDS.RDF.Parsing.Tokens.TokenQueueMode). This controls the type of queue used in the tokeniser process and can potentially affect the speed of parsing (though in most cases there is minimal difference). The available modes are:

| Queue Mode | Queue Behaviour |
|------------|-----------------|
| `TokenQueueMode.QueueAllBeforeParsing` | The entire file is tokenised before parsing commences |
| `TokenQueueMode.SynchronousBufferDuringParsing` | The file is tokenised as parsing proceeds, a limited number of Tokens are generated and buffered each time the parser asks for a Token. |
| `TokenQueueMode.AsychronousBufferDuringParsing` | The file is tokenised in the background while parsing proceeds, if the parser asks for a Token and the tokeniser has yet to produce enough Tokens then the parser must wait for a Token to become available. |

# Store Parsers

Store Parsers differ from Graph Parsers in that the input they parse may contain multiple Graphs and so their output is actually a Triple Store rather than a single Graph. You will often see Store Parsers referred to as RDF Dataset parsers.

Store Parsers implement the [`IStoreReader`](xref:VDS.RDF.IStoreReader) interface which defines a similar to the `IRdReader` interface takes a [`ITripleStore`](xref:VDS.RDF.ITripleStore) or [`IRdfHandler`](xref:VDS.RDF.IRdfHandler) and either a `TextReader`, `StreamReader` or a `String`. A Store Parser can be used as follows:

```csharp
TripleStore store = new TripleStore();
TriGParser trigparser = new TriGParser();

//Load the Store
trigparser.Load(store, "Example.trig");
```

As with Graph Parsers various exceptions may be thrown.

## Reading RDF Datasets from Common Sources

Similarly to Graph Parsers the Store Parsers can all be invoked indirectly with various methods of the [`EmbeddedResourceLoader`](xref:VDS.RDF.Parsing.EmbeddedResourceLoader), [`FileLoader`](xref:VDS.RDF.Parsing.FileLoader), [`StringParser`](xref:VDS.RDF.Parsing.StringParser) and [`UriLoader`](xref:VDS.RDF.Parsing.UriLoader) classes.  See the API documentation for those classes for the relevant overloads.

# Advanced Parsing

The examples we've shown so far all use an abstracted parsing model where you parse directly to a [`IGraph`](xref:VDS.RDF.IGraph) or [`ITripleStore`](xref:VDS.RDF.ITripleStore].  The downside of this is that you have to wait for your entire parsing operation to complete before you can work with the parsed data and that for very large inputs this can either take a substantial amount of time or exhaust available memory.

Behind the scenes our parser subsystem is actually fully stream based and is exposed to you via the [`IRdfHandler`](xref:VDS.RDF.IRdfHandler) based overloads of relevant methods. This allows you much greater control over what is done with parsed data such as processing it in a stream oriented fashion.

In the examples given so far you have only been able to parse RDF into either a `IGraph` or a `ITripleStore` instance but this is not your only option.  You can use a `IRdfHandler` to control explicitly what happens with the RDF you are parsing. Using any of the included implementations will require you to add the following using statement:

```csharp
using VDS.RDF.Parsing.Handlers;
```

For example you may only want to count the Triples and not care about the actual values so you could use a [`CountHandler`](xref:VDS.RDF.Parsing.Handlers.CountHandler) to do this:

```csharp
//Create a Handler and use it for parsing
CountHandler handler = new CountHandler();
TurtleParser parser = new TurtleParser();
parser.Load(handler, "example.ttl");

//Print the resulting count
Console.WriteLine(handler.Count + " Triple(s)");
```

There are a variety of included implementations which do various things like redirecting Triples directly to a file, native Triple Store etc. You can also implement your own either entirely from scratch or just derive from [`BaseRdfHandler`](xref:VDS.RDF.Parsing.Handlers.BaseRdfHandler) like our own implementations do to get most of the implementation for free.

Take a look a the [Handlers API](Handlers-API.md) for more discussion on this topic.

# Parser Behaviour

All the Graph Parsers provided in the library behave as follows:

* File/Stream Management:
  * In the event of an error during Parsing the file/stream being Parsed will be closed
  * On successful completion of Parsing the file/stream being Parsed will be closed
* If Parsing fails the Graph will not contain any of the Triples successfully parsed prior to the failure
* If a Parser is asked to parse into a non-empty Graph then the Parser will first parse into an Empty Graph and then Merge that Graph with the provided Graph.

All the Store Parsers provided in the library behave as follows:

* File/Stream Management as Graph Parsers
* If the Parser produces a Graph which already exists in the destination Store then an error may occur depending on how that Store behaves when a Graph already exists

# Parser Classes

These are the standard parser classes contained in the Library:

| Parser Class | Supported Input |
|--------------|-----------------|
| [`JsonLdParser`](xref:VDS.RDF.Parsing.JsonLdParser) | JSON-LD |
| [`NTriplesParser`](xref:VDS.RDF.Parsing.NTriplesParser) | NTriples |
| [`Notation3Parser`](xref:VDS.RDF.Parsing.Notation3Parser) | Notation 3, Turtle, NTriples, some forms of TriG |
| [`NQuadsParser`](xref:VDS.RDF.Parsing.NQuadsParser) | NQuads, NTriples |
| [`RdfAParser`](xref:VDS.RDF.Parsing.RdfAParser) | RDFa 1.0 embedded in (X)HTML, some RDFa 1.1 support |
| [`RdfJsonParser`](xref:VDS.RDF.Parsing.RdfJsonParser) | RDF/JSON (Talis specification) |
| [`RdfXmlParser`](xref:VDS.RDF.Parsing.RdfXmlParser) | RDF/XML |
| [`TriGParser`](xref:VDS.RDF.Parsing.TriGParser) | TriG |
| [`TriXParser`](xref:VDS.RDF.Parsing.TriXParser) | TriX |
| [`TurtleParser`](xref:VDS.RDF.Parsing.TurtleParser) | Turtle, NTriples |

----

# Tutorial Navigation

The next topic is [Writing RDF](Writing-RDF.md), the previous topic was [Hello World](Hello-World.md).

Users may wish to jump to the following topics to learn more:

* [Working with Graphs](Working-With-Graphs.md)
* [Working with Triple Stores](Working-With-Triple-Stores.md)
* [Handlers API](Handlers-API.md)