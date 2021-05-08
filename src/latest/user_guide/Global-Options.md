# Global Options 

dotNetRDF has a set of global static options provided by the [`Options`](xref:VDS.RDF.Options) class.  These are used to configure various aspects of dotNetRDF behaviour, some act as defaults for certain functionality while others toggle functionality/features on/off as desired.

Here are the available options:

## Core Options 

### FullTripleIndexing 

Controls whether implementations of [`BaseTripleCollection`](xref:VDS.RDF.BaseTripleCollection) that support indexing will create full triple indexes, defaults to `true`.  See [Minimizing Memory Usage](../howto/Minimize-Memory-Usage.md) for more discussions on triple indexing.

### InternUris 

Controls the [URI Interning](../developer_guide/URI-Interning.md) feature of the library which is used to speed up URI equality checks and reduce memory usage.  However depending on your usage of the library it may actually inflate memory usage, see the linked page for more discussion of this option.

## Literal Options 

### LiteralEqualityMode 

Controls the behaviour when you call `Equals()` on instances of [`ILiteralNode`](xref:VDS.RDF.ILiteralNode).  This takes a value from the [`LiteralEqualityMode`](xref:VDS.RDF.LiteralEqualityMode) enumeration, the default is `Strict`.  In `Strict` mode literal equality follows RDF term equality semantics i.e. the lexical values must be exactly equal and so must the language tag/datatype URI if present.

If you set this to `Loose` instead then value equality semantics are used i.e. if the literals represent the same value then they are considered equal.

Please see [Equality and Comparison](Equality-And-Comparison.md) for more information.

### LiteralValueNormalization 

Controls whether literal values have Unicode normalization applied to them when they are created, this defaults to `false`.  May be useful to enable if you are ingesting non-normalized data though may increase data load times.

### DefaultCulture 

Controls the culture used for comparing the lexical values of literals when lexical sorting is used.  The default is to use the invariant culture to preserve behavioural compatibility with past releases.  It may be useful to customize this setting if you want to more naturally sort string data.

### ComparisonOptions 

Controls how the lexical values of literals are compared when lexical sorting is used.  The default is to use Ordinal comparison which preserves behavioural compatibility with past releases.  It may be useful to customize this setting if you want to more naturally sort string data.

## HTTP Options 

### ForceHttpBasicAuth 

Controls whether to always send HTTP Basic Authentication headers in HTTP requests when appropriate, defaults to `false`.

Normally dotNetRDF relies on the standard .Net HTTP support which uses the standard HTTP challenge response pattern for establishing authenticated connections.  However some badly behaved servers may not carry out the challenge response correctly in which case it may be necessary to enable this option.  This only works for servers that use HTTP Basic Authentication, other authentication types cannot be forced.

### HttpDebugging 

Controls whether to print debug information about HTTP requests and responses to the console, defaults to `false`.  See [Debugging HTTP Communication](../howto/Debug-HTTP-Communication.md) for more information.

### HttpFullDebugging 

Controls whether the full response stream for HTTP responses is printed to the console for debugging, defaults to `false`.  See [Debugging HTTP Communication](../howto/Debug-HTTP-Communication.md) for more information.

## Parsing Options 

### ForceBlockingIO 

Controls whether parsers will rely on fully blocking buffered IO to read in data, defaults to `false`.

Normally the library chooses whether to use this based on the type of data being read and avoids fully blocking buffered IO when possible.  However they may be occasions where the chosen option is incorrect if you use an unusual data source or the data source is wrapped.  Therefore sometimes it may be necessary to enforce blocking IO by setting this option.

### UriLoaderCaching 

Controls whether dotNetRDF will maintain a cache of RDF retrieved from files for future use, defaults to `true`.  This cache can speed up subsequent loads from the web but may not be desirable if the retrieved data is being auto-generated or frequently update.  Thus in some cases you may wish to disable this functionality.

### UriLoaderTimeout 

Sets the timeout for retrieving RDF data from the web in milliseconds, defaults to ` 15,000` i.e. 15 seconds.  This timeout reflects the time to establish a connection to the HTTP server, it is not a timeout on how long parsing the retrieved data takes.

It may be useful to increase this if you have a slow internet connection or are accessing RDF from a slow service.

## Query Options 

### QueryExecutionTimeout 

Global timeout setting for in-memory query execution given in milliseconds, defaults to ` 180,000` i.e. 3 minutes.  This setting has no-effect for other forms of query execution.

This can be overridden as a per-query level by the [`Timeout`](xref:VDS.RDF.Query.SparqlQuery.Timeout) property of a [`SparqlQuery`](xref:VDS.RDF.Query.SparqlQuery) instance.

### QueryOptimisation 

Controls whether query pattern optimization is applied, defaults to `true`.  May be useful to disable if the default optimizer is optimizing your query poorly.

### AlgebraOptimisation 

Controls whether query algebra optimization is applied, defaults to `true`.  May be useful to disable if the standard optimizers are optimizing your query poorly or if you want to execute the basic algebra only.

### UnsafeOptimisation 

Controls whether certain optimizations which `may` make queries run faster but change the semantics of the query can be applied, defaults to `false`.

### QueryDefaultSyntax 

Sets the default syntax used for parsing SPARQL queries, takes a value from the [`SparqlQuerySyntax`](xref:VDS.RDF.Parsing.SparqlQuerySyntax) enumeration.  Defaults to `Sparql_1_1` i.e. SPARQL 1.1

### QueryAllowUnknownFunctions 

Controls whether unknown SPARQL extension functions should be allowed, defaults to `true`.  When enabled unknown extension functions are simply treated as functions that return unbound for every input.  When disabled an unknown extension function will give a parser error.

### RigorousEvaluation 

Controls whether the in-memory SPARQL engine rigorously checks the provided matches from the underlying [`ISparqlDataset`](xref:VDS.RDF.Query.Datasets.ISparqlDataset), defaults to `false` as this is usually unnecessary.

You may need to enable this if your [`ISparqlDataset`](xref:VDS.RDF.Query.Datasets.ISparqlDataset) implementation cannot guarantee that a call to `GetTriplesWithX()` only returns triples matching the given arguments.

### StrictOperations 

Controls whether SPARQL operators are restricted to only the implementations required by the SPARQL specifications, defaults to `false`.

When disabled certain additional operators will be permitted such as date time computations.  See [SPARQL Operators](../developer_guide/SPARQL-Operators.md) for discussion of this feature.

### UsePLinqEvaluation 

Controls whether the in-memory SPARQL engine uses PLINQ evaluation to improve SPARQL performance, defaults to `true`.  This is only available on platforms that support PLINQ i.e. .Net 4.0 non-Silverlight builds.

May be useful to disable if you have a multi-core machine but only want to use a single core for query evaluation.

## Update Options 

### UpdateExecutionTimeout 

Sets the timeout used for in-memory update execution in milliseconds, defaults to `180,000` i.e. 3 minutes.  This setting has no-effect for other forms of update execution.

This can be overridden as a per-update level by the `Timeout` property of a [SparqlUpdateCommandSet](xref:VDS.RDF.Update.SparqlUpdateCommandSet) instance.

## Writing Options 

### AllowMultiThreadedWriting 

Controls whether writers that support multi-threading writing will use this to improve write performance, defaults to `false`.  This is disabled by default because while it can improve performance it may cause error information to propagate incorrectly resulting in a failed write with no user indication of this.

### DefaultCompressionLevel 

Sets the default compression level that writers will use if they support varying compression levels.

### UseBomForUtf8 

Controls whether the optional UTF-8 BOM is included in UTF-8 output, defaults to `false`.

Generally speaking it is best to leave this setting untouched since creating files with UTF-8 BOM may render those files unusable by non .Net tools since most UTF-8 aware tools don't expect to see the optional BOM.

### UseDtd 

Controls whether writers that may use DTDs in their output will actually use a DTD, defaults to `false`.

Many places have restrictions on the use of DTDs in documents because these can be used to do DoS attacks.  Enable this option only if using dotNetRDF as part of a system where all components are trusted to exchange data containing DTDs.