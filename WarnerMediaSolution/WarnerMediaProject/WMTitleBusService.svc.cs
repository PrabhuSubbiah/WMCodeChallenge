using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;  


namespace WarnerMediaProject
{
    [ServiceContract(Namespace = "")]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class WMTitleBusService
    {
        // To use HTTP GET, add [WebGet] attribute. (Default ResponseFormat is WebMessageFormat.Json)
        // To create an operation that returns XML,
        //     add [WebGet(ResponseFormat=WebMessageFormat.Xml)],
        //     and include the following line in the operation body:
        //         WebOperationContext.Current.OutgoingResponse.ContentType = "text/xml";
        [OperationContract]
        public string GetData(string strSearch)
        {
            SqlConnection con = new SqlConnection("Data Source=VISHNUKUTTI;Initial Catalog=Titles;User ID=sa;Password=vishnu123");
            con.Open();
            SqlCommand cmd  = null;
            if(string.IsNullOrEmpty(strSearch))
               cmd = new SqlCommand("Select * from title", con);
            else
                cmd = new SqlCommand("Select * from title where titlename like '%" + strSearch + "%'" , con);

            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            sda.Fill(ds);
            cmd.ExecuteNonQuery();
            con.Close();
            DataTable dt = ds.Tables[0];
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            return serializer.Serialize(rows);
        }

        [OperationContract]
        public string GetStoryLine(string strSearch)
        {
            SqlConnection con = new SqlConnection("Data Source=VISHNUKUTTI;Initial Catalog=Titles;User ID=sa;Password=vishnu123");
            con.Open();
            SqlCommand cmd  = null;
            if(string.IsNullOrEmpty(strSearch))
                cmd = new SqlCommand("Select Description, Language from storyline", con);
            else
                cmd = new SqlCommand("Select Description, Language from storyline where titleid = " + strSearch, con);

            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            sda.Fill(ds);
            cmd.ExecuteNonQuery();
            con.Close();
            DataTable dt = ds.Tables[0];
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            return serializer.Serialize(rows);
        }

        [OperationContract]
        public string GetAwards(string strSearch)
        {
            SqlConnection con = new SqlConnection("Data Source=VISHNUKUTTI;Initial Catalog=Titles;User ID=sa;Password=vishnu123");
            con.Open();
            SqlCommand cmd = null;
            if (string.IsNullOrEmpty(strSearch))
                cmd = new SqlCommand("Select awardwon, awardyear, award,awardcompany from award", con);
            else
                cmd = new SqlCommand("Select awardwon, awardyear, award,awardcompany from award where titleid = " + strSearch, con);

            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            sda.Fill(ds);
            cmd.ExecuteNonQuery();
            con.Close();
            DataTable dt = ds.Tables[0];
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            return serializer.Serialize(rows);
        }


        // Add more operations here and mark them with [OperationContract]
    }
}
