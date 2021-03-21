[[Home]] > [[User Guide|UserGuide]] > [[Tools|Tools]] > [[rdfEditor|Tools-rdfEditor]]

# rdfEditor 

rdfEditor is a GUI tool designed as a Notepad replacement for editing RDF and SPARQL. It provides syntax highlighting, validation and auto-completion and all major RDF and SPARQL syntaxes are supported (though auto-completion is only available for some syntaxes).

**Note:** This tool is Windows only

## Download 

You can download this tool as part of our [[Toolkit|Tools]]

## Documentation 

rdfEditor is a notepad style GUI tool and as such should be relatively self explanatory.  Some useful features that may not be immediately obvious are highlighted here.

### Customisable Apperance 

You can customise practically every aspect of the display of RDF, you can access the following dialogue by going to `Options > Customise Appearance Settings`

{{http://www.dotnetrdf.org/images/screenshots/editor_appearance.jpg|rdfEditor - Customize Appearance}}

For information on advanced customisation see [[Advanced Settings|Tools-rdfEditor-Advanced-Settings]]

### Converting between Formats 

You can convert from one RDF format to another like so:

# Switch to the tab containing the document you want to convert from.  This must be a valid RDF document as reported by the editor.
# Go to `File > Save With...` and select one of the supported formats
# A new tab will be opened with the document converted to the destination format

If you want to customize the conversion you can do so by first checking `File > Save With... > Prompt for Advanced Writer Options?`.  With this option enabled rdfEditor will bring up a dialogue when you request a conversion allowing you to configure options as desired.

## Screenshots 

### Turtle Syntax 

{{http://www.dotnetrdf.org/images/screenshots/editor_turtle.jpg|rdfEditor - Turtle Syntax}}

### SPARQL Syntax 

{{http://www.dotnetrdf.org/images/screenshots/editor_sparql.jpg|rdfEditor - SPARQL Syntax}}

### RDF/XML Syntax 

{{http://www.dotnetrdf.org/images/screenshots/editor_rdfxml.jpg|rdfEditor - RDF/XML Syntax}}

### Structure View 

Structure view shows the actual triples/quads/SPARQL results found in a document being edited

{{http://www.dotnetrdf.org/images/screenshots/editor_structure.jpg|rdfEditor - Structure View}}

