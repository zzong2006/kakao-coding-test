package com.kakaotest.sqlparquet;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import java.io.FileReader;
import java.util.Hashtable;

// ParsingJSON class : Parsing input json file and get information used in SQLToParquet and PareutToText
public class ParsingJSON {
    JSONParser parser ;
    private long concurrency ;              // The number of threads of writing parquet file
    Hashtable<String, String> info = new Hashtable<>();

    public long getConcurrency() {
        return concurrency;
    }

    public ParsingJSON(String fileName){
        parser = new JSONParser();
        try{
            JSONArray jsonArray =  (JSONArray) parser.parse(new FileReader(fileName));
            JSONObject inputObject = (JSONObject) ((JSONObject) jsonArray.get(0)).get("MENULOG_ETL_Job");
            // concurrency
            concurrency = (long) inputObject.get("concurrency");

            // source
            JSONObject sourceObject = (JSONObject) inputObject.get("source");
            info.put( "mysqlURL", sourceObject.get("mysql_server") + ":"
                    +sourceObject.get("mysql_port") + "/"
                    +sourceObject.get("database") + "?serverTimezone="
                    +sourceObject.get("serverTimezone")
            );
            info.put("userName", (String)sourceObject.get("user"));
            info.put("passWord", (String)sourceObject.get("password"));
            info.put("tableName", (String)sourceObject.get("table"));
            info.put("fieldNames", (String)sourceObject.get("fieldName"));

            // transform
            JSONObject transformObject = (JSONObject) inputObject.get("transform");
            info.put("schema", (String)transformObject.get("schema"));

            // target
            JSONObject targetObject = (JSONObject) inputObject.get("target");
            info.put("hdfsURL", targetObject.get("hdfs_server") + ":" +
                    targetObject.get("nameNode_port")   );
            info.put("outputPath", (String)targetObject.get("outputPath"));
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    public Hashtable<String, String> getInfo() {
        return info;
    }

    // For local test
    public static void main(String[] args) {
        ParsingJSON a = new ParsingJSON("/tmp/jobJSON.json");

    }
}
