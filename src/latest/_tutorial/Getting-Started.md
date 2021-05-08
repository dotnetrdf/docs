# Getting Started with dotNetRDF

This page serves as a quick reference on how to add dotNetRDF to your projects and what features are found in which libraries. If you've done this already you can jump ahead to the [Library Overview](Library-Overview.md) which will introduce you to the Core APIs in dotNetRDF.

## Add dotNetRDF to your Project/Solution

Firstly you need to add dotNetRDF to your project/solution, you can do this using NuGet or manually yourself.

### Using NuGet

Using NuGet is our preferred and recommended way to manage dotNetRDF since it will ensure you install the correct version and all required dependencies.

To do this you will need to have the NuGet Package Manager extension to Visual Studio installed. Then you can right click on your project and select Manage NuGet Packages, search the online gallery for dotNetRDF and install the libraries you want.

### Adding manually to your Project/Solution

If you prefer to install dotNetRDF manually you can do so by following these instructions, if you haven't done so already go ahead and download the dotNetRDF Libraries from [our CodePlex project page](https://dotnetrdf.codeplex.com/).  This will give you a zip file which when unzipped contains the following directory structure:

* `Core` Contains the builds of the Core Library
* `Data` Contains the builds of the Data Libraries
  * `Virtuoso` Contains the Data.Virtuoso Library
* `Query` Contains the builds of the Query Libraries
  * `FullText` Contains the Query.FullText Library

The first thing you'll notice is that under each of these directories are a bunch of sub-directories. These represent builds of the library targeting specific .Net framework versions and profiles. For reference the directory names correspond as follows:

| Folder | Target .Net Framework Version |
|--------|-------------------------------|
| `net35` | .Net 3.5 Full |
| `net35-client` | .Net 3.5 Client Profile |
| `net40` | .Net 4.0 Full |
| `net40-client` | .Net 4.0 Client Profile |
| `sl4` | Silverlight 4.0 |
| `sl4-wp` | Silverlight 4.0 for Windows Phone 7 |

One of the most important things you need to do when adding dotNetRDF as a reference to your project is ensure you select the correct version that matches the target framework version and profile your project uses. If you don't do this you will run into all sorts of compiler errors!

If you aren't sure what version you need right click on your project and select Properties, then on the Build tab look at the value stated in the Target Framework drop down.  Use this and the above list to determine which version you need to install.

To add dotNetRDF to your project right click on your project and click Add Reference, then browse to the directory containing the appropriate version of the library you want and select all the files in that directory. This will add both the dotNetRDF and its dependencies to your project ensuring that all features will work correctly. While you can add just dotNetRDF on its own if you then attempt to use certain features which rely on the dependent libraries you'll run into problems.

## The Libraries

So as you've already seen above the standard distribution of dotNetRDF comes with a variety of different libraries. This section details what features can be found in each library.

### Core

The Core library provides all the core RDF and SPARQL infrastructure of dotNetRDF. It includes all the classes for reading and writing RDF, manipulating it in memory and a SPARQL 1.1 implementation. It also includes support for a variety of popular 3rd party triple stores as detailed in Triple Store Integration.

The Core library depends on [HtmlAgilityPack](http://htmlagilitypack.codeplex.com), [Json.Net](http://json.codeplex.com) and [VDS.Common](http://bitbucket.org/rvesse/vds-common).

### Data.Virtuoso

The Data.Virtuoso library provides for integration with [OpenLink Virtuoso](http://virtuoso.openlinksw.com) a popular open source/commercial triple store. It is separate from the Core library unlike some other connectors because it requires additional dependencies in the form of the Virtuoso ADO.Net provider

### Query.FullText

The Query.FullText library provides full text querying extensions to SPARQL based on top of [Lucene.Net](http://lucenenet.apache.org). See Full Text Querying with SPARQL for more details on this functionality.

----

# Tutorial Navigation

The next topic in the tutorial is the [Library Overview](Library-Overview.md)

Users interested in learning more may wish to jump straight to one of the following topics:

* [Full Text Querying with SPARQL](../user_guide/Full-Text-Querying-With-SPARQL.md) 
* [Triple Store Integration](../user_guide/Triple-Store-Integration.md)