[[Home]] > [[User Guide|UserGuide]] > [[Storage API|Storage-API]] > [[Servers API|Storage-Servers]]

# Servers API 

The Servers API provides limited management capabilities for 3rd party triple stores.  It is represented by the [IStorageServer](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_Management_IStorageServer.htm) and [IASyncStorageServer](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_Management_IAsyncStorageServer.htm) interfaces.  These interfaces provide limited abilities to create, delete, get and list stores provided on a server i.e. the ability to manage and access multiple [IStorageProvider](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_IStorageProvider.htm) instances.

# Implementations 

The following implementations are currently provided:

| Implementation | Description |
| --- | --- |
| [AllegroGraphServer](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_Management_AllegroGraphServer.htm) | Manages a catalog of an AllegroGraph server, see the [[Allegro Graph|Storage-AllegroGraph]] documentation |
| [SesameServer](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_Management_SesameServer.htm) | Manages a Sesame HTTP Protocol compliant server, see the [[Sesame|Storage-Sesame]] documentation |
| [StardogServer](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_Management_StardogServer.htm) | Manages a Stardog server, see the [[Stardog|Storage-Stardog]] documentation |

# Basic Usage 

## Properties 

These interfaces provide a single `IOBehaviour` property which reports [IOBehaviour](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_IOBehaviour.htm) that describes the capabilities of an implementation i.e. which operations are supported.

## Methods 

These interfaces provide several methods for carrying out the varying management tasks supported, here we demonstrate each with an example.

### ListStores() 

The `ListStores()` method lists the stores available on a server.

```csharp
using System;
using VDS.RDF;
using VDS.RDF.Storage.Management;

public class ListStoresExample
{
  public static void Main(String[] args)
  {
     //Connect to a server, we use Stardog for this example
     StardogServer server = new StardogServer("http://localhost:5822", "username", "password");

     //Get the list of stores
     foreach (String store : server.ListStores())
     {
       Console.WriteLine(store);
     }
  }
}
```

### GetStore() 

The `GetStore()` method gets a connection to a specific store assuming it is available on the server.

```csharp
using System;
using VDS.RDF;
using VDS.RDF.Storage;
using VDS.RDF.Storage.Management;

public class ListStoresExample
{
  public static void Main(String[] args)
  {
     //Connect to a server, we use Stardog for this example
     StardogServer server = new StardogServer("http://localhost:5822", "username", "password");

     //Get a specific store
     IStorageProvider store = server.GetStore("example");
  }
}
```

### DeleteStore() 

The `DeleteStore()` method is used to delete a store from the server, this is typically non-reversible and should be used with extreme care.

```csharp
using System;
using VDS.RDF;
using VDS.RDF.Storage.Management;

public class ListStoresExample
{
  public static void Main(String[] args)
  {
     //Connect to a server, we use Stardog for this example
     StardogServer server = new StardogServer("http://localhost:5822", "username", "password");

     //Delete a specific store
     server.DeleteStore("example");
  }
}
```

### Creating a Store 

Creating a store is the most complex operation is done with a combination of the `CreateStore()` and either the `GetDefaultTemplate()` or `GetAvailableTemplates()` method.  Creating a store requires that you provide a [IStoreTemplate](https://dotnetrdf.github.io/api/html/T_VDS_RDF_Storage_Management_Provisioning_IStoreTemplate.htm) instance which indicates to the server what kind of store to create.

#### Templates 

The `GetDefaultTemplate()` method returns a template that can be modified in order to create whatever the server considers its default store type.  If the server supports multiple store types the `GetAvailableTemplates()` method will return all available templates.

A template has at the minimum a `ID` property which specifies the ID for the store to be created, it also has a `TemplateName` and `TemplateDescription` properties which describe the type of store the template may be used to create.  Templates also provide a `Validate()` method which can be used to ensure that templates are valid before use, any server will call this on templates passed to the `CreateStore()` method before actually attempting to create the store.

Since servers may have many implementation specific features typically there will be some number of additional properties that are available on a template that will allow you to customize your template.  See documentation for the various supported implementations to see what templates are supported.  Template implementations are annotated using `System.ComponentModel` annotations so can be explored via reflection if you so desire.

#### CreateStore() 

Once you have an appropriate template you can pass it to the `CreateStore()` method to get the store created.  This method will return `true` if the creation succeeds and `false` (or an exception) otherwise.

```csharp

using System;
using VDS.RDF;
using VDS.RDF.Storage.Management;
using VDS.RDF.Storage.Management.Provisioning;

public class ListStoresExample
{
  public static void Main(String[] args)
  {
     //Connect to a server, we use Sesame for this example
     IStorageServer server = new SesameServer("http://localhost:8080/openrdf-sesame/");

     //Create a new store using the default template
     IStoreTemplate template = server.GetDefaultTemplate("example");
     if (server.CreateStore(template))
     {
       Console.WriteLine("Store Created OK");
     }
     else
     {
       Console.WriteLine("Store Creation Failed");
     }
  }
}
```