package com.kakaotest.sqlparquet;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;
import org.apache.parquet.example.data.Group;
import org.apache.parquet.hadoop.example.ExampleInputFormat;

import java.io.IOException;

// ParquetToText class : Do job which converts Parquet data to Text data and save them into HDFS
public class ParquetToText extends Configured implements Tool {
    // Mapper Function (Note : only do map)
    public static class ParquetToTextMapper extends Mapper<Void, Group, NullWritable, Text> {
        @Override
        protected void map(Void key, Group value, Context context)
                throws IOException, InterruptedException {
            context.write(NullWritable.get(), new Text(value.toString()));
        }
    }

    @Override
    public int run(String[] strings) throws Exception {
        if(strings.length != 2) {
            System.err.println("Usage: ParquetToText <Job_json_file_used_in_SQLParquetWriter> <output>");
            System.exit(2);
        }
        // parsing json file to get output path of SQLToParquet job
        ParsingJSON jsonInfo = new ParsingJSON(strings[0]);
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf);

        FileInputFormat.addInputPath(job, new Path(jsonInfo.getInfo().get("hdfsURL") + jsonInfo.getInfo().get("outputPath")));
        FileOutputFormat.setOutputPath(job, new Path(strings[1]));

        job.setMapperClass(ParquetToTextMapper.class);
        job.setNumReduceTasks(0);       // Since this job only convert parquet to text file, make only to do map, not reduce.

        job.setInputFormatClass(ExampleInputFormat.class);

        job.setOutputKeyClass(NullWritable.class);
        job.setOutputValueClass(Text.class);

        return job.waitForCompletion(true) ? 0 : 1;
    }

    // For local test
    public static void main(String[] args) throws Exception {
        int exitCode = ToolRunner.run(new ParquetToText(), args);
        System.exit(exitCode);
    }
}
