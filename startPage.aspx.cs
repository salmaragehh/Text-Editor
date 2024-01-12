/*
* Filename: startPage.aspx.cs
* Project: Text Editor
* By: Salma Rageh  
* Date: 2023-12-01
* Description: This file and it's functions correspond with the events that happen on the startPage.aspx page.
*/

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace Text_Editor
{
    public partial class startPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        /*  Name	:	GetFilesList()
	    *	Purpose :	retrieve the file names from the directory
        *	Inputs	:	none                   
	    *	Outputs	:	none
	    *	Returns	:	List<string>        fileList        :a list of all the file names in the directory 
	    */
        [WebMethod]
        public static List<string> GetFilesList()
        {
            string directoryPath = HttpContext.Current.Server.MapPath("MyFiles");
            List<string> fileList = new List<string>();

            if (Directory.Exists(directoryPath))
            {
                string[] files = Directory.GetFiles(directoryPath);
                foreach (string file in files)
                {
                    fileList.Add(Path.GetFileName(file));
                }
            }

            return fileList;
        }

        /*  Name	:	OpenFile()
	    *	Purpose :	open a file and retrieve it's contents
        *	Inputs	:	string      fileToLoad      : The name of the file to open                   
	    *	Outputs	:	none
	    *	Returns	:	string      returnData      : json object containing the file contents and status 
	    */
        [WebMethod]
        public static new string  OpenFile(string fileToLoad)
        {
            string returnData;
            string fileStatus;
            string fileContents;
            string filePath;

            try
            {
                filePath = HttpContext.Current.Server.MapPath("MyFiles");
                filePath = filePath + @"\" + fileToLoad;
                if (File.Exists(filePath))
                {
                    fileStatus = "Success";
                    fileContents = File.ReadAllText(filePath);
                }
                else
                {
                    fileStatus = "Failure";
                    fileContents = "File doesn't exist";
                }
            }
            catch (Exception e)
            {
                fileStatus = "Exception";
                fileContents = "Something bad happened: " + e.ToString();
            }

            returnData = JsonConvert.SerializeObject(new { status = fileStatus, description = fileContents });
            return returnData;
        }

        /*  Name	:	SaveFile()
	    *	Purpose :	save the changes to a file
        *	Inputs	:	string      fileName      : The name of the file being changed
        *	            string      content       : What has been changed and written
	    *	Outputs	:	none
	    *	Returns	:	string      returnData      : json object containing the status
	    */
        [WebMethod]
        public static string SaveFile(string fileName,string content)
        {
            string returnData;
            string saveStatus;
            string filePath = HttpContext.Current.Server.MapPath("MyFiles");
            filePath = filePath + @"\" + fileName;
            try
            {
                File.WriteAllText(filePath, content);
                saveStatus = "Success";
            }
            catch(Exception e)
            {
                saveStatus = "Exception";
                
            }
            returnData = JsonConvert.SerializeObject(new { status = saveStatus });
            return returnData;
        }


    }
    
}
