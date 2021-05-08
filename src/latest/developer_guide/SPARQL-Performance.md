[[Home]] > [[Developer Guide|DeveloperGuide]] > [[SPARQL Engine|DeveloperGuide-SPARQL-Engine]] > [[SPARQL Performance|DeveloperGuide-SPARQL-Performance]]

# SPARQL Performance

This page provides information on the performance of our SPARQL engine.

## Performance Limitations 

### Memory Usage

Our in-memory [[Leviathan engine|DeveloperGuide-SPARQL-Leviathan-Engine]] is designed to scale to a few million triples in-memory.  However scalability will vary heavily with your data and queries e.g. data with lots of large literals will require more memory and queries that generate large intermediate results will also require lots of memory.

Memory usage may be affected by how you load your data, see [[How To: Minimize Memory Usage|HowTo-Minimize-Memory-Usage]] for some discussion of configuring indexes to reduce memory usage.

We recommend that if you have more than a million triples you switch to using one of the many supported third party triple stores, see [[Storage Providers|UserGuide-Storage-Providers]] for the available implementations.

### Multi-Core Systems

When running a .Net 4.0 build on a multi-core system dotNetRDF leverages the .Net PLINQ feature to parallelize some aspects of query evaluation that may significantly improve performance over running in single core mode.  However not all queries can be safely parallelized so you may see varying results.

## Benchmark Results

### BSBM Performance

The [Berlin SPARQL Benchmark](http://wifo5-03.informatik.uni-mannheim.de/bizer/berlinsparqlbenchmark/) is a standard benchmark for SPARQL engines, here are some of our results on this.

The first graph compares total runtime (Y Axis) against dataset size (X axis) so smaller values are better since they indicate faster performance.  As you can see old releases scaled exponentially, the current codebase scales linearly.

The second graph compares Query Mixed per Hour aka QMpH (Y Axis) against dataset size (X axis) so larger values are better since they indicate better higher throughput.  As you can see older releases tended to achieve reduced throughput as the dataset size increased, the current codebase gets much better throughput and scales linearly.

![BSBM Results](https://github.com/dotnetrdf/dotnetrdf/wiki/BSBMPerformance.png)

You can find the latest figures in the spreadsheet [[here|DeveloperGuide-SPARQL-Performance/dotNetRDF BSBM v3 Benchmark.xlsx]]