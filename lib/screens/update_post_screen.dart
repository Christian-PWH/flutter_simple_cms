import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_cms/api/parse_services.dart';
import 'package:flutter_simple_cms/screens/home_screen.dart';
import 'package:flutter_simple_cms/utilities/constants.dart';
import 'package:flutter_simple_cms/widgets/show_drawer.dart';
import 'package:flutter_simple_cms/widgets/show_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:path/path.dart' as path;

class UpdatePost extends StatefulWidget {
  const UpdatePost({super.key, required this.postObject});

  final ParseObject postObject;

  @override
  State<UpdatePost> createState() => UpdatePostState();
}

class UpdatePostState extends State<UpdatePost> {
  ParseObject? postObject;
  final titleFieldKey = GlobalKey<FormState>();
  final contentFieldKey = GlobalKey<FormState>();
  final TextEditingController postTitleCtl = TextEditingController();
  final TextEditingController postContentCtl = TextEditingController();

  File? postImageCoverUpdated;
  ParseFile? postImageCover;

  String? postImageCoverName;
  String? postTitle;
  String? postContent;

  bool? isLoading = false;

  @override
  void initState() {
    super.initState();
    postObject = widget.postObject;
    postImageCover = postObject?.get<ParseFile>('postImageCover');
    postTitle = postTitleCtl.text = postObject!.get<String>('postTitle')!;
    postContent = postContentCtl.text = postObject!.get<String>('postContent')!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Post')),
        body: _body(context),
        drawer: showDrawer(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          postImageCoverPicker(context),
          addSpace(),
          postContentTextField(titleFieldKey, 'Post Title', postTitleCtl,
              TextInputType.text, 1, false, Icons.star, 'required', (value) {
            setState(() {
              postTitle = value;
            });
          }),
          addSpace(),
          postContentTextField(
              contentFieldKey,
              'Post Content',
              postContentCtl,
              TextInputType.multiline,
              7,
              false,
              Icons.star,
              'required', (value) {
            setState(() {
              postContent = value;
            });
          }),
          addSpace(),
          postUpdateButton(context),
        ],
      ),
    );
  }

  Widget addSpace() => const SizedBox(height: 16);

  Widget requirementHintText(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 13.0,
          color: Colors.grey,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 13.0, color: Colors.grey),
        ),
      ],
    );
  }

  Widget postImageCoverPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: postImageCover != null,
          child: Center(
            child: SizedBox(
              width: 350,
              height: 300.0,
              child: postImageCover != null
                  ? postImageCoverUpdated != null
                      ? Image.file(
                          postImageCoverUpdated!,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          postImageCover!.url!,
                          fit: BoxFit.cover,
                        )
                  : Container(),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
          child: const Text(
            'Post Image Cover',
            style: kHeaderTextStyle,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size.fromHeight(50.0),
          ),
          child: const Text(
            'Choose Image',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
              if (value != null) {
                setState(() {
                  postImageCoverUpdated = File(value.path);
                  postImageCoverName = path.basename(value.path);
                });
              }
            });
          },
        ),
        requirementHintText(
            CupertinoIcons.exclamationmark_circle_fill, 'optional'),
      ],
    );
  }

  Widget postContentTextField(
      GlobalKey<FormState> fieldKey,
      String fieldLabel,
      TextEditingController ctl,
      TextInputType inputType,
      int maxLine,
      bool validate,
      IconData requiredIcon,
      String requiredLabel,
      void Function(String)? onTextChange) {
    return Form(
      key: fieldKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
            child: Text(
              fieldLabel,
              style: kHeaderTextStyle,
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              // errorText: validate ? 'Field Can\'t Be Empty' : null,
            ),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Field Can\'t Be Empty';
              } else {
                return null;
              }
            },
            controller: ctl,
            keyboardType: inputType,
            maxLines: maxLine,
            onChanged: onTextChange,
          ),
          requirementHintText(requiredIcon, requiredLabel),
        ],
      ),
    );
  }

  Widget postUpdateButton(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50.0,
        width: 150.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(),
          onPressed: isLoading!
              ? null
              : () {
                  if (postTitle != null && postContent != null) {
                    setState(() => isLoading = true);
                    ParseService()
                        .updatePost(postObject?.objectId, postImageCoverUpdated,
                            postTitle, postContent)
                        .then((response) {
                      if (response.success) {
                        setState(() => isLoading = false);
                        showSnackbar(
                          context,
                          'Post Edited!',
                          Colors.greenAccent,
                          Icons.check_circle_outline,
                          Colors.greenAccent,
                        );
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      } else {
                        setState(() => isLoading = false);
                        showSnackbar(
                          context,
                          response.error?.message,
                          Colors.red,
                          Icons.error_outline,
                          Colors.red,
                        );
                      }
                    });
                  } else {
                    titleFieldKey.currentState!.validate();
                    contentFieldKey.currentState!.validate();
                  }
                },
          child: Center(
            child: isLoading!
                ? const CircularProgressIndicator(
                    color: Colors.blueAccent,
                  )
                : const Text('Save'),
          ),
        ),
      ),
    );
  }
}
