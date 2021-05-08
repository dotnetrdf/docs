[[Home]] > [[Developer Guide|DeveloperGuide]] > [[SPARQL Engine|DeveloperGuide-SPARQL-Engine]] > [[Function Libraries|DeveloperGuide-SPARQL-Function-Libraries]]

# Function Libraries

Function Libraries are collections of extension functions that may be used in SPARQL queries and updates.  These are supported by our in-memory [[Leviathan Engine|DeveloperGuide-SPARQL-Leviathan-Engine]] and some may be supported by other triple stores as well.

If you are looking to add your own extension functions please see the [[Extension Functions|DeveloperGuide-SPARQL-Extension-Functions]] documentation for details on how to do that.

| Function Library | Description |
|------------------|-------------|
| [ARQ](http://jena.apache.org/documentation/query/library-function.html) | The ARQ function library contains several useful extension functions |
| [[XPath|DeveloperGuide-SPARQL-XPath-Functions]] | The XPath Function library has a wide variety of functions, many of these now have SPARQL equivalents as of SPARQL 1.1 |
| [[Leviathan|DeveloperGuide-SPARQL-Leviathan-Functions]] | Our own function library with a number of useful numeric and trigonometric functions |