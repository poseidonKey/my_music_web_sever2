<?php

// $musicFolder = 'http://192.168.219.106/musicPlayer/music';
$musicFolder = 'music/Yuhki Kuramoto/';
// $musicFolder = 'http://192.168.219.106/musicPlayer/music/Yuhki Kuramoto/';
// $folderName = isset($_GET['folder']) ? $_GET['folder'] : '';

// $folderUrl = $musicFolder . '/' . $folderName . '/';
// $folderUrl = 'music/Yuhki Kuramoto/';

// Set the path to the music folder

// Scan the music folder for MP3 files
$mp3Files = glob($musicFolder . '*.mp3');

// Initialize an array to store the list of music files
$musicList = array();

// Iterate through each MP3 file and build the music list
foreach ($mp3Files as $file) {
  // Extract the filename without the path
  $filename = basename($file);
  // Create an entry for the music file in the music list
  $musicList[] = array(
    'name' => substr($filename, 0, strrpos($filename, '.')), // Remove the file extension from the filename
    'url' =>  $file // Construct the URL to the MP3 file
  );
}

// Set the response header to indicate JSON content
header('Content-Type: application/json');

// Output the music list as JSON
echo json_encode($musicList);
