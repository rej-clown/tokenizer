Action tokenRequest(const char[] path, Json context) 
{    
    Action what = Plugin_Continue;

    JsonBuilder data = 
        new JsonBuilder("{}");

    if(context)
        asJSONO(data)
            .Update(asJSONO(context), JSON_UPDATE);

    Call_StartForward(g_gfOnTokenRequest);
    Call_PushString(path)
    Call_PushCell(data);
    Call_Finish(what);

    if(context && what == Plugin_Changed)
        asJSONO(context).Update(asJSONO(data.Build()), JSON_UPDATE);

    if(what < Plugin_Stop)
    {
        asJSONO(data.Build()).Clear();

        if(context)
            asJSONO(data.Build())
                .Update(asJSONO(context), JSON_UPDATE);

        Call_StartForward(g_gfOnTokenResponse);
        Call_PushString(path);
        Call_PushCell(data.Build());
        Call_Finish();
    }

    delete data;
    return what;
}
