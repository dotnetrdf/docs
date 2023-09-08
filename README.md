---
# Archived Documentation Repository

As of release 3.0, the documentation for dotNetRDF has moved to the [main repository](https://github.com/dotnetrdf/dotnetrdf) 
---

# docs
Documentation for the dotNetRDF library and tools

This repository contains the main documentation for dotNetRDF. We aim to release a new version of the docs with each minor release of the library (as an API changes should require at least a bump in minor version number). The published version of the docs can be found on the dotNetRDF website at https://dotnetrdf.org/docs/.

## Building the docs

The docs project is built using [DocFx](https://dotnet.github.io/docfx/index.html). We are currently using DocFx 2.x for the build.
As DocFX 2 doesn't have built-in support for multiple versions of documentation, the project fakes it by essentially creating
a duplicate of the docs for each minor release, plus two additional pseudo-releases: `stable` and `latest`. The `stable` release should always be an exact duplicate of the docs for the currently released minor version of the library; and `latest` should represent work in progress (and ideally be the docs for the code that exists on the main branch of the `dotNetRDF` repository).

NOTE: The DocFX configuration files have been written with the assumption that a clone of the dotNetRDF repository is present at ../dotNetRDF (relative to the directory containing this README) - this path assumption is baked into the steps that extract API metadata from the repository.

There are a few scripts provided to help automate local doc development and deployment via GitHub actions.

The Powershell script `latest_to_stable.ps1` is a script to create a new release of the docs as a copy of the docs in the `src/latest` directory. That release will go into two places - the `stable` directory and a new directory created for the release. That script takes a single `version` parameter which should be of the form `MAJ`.`MIN`.x (where `MAJ` and `MIN` are the major and minor version numbers of the release) and performs the following steps:

    * Create a new DocFX build file for the release version (as a copy of `src/docfx_template.json` with all instances of `_version_` replaced with the release version number) named `{$version}_docfx.json`
    * Create a new directory for `$version` under `src` (if it already exists, all content in the directory is deleted)
    * Recursively copy the content of `src/latest` to `src/$version`
    * Delete all of the content of `src/stable`
    * Recursively copy the content of `src/latest` to `src/stable`
    * Build the docs under `src/stable` (using src/stable_docfx.sjon)
    * Build the docs under `src/$version` (using src/{$version}_docfx.json)
    
To assist with developing and reviewing docs locally there are some NPM scripts. These all work on the latest version of the docs (under `src/latest`)

    * `npm run serve` - builds the latest docs and starts the DocFX server so that they can be browsed at http://localhost:8080/ (note that the docs are actually rooted under http://localhost:8080/docs/)
    * `npm run watch` - runs the build process and starts the server as above, but then watches the source directory for changes and automatically rebuilds and restarts the server
    * `npm run metadata` - runs the API metadata extraction only.
    * `npm run build` - runs the build process without starting the server
