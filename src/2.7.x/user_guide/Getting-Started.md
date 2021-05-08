# Getting Started with dotNetRDF

This page serves as a quick reference on how to add dotNetRDF to your projects and what features are found in which libraries. If you've done this already you can jump ahead to the [Library Overview](Library-Overview.md) which will introduce you to the Core APIs in dotNetRDF.

## Add dotNetRDF to your Project/Solution

Firstly you need to add dotNetRDF to your project/solution, you can do this using NuGet or manually yourself.

### Using NuGet

Using [NuGet](https://docs.microsoft.com/en-us/nuget/) is our preferred and recommended way to manage dotNetRDF since it will ensure you install the correct version and all required dependencies. Typically you add a reference to the dotNetRDF package(s) you want within your project file and the build process will retrieve and install those pacakges for you. On older platforms you may need to use the NuGet command-line tool to retrieve the packages.

## The Libraries

The standard distribution of dotNetRDF comes with a variety of different libraries. This section details what features can be found in each library.

### Core

The Core library provides all the core RDF and SPARQL infrastructure of dotNetRDF. It includes all the classes for reading and writing RDF, manipulating it in memory and a SPARQL 1.1 implementation. It also includes support for a variety of popular 3rd party triple stores as detailed in Triple Store Integration.

The Core library depends on [AngleSharp](https://github.com/AngleSharp/AngleSharp), [HtmlAgilityPack](https://html-agility-pack.net/), [Json.Net](https://github.com/JamesNK/Newtonsoft.Json) and [VDS.Common](https://github.com/dotnetrdf/vds-common).

This core library is installed using the `dotNetRDF` NuGet package.

### Data.DataTables

The Data.DataTables library provides an [`IRdfHandler`](xref:VDS.RDF.IRdfHandler) interface that turns triples (e.g. from a parsed file) into rows in a DataTable.

This library is installed using the `dotNetRDF.Data.DataTables` NuGet package.

### Data.Virtuoso

The Data.Virtuoso library provides for integration with [OpenLink Virtuoso](http://virtuoso.openlinksw.com) a popular open source/commercial triple store. It is separate from the Core library unlike some other connectors because it requires additional dependencies in the form of the Virtuoso ADO.Net provider.

This library is installed using the `dotNetRDF.Data.Virtuoso` NuGet package.

### Query.FullText

The Query.FullText library provides full text querying extensions to SPARQL based on top of [Lucene.Net](http://lucenenet.apache.org). See Full Text Querying with SPARQL for more details on this functionality.

This library is installed using the `dotNetRDF.Query.FullText` NuGet package.

----

# Tutorial Navigation

The next topic in the tutorial is the [Library Overview](Library-Overview.md)

Users interested in learning more may wish to jump straight to one of the following topics:

* [Full Text Querying with SPARQL](Full-Text-Querying-With-SPARQL.md) 
* [Triple Store Integration](Triple-Store-Integration.md)