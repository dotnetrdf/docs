[[Home]] > [[User Guide|UserGuide]] > [[RDF Serialisations|RDF-Serialisations]]

= RDF Serialisations

This page serves as a reference of the RDF serialisations supported by dotNetRDF, this includes links to the specifications implemented.  How to choose between different variants of the specifications were supported and brief descriptions of the differences.  Since many of these variants are more recent standards we also note from which version onwards we support them or in some cases that they are not yet supported.

Several of these serialisations have multiple variants of them with differing syntax rules.  Where multiple variants are supported dotNetRDF will default to accepting the most recent supported variant for input **but** will use the oldest supported variant for output.  This is [Postel's Law](http://en.wikipedia.org/wiki/Robustness_principle) in action - we are liberal in what we accept and conservative in what we send.

| Serialisation | Known Variants | Supported? |
| --- | --- | --- |
| NTriples | [RDF 1.0 Test Cases](http://www.w3.org/TR/2004/REC-rdf-testcases-20040210/#ntriples) and [RDF 1.1 NTriples](http://www.w3.org/TR/n-triples/) | Yes and 1.0.4 onwards |
| NQuads | [DERI NQuads](http://sw.deri.org/2008/07/n-quads/) and [RDF 1.1 NQuads](http://www.w3.org/TR/n-quads/) | Yes and 1.0.4 onwards |
| Turtle | [Dave Beckett specification](http://www.w3.org/TeamSubmission/turtle/) and [RDF 1.1 Turtle](http://www.w3.org/TR/turtle/) | Yes and 1.0.0 onwards |

== NTriples

NTriples is a simple line based format for encoding RDF triples, each line may either be blank, a comment or contain a triple.  The NTriples syntax uses no syntactic compressions of any sort so is useful as a canonical serialisation format.

There are two variants of NTriples supported.

=== Original

The original NTriples syntax was defined as part of the RDF 1.0 Working Group defined in the [RDF 1.0 Test Cases](http://www.w3.org/TR/2004/REC-rdf-testcases-20040210/#ntriples) published in 2004.  It is a purely ASCII encoded serialisation so any character outside the ASCII range has to be represented using a `\u` or `\U` escape.

Prior to **1.0.4** this was the only NTriples syntax supported.

When using the `NTriplesParser` or `NTriplesWriter` the `NTriplesSyntax.Original` enumeration value is used to indicate that this syntax should be used.

=== RDF 1.1

The RDF 1.1 specifications included a new format specification for NTriples which is [RDF 1.1 NTriples](http://www.w3.org/TR/n-triples/) published in 2014.  The major difference between this and the previous syntax is that the RDF 1.1 variant uses UTF-8 encoding rather than ASCII.  This means that characters which previously had to be escaped can now be represented directly though they still be escaped if desired.

This syntax has been supported from **1.0.4** onwards

When using the `NTriplesParser` or `NTriplesWriter` the `NTriplesSyntax.Rdf11` enumeration value is used to indicate that this syntax should be used.

== NQuads

NQuads is a simple line based format for encoding RDF quads which is closely related to NTriples.  There are two variants of NQuads supported:

=== Original

NQuads was originally specified by researchers at DERI as [NQuads: Extending NTriples with Context](http://sw.deri.org/2008/07/n-quads/) in 2008 and defines a simple extension to the original NTriples format that adds a fourth field to allow quads to be conveyed instead of triples.  It is a purely ASCII encoded serialisation so any character outside the ASCII range has to be represented using a `\u` or `\U` escape.

When using the `NQuadsParser` or `NQuadsWriter` the `NQuadsSyntax.Original` enumeration value is used to indicate that this syntax should be used.

=== RDF 1.1

The RDF 1.1 specifications included a new specification for NQuads which is [RDF 1.1 NQuads](http://www.w3.org/TR/n-quads/) published in 2014.  The major difference between this and the previous syntax is that the RDF 1.1 variant uses UTF-8 encoding rather than ASCII.  This means that characters which previously had to be escaped can now be represented directly though they still be escaped if desired.

This syntax has been supported from **1.0.4** onwards

When using the `NQuadsParser` or `NQuadsWriter` the `NQuadsSyntax.Rdf11` enumeration value is used to indicate that this syntax should be used.

== Turtle

Turtle (the name originally derived from Terse RDF Triples Language) is a simple text based language for encoding RDF.  It has some basic similarities to NTriples (and in fact any valid NTriples document is a valid Turtle document) however it supports a wide variety of syntactic compressions which make encoding RDF triples far more compact.

There are two variants of Turtle supported:

=== Original

The original [Terse RDF Triples Language](http://www.w3.org/TeamSubmission/turtle/) was specified by Dave Beckett in 2007 and later submitted to the W3C as a Team Submission in 2008.  The two versions of the specification are identical in technical content so are treated as a single syntax variant.

When using the `TurtleParser` and any of the Turtle writers the `TurtleSyntax.Original` enumeration value is used to indicate that this syntax should be used.

=== RDF 1.1

The RDF 1.1 specifications included a new specification for Turtle which is [RDF 1.1 Turtle](http://www.w3.org/TR/turtle/) published in 2014.  The main differences between this and the previous syntax is that the RDF 1.1 variant provides more permissive prefixed names (one of the major syntax compressions used) and provides better alignment with the SPARQL syntax.

This syntax has been supported from **1.0.0** onwards.

When using the `TurtleParser` and any of the Turtle writers the `TurtleSyntax.W3C` enumeration value is used to indicate that this syntax should be used.