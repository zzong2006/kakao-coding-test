package com.kakaotest.sqlparquet;


import org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapred.lib.db.DBWritable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CustomWritable implements Writable, DBWritable {
    private String logTimestamp;
    private String logID;
    private String userNumber;
    private String menuName;

    @Override
    public void write(DataOutput dataOutput) throws IOException {
        dataOutput.writeUTF(logTimestamp);
        dataOutput.writeUTF(logID);
        dataOutput.writeUTF(userNumber);
        dataOutput.writeUTF(menuName);
    }

    public String getLogTimestamp() {
        return logTimestamp;
    }

    public String getLogID() {
        return logID;
    }

    public String getUserNumber() {
        return userNumber;
    }

    public String getMenuName() {
        return menuName;
    }

    @Override
    public void readFields(DataInput dataInput) throws IOException {
        logTimestamp = dataInput.readUTF();
        logID = dataInput.readUTF();
        userNumber = dataInput.readUTF();
        menuName = dataInput.readUTF();
    }

    @Override
    public void write(PreparedStatement preparedStatement) throws SQLException {
        preparedStatement.setString(1, logTimestamp);
        preparedStatement.setString(2, logID);
        preparedStatement.setString(3, userNumber);
        preparedStatement.setString(4, menuName);
    }

    @Override
    public void readFields(ResultSet resultSet) throws SQLException {
        logTimestamp = resultSet.getString(1);
        logID = resultSet.getString(2);
        userNumber = resultSet.getString(3);
        menuName = resultSet.getString(4);
    }
}
