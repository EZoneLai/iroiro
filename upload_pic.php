<?php
 if ($_FILES["fileToUpload"]["error"] > 0 ){
    echo "Error: " . $_FILES["fileToUpload"]["error"]."<br>";
 }else{
     echo "filename" . $_FILES["fileToUpload"]["name"]."<br>";
     echo "filetype" . $_FILES["fileToUpload"]["type"]."<br>";
     echo "filesize" . $_FILES["fileToUpload"]["size"]."<br>";
     echo "tmpname" . $_FILES["fileToUpload"]["tmp_name"]."<br>";

     //if (file_exists("upload/" . $_FILES["fileToUpload"]["name"])){
     //	echo "file exists";
     //}else{
     	move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], "upload/" . $_FILES["fileToUpload"]["name"]);
     //}


 }



?>