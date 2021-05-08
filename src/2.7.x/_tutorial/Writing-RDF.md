[[Home]] > [[User Guide|UserGuide]] > Writing RDF

# Writing RDF with dotNetRDF

Once you've created a RDF Graph or retrieved it from some file/URI you will often need to write it to another file/stream in an RDF format of your choice. All the classes related to this are contained in the `VDS.RDF.Writing` namespace. So when you want to write RDF you'll need the following statements at the start of your code file:

```csharp
using VDS.RDF;
using VDS.RDF.Writing;
```

Currently dotNetRDF supports writing Graphs in the following formats:

* NTriples
* Turtle
* Notation 3
* RDF/XML
* RDF/JSON (Talis Specification)
* XHTML + RDFa
* Non-standardised formats
  * CSV
  * TSV

In addition the following formats are supported when writing a Triple Store containing multiple graphs:

* NQuads
* TriX
* TriG
* JSON-LD

Several of these serialisations have multiple variants of them with differing syntax rules.  Where multiple variants are supported dotNetRDF will default to accepting the most recent supported variant for input *but* will use the oldest supported variant for output.  This is [Postel's Law](http://en.wikipedia.org/wiki/Robustness_principle) in action - we are liberal in what we accept and conservative in what we send.

To learn about how to save Graphs to forms of Storage other than files on disk see [[Working with Graphs|Working-With-Graphs]] and for information on saving Triple Stores see [[Working with Triple Stores|Working-With-Triple-Stores]]

## Basic Usage

The Writer classes in dotNetRDF all implement the `IRdfWriter` interface which defines a single method `Save(…)` which takes an `IGraph` and then either a `TextWriter` or a `String`. Basic usage is as follows:

```csharp
//Assume that the Graph to be saved has already been loaded into a variable g
RdfXmlWriter rdfxmlwriter = new RdfXmlWriter();

//Save to a File
rdfxmlwriter.Save(g, "Example.rdf");

//Save to a Stream
rdfxmlwriter.Save(g, Console.StandardOut);
```

As with Parsers a Writer is a reusable class which can be used as many times as you wish to output Graphs to Files/Streams.

### Writing to Strings

There are two ways to write RDF to strings. The first way is to use the helper class `StringWriter` to generate a String from some graph e.g.

```csharp
//Assume that the Graph to be saved has already been loaded into a variable g
RdfXmlWriter rdfxmlwriter = new RdfXmlWriter();

String data = VDS.RDF.Writing.StringWriter.Write(g, rdfxmlwriter);
```

The second way is to write to a `System.IO.StringWriter` directly since all `IRdfWriter` instances can write to any `TextWriter` implementation e.g.

```csharp
//Assume that the Graph to be saved has already been loaded into a variable g
RdfXmlWriter rdfxmlwriter = new RdfXmlWriter();
System.IO.StringWriter sw = new System.IO.StringWriter();

//Call the Save() method to write to the StringWriter
rdfxmlwriter.Save(g, sw);

//We can now retrieve the written RDF by using the ToString() method of the StringWriter
String data = sw.ToString();
```

This second method is essentially what the library does internally when you use our `StringWriter` helper class as in the previous example

*Note:* In the above examples we used the full name of the classes since if you import System.IO in your code the class names will be ambiguous references if you don't do so.

## Serialization Variants

Several of the supported RDF serialisations have multiple variants of them with differing syntax rules.  Where multiple variants are supported dotNetRDF will default to accepting the most recent supported variant for input *but* will use the oldest supported variant for output.  This is [Postel's Law](http://en.wikipedia.org/wiki/Robustness_principle) in action - we are liberal in what we accept and conservative in what we send.

However in some cases you may want to directly decide which syntax variant you use, in this case typically you construct a writer and provide a value from the relevant syntax enumeration e.g.

```csharp
// Create a NTriples writer that uses the older stricter syntax
NTriplesWriter writer = new NTriplesWriter(NTriplesSyntax.Original);
```

Consult the documentation for a specific parser to see if multiple serialisation variants are supported.

## Advanced Usage

There are a variety of additional interfaces for Writers which are used to indicate the capabilities of writers. To start with the most common is `IPrettyPrintingWriter` which defines a property `PrettyPrintMode`. Setting this property to true causes the output RDF to be written using pretty printing (mostly by use of tabs and blank lines) to make it more human readable.

Less common is the `IHighSpeedWriter` interface which defines a property `HighSpeedModePermitted`. High Speed Mode is a mode supported by some writers which do a simplistic analysis on the Graph to gauge whether it will benefit from use of syntax compressions or not. If the writer decides that the Graph is ill-suited to the use of syntax compressions it will write in high speed more - essentially it will just write the Triples one at a time. The `HighSpeedModePermitted` property controls whether a writer is allowed to use this mode, if set to false then syntax compressions are always used even if the Graph is not considered suitable for their use.

Finally there is the `ICompressingWriter` interface which defines a property `CompressionLevel`. This property takes an integer value which defines the level of compression that should be used when writing the output. Generally values from the static `WriterCompressionLevel` class are used to set the compression level. Interpretation of compression level is up to the individual writer but generally setting a higher level will result in use of more syntax compressions than a lower level. Different compression levels do not necessarily lead to different output as some compressions can only apply if certain types of Triples appear in the Graph and some levels are treated identically.

For example you might write a utility function like the following which configures options on the writer if they are supported:

```csharp
public static void SaveGraph(IGraph g, IRdfWriter writer, String filename)
{
	//Set Pretty Print Mode on if supported
	if (writer is IPrettyPrintingWriter) {
		((IPrettyPrintingWriter)writer).PrettyPrintMode = true;
	}

	//Set High Speed Mode forbidden if supported
	if (writer is IHighSpeedWriter) {
		((IHighSpeedWriter)writer).HighSpeedModePermitted = false;
	}

	//Set Compression Level to High if supported
	if (writer is ICompressingWriter) {
		((ICompressingWriter)writer).CompressionLevel = WriterCompressionLevel.High;
	}

	//Save the Graph
	writer.Save(g, filename);
}
```

# Formatters

Formatters are an alternative to using an `IRdfWriter` to output RDF. Their advantage is that they can be used to format individual Nodes and Triples to just display what you want how you want, but their disadvantage is that they can't use the same array of compression techniques that a full `IRdfWriter` can use when writing a whole graph because they are stateless by design.  See the [[Formatting API|Formatting-API]] page for more information.

# Writer Behaviour

All the Writer classes in the Library exhibit the following behaviour:

* File/Stream Management:
  * If an error occurs then the file/stream being written to will be closed
  * On successful completion of writing the file/stream being written to will be closed
* If there is an issue with the Graph being saved that does not prevent it from being saved then the writer will raise a Warning event
* If the Graph being written contains Triples/Nodes which cannot be written by the writer then a `RdfOutputException` will be thrown

# Writer Classes

These are the standard Writer classes contained in the library:

| Class | Output Produced |
|-------|-----------------|
| `CompressingTurtleWriter` | Writes Turtle syntax potentially using all the available syntax compressions |
| `CsvWriter` | Writes Triples out as a CSV file |
| `HtmlWriter` | Writes Triples out as a HTML page with the Triples presented in a table |
| `NTriplesWriter` | Writes NTriples |
| `Notation3Writer` | Writes Notation 3 using all available syntax compressions |
| `PrettyRdfXmlWriter` | Streaming Writer for RDF/XML which uses syntax compressions which lead to pretty RDF/XML output |
| `RdfJsonWriter` | Writes RDF/JSON |
| `RdfXmlWriter` | Fast Streaming Writer for RDF/XML which uses a limited number of syntax compressions |
| `TsvWriter` | Writes Triples out as a TSV file |
| `TurtleWriter` | Writes Turtle using a limited number of syntax compressions |

In addition, there is a helper class, `SingleGraphWriter` which implements the `IRdfWriter` interface and allows a graph to be written using a writer that implements the `IStoreWriter` interface. This allows a graph to be written using the serialization formats described at [[Working with Triple Stores|Working-With-Triple-Stores]].

We also provide a `GraphVizWriter` which does not output RDF. Instead it generates a GraphViz DOT format file suitable for visualizing the content of a single RDF graph.

----

# Tutorial Navigation

The next topic is [[Working with Graphs|Working-With-Graphs]], the previous topic was [[Reading RDF|Reading-RDF]].

Users wishing to learn more may wish to jump straight to one of the following topics:

* [[Working with Triple Stores|Working-With-Triple-Stores]]