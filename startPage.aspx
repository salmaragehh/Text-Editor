<!--
	FILE:          startPage.aspx
	PROJECT:       Text Editor
	PROGRAMMERS:   Salma Rageh  
	FIRST VERSION: 2023-11-30
	DESCRIPTION:   This code let's the user choose a file, edit it, and save the changes
-->

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="startPage.aspx.cs" Inherits="Text_Editor.startPage" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title></title>
    <link rel="stylesheet" type="text/css" href="style.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
    <h2>Online Text Editor</h2>
    <div>

        <label for="fileList">Select a File:</label>
        <select id="fileList">
        </select>
        <input type="text" id="editTextBox">
    </div>
    <br />
    <div>

        <textarea id="editor" rows="10" cols="50"></textarea>
    </div>
    <br />
    <button id="saveButton" disabled>Save</button>
    <br />
    <button id="saveAsButton" disabled>Save as</button>
    <div id="statusMessage"></div>
    <script>
        var jQueryXMLHttpRequest;
        $(document).ready(function () {
            // Populate file list dropdown
            displayFileList();
        });

        /*  Name	:	displayFileList()
        *	Purpose :	populate the dropdown of file names
        *	Inputs	:	none                   
        *	Outputs	:	Updates the dropdown
        *	Returns	:	Nothing 
        */
        function displayFileList() {
            console.log("displayyy file list");
            jQueryXMLHttpRequest = $.ajax({
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                url: 'startPage.aspx/GetFilesList',
                dataType: "json",
                success: function (data) {
                    if (data != null && data.d != null) {

                        var fileList = data.d;
                        console.log(fileList);
                        var select = $('#fileList');
                        select.empty();
                        select.append($('<option>').text('').attr('value', ''));
                        $.each(fileList, function (index, value) {
                            select.append($('<option>').text(value).attr('value', value));
                        });
                        select.on('change', function () {
                            var selectedFile = $(this).val();
                            if (selectedFile !== '') {
                                loadFileContent(selectedFile);
                                $("#editTextBox").val(selectedFile);
                            }
                            else
                            {
                                $("#editor").val('');
                                $("#statusMessage").html('Please Select a File');
                                $("#saveButton").hide();
                            }
                            
                        })

                    }
                },

                fail: function () {
                    $("#statusMessage").html("Failed to get file list.").addClass('error-message');
                }

            });
        }


        /*  Name	:	loadFileContent()
        *	Purpose :	load the contents of the selected file
        *	Inputs	:	selected_File       the file the user chose                   
        *	Outputs	:	Puts the file contents into the text area
        *	Returns	:	Nothing 
        */
        function loadFileContent(selected_File) {
            var selectedFile = selected_File;
            var jsonData = { fileToLoad: selectedFile };
            var jsonString = JSON.stringify(jsonData);

            jQueryXMLHttpRequest = $.ajax({
                type: "POST",
                url: "startPage.aspx/OpenFile",
                data: jsonString,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    if (data != null && data.d != null) {
                        var response = $.parseJSON(data.d);
                        $("#statusMessage").html("File loading status: <b>" + response.status + "</b>");
                        $("#editor").val(response.description);

                        $("#editor").on('input', function () {
                            document.getElementById("saveButton").disabled = false;
                            $("#saveButton").off().on("click", function () {
                                var changedContent = $("#editor").val();
                                saveFile(selectedFile, changedContent);
                            }
                            );

                            $("#editTextBox").on('input', function () {
                                document.getElementById("saveAsButton").disabled = false;
                                $("#saveAsButton").off().on("click", function () {
                                    var changedContent = $("#editor").val();
                                    var newFileName = $("#editTextBox").val();
                                    saveFile(newFileName, changedContent);
                                }
                                );
                            });
                        });
                        

                    }
                },
                fail: function () {
                    $("#statusMessage").html("The call to the load the file failed!").addClass('error-message');
                }
            });

        }

        /*  Name	:	saveFile()
        *	Purpose :	load the contents of the selected file
        *	Inputs	:	fileName       the file to save to
        *               content        the content to save to the file
        *	Outputs	:	A status message to the user if successful
        *	Returns	:	Nothing 
        */
        function saveFile(fileName, content) {
            var jsonData = { fileName: fileName, content: content };
            var jsonString = JSON.stringify(jsonData);

            jQueryXMLHttpRequest = $.ajax({
                type: "POST",
                url: "startPage.aspx/SaveFile",
                data: jsonString,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    if (data != null && data.d != null) {
                        var response = $.parseJSON(data.d);
                        $("#statusMessage").html("File Saving status: <b>" + response.status + "</b>");
                        displayFileList();
                        document.getElementById("saveButton").disabled = true;
                        document.getElementById("saveAsButton").disabled = true;
                    }
                },
                fail: function () {
                    $("#statusMessage").html("The call to save the file failed!").addClass('error-message');
                }
            })
        }
    </script>

</body>
</html>
