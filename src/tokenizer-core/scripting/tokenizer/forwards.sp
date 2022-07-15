Json tokenCreateRequest(const char[] method, Json body) 
{    
    JsonBuilder output = 
            (new JsonBuilder("{}"))
            .SetString("method", method)
            .Set("body", body);

    Call_StartForward(g_gfTokenCreateRequest);
    Call_PushCell(body);
    Call_Finish();

    if(!JSON_TYPE_EQUAL(output, JSON_OBJECT))
        delete output;
    
    if(!output)
        output = (new JsonBuilder("{}"))
                    .SetString("method", method)
                    .Set ("tokens", null)
                    .Set("body", body);

    
    return output.Build();
}

void tokenCreated(const Json jsonTokenData)
{
    Call_StartForward(tokenizer_OnTokenCreated);
    Call_PushCell(jsonTokenData);
    Call_Finish();
}

Json tokenFromStorageRequest(const char[] storage, const char[] token)
{
    static char jsonTemplate[PLATFORM_MAX_PATH];
    FormatEx(jsonTemplate, sizeof(jsonTemplate), 
             "{ \n
                \"storage\": \"%s\", \n
                \"token\": \"%s\", \n    
                \"body\": null
             }", 
             storage,
             token 
    );

    JsonBuilder output = new JsonBuilder(jsonTemplate);

    Call_StartForward(g_gfTokenFromStorageRequest);
    Call_PushCell(output);
    Call_Finish();

    if(!JSON_TYPE_EQUAL(output, JSON_OBJECT) || !JSONO_TYPE_EQUAL(output, "body", JSON_OBJECT))
        delete output;

    if(!output)
        output = new JsonBuilder(jsonTemplate);

    return output.Build();
}