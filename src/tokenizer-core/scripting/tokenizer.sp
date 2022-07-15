#pragma newdecls required

#include <tokenizer>

public Plugin myinfo = 
{
    name        = "[Tokenizer] core",
    author      = "rej.chev?",
    description = "...",
    version     = "1.0.0",
    url         = "discord.gg/ChTyPUG"
};

Json g_jsonConfig;

GlobalForward g_gfTokenCreateRequest;
GlobalForward g_gfTokenCreated;
GlobalForward g_gfTokenFromStorageRequest;
GlobalForward g_gfTokenActivateRequest;
GlobalForward g_gfTokenActivated;
GlobalForward g_gfTokenSecurityCheck;

GlobalForward g_gfOnTokenRequest;
GlobalForward g_gfTokenStorageRequest;
GlobalForward g_gfTokenSecurityRequest;

#include "tokenizer/forwards.sp"

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) 
{   
    // TODO: :/ 

    // Action tokenizer_OnTokenRequest(const char[] operation, JsonBuilder context) 
    g_gfOnTokenRequest = CreateGlobalForward(
        "tokenizer_OnTokenRequest", ET_Hook, Param_String, Param_Cell
    );

    // Action tokenizer_OnTokenSecurityRequest(const char[] operation, JsonBuilder context) 
    g_gfTokenSecurityRequest = CreateGlobalForward(
        "tokenizer_OnTokenSecurityRequest", ET_Hook, Param_String, Param_Cell
    );

    // Action tokenizer_OnTokenStorageRequest(const char[] operation, JsonBuilder context)  
    g_gfTokenFromStorageRequest = CreateGlobalForward(
        "tokenizer_OnTokenStorageRequest", ET_Hook, Param_String, Param_Cell    
    );

    RegPluginLibrary("tokenizer");

    if(late) OnAllPluginsLoaded();

    return APLRes_Success;
}

public void OnPluginStart()
{

}

public void OnAllPluginsLoaded()
{
   
}

public void OnMapStart()
{
    static const char configPath[] = 
            "configs/tokenizer/settings.json";

    if(!FileExists(configPath))
        SetFailState("Whare is my config: %s ?", configPath);

    g_jsonConfig = Json.JsonF(configPath, 0);
}

