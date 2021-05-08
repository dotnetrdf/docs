# SPARQL Engine

This page acts as a hub for topics about our SPARQL Engine, if you are interested in learning how to make queries and updates please see the [Querying with SPARQL](../user_guide/Querying-With-SPARQL.md) and [Updating with SPARQL](../user_guide/Updating-With-SPARQL.md) pages.

## Leviathan

Leviathan is the code name for our block based in-memory SPARQL evaluation engine, it has the following capabilities:

* Execution
  * Full SPARQL 1.0 and SPARQL 1.1 queries and updates are supported. Please see the [Known Issues] page for current issues with our SPARQL support.  Also see [SPARQL Conformance](SPARQL-Conformance.md) for current conformance status.
  * Support for adding [Extension Functions](SPARQL-Extension-Functions.md) per the [SPARQL specification](http://www.w3.org/TR/sparql11-query/#extensionFunctions)
* Optimisation
  * Powerful query optimizations described on the [SPARQL Optimization](SPARQL-Optimization.md) page
* Extensions
  * Full Text Query, see [Full Text Querying with SPARQL](../user_guide/Full-Text-Querying-With-SPARQL.md)
  * `LET` assignments permitted with semantics equivalent to [ARQ](http://jena.apache.org/documentation/query/index.html)
  * Additional `NMAX` and `NMIN` aggregates (Numeric Maximum and Minimum)
  * Additional `MEDIAN` and `MODE` aggregates
  * Additional [Function libraries](SPARQL-Function-Libraries.md)
    * Support for some of the [XPath function library](SPARQL-XPath-Functions.md)
    * Support for the [ARQ function library](http://jena.apache.org/documentation/query/library-function.html)
    * Support for our own [Leviathan function library](SPARQL-Leviathan-Functions.md)

You can learn more about this engine on the [Leviathan Engine](SPARQL-Leviathan-Engine.md) page.

## Further Reading

* [SPARQL Optimization](SPARQL-Optimization.md)
  * [Implementing Custom Optimizers](SPARQL-Implementing-Custom-Optimizers.md)
* [SPARQL Extensions](SPARQL-Extensions.md)
* [SPARQL Performance](SPARQL-Performance.md)
* [SPARQL Conformance](SPARQL-Conformance.md)