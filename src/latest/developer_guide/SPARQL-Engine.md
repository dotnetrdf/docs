[[Home]] > [[Developer Guide|DeveloperGuide]] > [[SPARQL Engine|DeveloperGuide-SPARQL-Engine]]

# SPARQL Engine

This page acts as a hub for topics about our SPARQL Engine, if you are interested in learning how to make queries and updates please see the [[Querying with SPARQL|UserGuide-Querying-With-SPARQL]] and [[Updating with SPARQL|UserGuide-Updating-With-SPARQL]] pages.

## Leviathan

Leviathan is the code name for our block based in-memory SPARQL evaluation engine, it has the following capabilities:

* Execution
  * Full SPARQL 1.0 and SPARQL 1.1 queries and updates are supported. Please see the [Known Issues] page for current issues with our SPARQL support.  Also see [[SPARQL Conformance|DeveloperGuide-SPARQL-Conformance]] for current conformance status.
  * Support for adding [[Extension Functions|DeveloperGuide-SPARQL-Extension-Functions]] per the [SPARQL specification](http://www.w3.org/TR/sparql11-query/#extensionFunctions)
* Optimisation
  * Powerful query optimizations described on the [[SPARQL Optimization|DeveloperGuide-SPARQL-Optimization]] page
* Extensions
  * Full Text Query, see [[Full Text Querying with SPARQL|UserGuide-Full-Text-Querying-With-SPARQL]]
  * `LET` assignments permitted with semantics equivalent to [ARQ](http://jena.apache.org/documentation/query/index.html)
  * Additional `NMAX` and `NMIN` aggregates (Numeric Maximum and Minimum)
  * Additional `MEDIAN` and `MODE` aggregates
  * Additional [[Function libraries|DeveloperGuide-SPARQL-Function-Libraries]]
    * Support for some of the [[XPath function library|DeveloperGuide-SPARQL-XPath-Functions]]
    * Support for the [ARQ function library](http://jena.apache.org/documentation/query/library-function.html)
    * Support for our own [[Leviathan function library|DeveloperGuide-SPARQL-Leviathan-Functions]]

You can learn more about this engine on the [[Leviathan Engine|DeveloperGuide-SPARQL-Leviathan-Engine]] page.

## Further Reading

* [[SPARQL Optimization|DeveloperGuide-SPARQL-Optimization]]
  * [[Implementing Custom Optimizers|DeveloperGuide-SPARQL-Implementing-Custom-Optimizers]]
* [[SPARQL Extensions|DeveloperGuide-SPARQL-Extensions]]
* [[SPARQL Performance|DeveloperGuide-SPARQL-Performance]]
* [[SPARQL Conformance|DeveloperGuide-SPARQL-Conformance]]