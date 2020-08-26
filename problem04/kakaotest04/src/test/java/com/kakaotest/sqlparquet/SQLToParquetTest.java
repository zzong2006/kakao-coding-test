package com.kakaotest.sqlparquet;

import static org.junit.jupiter.api.Assertions.*;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileUtil;
import org.apache.hadoop.hdfs.MiniDFSCluster;
import org.apache.hadoop.util.ToolRunner;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;

import java.io.File;
import java.lang.reflect.Field;
import java.nio.file.Files;
import java.text.MessageFormat;
import java.util.UUID;

// If you would prefer that JUnit Jupiter execute all test methods on the same test instance
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class SQLToParquetTest {
    protected String hdfsUri;
    protected Configuration conf;
    private File testDir;
    private MiniDFSCluster miniDFSCluster;

    @BeforeAll
    public void setUp() throws Exception {
        if (System.getProperty("os.name").toLowerCase().contains("windows")) {
            File winutilsFile = new File(
                    getClass().getClassLoader().getResource("hadoop/bin/winutils.exe").toURI());
            System.setProperty("hadoop.home.dir",
                    winutilsFile.getParentFile().getParentFile().getAbsolutePath());
            System.setProperty("java.library.path", winutilsFile.getParentFile().getAbsolutePath());
            Field fieldSysPath = ClassLoader.class.getDeclaredField("sys_paths");
            fieldSysPath.setAccessible(true);
            fieldSysPath.set(null, null);
        }

        testDir = Files.createTempDirectory("test_hdfs").toFile();
        conf = new Configuration();     // Read core-default.xml, core-site.xml
        conf.set(MiniDFSCluster.HDFS_MINIDFS_BASEDIR, testDir.getAbsolutePath());
        miniDFSCluster = new MiniDFSCluster.Builder(conf).nameNodePort(11000).build();
        hdfsUri = miniDFSCluster.getURI().toString();
    }


    @AfterAll
    public void tearDown() {
        miniDFSCluster.shutdown();
        FileUtil.fullyDelete(testDir, true);
    }

    @Test
    public void testRandom() throws Exception{
        // Make random output file name
        String tempOutput = MessageFormat.format("{0}_{1}", "Output", UUID.randomUUID());
        String tempTextOutput = MessageFormat.format("{0}_{1}", "OutputText", UUID.randomUUID());
        String TesthdfsUri = "hdfs://localhost:9000";

        // Convert MySQL data to Parquet data
        String[] args = {"/tmp/jobJSON.json"};
        int res = ToolRunner.run(new SQLToParquet(), args);

        // Convert Parquet data to Text data
        String[] args2 = {"/tmp/jobJSON.json", tempTextOutput};
        int res2 = ToolRunner.run(conf, new ParquetToText(), args2);

    }
}
