[[Home]] > [[User Guide|UserGuide]] > [[Tools|Tools]] > [[SparqlGui|Tools-SparqlGui]]

# SparqlGui 

The SparqlGUI is a Windows GUI tool for testing out SPARQL queries on arbitrary datasets which you create by loading in RDF from files and/or remote URIs. Additionally you may set an option so that the query can load graphs on demand from the web where they are specified in `FROM`, `FROM NAMED` or `GRAPH` clauses in the query.

It will also run under Mono though user experience for Windows Forms based GUIs is less than optimal with Mono.

## Download 

You can download this tool as part of our [Toolkit](http://www.dotnetrdf.org?content.asp?pageID=Download%20dotNetRDF%20Toolkit%20for%20Windows)

## Documentation 

As a GUI tool SparqlGui is fairly self-explanatory, here we primarily cover the various options you can configure to tune the behaviour of the tool.

### Syntax Options 

The `Syntax Options` panel lets you set which SPARQL syntax should be used for parsing your queries, this allows you to test whether a query is valid for a given SPARQL specification. If you try and use syntax in your query that is not supported by your chosen syntax then a parsing error will occur and a message will be displayed when you attempt to make your query.

SPARQL 1.0 and 1.1 represent the standards, SPARQL 1.1 Extended is the SPARQL 1.1 standard plus some custom extensions - namely LET assignment, additional aggregates and some keyword synonyms.

### SPARQL Results Format 

Selects the format that you want the results of SELECT/ASK queries presenting to you in. This only applies when the `View Results and Graphs in Application` option is disabled.

### Graph Format 

Selects the format that you want the results of CONSTRUCT/DESCRIBE queries presenting to you in.  This only applies when the `View Results and Graphs in Application` option is disabled.

### Query Options 

Query Options lets you set options for how queries are executed and parsed.

|= Option |= Default |= Description |
| Timeout | 10,000 ms | Sets the timeout for query execution |
| Partial Results on Timeout | Disabled |Controls whether any results should be returned in the event of a timeout. |
| Allowing Graphs to be loaded 'on demand' from the web | Disabled | Controls the behaviour when queries that specify graph URIs in `FROM`, `FROM NAMED` or `GRAPH` clauses if the Graphs aren't already present in the dataset.  When enabled the tool will attempt to retrieve them from the web. |
| Permit Unknown Function URIs | Enabled | When enabled if a function is invoked by URI and dotNetRDF does not know about that function it treats it as a function that returns an error for any input. If this option is not set when an unknown function is encountered a parser error will occur. |
| Optimise Queries | Enabled | Controls whether query pattern optimization is used. |
| Optimise Query Algebra | Enabled | Controls whether algebra optimisation are used. |
| Enable Parallel Query Evaluation | Enabled | Controls whether parallel query evaluation is used to boost performance. |
| Default Graph is union of all graphs | Disabled | Controls whether queries that parts of a query that don't specify a graph to query will query all graphs rather than only the unnamed default graph |
| View Results and Graphs in Applications | Enabled | When enabled results are shown in the in application viewer, when disabled the results/graph are written to a file and a separate process launched to open that file.  This will cause the file to open in the default viewer application configured for that file type on your system. |
| Log Query Explanations | Disabled | When enabled query execution will likely be slower but explanations will be logged to the log file allowing you to understand why a query does/doesn't return results. |
| Enable Full Text Indexing | Disabled | When enabled you can use our full text search extensions as detailed on the [[Full Text Querying with SPARQL|Full-Text-Querying-With-SPARQL]] page. |
| Allow Unsafe Optimisations | Disabled | Controls whether certain optimizations that are considered potentially unsafe i.e. may change the semantics and thus the results of the queries may be used.  You can experiment with this if you want but it affects very few queries and often gives worse performance than normal optimizations. |
| Use BOM for UTF-8 Output | Disabled | Controls whether data exported to files in UTF-8 formats includes a UTF-8 BOM. Disable this option if the data you export will be used with Linux/Unix/Java tools as these sometimes have trouble with the UTF-8 BOM as they don't expect it (whereas Windows does). |

**Note:** We recommend never changing the Optimise Queries/Optimiser Query Algebra settings unless a query is giving unexpected/slow results and you suspect it may be the result of bad optimisation. If you do encounter a query which does this please let us know (see [[Contact Us]]) so that we can try and fix this for future releases.

Other Features

If you try and make a query without loading any data first you will receive a warning about this, you can either abort the query, retry to run the query anyway or ignore to run the query and suppress the warning for that session.

You can save and load queries to text files using the Load Query and Save Query buttons.

## Screenshots 

The main interface looks like the following:

{{http://www.dotnetrdf.org/images/screenshots/sparqlgui_main1.jpg|SparqlGui - Interface}}

Using the top of the form you can import RDF from local files and remote URIs as required. Once some RDF is loaded the status bar will show the number of Graphs and Triples in the dataset as seen in this screenshot:

{{http://www.dotnetrdf.org/images/screenshots/sparqlgui_main2.jpg|SparqlGui - Interface with Data Loaded}}

### Query Results 

Query results are displayed by default inside a new window in the program like so:

{{http://www.dotnetrdf.org/images/screenshots/sparqlgui_results.jpg|SparqlGui - Results View}}

From this window you can choose to export the SPARQL Results/RDF Graph if you wish to.

You can disable this to use the alternative behaviour of opening the results directly in the relevant program for the produced output type by unchecking the `View Results and Graphs in the Application` in the Options panel

### Query Inspector 

The utility includes a Query Inspector function which allows you to see how dotNetRDF interprets your query i.e. explicit nesting and triple pattern reordering and the resulting SPARQL Algebra for your query as seen in the following screenshot:

{{http://www.dotnetrdf.org/images/screenshots/sparqlgui_inspector.jpg|SparqlGui - Query Inspector}}