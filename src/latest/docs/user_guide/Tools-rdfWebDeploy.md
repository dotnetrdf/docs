# rdfWebDeploy 

rdfWebDeploy is a command line utility for deploying [ASP.Net Integration](ASPNET-Integration.md)

## Download 

You can download this tool as part of our [Toolkit](Tools.md)

# Documentation 

Command usage is as follows:

```dos
rdfWebDeploy.exe mode [options]
```

For example to deploy an application:

```dos
rdfWebDeploy.exe -deploy /demos config.ttl
```

To verify dotNetRDF DLLs are present and correct:
```dos
rdfWebDeploy.exe -dllverify /demos
```

## Notes 

All modes which support the webapp parameter specify it as the virtual path for the parameter on your local IIS instance, if you don't have a local IIS instance specify a path to the root directory of your web application and specify the `-noiis` option as an additional command line argument

### Supported Modes 

#### deploy

```dos
rdfWebDeploy.exe -deploy webapp config.ttl [options]
```

Automatically deploys the given configuration file to the given web applications by setting up it's `Web.Config` file appropriately and deploying necessary DLLs.

#### dllupdate 

```dos
rdfWebDeploy.exe -dllupdate webapp [options]
```

Updates all the required DLLs in the applications bin directory to the versions in the toolkits directory.

#### dllverify 

```dos
rdfWebDeploy.exe -dllverify webapp [options]
```

Verifies whether the required DLLs are present in the applications `bin/` directory

#### help 

```dos
rdfWebDeploy.exe -help
```

Shows a console version of this usage guide

#### list

```dos
rdfWebDeploy.exe -list config.ttl
```

Lists the Handlers in the given configuration file

#### test 

```dos
rdfWebDeploy.exe -test config.ttl
```

Tests whether a configuration file parses and makes various tests for validity

#### vocab 

```dos
rdfWebDeploy.exe -vocab file.ttl
```

Outputs the Configuration Vocabulary to the given file for use as a reference

#### xmldeploy 

```dos
rdfWebDeploy.exe -xmldeploy web.config config.ttl [options]
```

Automatically deploys the given configuration file to the given web applications by setting up it's `Web.Config` file appropriately and deploying necessary DLLs

### Supported Options 

| Option |  Supported Modes |  Purpose |
|--------|------------------|----------|
| `-nointreg` | `deploy` and `xmldeploy` | If specified then Handlers will not be registered for IIS Integrated Mode |
| `-noclassicreg` | `deploy` and `xmldeploy` | If specified then Handlers will not be registered for IIS Classic Mode |
| `-noiis` | All modes that take the webapp parameter | If specified indicates that there is not a local IIS instance available or you wish to deploy to a web application which is not associated with your local IIS instance. Essentially forces `deploy` mode to switch to `xmldeploy` mode |
| `-site "Site Name"` | All modes that take the webapp parameter | Specifies the IIS site in which the web application resides |
