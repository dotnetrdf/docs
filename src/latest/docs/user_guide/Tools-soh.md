[[Home]] > [[User Guide|UserGuide]] > [[Tools|Tools]] > [[SPARQL over HTTP (soh)|Tools-soh]]

# SPARQL over HTTP (soh) 

A command line utility for accessing SPARQL servers

## Download 

You can download this tool as part of our [Toolkit](http://www.dotnetrdf.org?content.asp?pageID=Download%20dotNetRDF%20Toolkit%20for%20Windows)

## Documentation 

soh operates in one of three modes:

| Mode | Function |
| --- | --- |
| query | Makes SPARQL Queries |
| update | Makes SPARQL Updates |
| protocol | Makes SPARQL Graph Store protocol requests |

The mode must always be specified as the first argument to the tool.

### Query Mode 

Command Usage is:

{{{
soh.exe query [options]
```

e.g. Query a endpoint with the query specified at the command line 
{{{
soh.exe query --service http://dbpedia.org/sparql "SELECT * WHERE {?s a ?type} LIMIT 10"
```
e.g. Query an endpoint with the query taken from a file
{{{
soh.exe query --service http://dbpedia.org/sparql --query query.rq
```

#### Supported Options 

| Option | Purpose |
| --- | --- |
| `--service URI` or `--server URI` | Either argument can be used to set the SPARQL endpoint to which the query is sent |
| `--query QUERY` or `--file FILE` | Either of these arguments may be used to specify that the query should be taken from a file rather than the 1st anonymous argument. `--query` has precedence if both are specified |
| `--accept mime/type` | Used to specify the Mime Type you'd like the query results in |
| `--v` or `--verbose` | Used to enable Verbose mode
| `--nobom` | Used to disable the use of BOM for UTF-8 output |
| #--version## | Displays the version and quits |
| `--h` or `--help` | Displays the help and quits |

### Update Mode 

Command Usage is:

{{{
soh.exe update [options]
```

e.g. Update an endpoint specifying the update at the command line
{{{
soh.exe update service http://example.org/update "LOAD <http://dbpedia.org/resource/Ilkeston>"
```
e.g. Update an endpoint specifying the update using a file.
{{{
soh.exe update service http://example.org/update --update update.ru
```

#### Supported Options 

| Option | Purpose |
| --- | --- |
| `--service URI` or `--server URI` | Either argument can be used to set the SPARQL endpoint to which the update is sent |
` --update UPDATE` or `--file FILE` | Either of these arguments may be used to specify that the update should be taken from a file rather than the 1st anonymous argument. `--update` has precedence if both are specified |
| `--v` or `--verbose` | Used to enable Verbose mode |
| `--nobom` | Used to disable the use of BOM for UTF-8 output |
| `--version` | Displays the version and quits |
| `--h` or `--help` | Displays the help and quits |

### Protocol Mode 

Command Usage is:

{{{
soh.exe protocol [head|get|post|put|delete] datasetURI graph [file] [options]
```

e.g. Upload a RDF file to the default graoh
{{{
soh.exe protocol put http://example.org/dataset/data default example.rdf
```

e.g. Delete a given graph
{{{
soh.exe protocol delete http://example.org/dataset/data http://example.org/someGraph
```

#### Note 

* The 2nd argument must be a supported HTTP method (case insensitive).
* The 3rd argument must be a SPARQL Uniform HTTP Protocol server endpoint URI
* The 4th argument must be either a Graph URI or default to indicate that either a Named Graph or the Default Graph should be affected
* The `file` argument is required only for the put and post methods. Using it with any other method will cause an error

#### Supported Options 

| Option | Purpose |
| --- | --- |
| `--accept mime/type` | Used to specify the MIME Type you'd like to GET graphs in |
| `--v` or `--verbose` | Used to enable Verbose mode |
| `--nobom` | Used to disable the use of BOM for UTF-8 output |
| `--nocache` | Disables the use of GET request caching so data retrieved is always fresh data
| `--version` | Displays the version and quits |
| `--h` or `--help` | Displays the help and quits |