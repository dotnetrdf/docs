[[Home]] > [[User Guide|UserGuide]] > [[Tools|Tools]] > [[rdfServerGui|Tools-rdfServerGui]]

# rdfServerGui 

rdfServerGui is a basic GUI for working with [[rdfServer|Tools-rdfServer]]

## Download 

You can download this tool as part of our [Toolkit](http://www.dotnetrdf.org?content.asp?pageID=Download%20dotNetRDF%20Toolkit%20for%20Windows)

## Documentation 

rdfServerGui is a basic GUI that can be used to manage [[rdfServer|Tools-rdfServer]] instances.  The basic UI looks like the following:

{{http://www.dotnetrdf.org/images/screenshots/rdfservergui.jpg|rdfServerGui}}

As can be seen it provides three tabs:

* Create Server - Used to create a server using simple options
* Create Server Advanced - Used to create a server by providing command line options for rdfServer
* Running Servers - Used to monitor active servers

### Create Server 

The Create Server tab provides the easiest way to get a server up and running, fill out the options you are interested in and hit Create.  The following is a summary of the options:

|= Option |= Default |= Description |
| Host | localhost | The hostname on which the server will listen for HTTP requests. |
| Port | 1986 | The port on which the server will listen for HTTP requests. |
| Configuration File | None | Used to specify a RDF configuration file that will be used to configure rdfServer |
| Enable Log File? | Disabled | If enabled will log HTTP requests to the file specified by the Log File option |
| Log File | log.txt | Log file to log HTTP requests to, only used if Enable Log File? is enabled |
| Log Format | common | Log format for HTTP request logging, use one of the provided defaults or enter an Apache mod_log style format string |
| Base Directory | None | If set static content from the given directory can be served in addition to handling SPARQL requests |
| Enable Verbose Mode | Enabled | If set additional output will be printed to the Console for monitoring. |
| Enable Quiet Mode | Disabled | If set disables verbose mode if set and reduces console output level. |
| Run as External Process | Disabled | Allows for the server to persist as a separate process beyond the life of the GUI, external processes have more limited management options.  When disabled the server runs in-process which means it pesists as long as the GUI is running, this provides more monitoring and management options. |
| Start Server Automatically? | Disabled | If enabled the server will be started as soon as you hit the Create button. |

Let's assume we create a server like so:

{{http://www.dotnetrdf.org/images/screenshots/rdfservergui_create_simple.jpg|rdfServerGui}}

The above creates an in-process server on the default host and port, with default logging enabled and verbose mode on.  After we hit create we can go to the Running Servers tab where we see the following:

{{http://www.dotnetrdf.org/images/screenshots/rdfservergui_running_simple_stopped.jpg|rdfServerGui}}

After we hit the Start button we can go to our browser and make some requests against the server, these will be logged to the monitoring pane like so:

{{http://www.dotnetrdf.org/images/screenshots/rdfservergui_running_simple_monitoring.jpg|rdfServerGui}}

#### Running as External Process 

If you run as an external process for your server you have more limited control, however they have the advantage that they persist beyond the life of the GUI.  So if you start an external server from the GUI and then close the GUI you can still access that server through your browser until such time as you kill the external process.

If you restart the GUI you will be able to see running external servers but you will not be able to monitor them because it is not possible to connect to the console output of a process not created by the current process.

### Create Server Advanced 

Create Server Advanced simply allows you to create a server by specifying the same command line arguments as if you were starting [[rdfServer|Tools-rdfServer]] directly.  Servers created this way always run as external servers and give you complete control over the options you pass to the server.