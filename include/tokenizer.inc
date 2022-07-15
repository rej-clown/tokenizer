#if defined _tokenizer_included
 #endinput
#endif
#define _tokenizer_included

#define TOKENIZER_API_KEY             17042022

#if defined TOKENIZER_API
    #define API_OOD         "The plugin module uses an outdated API. You must update it. Comp. API key: "...TOKENIZER_API_KEY    
#endif

enum STORAGE_OPERATION
{
    STORAGE_CREATE = 0,
    STORAGE_READ,
    STORAGE_UPDATE,
    STORAGE_DELETE,

    STORAGE_OPERATIONS_END
};

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
