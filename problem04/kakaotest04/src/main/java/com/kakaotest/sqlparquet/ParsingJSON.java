package com.kakaotest.sqlparquet;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import java.io.FileReader;
import java.util.Hashtable;

public class ParsingJSON {
    JSONParser parser ;
    private long concurrency ;       // The number of threads of writing parquet file
    Hashtable<String, String> info = new Hashtable<>();

    public long getConcurrency() {
        return concurrency;
    }

    public ParsingJSON(String fileName){
        parser = new JSONParser();
        try{                            // get source input
            JSONArray jsonArray =  (JSONArray) parser.parse(new FileReader(fileName));
            JSONObject inputObject = (JSONObject) ((JSONObject) jsonArray.get(0)).get("MENULOG_ETL_Job");
            concurrency = (long) inputObject.get("concurrency");

            JSONObject sourceObject = (JSONObject) inputObject.get("source");
            info.put( "mysqlURL", (String)sourceObject.get("mysql_server") + ":"
                    +(String)sourceObject.get("mysql_port") + "/"
                    +(String)sourceObject.get("database") + "?serverTimezone="
                    +(String)sourceObject.get("serverTimezone")
            );
            info.put("userName", (String)sourceObject.get("user"));
            info.put("passWord", (String)sourceObject.get("password"));
            info.put("tableName", (String)sourceObject.get("table"));
            info.put("fieldNames", (String)sourceObject.get("fieldName"));

            JSONObject transformObject = (JSONObject) inputObject.get("transform");
            info.put("schema", (String)transformObject.get("schema"));

            JSONObject targetObject = (JSONObject) inputObject.get("target");
            info.put("hdfsURL", (String)targetObject.get("hdfs_server") + ":" +
                    (String)targetObject.get("nameNode_port")   );
            info.put("outputPath", (String)targetObject.get("outputPath"));
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    public Hashtable<String, String> getInfo() {
        return info;
    }

    public static void main(String[] args) {
        ParsingJSON a = new ParsingJSON("/tmp/jobJSON.json");

    }
}
