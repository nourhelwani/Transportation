using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.Script.Serialization;
/// <summary>
/// Summary description for JSONHelper
/// </summary>
public static class JSONHelper
{
    public static string SerializeDataset(DataSet ds)
    {
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
        Dictionary<string, object> row;
        foreach (DataRow dr in ds.Tables[0].Rows)
        {
            row = new Dictionary<string, object>();
            foreach (DataColumn col in ds.Tables[0].Columns)
            {
                row.Add(col.ColumnName, dr[col]);
            }
            rows.Add(row);
        }
        return serializer.Serialize(rows);
    }
    public static string GetAllPlaces()
    {
        DataSet ds = PlaceHelper.Creat_Ds();
        return SerializeDataset(ds);
    }
}