<?php

function upload_file($target_dir, $file_name, $imageFileType, $tmp_name)
{
    $uploadOk = 1;
    $allowed_ext = array('jpg', 'png', 'jpeg', 'bmp', 'gif');
    $target_file = $target_dir . uniqid('', true) . '.' . $file_name;
    $physical_target_file = ROOTPATH . $target_file;

    // Check if file already exists
    if (file_exists($physical_target_file)) {
        $message = "Sorry, file already exists.";
        $uploadOk = 0;
    }
// Check file size
    if ($_FILES["upload"]["size"] > 20000000) {
        $message = "Sorry, your file is too large.";
        $uploadOk = 0;
    }
// Allow certain file formats
    if (!in_array($imageFileType, $allowed_ext)) {
        $message = "Sorry, only JPG, JPEG, PNG & GIF files are allowed.";
        $uploadOk = 0;
    }
// Check if $uploadOk is set to 0 by an error
    if ($uploadOk == 0) {
        return "{
        \"uploaded\": 0,
        \"error\": {
            \"message\": \"$message\"
        }
      }";
// if everything is ok, try to upload file
    } else {
        if (move_uploaded_file($tmp_name, $physical_target_file)) {
            $url = $target_file;
            return "{
            \"uploaded\": 1,
            \"fileName\":\"" . "$file_name" . "\",
            \"url\": \"$url\"
          }";
        } else {
            return "{
            \"uploaded\": 0,
            \"error\": {
                \"message\": \"Sorry, there was an error uploading your file.\"
            }
          }";
        }
    }
}

if (isset($_FILES["upload"]["name"]))
{
    $target_dir = "/uploader/files/";
    $file_name = basename($_FILES["upload"]["name"]);
    $imageFileType = strtolower(pathinfo($file_name, PATHINFO_EXTENSION));
    echo upload_file($target_dir, $file_name, $imageFileType, $_FILES["upload"]["tmp_name"]);
}
