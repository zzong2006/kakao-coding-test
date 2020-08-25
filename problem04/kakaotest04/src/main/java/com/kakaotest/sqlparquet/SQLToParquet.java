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

public class SQLToParquet extends Configured implements Tool {
    private String driverClass = "com.mysql.cj.jdbc.Driver";
    private String dbUrl = "jdbc:mysql://localhost:3306/KAKAOBANK?serverTimezone=UTC";
    private String userName = "root";
    private String passwd = "db171!";
    private Path outputPath = new Path("/tmp/test003");

    private static MessageType schema = MessageTypeParser.parseMessageType(
            "message Pair {\n" +
                    " required binary logTimestamp (UTF8);\n" +
                    " required binary logID (UTF8);\n" +
                    " required binary userNo;\n" +
                    " required binary menuName;\n" +
                    "}"
    );

    @Override
    public int run(String[] strings) throws Exception {
        if(strings.length != 1) {
            System.err.println("Usage: SQLParquetWriter <Job_json_file>");
            System.exit(2);
        }

        ParsingJSON jsonInfo = new ParsingJSON(strings[0]);
        Configuration conf = new Configuration();
        DBConfiguration.configureDB(conf, driverClass,
                jsonInfo.getInfo().get("mysqlURL"),
                jsonInfo.getInfo().get("userName"),
                jsonInfo.getInfo().get("passWord"));

        Job job = Job.getInstance(conf);
        job.setJarByClass(getClass());

        MultithreadedMapper.setMapperClass(job, customMapper.class);
        MultithreadedMapper.setNumberOfThreads(job, (int)jsonInfo.getConcurrency());
        job.setMapperClass(MultithreadedMapper.class);
        job.setNumReduceTasks(0);

        job.setMapOutputKeyClass(Void.class);
        job.setMapOutputValueClass(Group.class);

        job.setOutputKeyClass(Void.class);
        job.setOutputValueClass(Group.class);

        job.setInputFormatClass(DBInputFormat.class);
        job.setOutputFormatClass(ExampleOutputFormat.class);
        ExampleOutputFormat.setSchema(job, MessageTypeParser.parseMessageType(jsonInfo.getInfo().get("schema")));

        FileOutputFormat.setOutputPath(job, new Path(jsonInfo.getInfo().get("hdfsURL") + jsonInfo.getInfo().get("outputPath")));
        DBInputFormat.setInput(job, CustomWritable.class, jsonInfo.getInfo().get("tableName"), null,
                null, jsonInfo.getInfo().get("fieldNames").split(","));
        return job.waitForCompletion(true) ? 0 : 1;
    }

    public static class customMapper extends Mapper<LongWritable, CustomWritable, Void, Group>{
        private GroupFactory groupFactory = new SimpleGroupFactory(schema);

        @Override
        protected void map(LongWritable key, CustomWritable value, Context context) throws IOException, InterruptedException {
            Group groupIns = groupFactory.newGroup().append("logTimestamp",value.getLogTimestamp())
                    .append("logID",value.getLogID())
                    .append("userNo",value.getUserNumber())
                    .append("menuName",value.getMenuName());
            context.write(null, groupIns);
        }
    }

    public static void main(String[] args) throws Exception {
        int res = ToolRunner.run(new Configuration(), new SQLToParquet(), args);
        System.exit(res);
    }
}
