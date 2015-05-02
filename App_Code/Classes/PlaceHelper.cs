using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;
/// <summary>
/// Summary description for PlaceHelper
/// </summary>
public static class PlaceHelper
{
    public static DataSet Creat_Ds()
    {
        SqlConnection con = new SqlConnection(@"server=Mustafa-PC\SQLEXPRESS;database=Transportation;integrated security=true;");
        con.Open();
        SqlCommand comm = con.CreateCommand();
        comm.CommandText = "select * from [Transportation].[dbo].[AREA_COORDINATES]";
        SqlDataAdapter Adapter = new SqlDataAdapter(comm);
        DataSet dset = new DataSet();
        Adapter.Fill(dset);
        return dset;
    }
}