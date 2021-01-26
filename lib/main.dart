import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:video_decyrptor/AesDecrypt.dart';
import 'package:video_decyrptor/VideoEncFileScreen.dart';
import 'dart:io';

import 'package:video_decyrptor/VideoFileScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var files;

  void getFiles() async {
    //asyn function to get list of files
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0]
        .rootDir; //storageInfo[1] for SD card, geting the root directory
    var fm = FileManager(root: Directory(root)); //
    files = await fm.filesTree(
        //set fm.dirsTree() for directory/folder tree list
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["enc"] //optional, to filter files, remove to list all,
        //remove this if your are grabbing folder list
        );
    setState(() {}); //update the UI
  }

  void printFile(file_path) async {
    print('PRINT FILE $file_path');
    final File file = File(file_path);
    // final text = await file.readAsString();
    // print(text);
  }

  @override
  void initState() {
    // TODO: implement initState
    getFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("File/Folder list from SD Card"),
          backgroundColor: Colors.redAccent),
      body: files == null
          ? Text("Searching Files")
          : ListView.builder(
              //if file/folder list is grabbed, then show here
              itemCount: files?.length ?? 0,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                  title: Text(files[index].path.split('/').last),
                  leading: Icon(Icons.insert_drive_file),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.redAccent,
                  ),
                  onTap: () {
                    // you can add Play/push code over here
                    // printFile(files[index].path.toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            // builder: (ctx) => DetailsScreen(
                            //   filePath: files[index].path.toString(),
                            // )
                            // builder: (ctx) => VideoFileScreen(
                            //       filePath: files[index].path.toString(),
                            //     )));
                            builder: (ctx) => VideoEncFileScreen(
                                  filePath: files[index].path.toString(),
                                )));
                    // builder: (ctx) => AesDecyrypt()));
                  },
                ));
              },
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
