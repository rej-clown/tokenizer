#include <tokenizer>

static const char operation_create[] = "core.token.operation.create";

public void OnPluginStart()
{
    LoadTranslations("tokenizer-token.phrases");

    RegConsoleCmd("sm_token_create", onCreateToken);
}

// sm_create_token <method> <count> <security> <body>
Action onCreateToken(int iClient, int args)
{
    if(args != 4)
        return Plugin_Handled;

    JsonBuilder context = new JsonBuilder("{}");

    char method[PLATFORM_MAX_PATH];
    GetCmdArg(1, method, sizeof(method));

    char count[PLATFORM_MAX_PATH];
    GetCmdArg(2, count, sizeof(count));

    char security[PLATFORM_MAX_PATH];
    GetCmdArg(3, security, sizeof(security));

    char body[512];
    GetCmdArg(4, body, sizeof(body));

    char auth[66];
    if(!GetClientAuthId(iClient, AuthId_Engine, auth, sizeof(auth)))
        return Plugin_Handled;

    Json o;
    Json s;
    context
        .SetString("method", method)
        .SetInt("count", StringToInt(count))
        .SetString("client_sid", auth)
        .Set("tokens", null)
        .Set("security", (s = (new JsonBuilder((security[0]) ? security : null)).Build()))
        .Set("body", (o = (new JsonBuilder(body)).Build()));


    CreateToken(iClient, operation_create, context);

    delete o;
    delete s;
    delete context;
    return Plugin_Handled;
}

public void CreateToken(int who, const char[] operation, JsonBuilder context)
{
    Action whatNext;
    JsonBuilder buffer = new JsonBuilder("{}");

    asJSONO(buffer.Build())
        .Update(asJSONO(context.Build()), JSON_UPDATE_RECURSIVE);

    if((whatNext = tokenizer_TokenSecurity("core.security.operation.test", buffer)) < Plugin_Handled)
        if((whatNext = tokenizer_Token(operation, buffer)) == Plugin_Changed && !asJSON(buffer).Equal(context.Build()))
            whatNext = tokenizer_TokenStorage(operation, buffer);

    if(whatNext == Plugin_Changed)
        SendMessage(who, operation, buffer);

    delete buffer;
}

public Action tokenizer_OnTokenRequest(const char[] operation, JsonBuilder context)
{
    if(strcmp(operation, operation_create))
        return Plugin_Continue;

    static const char operation_method[] = "core.method.operation.encode";

    return tokenizer_TokenMethodGeneration(operation, context);    
}

void SendMessage(int target, const char[] operation, JsonBuilder context)
{
    Json body = asJSONO(context.Build()).Get("body");
    Json tokens = asJSONO(context.Build()).Get("tokens");

    char authT[66];
    char body_s[512];
    char token[PLATFORM_MAX_PATH];

    body.ToString(body_s, sizeof(body_s), 0);
    context.GetString("auth", authT, sizeof(authT));

    for(int i = 0; i < asJSONA(tokens).Length; i++)
    {
        asJSONA(tokens).GetString(i, token, sizeof(token));

        LogMessage("Токен [ %s ] создан %s. Тело: %s", token, authT, body);   
    }

    delete body;
    delete tokens;
}