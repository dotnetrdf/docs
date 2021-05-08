# Event Model

dotNetRDF makes limited use of events itself but various classes generated useful events that you can attach handlers to as desired, this document gives a quick overview of the various events available.

## Warning Events

The parsers and serializers for RDF all support `Warning` or `StoreWarning` events which are used to notify of non-fatal issues with RDF being read/written. This simply output a String which contains a message describing the issue with the RDF and what action the parser has taken (if appropriate).

## Data Model Events

dotNetRDF raises a variety of events which bubble up internally through multiple layers:

### Triple Store Events

| Event | Occurrence |
|-------|------------|
| [ITripleStore.GraphAdded](xref:VDS.RDF.ITripleStore#VDS_RDF_ITripleStore_GraphAdded) | Occurs when a Graph is added to a Store
| [ITripleStore.GraphRemoved](xref:VDS.RDF.ITripleStore#VDS_RDF_ITripleStore_GraphRemoved) | Occurs when a Graph is removed from a Store
| [ITripleStore.GraphChanged](xref:VDS.RDF.ITripleStore#VDS_RDF_ITripleStore_GraphChanged) | Occurs when a Graph is changed. This event is a bubbled event triggered by the [IGraph.Changed](xref:VDS.RDF.IGraph#VDS_RDF_IGraph_Changed) event 
| [ITripleStore.GraphCleared](xref:VDS.RDF.ITripleStore#VDS_RDF_ITripleStore_GraphCleared) | Occurs when a Graph is cleared.  This event is a bubbled event triggered by the [IGraph.Cleared](xref:VDS.RDF.IGraph#VDS_RDF_IGraph_Cleared) event 
| [ITripleStore.GraphMerged](xref:VDS.RDF.ITripleStore#VDS_RDF_ITripleStore_GraphMerged) | Occurs when a Graph has a merge operation performed on it

### Graph Events

| Event | Occurrence |
|-------|------------|
| [IGraph.TripleAsserted](xref:VDS.RDF.IGraph#VDS_RDF_IGraph_TripleAsserted) | Occurs when a Graph has a Triple asserted in it.  This event is a bubbled event triggered by the [BaseTripleCollection.TripleAdded](xref:VDS.RDF.BaseTripleCollection#VDS_RDF_BaseTripleCollection_TripleAdded) event |
| [IGraph.TripleRetracted](xref:VDS.RDF.IGraph#VDS_RDF_IGraph_TripleRetracted) | Occurs when a Graph has a Triple retracted from it.  This event is a bubbled event triggered by the [BaseTripleCollection.TripleRemoved](xref:VDS.RDF.BaseTripleCollection#VDS_RDF_BaseTripleCollection_TripleRemoved) event |
| [IGraph.Changed](xref:VDS.RDF.IGraph#VDS_RDF_IGraph_Changed) | Occurs when a Graph changes |
| [IGraph.ClearRequested](xref:VDS.RDF.IGraph#VDS_RDF_IGraph_ClearRequested) | Occurs when a `Clear()` operation is requested on a Graph |
| [IGraph.Cleared](xref:VDS.RDF.IGraph#VDS_RDF_IGraph_Cleared) | Occurs when a Graph is cleared |
| [IGraph.MergeRequested](xref:VDS.RDF.IGraph#VDS_RDF_IGraph_MergeRequested) | Occurs when a `Merge()` operation is requested on a Graph |
| [IGraph.Merged](xref:VDS.RDF.IGraph#VDS_RDF_IGraph_Merged) | Occurs when a Graph is merged |

### Triple Collection Events

| Event | Occurrence |
|-------|------------|
| [BaseTripleCollection.TripleAdded](xref:VDS.RDF.BaseTripleCollection#VDS_RDF_BaseTripleCollection_TripleAdded) | Occurs when a Triple is added to the collection |
| [BaseTripleCollection.TripleRemoved](xref:VDS.RDF.BaseTripleCollection#VDS_RDF_BaseTripleCollection_TripleRemoved) | Occurs when a Triple is removed from the collection |