[[Home]] > [[User Guide|UserGuide]] > [[Tools|Tools]] > [[rdfQuery|Tools-rdfQuery]]

# rdfQuery 

A command line utility for querying local/remote RDF using SPARQL

## Download 

You can download this tool as part of our [Toolkit](http://www.dotnetrdf.org?content.asp?pageID=Download%20dotNetRDF%20Toolkit%20for%20Windows)

## Documentation 

Command usage is as follows:

{{{
rdfQuery.exe input1 [input2 [input3 [...]]] [options] query
```

e.g. Query a single file
{{{
rdfQuery.exe data.rdf "SELECT * WHERE {?s a ?type}"
```

e.g. Query a remote file and get SPARQL JSON results
{{{
rdfQuery.exe -uri:http://example.org/something -outformat:json "SELECT * WHERE {?s a ?type}" > results.srj
```

e.g. Query a remote endpoint and get SPARQL XML results
{{{
rdfQuery.exe -endpoint:http://dbpedia.org/sparql -out:results.srx -outformat:srx "SELECT * WHERE {?s a ?type} LIMIT 50"
```

As in the above examples you can query a mixture of local files and URIs by prefixing URIs with `-uri:`

To query a remote endpoint you can use the `-endpoint:` option and specify the endpoint URI. If you use this option you cannot specify any other inputs

### Notes 

* rdfQuery uses the SPARQL XML Results & NTriples Writers as its default writers if a specific format is not specified with the `-outformat` option
* rdfQuery writes to stdout if no output file is specified with the -out or -output option
* rdfQuery reads a query from stdin if the last argument is not a query (i.e. it is anything other than some -option)

### Supported Options 

| Option | Purpose |
| --- | --- |
| `partialResults[:boolean]` | Specifies whether partial results should be returned in the event of a query timeout. Only valid for queries over local files and remote URIs |
| `-r:reaonser` | Applies a SKOS/RDFS reasoner to the input data, use `skos` or `rdfs` as the `reasoner` argument.  SKOS Concept Hierarchy/RDFS class & property hierarchies are dynamically determined based on the input data. You may need to reorder the input files and URIs in order to get correct inference results e.g. if your schema was the last input it would result in little/no inferences being made |
| `-roqet` | Runs rdfQuery in [roqet](http://librdf.org/rasqal/roqet.html) compatibility mode, type `rdfQuery.exe -roqet -h` for more information. Must be the first argument or ignored. |
| `-syntax[:syntax]` | Specifies what Query Syntax should be permitted, see Supported Syntax for more information. |
| `-timeout:i` | Specifies the Query Timeout in milliseconds |

==== Supported Syntax ===

The following query syntaxes are supported:

* ` 1` - SPARQL 1.0 Standard
* ` 1.0` - SPARQL 1.0 Standard
* ` 1.1` - SPARQL 1.1 Standard (Current Working Draft)
* `E` - SPARQL 1.1 with Extensions (LET and additional aggregates) 