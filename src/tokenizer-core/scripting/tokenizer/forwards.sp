Action tokenRequest(const GlobalForward globalForward, const char[] operation, JsonBuilder context) 
{    
    Action what = Plugin_Continue;

    Call_StartForward(globalForward);
    // Call_PushString(path);
    Call_PushString(operation)
    Call_PushCell(context);
    Call_Finish(what);

    return what;
}
