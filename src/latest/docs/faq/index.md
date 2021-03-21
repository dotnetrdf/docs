# FAQs

This page details common problems


## Platform

### What platforms does dotNetRDF run on?

dotNetRDF runs on .Net 3.5 Framework and higher, builds are provided for various framework profiles on the different versions of the framework. Exact supported features depend on the build used, see [Getting Started](../tutorial/Getting-Started.md) for more details on the builds.

dotNetRDF will also run under Mono 2.8 and higher, generally we recommend using the newest Mono release possible for best results.

## Compilation/Runtime Errors

### How do I compile dotNetRDF myself?

Firstly check out the source from the [GitHub repository](https://github.com/dotnetrdf/dotnetrdf). Once downloaded you can either open the solution in Visual Studio 2015 or build via the NAnt scripts. Building via the NAnt scripts is more powerful and only relies on the relevant .Net Framework SDKs having been installed on your system and so doesn't require a full Visual Studio install.

See documentation under `Build/` in the source-code tree for more information.

### My code won't compile because a namespace or class from dotNetRDF was not found?

There are a number of possible causes of this type of error, please check you have done all of the following.

Have you added dotNetRDF as a reference to your project? See Getting Started for help with this

Is the version of dotNetRDF referenced the correct version for the target framework version of your project? dotNetRDF comes in builds for a variety of different versions of the .Net framework, using the wrong build will lead to compile errors - see Getting Started

Are you using the latest version of the library? Check the Project Status page and compare the build and version number with that shown in your editor

Have you added the appropriate using declarations to your code? Check the Intellisense API to see what namespace different classes are in

Are you trying to use deprecated/removed code? We have a clear [Deprecation Policy](../developer_guide/Deprecation-Policy.md) and we actively obsolete and deprecate old APIs over time. If you upgrade your version over time you will see warnings ahead of time but if you jump several versions in one go you may encounter problems with missing APIs. See the ChangeLog.txt file in the release see what may have changed. 

### I get a "No overload for method X takes Y arguments" error or similar

Some features are not available across all builds of the library because they cannot be supported on the platform (e.g. anything using synchronous HTTP is not supported under Silverlight or Windows Phone)

This means that some methods shown in the documentation will not be available. Use your editors auto-complete functions to see alternative overloads for the method which are supported with the chosen build of dotNetRDF.

### I get a "The Namespace URI for the given Prefix 'http' is not known by the in-scope NamespaceMapper"

This error occurs because you have tried to use the version of CreateUriNode() that expects a Prefixed Name e.g. rdf:type instead of the method that expects a Uri

Ensure you call the version of the method that takes a Uri instance instead.

## Data Errors

### The data returned from a remote service is not in the format I expected?

When you use any class that talks to some remote service to retrieve data whether it be the UriLoader or some triple store connector like the FusekiConnector the data returned will be dictated by the service you are accessing.

All dotNetRDF is responsible for is sending the request to the remote service and parsing the data returned into the relevant .Net objects for you to work with. If some piece of data comes back as a `ILiteralNode` and you expected a `IUriNode` then that is nothing to with dotNetRDF - it is the remote service that returned the data in that format.

### My query returned no results?

Depending on how you make a query it is either being evaluated by dotNetRDF itself or passed off to some external service to do the query processing. There can be a number of reasons why a query did not return, check the following.

Is there a typo in your query? Are you sure the query you wrote is actually correct, minor mistakes in namespace declarations can make your query syntactically correct but fail to match anything. Did you misspell a namespace or Prefixed Name?

Are you using literals in triple patterns in your query? Literals in triple patterns are matched strictly in SPARQL so things that look very similar are not considered equal e.g. `"1"^^xsd:integer != "1"^^xsd:decimal` . If you are using Literals you may be better using a variable combined with a `FILTER` clause because the equality in filter expressions is value based equality so would match something like the above where triple pattern matching would not.

Are there named graphs involved? If so does your query actually query the appropriate named graphs?  Please see [SPARQL Datasets](../user_guide/SPARQL-Datasets.md) for help with this.

Does the data being queried actually contain the triples you are trying to match?

You can try debugging your query by following the instructions on [Debugging SPARQL Queries](../howto/Debug-SPARQL Queries.md)

If you still have problems then you may wish to ask for [Support](../support/index.md) - bear in mind that for many query able data sources such as 3rd party triple stores you are likely better off asking the people behind the store for help rather than us because we may just be sending a query and receiving a result in which case the lack of results is outside of our control.