[[Home]] > [[Developer Guide|DeveloperGuide]] > [[Compiling|DeveloperGuide-Compiling]]

# Compiling dotNetRDF

Compiling dotNetRDF may be done in two ways:

1. Using Visual Studio 2010 or higher
2. Using NAnt

## Using Visual Studio

Using Visual Studio is the easiest way to compile dotNetRDF although there are several additional dependencies necessary:

* Silverlight Developer Tools
* Windows Phone Developer Tools
* IIS Express
* NuGet

Some of these can be installed automatically be following the VS provided prompts, others need to be manually downloaded and installed.

With all these tools in place you can simply run a Build in Visual Studio which should build everything for you.

## Using NAnt

Using NAnt is primarily for advanced users, it allows you to build individual components of the system and release distributions.  This requires you to have NAnt installed and the following:

* .Net Framework SDK
* Silverlight Developer Tools
* Windows Phone Developer Tools
* NuGet

You can get a list of available NAnt targets by using the NAnt CLIs project help functionality, general useful targets are as follows:

| Target |  Description |
|--------|--------------|
| license | Checks all code files have appropriate license headers in place |
| compile | Compiles all libraries and utilities |
| compile-libs | Compile all libraries |
| compile-utils | Compile all utilities |
| build | Compiles all libraries and utilities and copies them to `bin/nightlies` |
| build-release | Compiles all libraries and utilities and copies them to `bin/stable` |
| dist | Builds distribution zip files |