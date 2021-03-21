[[Home]] > [[User Guide|UserGuide]] > [[Configuration API|Configuration-API]]

# Configuration API 

The Configuration API is a powerful feature of dotNetRDF which provides an RDF based means of encoding configuration information such that objects representing commonly used objects such as Graphs, connections to Triple Stores etc. can be dynamically loaded. This functionality is provided by the [ConfigurationLoader](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Configuration_ConfigurationLoader.htm) class which is in the `VDS.RDF.Configuration` namespace.

Dynamic loading is done by classes which implement the [IObjectFactory](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Configuration_IObjectFactory.htm) interface which means that this mechanism can be extended as desired. Either additional `IObjectFactory` instances can be registered programmatically with the `AddObjectFactory(IObjectFactory factory)` method or you can specify them in your configuration files and have the system automatically detect them by calling the `AutoConfigureObjectFactories(IGraph g)` function.

# Configuration File structure 

A Configuration file is simply an RDF graph which uses the [Configuration Vocabulary](http://www.dotnetrdf.org/configuration#) to specify objects which can be loaded dynamically by the `ConfigurationLoader`. A Configuration file may be encoded in any valid RDF graph format which the library understands though typically we recommend using Turtle/N3 for their human readability and ease of editing compared to other RDF serializations.

The [Configuration vocabulary](http://www.dotnetrdf.org/configuration#) allows for specifying a variety of commonly used objects in dotNetRDF as listed in the Configurable Objects section.

## Vocabulary Basics 

To specify an object you will need at least two triples, for example to specify an empty Graph you would need the following:

```turtle

@prefix dnr: <http://www.dotnetrdf.org/configuration#> .

# Encodes a Graph
<http://example.org/graph> a dnr:Graph ;
  dnr:type "VDS.RDF.Graph" .
```

We use the `rdf:type` (specified here by the Turtle/N3 keyword `a`) predicate to specify that some Node has a type of `dnr:Graph` which is the class of Graphs in the Configuration Vocabulary. Then the `dnr:type` property is used to specify the .Net type of this object, for dotNetRDF types it is sufficient to specify the full namespace qualified name of the class. For any other class you will need to specify the Assembly Qualified Name of the class.

If you fail to specify a `dnr:type` property then the object may be unloadable though some classes in the Configuration Vocabulary have default types. In the case of the `dnr:Graph` class the default type is [Graph](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Graph.htm).

## Imports 

Since configuration graph for larger applications can grow to be quite complex you can use our imports mechanism to split your configuration over several files.  Importing is as simple as the following:

```turtle

@prefix dnr: <http://www.dotnetrdf.org/configuration#> .

# Import from another file
<> dnr:imports "other-config.ttl" .

# Import from another URI
<> dnr:imports <http://example.org/other-config.ttl> .
```

If you are using imports then you should always use the `LoadConfiguration()` method to load your Configuration Graph as this will automatically resolve imports for you.

## Auto-Configuration 

The API supports the notion of auto-configuration, some types of object that should be globally registered can be auto-configured either when your Configuration is loaded or on demand via one of the auto-configuration methods e.g. `AutoConfigureOjectFactories(IGraph g)`

When you use the `LoadConfiguration()` method the auto-configuration will be automatically done for you unless you explicitly opt out using one of the overloads.

Currently the following may be auto-configured:

* [[Object Factories|Configuration-Object-Factories]]
* [[Readers and Writers|Configuration-Readers-And-Writers]]
* [[SPARQL Operators|Configuration-SPARQL-Operators]]
* [[Static Options|Configuration-Options]]

## Special URIs 

Since your configuration file may need to specify information that is sensitive (e.g. passwords) which you may not want to expose in a plain text file we provide for the use of special URIs of the form `<appsetting:AppSettingName>`.

These URIs allow you to refer to the value of an AppSetting defined in the `<appSettings>` section of your `Web.config` file. You can then use the standard techniques for encrypting the `<appSettings>` section of your `Web.config` file to obfuscate your password.

**Note:** We recommend that you follow security best practises so that where you need to set passwords in a configuration file you use an account that is restricted to only the privileges necessary for the application.

# Key Functions 

## LoadConfiguration() 

`LoadConfiguration()` is a helper function that can be used to load in a configuration graph, it invokes the standard RDF loading mechanisms but also handles some special features of the Configuration API such as imports, auto-configuration etc.

## LoadObject() 

The main function that you will want to use is the `LoadObject()` function which attempts to load objects dynamically based on the information in a provided graph. The function is invoked by passing in a Configuration Graph containing the configuration and a Node representing the Object to be loaded.

For example consider the following configuration file which we'll refer to as `config.ttl`:

```turtle

@prefix dnr: <http://www.dotnetrdf.org/configuration#> .

# Encodes a Graph
<http://example.org/graph> a dnr:Graph ;
  dnr:type "VDS.RDF.Graph" ;
  dnr:fromFile "example.rdf" .
```

To load the Graph specified in the Configuration file you would use the following code:

```csharp
using System;
using VDS.RDF;
using VDS.RDF.Configuration;
using VDS.RDF.Parsing;

public class LoadObjectExample
{
	public static void Main(String[] args)
	{
		//First need to load in the Configuration Graph
		IGraph config = ConfigurationLoader.LoadConfiguration("config.ttl");

		//Then get a Node referencing the object we want to load
		INode graphNode = config.CreateUriNode(new Uri("http://example.org/graph"));

		try
		{
			//Now we'll try and load the object
			Object temp = ConfigurationLoader.LoadObject(config, graphNode);

			//Test it got loaded as a Graph as we expected
			if (temp is IGraph)
			{
				Console.WriteLine("Loaded Graph successfully from Configuration");
				//You can now cast this object to IGraph and use it as you would any other Graph
			}
			else
			{
				Console.WriteLine("Failed to load Graph from Configuration");
				//If loading gives an object of different type from the expected this suggests your configuration file is malformed in some way
				//Typically an exception would be thrown in such a case with an error message
				//informing you of the particular issue with your configuration
				//You can force an exception to be thrown in this case by using the three argument
				//form of LoadObject() which takes in the desired type
			}
		}
		catch (DotNetRdfConfigurationException configEx)
		{
			//This exception may be thrown if the object is unloadable e.g due to malformed
			//configuration
		}
	}
}
```

# Configurable Objects 

As of the most recent release all of the following objects can be loaded from Configuration files, follow the links by each one to see detailed descriptions of the possible configuration for these objects:

## Core Objects 

* [[Graphs|Configuration-Graphs]]
* [[Triple Stores|Configuration-Triple-Stores]]
* [[Object Factories|Configuration-Object-Factories]]
* [[Readers and Writers|Configuration-Readers-And-Writers]]

## SPARQL Features 

* [[SPARQL Endpoints|Configuration-SPARQL-Endpoints]]
* [[Query Processors|Configuration-Query-Processors]]
* [[Update Processors|Configuration-Update-Processors]]
* [[Protocol Processors|Configuration-Protocol-Processors]]
* [[SPARQL Datasets|Configuration-SPARQL-Datasets]]
* [[SPARQL Expression Factories|Configuration-SPARQL-Expression-Factories]]
* [[SPARQL Operators|Configuration-SPARQL-Operators]]
* [[SPARQL Optimisers|Configuration-SPARQL-Optimisers]]
* [[Full Text Query|Configuration-Full-Text-Query]]
* [[Reasoners|Configuration-Reasoners]]

## 3rd Party Triple Store Integration 

* [[Storage Providers|Configuration-Storage-Providers]]

## ASP.Net Integration 

* [[HTTP Handlers|Configuration-HTTP-Handlers]]
* [[User Groups|Configuration-User-Groups]]
* [[Permissions|Configuration-Permissions]]
* [[Users|Configuration-Users]]

## Miscellaneous 

* [[Static Options|Configuration-Options]]
* [[Proxy Servers|Configuration-Proxy-Servers]]

