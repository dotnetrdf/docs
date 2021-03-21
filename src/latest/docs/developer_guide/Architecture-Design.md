[[Home]] > [[Developer Guide|DeveloperGuide]] > [[Architecture|DeveloperGuide-Architecture]] > [[Design|DeveloperGuide-Architecture-Design]]

# Design

This section of the wiki covers design documents past and present for the library.  A lot of time design for simple features/fixes takes place on the mailing list and via our [Issue Tracker](https://github.com/dotnetrdf/dotnetrdf/issues) and the [old Issue Tracker](http://www.dotnetrdf.org/tracker/) so only major features get covered here.  In particular from 0.5.0 onwards we have heavily relied upon the issue tracker to monitor design tasks.

## Future Designs

| Design Document | Description |
|-----------------|-------------|
| [[dotNetRDF 2.0|DeveloperGuide-Architecture-Design-2.0]] | Details the planned simplification and refactoring of dotNetRDF for 2.0 |
| [[Medusa|DeveloperGuide-Architecture-Design-Medusa]] | Details a planned new streaming query engine for dotNetRDF |
| [SPIN](DesignDocs/dotnetRDF SPIN Design.docx) | Details a planned .Net implementation of [SPIN](http://www.spinrdf.org) |

## Past Designs

### Adopted Past Designs

| Design Document | Description |
|-----------------|-------------|
| [dotNetRDF 0.4.1](DesignDocs/dotNetRDF 0.4.1 Design.docx) | Designs for 0.4.1 which resulted in the [[Handlers API|UserGuide-Handlers-API]] abstraction. |
| [dotNetRDF 0.4.2](DesignDocs/dotNetRDF 0.4.2 Design.docx) | Designs for 0.4.2 which resulted in some internal improvements to the SPARQL engine |
| [dotNetRDF 0.5.0](DesignDocs/dotNetRDF 0.5.0.docx) | Designs for 0.5.0 which included expanded the utility of the [[Handlers API|UserGuide-Handlers-API]] and some .Net serialization support |

### Obsolete/Discarded Past Designs

| Design Document | Description |
|-----------------|-------------|
| [dotNetRDF 0.4.3](DesignDocs/dotNetRDF 0.4.3 Design.docx) | Designs for 0.4.3 which included a SQL backend which we later discontinued due to performance limitations |