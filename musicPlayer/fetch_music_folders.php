<?php

$musicFolder = './music'; // Change this to your music folder path

$folders = array_filter(glob($musicFolder . '/*'), 'is_dir');
$folderNames = array_map('basename', $folders);

header('Content-Type: application/json');
echo json_encode($folderNames);
