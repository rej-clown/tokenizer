Action tokenRequest(const GlobalForward gf, const char[] operation, JsonBuilder context) 
{    
    Action what = Plugin_Continue;

    Call_StartForward(gf);
    Call_PushString(operation)
    Call_PushCell(context);
    Call_Finish(what);

    return what;
}
