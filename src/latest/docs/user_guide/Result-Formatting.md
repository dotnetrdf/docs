[[Home]] > [[User Guide|UserGuide]] > [[Advanced SPARQL|Advanced-SPARQL]] > [[Result Formatting|Result-Formatting|]]

# Result Formatting 

When you make a SPARQL query as detailed on the [[Querying with SPARQL|Querying-With-SPARQL]] you typically get back a [SparqlResultSet](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Query_SparqlResultSet.htm) object.  While you can trivially dump results to strings using the `ToString()` method this doesn't give you a particularly pretty output, this page details various methods by which you can format results for display.

## Using Formatters 

dotNetRDF supports a powerful [[Formatting API|Formatting-API]] which is discussed in general elsewhere, this can be leveraged for the purposes of formatting results.  Since values in each column of a [SparqlResult](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Query_SparqlResult.htm) are just normal [INode](https://dotnetrdf.github.io/api/html/T_VDS_RDF_INode.htm) values you can use any of the existing [INodeFormatter](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Writing_Formatting_INodeFormatter.htm) implementations for this.

For example:

```csharp

//Assume we already have our query results in the variable results

//Create a formatter
INodeFormatter formatter = new TurtleFormatter();

foreach (SparqlResult result in results)
{
   Console.WriteLine(result.ToString(formatter));
}
```

The above will print out results using Turtle formatting for the terms, exact formatting will vary depending on the formatter used and arguments passed to the constructor.

## Extracting Values as Strings 

Sometimes you may prefer to extract the actual values from the nodes as strings e.g.

```csharp

//Assume we have our results in the variable results

foreach (SparqlResult result in results)
{
  INode n;
  String data;
  if (result.TryGetValue("var", out n))
  {
    switch (n.NodeType)
    {
      case NodeType.Uri:
        data = ((IUriNode)n).Uri.AbsoluteUri;
        break;
      case NodeType.Blank:
        data = ((IBlankNode)n).Label;
        break;
      case NodeType.Literal:
        //You may want to inspect the DataType and Language properties and generate
        //a different string here
        data = ((ILiteralNode)n).Value;
        break;
      default:
        throw new RdfOutputException("Unexpected Node Type");
    }
  }
  else
  {
    data = String.Empty;
  }

  //Do what you want with the extracted string
}
```