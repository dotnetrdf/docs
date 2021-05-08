[[Home]] > [[Developer Guide|DeveloperGuide]] > [[Architecture|DeveloperGuide-Architecture]] > [[Design|DeveloperGuide-Architecture-Design]] > [[Medusa Query Engine|DeveloperGuide-Architecture-Design-Medusa]]

# Medusa Query Engine

Medusa is the code name for a next generation streaming query engine for dotNetRDF.  

The current prototype development work is ongoing on the 1.9 branch in the new dotNetRDF.Sparql.Core library.

## Motivation

Our current [[Leviathan Engine|DeveloperGuide-SPARQL-Leviathan-Engine]] is what is typically characterised as a block based engine, this means that it works by evaluating one chunk of the query in full before moving onto the next.  While this has some advantages it also some key disadvantages, namely:

* Very memory inefficient for queries with large intermediate results
* Can't return any results until all results are generated

While the current version of Leviathan does have some limited support for lazy evaluation of certain queries this is by no means fantastic and is limited to a very small subset of queries.

A streaming engine by contrast is designed to evaluate the query as lazily as possible, in the .Net context this means it will be implemented almost entirely using LINQ.  The advantages of a streaming engine are that it avoids the stated disadvantages of a block based engine.  A streaming engine has much lower memory overhead because it only needs enough memory to calculate the next answer, this also means that it can start returning results as soon as it finds it's first results.  Bear in mind that it does still have some disadvantages:

* May end up doing more work than a block based engine for some kinds of query
* May be harder to parallelize evaluation for some kinds of query

Note that since we will use LINQ to build the Medusa engine using PLINQ to parallelize things is an obvious option and one Leviathan already uses internally to great effect.  However with a streaming engine we will have to be careful of when to parallelize because some things will not be amenable to parallelization e.g. `ORDER BY`.

## Design

The Medusa query engine will be implemented as a ground up rewrite of the existing query engine.  Where appropriate it will port and re-use existing code but past experimentation has shown that the current API makes the design we want to follow unworkable.  Therefore the decision has been taken to write the new engine mostly from scratch, this will likely be quicker than trying to bend the existing API to the new design.

The design borrows heavily from the design of the streaming [Apache Jena](http://jena.apache.org) ARQ engine where appropriate.

### Results API

A new `IQueryResult` API is introduced replacing the current poor design of returning `Object` and relying on users casting it appropriately.  This API provides properties for determining what kind of result it is and properties for accessing strongly typed results.

The `SparqlResultSet` API is replaced with a new `ITabularResults` API which embodies the notion that results may be streaming i.e. not cached into memory.  Extensions of this API that allow for random access and caching into memory are also provided.

### Query API

The existing immutable `SparqlQuery` API is replaced with a new mutable `IQuery` interface and a basic Query implementation.  The intention is that a `IQuery` is entirely mutable so it can be built by a parser or programmatically from code.

The existing `GraphPattern` API is replaced with a new `IElement` API based on the `Element` API from ARQ.  This is necessary to resolve several problems that have emerged over the years in how graph patterns are represented.  One feature of this change is that `ITriplePattern` and its associated APIs are removed entirely, things are either a `IElement` or they are a `Triple` contained within an appropriate `IElement` instance.

### Algebra API

The `ISparqlAlgebra` API is replaced with a simplified `IAlgebra` API.  One of the big changes here is that the representation of the algebra is separated from the evaluation thereof.  This makes it possible to build new/alternative query engines in the future based upon the same API without needing significant API rewrites.  It also reduces some complexity with their being multiple implementations of certain core algebra concepts with different evaluation strategies.

The `ISet` API is renamed to `ISolution` to better describe it and has some additional methods added.

In the new design the evaluation strategy is managed separately by a `IAlgebraExecutor` interface which will make it much easier to extend and improve specific parts of the evaluation engine as necessary.  As already noted the Medusa engine will evaluate algebra by converting each operation into an appropriate `IEnumerable<ISolution>` thus meaning that the query is evaluated lazily i.e. until the solution sequence is enumerated minimal real work is done.

A `IAlgebraVisitor` interface is provided for accessing algebra in an easy fashion and a `IAlgebraTransform` interface is provided for transforming algebra from one form to another e.g. in evaluation.

### Join Strategies

One of the flexibilities that the new design affords us is the ability to selectively choose different join strategies rather being locked into the current choices of join strategy.  A `IJoinStrategy` API is provided which includes APIs for selecting the join strategy to use, implementations of the different join strategies and the ability to easily add new join strategies in future.

The current prototype has cross products, loop joins and two variations of hash join.  There are also simple decorators that change joins into left/minus joins as necessary.  In future we will probably also look at adding merge joins.

### Expression Evaluation

The `ISparqlExpression` interface is converted to the `IExpression` interface and some additional methods added.  Specific sub-interfaces for the different kinds of expression are explicitly provided.  The existing implementations can be ported over with a certain amount of rewriting required to adapt them to the API changes.

The main change to the interface is the `Evaluate()` method, currently its signature looks like the following:

```csharp
    IValuedNode Evaluate(SparqlEvaluationContext context, int bindingID);
```

We propose to change this to the following:

```csharp
    IValuedNode Evaluate(ISolution solution, IExpressionContext context);
```

Some form of context is still needed because some forms of expressions need to have state persisted through the life of the query (e.g. the `NOW()` function).  Also some functions need a reference back to the algebra processor (needed for `EXISTS` and `NOT EXISTS`).

Another change that will be made is late binding of extension functions.  Extension functions will be represented by a generic placeholder expression that will late bind to the actual function at evaluation time.  Thus the available custom expression factories will form part of the `IExpressionContext`

## Status

The status of the Medusa prototype is as follows:

* Results API implemented
* IQuery API implemented
* IQuery to IAlgebra compilation mostly implemented
* Algebra API mostly implemented
* Algebra evaluation mostly implemented
* Minimal IExpression API

The following features are missing:

* Most expressions are not yet ported
* No SPARQL Query parser
* No SPARQL Updates
* No Group By, Property Path, Service and Property Function evaluation

This means that basic queries can be built and evaluated programmatically but you can't yet parse and run an arbitrary SPARQL query.

Also what is implemented is still in an early stage so APIs may evolve as the implementation continues.  The testing is currently fairly limited.