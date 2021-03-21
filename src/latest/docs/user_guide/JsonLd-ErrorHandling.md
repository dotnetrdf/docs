[[User Guide|UserGuide]] > [[JSON-LD API|JsonLd-Api]] > Error Handling

# Error Handling

Errors relating to JSON-LD processing are notified by the JsonLdProcessor raising a JsonLdProcessorException or a JsonLdFramingException. These exceptions both contain an ErrorCode field whose value is a JsonLdErrorCode or JsonLdFramingErrorCode respectively. All of the error codes are based directly on the codes defined in the [JSON-LD API Specification](https://json-ld.org/spec/latest/json-ld-api/) and [JSON-LD Framing Specification](https://json-ld.org/spec/latest/json-ld-framing/)