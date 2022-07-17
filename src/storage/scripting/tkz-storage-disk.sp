#pragma newdecls required

#define TOKENIZER_API

#include <tokenizer>

stock const char myself_path[] =
    "core.storage.disk";

static const char myself_write[] =
    "core.storage.disk.write";

stock const char myself_read[] = 
    "core.storage.disk.read";

static const char core_config[] =
    "core.config";

static const char shared_error[] =
    "core.message.error.send";

// TODO:123
char myself_data_path[PLATFORM_MAX_PATH];

typedef func_comparator = 
    function bool(const char[] left, const char[] right);

public void OnPluginStart()
{
    
}

public Action tokenizer_OnRequestSend(const char[] path, JsonBuilder data)
{
    if(!strcmp(path, core_config))
    {
        char core_api_version[64];
        view_as<JsonObject>(data.Build())
            .GetString("VERSION_API", core_api_version, sizeof(core_api_version));

        if(strcmp(TOKENIZER_API_VERSION, core_api_version))
            SetFailState(API_OOD);

        Json error;
        if((error = ReadStoragePathFromConfig(view_as<JsonObject>(data))) != null)
        {
            tokenizer_SendRequest(shared_error, error);
            delete error;
        }
    }

    /*
    {
        "<token>"
        {
            <any data>
        },

        "<token-2>"
        {
            <any data>
        }
    }
    */

    if(!strcmp(path, myself_read))
    {
        Json error;
        if((error = ReadStorage(view_as<JsonObject>(data.Build()))) == null)
            return Plugin_Changed;

        tokenizer_SendRequest(shared_error, error);
        delete error;

        return Plugin_Handled;
    } 

    if(!strcmp(path, myself_write))
    {
        Json storage
        if(tokenizer_SendRequest(myself_read, storage) != Plugin_Changed)
        {
            delete storage;
            return Plugin_Handled;
        }

        view_as<JsonObject>(storage).Update(view_as<JsonObject>(data.Build()), JSON_UPDATE_MISSING);
        view_as<Json>(storage).ToFile(myself_data_path, JSON_INDENT(4));

        delete storage;
    }

    return Plugin_Continue;
}

Json ReadStoragePathFromConfig(const JsonObject config)
{
    JsonBuilder error = 
        new JsonBuilder("{}");

    if(config.HasKey("storage") && JSONO_TYPE_EQUAL(config, "storage", JSON_OBJECT))
    {
        JsonObject storage = 
            view_as<JsonObject>(config.Get("storage"));

        if(storage.HasKey("disk") && JSONO_TYPE_EQUAL(storage, "disk", JSON_OBJECT))
        {
            JsonObject disk = 
                view_as<JsonObject>(storage.Get("disk"));

            if(disk.HasKey("path") && JSONO_TYPE_EQUAL(disk, "path", JSON_STRING))
            {
                disk.GetString("path", myself_data_path, sizeof(myself_data_path));
                
                BuildPath(Path_SM, myself_data_path, sizeof(myself_data_path), myself_data_path);
                
                delete error;
            }
            else error.SetString("message", "Attribute 'storage.disk.path' is not exists or is not string");

            delete disk;
        }
        else error.SetString("message", "Attribute 'storage.disk' is not exists or is not object");

        delete storage;
    }
    else error.SetString("message", "Attribute 'storage' is not exists or is not object");
    

    return error ? (error
                    .SetString("path", myself_path)
                    .SetString("target", "os")
                    .Build()) 
                : null;
}

Json ReadStorage(JsonObject data)
{
    JsonArray filters = 
        view_as<JsonArray>(data.Get("filters"));

    Json tokens = 
        Json.JsonF(myself_data_path, 0);

    Json error = 
        (new JsonBuilder("{}"))
            .SetString("path", myself_read)
            .SetString("target", "os")
            .Build();

    if(tokens && filters && filters.Length)
    {
        // TODO: another comparator
        remove_if(tokens, filters, equal);
    }

    return error;
}

// TODO: ...
void remove_if(Json tokens, JsonArray filter, func_comparator comparator)
{

}

bool equal(const char[] left, const char[] right)
{
    return !(strcmp(left, right));
}