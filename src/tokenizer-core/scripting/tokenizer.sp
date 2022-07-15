#pragma newdecls required

#include <jansson>

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
GlobalForward g_gfTokenRemoveRequest;

#include "tokenizer/forwards.sp"

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) 
{    
    // Json tokenizer_OnTokenCreateRequest(const char[] method, const Json body)
    g_gfTokenCreateRequest = CreateGlobalForward(
        "tokenizer_OnTokenCreateRequest", ET_Hook, Param_Cell
    );

    // void tokenizer_OnTokenCreated(const Json tokenData)
    g_gfTokenCreated = CreateGlobalForward(
        "tokenizer_OnTokenCreated", ET_Ignore, Param_Cell
    );

    // Json tokenizer_OnTokenFromStorageRequest(const char[] storage, const char[] token) 
    g_gfTokenFromStorageRequest = CreateGlobalForward(
        "tokenizer_OnTokenFromStorageRequest", ET_Hook, Param_Cell
    );

    // bool tokenizer_OnTokenActivateRequest(const int whoActivate, const Json tokenData)
    // @oaram whoActivate   Игрок, который пытается использовать токен
    // @param tokenData     Объект с данными, содержит (method, token, secProviders, body) [body - объект содержит любое количество аттрибутов; secProviders - массив с валидаторами]
    // @return              true - запрос успешен, false - ключ тупо не валиден? (TODO: продумать)
    g_gfTokenActivateRequest = CreateGlobalForward(
        "tokenizer_OnTokenActivateRequest", ET_Hook, Param_Cell, Param_Cell
    );

    // void tokenizer_OnTokenActivated(const int whoActivated, const char[] token)
    // На этом моменте токен уже использован. Отправка запроса на удаление
    g_gfTokenActivated = CreateGlobalForward(
        "tokenizer_OnTokenActivated", ET_Ignore, Param_Cell, Param_String
    );

    // bool tokenizer_OnTokenSecurityCheck(const char[] secProvider, const Json context)
    // Вызывается из модуля-услуги(VIP, SHOP...) для валидации токена (срок годности, количество использований и т.д.) 
    // @param secProvider   Имя валидатора (уникальное)
    // @param context       Контекст, содержит в себе аттрибут, который резервирует secProvider
    // @return              true - ключ прошел проверку (валиден), иначе - false
    g_gfTokenSecurityCheck = CreateGlobalForward(
        "tokenizer_OnTokenSecurityCheck", ET_Hook, Param_String, Param_Cell
    )

    // void tokenizer_OnTokenRemoveRequest(const char[] token, const char[] reason)
    // Запрос на удаление, может быть проигнорирован.
    // Эта штука можут вызываться при непрохождении валидатора (если токен персональный, по STEAM_ID например, то понятное дело стоит проигнорить)
    // Вообще, если есть secProvider'ы, то стоит оставить вызов только на них, наверное....
    g_gfTokenRemoveRequest = CreateGlobalForward(
        "tokenizer_OnTokenRemoveRequest", ET_Ignore, Param_String, Param_String 
    )

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

