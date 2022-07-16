#include <tokenizer>

static const char method_custom[] = "core.method.custom";
static const char operation_encode[] = "core.method.operation.encode";

public Action tokenizer_OnTokenMethodRequest(const char[] operation, JsonBuilder context)
{
    if(strcmp(operation, operation_encode))
        return Plugin_Continue;

    if(!JSON_EQUAL_TYPE(context.Build(), JSON_OBJECT))
        return Plugin_Stop;

    if(!asJSONO(context.Build()).HasKey("method"))
        return Plugin_Handled;

    char method[PLATFORM_MAX_PATH];
    asJSONO(context.Build()).GetString("method", method, sizeof(method));

    if(strcmp(method_custom, method))
        return Plugin_Continue;

    Json tokens;
    
    // "tokens": [<tokens>]
    context.Set("tokens", (tokens = GenerateCustomTokens(context.Build())));

    return Plugin_Changed;
}

Json GenerateCustomTokens(const Json context)
{
    // TODO: method body
}