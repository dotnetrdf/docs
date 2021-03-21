[[Home]] > [[User Guide|UserGuide]] > [[Storage API|Storage-API]] > [[Storage Providers|UserGuide/Storage/Providers]] > [[Stardog|Storage-Stardog]]

# Stardog 

[Stardog](http://stardog.com) the RDF database from Clark & Parsia can be connected to via the [StardogConnector](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_StardogConnector.htm).  This connector uses the Stardog HTTP interface so requires a running Stardog HTTP server.

The `StardogConnector` assumes the latest version of Stardog is being used, currently these are the 3.x releases.  A [StardogV1Connector](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_StardogV1Connector.htm), [StardogV2Connector](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_StardogV2Connector.htm) and [StardogV3Connector](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_StardogV3Connector.htm) are provided if you wish to be explicit about the version of Stardog you are connecting to.

In terms of backwards compatibility the newer connectors may be able to talk to an older server but we can't guarantee this will work correctly, also newer connectors have support for newer Stardog features which will not work if used against an older server.

## Supported Capabilities 

* Load, Save, Delete, Update and List Graphs
* SPARQL Query
** Configurable query reasoning levels (for Stardog 1.x and 2.x)
* SPARQL Update for Stardog 2.x and 3.x connections
* Transactions

## Creating a Connection 

Connecting to a Stardog database requires knowing the Base URI for the server, a database ID and user credentials if security is enabled e.g.

```csharp

StardogConnector stardog = new StardogConnector("http://localhost:5820", "example", "username", "password");
```

## Configurable Query Reasoning 

Stardog 1.x and 2.x supports configurable reasoning levels on a per-query basis.  The current reasoning level is controlled by the `Reasoning` property and takes a value from the [StardogReasoningMode](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_StardogReasoningMode.htm) enum.

Note that from Stardog 3.x the reasoning level is controlled at the database level and cannot be changed at the connection level.

This may be changed any time you like and affects any subsequent queries made via the `Query()` method.

## Transactions 

Stardog is one of the few stores currently supported that support transactions, see the [[Transactions API|Storage-Transactions]] page for an overview of those APIs.  If the Transaction APIs are not explicitly used each operation occurs in its own transaction which is auto-committed at the end of its operation.

# Managing a Server 

We support managing a server via the [StardogServer](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_Management_StardogServer.htm) class which implements our [[Servers API|Storage-Servers]]

The `StardogServer` assumes the latest version of Stardog is being used, currently these are the 3.x releases.  A [StardogV1Server](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_Management_StardogV1Server.htm), [StardogV2Server](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_Management_StardogV2Server.htm) and [StardogV3Server](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_Management_StardogV3Server.htm) are provided if you wish to be explicit about the version of Stardog you are connecting to.

A `StardogConnector` provides access to its associated server via the `ParentServer` or `AsyncParentServer` property.

## Connecting to a Server 

You can also connect directly to a server by creating an instance of the [StardogServer](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_Management_StardogServer.htm) class.  This requires you to know the Base URI of the server:

```csharp

StardogServer server = new StardogServer("http://localhost:5822", "username", "password");
```

## Creating Stores 

When creating a store the `StardogServer` will provide templates from the following selection:

| Template | Description |
| --- | --- |
| [StardogDiskTemplate](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_Management_Provisioning_Stardog_StardogDiskTemplate.htm) | Used to create a Stardog disk store |
| [StardogMemTemplate](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_Management_Provisioning_Stardog_StardogMemTemplate.htm) | Used to create a Stardog memory store |

Both of these derive from the [BaseStardogTemplate](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_Management_Provisioning_Stardog_BaseStardogTemplate.htm) which provides a large range of properties that can be used to configure Stardog database options.