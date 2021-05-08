# Store Manager 

The Store Manager is a utility which allows you to use a simple GUI interface to view and manage the contents of Triple Stores. You can work with any of the supported native Triple Stores, see [Storage Providers](Storage-Providers.md) for the list of currently supported stores.

Functionality differs depending on the type of store and the capabilities of the given store (or more specifically of our integration with that store).

## Download 

You can download this tool as part of our [Toolkit](Tools.md)

## Documentation 

### Getting Started 

Firstly when you start up the application you'll see the following Start Page:

{{http://www.dotnetrdf.org/images/screenshots/storemanager_startpage.jpg|Store Manager - Start Page}}

If you've used the tool previously you will see Recent and Favourite Connections here and can double click to instantly start working with one of those connections. If you'd like to modify an existing connection click once to select it then right click and hit `Edit Connection` - if you always want to edit connections before using them you can select that option at the bottom of the start page and then just double click to edit a connection.

To make a new connection select `Connect to a Triple Store` to open the New Connection dialogue.

You can work with multiple connections at a time and can always get back to this Start Page by going to `File > Show Start Page`, to just make a new connection go to `File > New Connection`:

{{http://www.dotnetrdf.org/images/screenshots/storemanager_menu.jpg|Store Manager - File Menu}}

### Connecting to a Store 

When you've chosen to create a New Connection either via the File Menu or the Start Page you'll see the following dialogue:

{{http://www.dotnetrdf.org/images/screenshots/storemanager_newconnection.jpg|Store Manager - New Connection}}

Available stores are any store which we provide support in any of our publicly released libraries or for which you have a [Store Plugin](Tools-Store-Manager-Plugins.md) available in your `plugins/` folder.

### Graph List 

If your chosen Store supports named Graphs and can return the Graph list in response to an appropriate SPARQL query then you will see a list of graphs on the main screen.

{{http://www.dotnetrdf.org/images/screenshots/storemanager_graphlist.jpg|Store Manager - Graph List}}

### Querying with SPARQL 

Provided your chosen store supports SPARQL you can query against it using the SPARQL tab as shown in the screenshot below:

{{http://www.dotnetrdf.org/images/screenshots/storemanager_improved_editor.png|Store Manager - SPARQL Query}}

As with the [SparqlGui](Tools-SparqlGui.md) you can save and load queries to text files as desired. 

Results are displayed in the same window like so, results from multiple queries are presented as tabs that can be switched between. You can hit the detach button to open a set of results in a separate window if you prefer that:

{{http://www.dotnetrdf.org/images/screenshots/storemanager_inline_results1.png|Store Manager - Results View}}

The Graph viewer presents a list of all the Triples in the Graph. You can export the Graph in the format of your choice using the Export Data button which displays the following dialogue:

{{http://www.dotnetrdf.org/images/screenshots/storemanager_exportgraph.jpg|Store Manager - Export Results}}

The dialogue allows you to save to a file in the format of your choice using the desired options for the writer.

You may also visualise the Graph using GraphViz (if you have it installed on your system), even if it isn't installed you can use the Visualise button to access a dialogue which will let you save your Graph in DOT format so you can process it with GraphViz at a later date. If GraphViz is installed you can generate a PNG/SVG image of the Graph using this feature.

### Tasks View 

When connecting to a store all actions performed on that store are treated as distinct tasks and run in the background. This allows you to carry out multiple operations simultaneously while the GUI remains responsive and lets you monitor the progress of any Task. Tasks can be monitored from the Tasks view shown below:

{{http://www.dotnetrdf.org/images/screenshots/storemanager_tasks.jpg|Store Manager - Tasks View}}

Right clicking on a task will give you access to more information about it.