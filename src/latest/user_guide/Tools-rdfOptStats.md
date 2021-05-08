# rdfOptStats 

rdfOptStats is a command line utility for generating statistics on RDF for use with our  [WeightedOptimiser](xref:VDS.RDF.Query.Optimisation.WeightedOptimiser) for SPARQL queries.

## Download 

You can download this tool as part of our [Toolkit](Tools.md)

## Documentation 

Command usage is as follows:

```dos
rdfOptStats.exe [options] input1 [input2 [input3 ...]]
```

e.g. Generate all stats to a file `stats.ttl` for the input files `data1.rdf` and `data2.rdf`

```dos
rdfOptStats.exe -all -output stats.ttl data1.rdf data2.rdf
```

e.g. Generate all stats for all files within a given directory

```dos
rdfOptStats.exe -all -output stats.nt data\*
```

### Notes 

Only simple wildcard patterns are supported as inputs e.g.

* data\*
* some\path\*.rdf
* *.*
* *.ttl

Any other wildcard pattern will be rejected

### Supported Options 

| Option | Purpose |
| --- | --- |
| `-all` | Specifies that counts of Subjects, Predicates and Objects should be generated |
| `-literals` | Specifies that counts should include Literals (default is URIs only) - this requires an output format that supports Literal Subjects e.g. N3 |
| `-nodes` | Specifies that aggregated for Nodes should be generated i.e. counts that don't specify which position the URI/Literal occurs in |
| `-p` | Specifies that counts for Predicates should be generated |
| `-o` | Specifies that counts for Objects should be generated |
| `-output file` | Specifies the file to output the statistics to |
| `-s` | Specifies that counts for Subjects should be generated |