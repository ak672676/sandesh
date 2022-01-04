import 'dart:typed_data';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sandesh/models/user.dart';
import 'package:sandesh/providers/user_provider.dart';
import 'package:sandesh/resources/firestore_methods.dart';
import 'package:sandesh/utils/colors.dart';
import 'package:sandesh/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  TextEditingController _descriptionsController = TextEditingController();
  bool _isLoading = false;

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Select a image"),
            children: [
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text("Take a photo"),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.camera);
                    setState(() {
                      _file = file;
                    });
                  }),
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text("Choose from gallery"),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                    });
                  }),
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionsController.text, _file!, uid, username, profImage);
      if (res == "Success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar("Posted", context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
                icon: Icon(Icons.upload),
                onPressed: () {
                  _selectImage(context);
                }),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              elevation: 1,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    clearImage();
                  }),
              title: Text("Add Post"),
              actions: [
                TextButton(
                  onPressed: () {
                    postImage(user.uid, user.username, user.photoUrl);
                  },
                  child: const Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                )
              ],
            ),
            body: Column(children: [
              _isLoading
                  ? const LinearProgressIndicator()
                  : const Padding(padding: EdgeInsets.only(top: 0)),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(user.photoUrl)),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: _descriptionsController,
                        decoration: const InputDecoration(
                          hintText: "What's on your mind?",
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      )),
                  SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                          image: MemoryImage(_file!),
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                        ))),
                      )),
                  Divider()
                ],
              ),
            ]),
          );
  }
}
