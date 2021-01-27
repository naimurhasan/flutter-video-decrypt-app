import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_decyrptor/VideoEncFileScreen.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
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
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyPermissionPage extends StatefulWidget {
  @override
  _MyPermissionPageState createState() => _MyPermissionPageState();
}

class _MyPermissionPageState extends State<MyPermissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("File/Folder list from SD Card"),
            backgroundColor: Colors.redAccent),
        body: Center(
          child: RaisedButton(
            child: Text('Grant Storage Permission'),
            onPressed: askPermission,
          ),
        ));
  }

  void askPermission() async {
    print('Requesting for permission');
    var status = await Permission.storage.status;

    if (status.isGranted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) => MyHomePage(title: 'Flutter Demo Home Page'),
          ));
    }

    if (status.isUndetermined || status.isDenied) {
      // We didn't ask for permission yet.
      final reqStatus = await Permission.storage.request();
      if (reqStatus == PermissionStatus.granted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (ctx) => MyHomePage(title: 'Flutter Demo Home Page'),
            ));
      }
    }
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var files;

  void getFiles() async {
    // check for permissions
    var status = await Permission.storage.status;

    if (!status.isGranted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => MyPermissionPage()));
    }

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
