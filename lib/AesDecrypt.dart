import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as Enc;
import 'package:flutter/material.dart';

class AesDecyrypt extends StatelessWidget {
  readFile() async {
    File protected_file =
        File('/storage/emulated/0/ADM/protected_video.mp4.enc');

    final b64key = Enc.Key.fromUtf8('12345678901234567890123456789012');
    // if you need to use the ttl feature, you'll need to use APIs in the algorithm itself
    final fernet = Enc.Fernet(b64key);
    final encrypter = Enc.Encrypter(fernet);

    // final encrypted = encrypter.encrypt(plainText);
    // print(encrypted.base64);
    // final decrypted = encrypter.decrypt(encrypted);
    // plainfile.writeAsBytes(encrypted.base64.codeUnits);

    final encrypted = Enc.Encrypted(
        Uint8List.fromList(base64Decode(await protected_file.readAsString())));
    // print(encrypter.decrypt(encrypted));

    File decFile = File('/storage/emulated/0/Android/protected_video.mp4');
    decFile.writeAsBytes(encrypter.decryptBytes(encrypted));

    // print(fernet.extractTimestamp(encrypted.bytes)); //
  }

  @override
  Widget build(BuildContext context) {
    readFile();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('AES Decrypt'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Text('Decrypt'),
      ),
    );
  }
}
