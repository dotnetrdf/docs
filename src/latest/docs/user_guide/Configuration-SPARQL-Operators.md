[[Home]] > [[User Guide|UserGuide]] > [[Configuration API|Configuration-API]] > [[SPARQL Operators|Configuration-SPARQL-Operators]]

# Configuring SPARQL Operators 

SPARQL Operators are a SPARQL extension that allows you to extend how certain operators in SPARQL are evaluated.  You can learn more about operators in the [[SPARQL Operators|DeveloperGuide-SPARQL-Operators]] page of the [[Developer Guide|DeveloperGuide]].

These may be configured quite simply provided they implement the [ISparqlOperator](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Query_Operators_ISparqlOperator.htm) interface and have an unparameterized constructor.

```turtle

@prefix dnr: <http://www.dotnetrdf.org/configuration#> .

[] a dnr:SparqlOperator ;
  dnr:type "VDS.RDF.Query.Operators.DateTime.DateTimeAddition" .
```