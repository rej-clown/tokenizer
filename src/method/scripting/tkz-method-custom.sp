#pragma newdecls required

#define TOKENIZER_API

#include <tokenizer>

public Plugin myinfo = 
{
    name        = "[Tokenizer] Custom Tokens",
    author      = "rej.chev?",
    description = "...",
    version     = "1.0.0",
    url         = "discord.gg/ChTyPUG"
};

stock const char myself_path[] = 
    "core.method.custom";

static const char myself_encode[] =
    "core.method.custom.encode";

static const char shared_error[] =
    "core.message.error.send"

static const char core_config[] = 
    "core.config";

JsonObject error;

public void OnPluginStart()
{
    error = view_as<JsonObject>((new JsonBuilder("{}"))
                .SetString("path", "")
                .SetString("message", "")
                .SetString("target", "os")
                .Build());
}

public Action tokenizer_OnRequestSend(const char[] path, JsonBuilder data)
{
    if(!strcmp(path, myself_encode))
    {
        Action what;

        if((what = encodeCustom(data)) == Plugin_Handled)
        {
            error.SetString("path", myself_encode)
            error.SetString("message", "Attribute 'body.tokens-custom' is not exists or is not array");

            tokenizer_SendRequest(shared_error, error);
        }

        return what;
    }

    // handshake
    if(!strcmp(path, core_config))
    {
        char core_api_version[64];
        view_as<JsonObject>(data.Build())
            .GetString("VERSION_API", core_api_version, sizeof(core_api_version));

        if(strcmp(TOKENIZER_API_VERSION, core_api_version))
            SetFailState(API_OOD);
    }

    return Plugin_Continue;
}

public Action encodeCustom(JsonBuilder data)
{
    JsonObject body = view_as<JsonObject>(view_as<JsonObject>(data.Build()).Get("body"));

    if(!canBeEncoded(body))
        return Plugin_Handled;

    JsonArray custom = 
        asJSONA(body.Get("tokens-custom"));

    data.Set("tokens", custom);

    delete custom;

    data.Set("body", body);

    delete body;

    return Plugin_Changed;
}

bool canBeEncoded(JsonObject data)
{
    return (data.HasKey("tokens-custom")
    &&      JSONO_TYPE_EQUAL(data, "tokens-custom", JSON_ARRAY)
    );
}