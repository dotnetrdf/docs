[[Home]] > [[Developer Guide|DeveloperGuide]] > [[Architecture|DeveloperGuide-Architecture]] > [[Design|DeveloperGuide-Architecture-Design]] > [[dotNetRDF 2.0 Design|DeveloperGuide-Architecture-Design-2.0]]

# dotNetRDF 2.0 Design

Now we have reached dotNetRDF 1.0 we have been thinking a lot about the state of the API and what we would really like to change if we were able to introduce more significant refactors and breaking changes.  This thinking so far forms the basis for this design document, the idea is that we would make a number of significant and breaking changes in the 2.0 API in order to clean up, simplify and modularize the API better.

It is proposed that an initial version of this revised API be published as a transitional 1.9 release so that users can use the new API and provide feedback as it is developed.  Parallel to that we will continue to support the 1.0 release with bug fixes, it is expected that an initial 1.9 will not be ready until around the same time as 1.1.0 is released.

## API Modularization

Currently the Core API has become quite bloated and it would make sense to divide some features out into their own separate libraries, the rough proposal is as follows:

| Module | APIs |
|--------|------|
| dotNetRDF.dll | Core data model, Configuration and Formatting APIs |
| dotNetRDF.IO.dll | Parsing and Writing APIs |
| dotNetRDF.IO.Json.dll | Parsing and Writing implementations that require Json.Net |
| dotNetRDF.IO.RdfA.dll | Parsing and Writing implementations that require HtmlAgilityPack to support RDFa |
| dotNetRDF.Sparql.dll | SPARQL Query and Update engine |
| dotNetRDF.Sparql.FullText.dll | dotNetRDF.Query.FullText renamed |
| dotNetRDF.Ontology.dll | Ontology API, likely expanded |
| dotNetRDF.Storage.dll | Storage API |
| dotNetRDF.Storage.Virtuoso.dll | dotNetRDF.Data.virtuoso renamed |
| dotNetRDF.Web.dll | Web API, abstractions of current ASP.Net support |
| dotNetRDF.Web.Asp.dll | ASP.Net implementation of Web API |

## API Refactors

There are a number of API refactors we wish to make as part of a 2.0 release and these are detailed here, they range from minor clean up to fairly significant refactors.

### Data Model Refactor

The core data model has become somewhat large and in places overly complex with multiple ways of achieving the same thing, not to mention confusing and misleading interface names in many places.  There are a variety of refactors we are proposing all of which aim to simplify the API and in some cases reduce the memory footprint and complexity of their usage.

#### Nodes Refactor

I propose that we refactor the Nodes API as follows:

1. Remove the tight coupling between a Node and the Graph it originated from
2. Allow for free moving of Nodes between different Graphs
3. Identify Blank Nodes in a way that allows the above
4. Don't require any work to create Node values to be done in Nodes
5. Move all Node classes to the Nodes namespace
6. Consolidate nodes into a single interface

The first point means removing the `Graph` and `GraphUri` properties from the `INode` interface, doing so removes the coupling between a Node and its originating Graph.  This has particular benefits for things like creating wrappers around factories and graphs since it will eliminate some of the current issues we can encounter involving Graph reference mismatches.

Once this is done point 2 becomes easy because we can now freely copy Nodes around because they just represent node values provided we fix point 3.  As a result the existing `CopyNode()` methods can all be deprecated and ultimately removed.

Point 5 is primarily just a clean up activity to better organize the code going forward.

Point 6 is likely the most significant, rather than having a separate interface for each Node type all the relevant methods will be directly on `INode`.  The contract will be that trying to access something that doesn't make sense for the relevant `NodeType` will result in a `NodeValueException`.  Making this change avoids the needs for lots of casting throughout the code base and should make code substantially easier to read and write.

##### Blank Node Identification

Point 3 is somewhat trickier, currently we use user defined/auto-assigned string labels to identify blank nodes.  This has proved to be a poor implementation decision requiring tons of hacks and workarounds to have blank nodes be properly scoped and avoid collisions.  My initial though was to identify blank nodes by a combination of two Guids, one is the Node ID identifier and one the Factory identifier.  This means that Blank Nodes don't strictly meet point 1 because this means it is tied to the factory, in practice this is likely not necessary.

Thus it will depend on whether we allow users to create Blank Nodes using an explicit Guid, if we do then we might need the Factory ID to ensure correct scoping.  If we don't allow this we can likely get away with a single Guid since it is for all intents and purposes a unique identifier so will also provide inherent scoping.  However the current consensus in the community is that a blank node can span multiple graphs and be the same node, it is only the serialization of that node which is scoped to a specific graph and in the case of dataset formats scoped to the dataset.

One thing we may want to do in making this change is still allow users to create blank nodes by human readable label and simply map these consistently to Guids internally (within the scope of a factory).  However a better solution might be to push this responsibility off on parsers which removes the need for graphs and node factories to track this.  Ultimately this will reduce memory usage within the system as this mapping will then be temporary for the life of a parser, there are techniques which can make this mapping extremely memory efficient which Jena already uses and we should look at adopting those in our parsers.

#### Node Creation

Point 4 refers to the fact that internally some nodes are creating by passing a Graph reference and having them call back to the graph to get data such as new Blank Node ID or resolving the Prefixed Name.  This again was a poor design decision and so we will remove the relevant constructors and instead require the Node Factory creating the Node to provide us with the Blank Node ID or resolved URI.

### Triple refactor

In light of the Nodes refactor we will make some similar changes to the Triple API:

* Remove reference to the Graph on a Triple
* Remove the rarely used `Context` parameter on a Triple

This is intended to simplify the `Triple` class, reduce it's memory footprint and get to a data model where it purely represents a triple.  It also simplifies the constructor for `Triple` since we no longer need to validate that the Nodes originate from the same Graph.  Removing the `Context` parameter only really affects the rarely used N3 function contexts which is a feature we don't truly support anyway and so I would prefer to remove support for.

With the removal of the `Graph` property we need to introduce a proper `Quad` class to represent Quads, the `Quad` class will have essentially the same API as a Triple but with the addition of a `Graph` property which will return a `INode`

**Note:** We wish to make the `Graph` property return a `INode` to support non-URI names for graphs though this goes beyond standard RDF, however it is common across other APIs and we should aim to be as broad and extensible as possible.

Implementation wise I intend to make `Quad` a standalone class not an extension because we don't want to allow implicit casting of `Quad` to `Triple`. Users should always be aware that this is a lossy operation, an `AsTriple()` method will be provided to do this explicitly.  Conversely `Triple` will likely provide an `AsQuad(Uri graphUri)` and `AsQuad(INode graphNode)` methods.  This decision also means we can implement `Quad` as a decorator over a `Triple` allowing us to reduce memory footprint further.

### IGraph Refactor

The Nodes refactor will result in a couple of minor changes to the `IGraph` API as it currently stands:

* There will no longer need to be a two argument form of `Merge()` since Nodes don't have a reference to their Graph URI to be preserve
* `GetNextBlankNodeID()` becomes obsolete and eventually removed
* Remove all defunct `GetXNode()` methods

As a result of this and the Nodes refactor there will be some implementation benefits for `IGraph`.  For example `Merge()` becomes super simple, just `Assert()` the triples from one graph into the other since there is no need to worry about mapping Blank Node IDs, this is particularly true since we will be explicitly allowing for blank node sharing across graphs.

The more significant changes we propose for the `IGraph` API are as follows:

1. Remove the `BaseUri` property entirely, the current name is a misnomer and generally used as the graph name.  It would be better to have no name associated with an `IGraph` directly because it is purely a set of triples, graph names would be a property of a storage implementation for sets of graphs.
2. Add a `Quads` property to retrieve the Triple's in `Quad` form
3. Make `Triples` property return a `IEnumerable<Triple>` instead of `BaseTripleCollection`
4. Simplify the set of `GetTriplesWithXY()` methods into a single `Find(INode s, INode p, INode o)` method where any/all may be null to signify matching anything.
5. Add convenience `RetractWhere()` method so that internally implementations can avoid materializing deletion candidates where possible
6. Remove other defunct selection related methods
7. Add `Edges` property which returns `INode` instances used in the predicate position
8. Rename `Nodes` property to `Vertices` to more accurately reflect what is returned

The 3rd change is the most significant but also the most important, it hides internal implementation details of how triples (more than it is already) are stored and makes it much easier to implement Graphs that don't have any direct in-memory storage if desired.

### ITripleStore/ISparqlDataset Refactor

The `ITripleStore` interface is both poorly named and a messy API, it also overlaps heavily with the `ISparqlDataset` API.  I suggest consolidating the functionality of the two APIs (while removing irrelevant functionality) into a single `IGraphStore` API.  The new name more accurately reflects the purpose and would have a cleaner API, excerpts of the proposed API are given below:

```csharp
    interface IGraphStore
    {
      IEnumerable<Uri> GraphUris { get; }

      IEnumerable<IGraph> Graphs { get; }

      IGraph this[Uri u] { get; }

      bool HasGraph(Uri u);

      bool Add(IGraph g);

      bool Add(IGraph g, Uri graphUri);

      bool AddTriple(Uri graphUri, Triple t);

      bool AddQuad(Quad q);

      bool Copy(Uri srcUri, Uri destUri);

      bool Move(Uri srcUri, Uri destUri);

      bool Remove(Uri u);

      //Get all Triples in the Store
      IEnumerable<Triple> Triples { get; }

      //Find matching triples
      IEnumerable<Triple> Find(INode subj, INode pred, INode obj);

      //Get all Quads in the store
      IEnumerable<Quad> Quads { get; } 
  
      //Find all matching quads
      IEnumerable<Quad> Find(INode graph, INode subj, INode pred, INode obj)

      //Is a Triple found anywhere in the store
      bool ContainsTriple(Triple t);

      //Is the Triple contained in the given Graphs
      bool ContainsTriple(IEnumerable<Uri> graphUris, Triple t);

      //Does a Quad exist in the store
      bool ContainsQuad(Quad q);
    }
```

Note that while this interface outline is by no means complete it does not include the active and default graph management portions of the `ISparqlDataset` API.  It is proposed that the burden of tracking what constitutes those graphs is the job of the query engine.  Likely we will introduce custom algebra to cover this or manage it purely in the query processors.

There will also be no `Graphs` property exposing a `BaseGraphCollection`, that will instead become purely the standard backing implementation for our in-memory implementations of this interface.

With this interface in place we will need to introduce new implementations of this which cover our existing key implementations:

* An in-memory implementation
* A storage backed implementation

### IO APIs Refactor

The Data Model refactors outlined above will facilitate some refactoring and streamlining of the existing IO APIs particularly in the Parsing namespace.  I propose to remove the `IStoreReader` interface and generalize the `IRdfReader` interface so we a RDF parser can pass into a `IGraph`/`IGraphStore`.  This will mean adding overloads of the `Load()` method which take a `IGraphStore` instead.

Since there will be no longer a `BaseUri` property on graphs it will also be useful to provide a Base URI to readers and writers for the purposes of parsing and serialization so appropriate overloads will be required for this.

As a side effect of the above the `IRdfHandler` interface will need to be expanded to add a `HandleQuad()` method, parsers will call either `HandleTriple()` or `HandleQuad()` depending on the data they produce.  This also allows for handlers to handle triples and quads differently if they so desire.

#### Formatting API Improvements

On the writing side we will introduce a `IQuadFormatter` which provides a `Format(Quad q)` method in a similar way to the existing `ITripleFormatter` method.  Similar to the changes on the parsing side we will replace the `IStoreWriter` interface with an expanded `IRdfWriter` interface.

We may also expand the formatting APIs to allow them to be passed a `TextWriter` directly in order to eliminate some of the overheads of generating and then writing a string.  The existing overloads that return strings can be rewritten in terms of `StringWriter` to minimize code duplication.

### Query APIs Refactor

As a result of other refactors there will be some changes required in the Query API, most notably that it needs to reflect the fact that queries will now operate over a `IGraphStore` instance and must track the default/active graphs themselves.

The mechanism by which we will track the default/active graphs is yet to be determined.

#### Query Parser and AST

While the current query parser and AST give us full conformance with the SPARQL specification their code is quite ugly and hacky in some respects.  We propose to replace the parser with a new parser either hand-written or using a parser generator with good .Net support like SableCC.  As part of this rewrite we would change the AST representation to align more closely with that used by ARQ as that would allow us to eliminate some of the  ugly code we currently have.

#### Query Results

Currently methods that can take any type of query return an `Object` and the user must cast to an appropriate `IGraph` or `SparqlResultSet`, this has proved to be a less than ideal decision and so I would like to introduce a general `QueryResult` class like so:

```csharp

    class QueryResult
    {
      bool IsResultSet { get; }
 
      bool IsGraph { get; }

      bool IsBoolean { get; }

      SparqlResultSet Results { get; }

      IGraph Graph { get; }

      bool BooleanResult { get; }
    }
```

Doing this makes peoples code simpler since they don't need to cast and it also allows us to expand result returns in the future to include additional information e.g. execution time.

We also intend to abstract `SparqlResultSet` into an interface and refactor it somewhat to support true streaming of results rather than having to buffer the entire results set into memory.

#### Query Processor Refactor

Currently `LeviathanQueryProcessor` is visitor-like in it's implementation but most of the real implementation is hidden inside the algebra classes.  I would like to move all implementation into the query processor itself.  This makes the code easier to maintain since it's all in one place and much easier for people to override specific parts of the implementation.

Some more thoughts on how the query processors can be refactored to support a new streaming engine can be found in the [[Medusa Query Engine|DeveloperGuide-Architecture-Design-Medusa]] design document.

#### ISparqlExpression Refactor

Right now to evaluate an expression you need to pass in the entire query context, realistically all you actually need is the `ISet` you are applying the expression on and possibly some limited context.  Making this refactor has a couple of blockers right now:

* Some expressions like `EXISTS` have semantics somewhat at odds with most other functions
* We should implement `IEquatable<ISparqlExpression>` so that we can more easily perform expression manipulations

With equality in place it then becomes relatively easy to scan the expression tree to find aggregates and replace them with temporary variables (or their assigned variables) in the same way that ARQ does.  In the spirit of the Query Processor Refactor and to make this easier we should also consider refactoring `IExpressionTransformer` into a visitor interface as part of these changes.

If we make this refactor it also paves the way for writing a true streaming engine that does not to process the query in blocks like Leviathan does but rather operates more in the manner of ARQ.

#### Optimizer Refactor

As with other proposed refactors changing `IAlgebraOptimiser` to be a visitor would make it easier to use and extend going forward.