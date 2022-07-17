#if defined _tokenizer_included
 #endinput
#endif
#define _tokenizer_included

#define TOKENIZER_API_VERSION   "1.0.0"

#if defined TOKENIZER_API
    #define API_OOD         "The plugin module uses an outdated API. You must update it. Comp. API key: "...TOKENIZER_API_VERSION
#endif

#include <jansson>

native Action tokenizer_SendRequest(const char[] path, Json data);

forward Action  tokenizer_OnRequestSend(const char[] path, JsonBuilder data);
forward void    tokenizer_OnResponseSend(const char[] path, const Json data);

public SharedPlugin __pl_tokenizer= 
{
    name = "tokenizer",
    file = "tokenizer.smx",
#if defined REQUIRE_PLUGIN
    required = 1
#else
    required = 0
#endif
};
