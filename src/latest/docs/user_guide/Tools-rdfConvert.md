[[Home]] > [[User Guide|UserGuide]] > [[Tools|Tools]] > rdfConvert

# rdfConvert 

rdfConvert is a command line utility for converting RDF between different formats.

## Download 

You can download this tool as part of our [[Toolkit|Tools]]

## Documentation 

Command usage is as follows:

```
rdfConvert.exe input1 [input2 [input3 [...]]] (-out:filename.ext | -outformat:mime/type) [options]
```

e.g. Convert a RDF/XML file to Turtle

```
rdfConvert.exe input.rdf -out:output.ttl
```

e.g. Convert multiple files into HTML

```
rdfConvert.exe input1.rdf input2.ttl input3.n3 -format:text/html
```

e.g. Convert a RDF/XML file into N3

```
rdfConvert.exe input.rdf -ext:n3
```

You can use URIs as input just by stating URIs (anything with a :// in it will be assumed to be a URI) e.g. 

```
rdfConvert.exe http://example.org/something -out:something.rdf
```

### Notes 

rdfConvert may be used to convert between Dataset (NQuads, TriG and TriX) formats as well as Graph formats

### Supported Options 

|  Option |  Purpose
|---------|------------
| `-best` | Causes the utility to attempt the best conversion it can (i.e. most compressed syntax) taking into account other options like compression level. May cause conversions to be slower and require more memory |
| `c[:integer]` | Sets the Compression Level used by compressing writers, if specified without an integer parameter then defaults to default compression. Specify `-best` to ensure the setting is respected |
| `-debug` | Prints more detailed error messages if errors occur |
| `-ext:ext` | Overrides the default file extension which will be automatically determined based on the `-out`/`-format` option. Must occur after the `-out`/`-format` option or it may be ignored
| `-format:format` | Specifies an output format in terms of a MIME Type or a file extension, if the MIME type/file extension does not correspond to a supported RDF Graph/Dataset format then the utility aborts. |
| `-help` | Prints a usage summary if it is the only argument, otherwise ignored |
| `-hs[:boolean]` | Enables/Disables High Speed write mode, if specified without a boolean parameter then defaults to enabled |
| `-nobom` | Specifies that no BOM should be used for UTF-8 Output |
| `-nocache` | Specifies that caching of input URIs is disabled i.e. forces the RDF to be retrieved directly from the URI bypassing any locally cached copy |
| `-out:filename.ext` or `-output:filename.ext` | Specifies a specific file to output to (assuming only 1 input), if more than one input is specified then this parameter sets the base filename for outputs (extension ignored in this case) |
| `-overwrite` | Specifies that the utility can overwrite existing files |
| `-pp[:boolean]` | Enables/Disables Pretty Printing, if specified without a boolean parameter then defaults to enabled |
| `-rapper` | Runs rdfConvert in [rapper](http://librdf.org/raptor/rapper.html) compatibility mode, type `rdfConvert.exe -rapper -h` for further information. Must be the first argument or ignored |
| `-warnings` | Shows Warning Messages output by Parsers and Serializers |