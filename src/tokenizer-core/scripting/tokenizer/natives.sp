// Action tokenizer_Token(const char[] operation, JsonBuilder context)
public any tokenToken(Handle plugin, int params)
{
    char operation[PLATFORM_MAX_PATH];
    GetNativeString(1, operation, sizeof(operation));

    return tokenRequest(g_gfOnTokenRequest, operation, view_as<JsonBuilder>(GetNativeCell(2)));
}

// Action tokenizer_TokenSecurity(const char[] operation, JsonBuilder context)
public any tokenTokenSecurity(Handle plugin, int params)
{
    char operation[PLATFORM_MAX_PATH];
    GetNativeString(1, operation, sizeof(operation));

    return tokenRequest(g_gfTokenSecurityRequest, operation, view_as<JsonBuilder>(GetNativeCell(2)));
}

// Action tokenizer_TokenStorage(const char[] operation, JsonBuilder context)
public any tokenTokenStorage(Handle plugin, int params)
{
    char operation[PLATFORM_MAX_PATH];
    GetNativeString(1, operation, sizeof(operation));

    return tokenRequest(g_gfTokenStorageRequest, operation, view_as<JsonBuilder>(GetNativeCell(2)));
}

// Action tokenizer_TokenStorage(const char[] operation, JsonBuilder context)
public any tokenMethodGeneration(Handle plugin, int params)
{
    char operation[PLATFORM_MAX_PATH];
    GetNativeString(1, operation, sizeof(operation));

    return tokenRequest(g_gfTokenMethodRequest, operation, view_as<JsonBuilder>(GetNativeCell(2)));
}