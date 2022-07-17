// Action tokenizer_Token(const char[] operation, JsonBuilder context)
public any tokenToken(Handle plugin, int params)
{
    char path[PLATFORM_MAX_PATH];
    GetNativeString(1, path, sizeof(path));

    return tokenRequest(path, view_as<Json>(GetNativeCell(2)));
}
