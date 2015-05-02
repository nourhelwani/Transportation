using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Web.Script.Serialization;
public partial class Pages_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [System.Web.Script.Services.ScriptMethod()]
    [System.Web.Services.WebMethod]
    public static List<string> getPlaceName(string prefixText)
    {
        SqlConnection con = new SqlConnection(@"server=Mustafa-PC\SQLEXPRESS;database=Transportation;integrated security=true;");
        con.Open();
        SqlCommand Command = con.CreateCommand();
        Command.CommandText = "SELECT [AREA_NAME] FROM [Transportation].[dbo].[AREA_COORDINATES] where [AREA_NAME] like N'%" + prefixText + "%' ;";
        SqlDataReader reader = Command.ExecuteReader();
        List<string> areaName = new List<string>();
        while (reader.Read())
        {
            areaName.Add(reader[0].ToString());
        }
        return areaName;
    }
}