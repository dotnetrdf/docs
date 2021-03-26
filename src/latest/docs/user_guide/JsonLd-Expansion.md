# Expansion

The expansion operation removes context from a JSON-LD document and makes the data structures within the JSON-LD document more regular. For more information about this operation please refer to [the JSON-LD API Specification](https://json-ld.org/spec/latest/json-ld-api/index.html#expansion).

The expansion operation accepts as input either a parsed JSON object (as a `Newtonsoft.Json.Linq.JObject`) or the URI of a JSON-LD document to be retrieved (passed either as a `System.Uri` or as a `Newtonsoft.Json.Linq.JValue`). If a URI is passed, the JSON-LD document is retrieved via an HTTP GET - this resolution and retrieval function can be overridden in the [`JsonLdProcessorOptions`](JsonLd-ProcessorOptions.md) instance passed to the method.

The expanded document is returned as a `Newtonsoft.Json.Linq.JArray` instance, which can then be further processed as required.

Under the .NET Standard framework, the APIs are available in both synchronous and asynchronous forms with the asynchronous methods having the name `ExpandAsync`. Under the .NET 4.0 framework only synchronous APIs are available.