# dotNetRDF User Guide

Welcome to the dotNetRDF user guide, this provides an introduction to dotNetRDF and aims to cover how to carry out a variety of common tasks in dotNetRDF.  Using this guide you can learn the basics of working with the library in order to enable you the user to build applications using dotNetRDF.

You may also be interested in our [FAQs](../faq/index.md) or our quick [How To](../howto/index.md) guides.

If you are already an experienced dotNetRDF user you may wish to look at the [Developer Guide](../developer_guide/index.md) instead which covers project architecture and advanced topics.

## Basic Tutorial

This series of pages aims to introduce you to the core concepts of dotNetRDF and get you up and running with the library, reading in order is suggested for new users:

1. [Getting Started](../tutorial/Getting-Started.md)
1. [Library Overview](../tutorial/Library-Overview.md)
1. [Hello World](../tutorial/Hello-World.md)
1. [Reading RDF](../tutorial/Reading-RDF.md)
1. [Writing RDF](../tutorial/Writing-RDF.md)
1. [Working with Graphs](../tutorial/Working-With-Graphs.md)
1. [Typed Values and Lists](../tutorial/Typed-Values-And-Lists.md)
1. [Working with Triple Stores](../tutorial/Working-With-Triple-Stores.md)
1. [Querying with SPARQL](../tutorial/Querying-With-SPARQL.md)
1. [Updating with SPARQL](../tutorial/Updating-With-SPARQL.md)

## General Topics

The following pages cover some general topics about the library:

* [Exceptions](Exceptions.md)
* [Equality and Comparison](Equality-And-Comparison.md)
* [Event Model](Event-Model.md)
* [Utility Methods](Utility-Methods.md)
* [Extension Methods](Extension-Methods.md)
* [Using the Namespace Mapper](Using-The-Namespace-Mapper.md)

## 3rd Party Triple Store Integration

We provide integration with a variety of 3rd party triple stores, see the following topics:

* [Storage API](Storage-API.md)
  * [Triple Store Integration](Triple-Store-Integration|.md)
  * [Storage Providers](Storage-Providers.md)
  * [Servers API](Storage-Servers.md)
  * [Transactions API](Storage-Transactions.md)

## SPARQL Features

The basic tutorial covers simple SPARQL query and updates, we have a selection of topics on advanced SPARQL features available:

* [Advanced SPARQL](Advanced-SPARQL.md)
  * [Result Formatting](Result-Formatting.md)
  * [SPARQL Datasets](SPARQL-Datasets.md)
  * [Full Text Querying with SPARQL](Full-Text-Querying-With-SPARQL.md)
  * [Advanced SPARQL Operations](Advanced-SPARQL-Operations.md)

The [SPARQL Engine](../developer_guide/SPARQL-Engine.md) section of the [Developer Guide](../developer_guide/index.md) may also be relevant to advanced users.

## Ontologies, Inference and Reasoning

Please see the following for documentation of ontology, inference and reasoning support:

* [Ontology API](Ontology-API.md)
* [Inference and Reasoning](Inference-And-Reasoning.md)

## ASP.Net Integration

Please see the [ASP.Net Integration](ASPNET-Integration.md) page for an overview of how we integrate into ASP.Net applications, or you can jump to specific topics below:

* [Creating SPARQL Endpoints](ASP-Creating-SPARQL-Endpoints.md)
* [Deploying with rdfWebDeploy](ASP-Deploying-With-rdfWebDeploy.md)

## Advanced APIs

The following documentation covers what are considered advanced topics but which may still be of value to everyday users of dotNetRDF.

* [Global Options](Global-Options.md)
* [Formatting API](Formatting-API.md)
* [Configuration API](Configuration-API.md)
* [Handlers API](Handlers-API.md)
* [JSON-LD API](JsonLd-API.md)

## Tools

See the [Tools](Tools.md) page for documentation pertaining to our GUI and command line tools.

* [rdfConvert](Tools-rdfConvert.md) 
* [rdfEditor](Tools-rdfEditor.md) 
* [rdfOptStats](Tools-rdfOptStats.md) 
* [rdfQuery](Tools-rdfQuery.md)
* [rdfServer](Tools-rdfServer.md) 
  * [rdfServerGui](Tools-rdfServerGui.md)
* [rdfWebDeploy](Tools-rdfWebDeploy.md) 
* [soh](Tools-soh.md)
* [SparqlGui](Tools-SparqlGui.md)
* [Store Manager](Tools-Store-Manager.md)

## Notes

Note that where we refer to the user in this guide we are referring to you the developer who is using the API.

All examples in the User Guide are given using C#.Net