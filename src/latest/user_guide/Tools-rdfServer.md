# rdfServer 

rdfServer is a command line HTTP server which provides a SPARQL Server.

You can use the related [rdfServerGui](Tools-rdfServerGui.md) tool to provide a simple GUI for the creation and management of these servers.

## Download 

You can download this tool as part of our [Toolkit](Tools.md)

## Documentation 

Usage is as follows:

```dos
rdfServer.exe [options]
```

For example try the following:

```dos
rdfServer.exe -v
```

Then point your browser at `http://localhost:1986/query` which will provide you a query interface, or `http://localhost:1986/update` which will give you the update interface.

### Supported Options 

| Option | Purpose |
| --- | --- |
| `-b directory` or `-base directory` | Sets the Base Directory from which static content can be served |
| `-c config.ttl` or `-config config.ttl` | Sets the Configuration File which specifies the Dataset to use for querying (see `default.ttl` for an example or the online documentation for the [Configuration API](Configuration-API.md)).  Configuration via the Configuration API has some limitations as detailed later on this page. |
| `-f format` or `-format format` | Sets the Log Format for use with logging, format string is in Apache mod_log style |
| `-help` | Prints this usage summary and quits |
| `-h host` or `-host host` | Sets the host name that the server listens on |
| `-l log.txt` or `-log log.txt` | Sets the log file used for logging |
| `-p port` or `-port port` | Sets the port that the server listens on |
| `-q` or `-quiet` | Suppresses all information messages and ignores verbose mode if set
| `-r` or `-rest` | Enabled RESTful Control which allows a request to be POSTed to `/control` with `operation=restart` or `operation=stop` to control the server |
| `-v` or `-verbose` | Sets Verbose mode - causes all requests and errors to be logged to console |

### Configuration Limitations 

When a Configuration file is used to configure the server the following limitations are placed on the configuration:

* Only HTTP Handlers declared as `VDS.RDF.Web.SparqlServer` are supported
* All `dotnetrdf:` URIs used as subjects for HTTP handlers must end in `/*` as SPARQL Servers are required to listen on wildcard paths.  For example `<dotnetrdf:/path/*>` would be a valid subject and the endpoints would then be available at `/path/query` and `/path/update`
* SPARQL Servers run under rdfServer **do not** support the SPARQL 1.1 Graph Store Protocol