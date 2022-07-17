#pragma newdecls required

#include <tokenizer>

#if !defined TOKENIZER_VERSION
    #define TOKENIZER_VERSION "1.0.0"
#endif

public Plugin myinfo = 
{
    name        = "[Tokenizer] core",
    author      = "rej.chev?",
    description = "...",
    version     = TOKENIZER_VERSION,
    url         = "discord.gg/ChTyPUG"
};

Json g_jsonConfig;

GlobalForward g_gfOnTokenRequest;
GlobalForward g_gfOnTokenResponse;

static const char myself_path[] = "core";
static const char myself_config[] = "core.config";

#include "tokenizer/natives.sp"
#include "tokenizer/forwards.sp"

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) 
{ 
    // Action tokenizer_OnTokenRequest(const char[] path, JsonBuilder data)
    // @param path      Some data path
    // @param data      Json data buffer which can be modified 
    // @return          Plugin_Continue - не изменяет data (гарантирует вызов response)
    //                  Plugin_Change   - в data есть изменения (гарантирует вызов response)
    //                  Plugin_Handle   - не применяет внесенные изменения в data (гарантирует вызов response)
    //                  Plugin_Stop     - не применяет внесенные изменения в data (не вызывает response)
    g_gfOnTokenRequest = CreateGlobalForward(
        "tokenizer_OnRequestSend", ET_Hook, Param_String, Param_Cell
    );

    // void tokenizer_OnResponceSend(const char[] path, const Json data)
    // @param path      Some data path
    // @param data      Buffered data saved after request
    g_gfOnTokenResponse = CreateGlobalForward(
        "tokenizer_OnResponseSend", ET_Ignore, Param_String, Param_Cell
    );

    // Calltrace: tokenizer_SendRequest -> tokenizer_OnRequestSend -> ?g_gfOnTokenResponse  
    CreateNative("tokenizer_SendRequest",                     tokenToken);
    
    RegPluginLibrary("tokenizer");

    // if(late) OnAllPluginsLoaded();

    return APLRes_Success;
}

public void OnPluginStart()
{
    tokenizer_SendRequest(myself_path, null);
}

public void OnMapStart()
{
    static const char configPath[] = 
        "configs/tokenizer/settings.json";

    if(!FileExists(configPath))
        SetFailState("Where is my config: %s ?", configPath);

    g_jsonConfig = Json.JsonF(configPath, 0);
    asJSONO(g_jsonConfig).SetString("VERSION_API", TOKENIZER_API_VERSION);
    asJSONO(g_jsonConfig).SetString("VERSION", TOKENIZER_VERSION);

    tokenizer_SendRequest(myself_config, g_jsonConfig);
}

// заглушка
public Action tokenizer_OnRequestSend(const char[] path, JsonBuilder data)
{
    return (strcmp(path, myself_config)) ? Plugin_Continue : Plugin_Stop;
}

