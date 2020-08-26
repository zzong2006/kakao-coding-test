package com.kakaotest.sqlparquet;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.mapred.lib.db.DBConfiguration;
import org.apache.hadoop.mapred.lib.db.DBInputFormat;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.lib.map.MultithreadedMapper;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;
import org.apache.parquet.example.data.Group;
import org.apache.parquet.example.data.GroupFactory;
import org.apache.parquet.example.data.simple.SimpleGroupFactory;
import org.apache.parquet.hadoop.example.ExampleOutputFormat;
import org.apache.parquet.schema.MessageType;
import org.apache.parquet.schema.MessageTypeParser;

import java.io.IOException;


// SQLToParquet Class : Do job which converts MySQL data to Parquet data and save them into HDFS
public class SQLToParquet extends Configured implements Tool {
    private String driverClass = "com.mysql.cj.jdbc.Driver";        // Need jdbc driver for accessing the MySQL server
    private static MessageType schema;
    @Override
    public int run(String[] strings) throws Exception {
        if(strings.length != 1) {
            System.err.println("Usage: SQLToParquet <Job_json_file>");
            System.exit(2);
        }

        ParsingJSON jsonInfo = new ParsingJSON(strings[0]);         // parsing json file
        Configuration conf = new Configuration();
        DBConfiguration.configureDB(conf, driverClass,              // Access the MySQL Server
                jsonInfo.getInfo().get("mysqlURL"),
                jsonInfo.getInfo().get("userName"),
                jsonInfo.getInfo().get("passWord"));

        Job job = Job.getInstance(conf);
        job.setJarByClass(getClass());

        MultithreadedMapper.setMapperClass(job, customMapper.class);            // Register mapper class
        // If the json file contains concurrency value more than 1, then do multi-threading map
        // Warning : ParquetWriter could not be thread-safe.
        MultithreadedMapper.setNumberOfThreads(job, (int)jsonInfo.getConcurrency());
        job.setMapperClass(MultithreadedMapper.class);
        job.setNumReduceTasks(0);                 // Since this job only convert SQL to parquet file, make only to do map, not reduce.

        job.setMapOutputKeyClass(Void.class);       // not necessary
        job.setMapOutputValueClass(Group.class);    // Group : parquet logical types

        job.setOutputKeyClass(Void.class);          // not necessary
        job.setOutputValueClass(Group.class);       // Group : parquet logical types

        job.setInputFormatClass(DBInputFormat.class);       // Input : MySQL
        job.setOutputFormatClass(ExampleOutputFormat.class);        // Output : Parquet Format

        schema = MessageTypeParser.parseMessageType(jsonInfo.getInfo().get("schema"));      // Parsing the schema
        ExampleOutputFormat.setSchema(job, schema);

        // Save to HDFS
        FileOutputFormat.setOutputPath(job, new Path(jsonInfo.getInfo().get("hdfsURL") + jsonInfo.getInfo().get("outputPath")));
        // Just SELECT * From MENU_LOG
        DBInputFormat.setInput(job, CustomWritable.class, jsonInfo.getInfo().get("tableName"), null,
                null, jsonInfo.getInfo().get("fieldNames").split(","));
        return job.waitForCompletion(true) ? 0 : 1;
    }

    // Mapper Function (Note : only do map)
    public static class customMapper extends Mapper<LongWritable, CustomWritable, Void, Group>{
        private GroupFactory groupFactory = new SimpleGroupFactory(schema);

        @Override
        protected void map(LongWritable key, CustomWritable value, Context context) throws IOException, InterruptedException {
            // Make Group type parquet variable
            Group groupIns = groupFactory.newGroup().append("logTimestamp",value.getLogTimestamp())
                    .append("logID",value.getLogID())
                    .append("userNo",value.getUserNumber())
                    .append("menuName",value.getMenuName());
            context.write(null, groupIns);
        }
    }

    // For local test
    public static void main(String[] args) throws Exception {
        int res = ToolRunner.run(new Configuration(), new SQLToParquet(), args);
        System.exit(res);
    }
}
