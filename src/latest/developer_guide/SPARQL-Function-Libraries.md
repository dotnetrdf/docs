# Function Libraries

Function Libraries are collections of extension functions that may be used in SPARQL queries and updates.  These are supported by our in-memory [Leviathan Engine](SPARQL-Leviathan-Engine.md) and some may be supported by other triple stores as well.

If you are looking to add your own extension functions please see the [Extension Functions](SPARQL-Extension-Functions.md) documentation for details on how to do that.

| Function Library | Description |
|------------------|-------------|
| [ARQ](http://jena.apache.org/documentation/query/library-function.html) | The ARQ function library contains several useful extension functions |
| [XPath](SPARQL-XPath-Functions.md) | The XPath Function library has a wide variety of functions, many of these now have SPARQL equivalents as of SPARQL 1.1 |
| [Leviathan](SPARQL-Leviathan-Functions.md) | Our own function library with a number of useful numeric and trigonometric functions |