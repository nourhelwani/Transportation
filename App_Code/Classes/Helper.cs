using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;

/// <summary>
/// Summary description for Helper
/// </summary>
public class Helper
{
    SqlConnection Connection;
    public Helper()
    {
        Connection = new SqlConnection(@"server=Mustafa-PC\SQLEXPRESS;database=Transportation;integrated security=true;");
    }
    public void OpenConnection()
    {
        if (Connection.State == ConnectionState.Closed || Connection.State == ConnectionState.Broken)
            Connection.Open();
    }
    public void CloseConnection()
    {
        if (Connection.State == ConnectionState.Open)
            Connection.Close();
    }
    public DataSet ExcuteSelectQuery(string quary)
    {
        // this.OpenConnection();
        SqlCommand Command = Connection.CreateCommand();
        Command.CommandText = quary;
        SqlDataAdapter Adapter = new SqlDataAdapter(Command);
        DataSet Dataset = new DataSet();
        Adapter.Fill(Dataset);
        this.CloseConnection();
        return Dataset;
    }
    public string ExcuteNonQuary(string quary)
    {
        try
        {
            // this.OpenConnection();
            SqlCommand Command = Connection.CreateCommand();
            Command.CommandText = quary;
            Command.ExecuteNonQuery();
            this.CloseConnection();
            return "Done";
        }
        catch (Exception e)
        {
            return e.Message;
        }
    }
}