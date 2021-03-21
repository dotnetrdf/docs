[[Home]] > [[User Guide|UserGuide]] > [[Formatting API|Formatting-API]]

# Formatting API 

The Formatting API is an collection of APIs found in the `VDS.RDF.Writing.Formatting` namespace, it is concerned with turning objects like nodes, triples and SPARQL results into strings for display.  The formatting API underpins the writers already seen in the basic tutorial on the [[Writing RDF|Writing-RDF]] page.

The API consists of a number of interfaces:

| Interface | Formatting Capabilities |
| --- | --- |
| [ICharFormatter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_Formatting_ICharFormatter.htm) | Formats individual characters |
| [IUriFormatter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_Formatting_IUriFormatter.htm) | Formats URIs |
| [IBaseUriFormatter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_Formatting_IBaseUriFormatter.htm) | Formats Base URI declarations |
| [INamespaceFormatter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_Formatting_INamespaceFormatter.htm) | Formats namespace declarations |
| [INodeFormatter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_Formatting_INodeFormatter.htm) | Formats [INode](https://dotnetrdf.github.io/api/html/T_VDS_RDF_INode.htm) instances |
| [ITripleFormatter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_Formatting_ITripleFormatter.htm) | Formats [Triple](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Triple.htm) instances |
| [IResultFormatter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_Formatting_IResultFormatter.htm) | Formats [SparqlResult](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Query_SparqlResult.htm) instances |

# Basic Usage 

Generally you will only want to use one of the higher level interfaces such as `INodeFormatter` or `ITripleFormatter`.  Both these interfaces define `Format(…)` methods which take either a `Triple` or an `INode` and return a string representation of them. You can also call `ToString(…)` overloads on `Triple` and `INode` which take in a formatter and return the String representation as formatted by that formatter.

In general any formatter usually provides one or more `Format()` or `FormatX()` methods which are used to format specific things.  These methods take the thing to be formatted and return a string.

## Example 1 

For example we can format specific nodes:

```csharp

//Assumes that we already have a Graph in the variable g
NTriplesFormatter formatter = new NTriplesFormatter();

//Want to get only the triples defining types - assumes rdf: prefix is appropriately defined for this Graph
UriNode rdfType = g.CreateUriNode("rdf:type");

//This prints only the subjects of the Triples we find with
//the predicate rdf:type using NTriples formatting
foreach (Triple t in g.GetTriplesWithPredicate(rdfType))
{
	Console.WriteLine(t.Subject.ToString(formatter));
}
```

## Standard Implementations 

Currently the library has the following formatters available but you can easily define your own:

| Formatter | Format Produced |
| --- | --- |
| [CsvFormatter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_Formatting_CsvFormatter.htm) | CSV |
| [Notation3Formatter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_Formatting_Notation3Formatter.htm) | Notation 3 |
| [NQuadsFormatter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_Formatting_NQuadsFormatter.htm) | NQuads |
| [NTriplesFormatter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_Formatting_NTriplesFormatter.htm) | NTriples |
| [SparqlFormatter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_Formatting_SparqlFormatter.htm) | SPARQL style, can also format queries |
| [TsvFormatter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_Formatting_TsvFormatter.htm) | TSV |
| [TurtleFormatter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_Formatting_TurtleFormatter.htm) | Turtle |
| [UncompressedNotation3Formatter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_Formatting_UncompressedNotation3Formatter.htm) | Uncompressed Notation 3 |
| [UncompressedTurtleFormatter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_Formatting_UncompressedTurtleFormatter.htm) | Uncompressed Turtle |

## Example 2 

Here's another example of formatting Triples for display on the console:

```csharp

using System;
using System.Collections.Generic;
using System.Linq;
using VDS.RDF;
using VDS.RDF.Writing.Formatting;

public class FormattingTriplesExample
{
  public static void Main(String[] args)
  {
    IGraph g = new Graph();

    //Assume we fill our graph with data from somewhere...

    //Create a formatter
    ITripleFormatter formatter = new TurtleFormatter(g);

    //Print triples with this formatter
    foreach (Triple t in g.Triples)
    {
      Console.WriteLine(t.ToString(formatter));
    }
  }
}
```