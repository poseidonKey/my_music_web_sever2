import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MusicFolderList extends StatefulWidget {
  const MusicFolderList({super.key});

  @override
  _MusicFolderListState createState() => _MusicFolderListState();
}

class _MusicFolderListState extends State<MusicFolderList> {
  List<String> _folderNames = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchFolderNames();
  }

  Future<void> _fetchFolderNames() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'http://192.168.219.106/musicPlayer/fetch_music_folders.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _folderNames = List<String>.from(data);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load folder names');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Folders'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _folderNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_folderNames[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MusicFileList(folderName: _folderNames[index]),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class MusicFileList extends StatelessWidget {
  final String folderName;

  const MusicFileList({super.key, required this.folderName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Files in $folderName'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchMusicFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<dynamic> files = snapshot.data ?? [];
            print(files.length);
            return ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(files[index]['name']),
                  onTap: () {
                    // Handle file tap
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<dynamic>> _fetchMusicFiles() async {
    final response = await http.get(Uri.parse(
        'http://192.168.219.106/musicPlayer/aa.php?folder=$folderName'));

    if (response.statusCode == 200) {
      // print(response.body);
      final List<dynamic> data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to load music files');
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: MusicFolderList(),
  ));
}
