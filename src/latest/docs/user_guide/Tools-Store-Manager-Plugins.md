[[Home]] > [[User Guide|UserGuide]] > [[Tools|Tools]] > [[Store Manager|Tools-Store-Manager]] > [[Store Manager Plugins|Tools-StoreManager-Plugins]]

# Store Manager Plugins 

[[Store Manager|Tools-Store-Manager]] supports a plugin system which allows you to manage any store that you've exposed via dotNetRDF's `IStorageProvider` interface using Store Manager without having to make any code changes to the tool.

## Plugin Requirements 

A plugin requires the following:

* A DLL containing your implementation of `IStorageProvider`
* A DLL (may be the same DLL as above) which implements the `IConnectionDefinition` interface found in **StoreManager.Core.dll** and has properties annotated with the `ConnectionAttribute`

See the [[Storage API|Storage-API]] documentation for details of the `IStorageProvider` API.

## Deploying a Plugin 

Once you have these DLL(s) you simply drop them into the `plugins/` directory of your copy of Store Manager and when you restart Store Manager it should detect them automatically if you've got your classes set up appropriately.

You can check which plugins were successfully detected by going to `Help > About`.  You can hot deploy plugins and have the tool detect them while running by going to `Help > About` and hitting the `Rescan` button though we recommend you restart the tool wherever possible particularly if you are replacing an existing plugin with an updated version.

If your plugin has been properly recognized and provides classes matching the above then when you go to `File > New Connection` you should see your store in the list of available stores.

## Help with Developing a Plugin 

If you need help with getting this advanced feature working we suggest you ask on the [[mailto:dotnetrdf-develop@lists.sf.net|developer list]].