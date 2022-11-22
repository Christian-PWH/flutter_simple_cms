import 'dart:io';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ParseService {
  Future<ParseResponse> createPost(
      File? postImageCover, String? postTitle, String? postContent) async {
    ParseObject createPost;
    if (postImageCover != null) {
      ParseFileBase? parseFile = ParseFile(postImageCover);

      parseFile.save().then((value) {
        createPost = ParseObject('PostList')
          ..set('postImageCover', parseFile)
          ..set('postTitle', postTitle)
          ..set('postContent', postContent);

        return createPost.save();
      });
    }
    createPost = ParseObject('PostList')
      ..set('postTitle', postTitle)
      ..set('postContent', postContent);

    return createPost.save();
    ;
  }

  Future<List<ParseObject>> getPosts() async {
    await Future.delayed(Duration(seconds: 2), () {});
    return [];
  }

  Future<void> updatePost(String id, bool done) async {
    await Future.delayed(Duration(seconds: 1), () {});
  }

  Future<void> deletePost(String id) async {
    await Future.delayed(Duration(seconds: 1), () {});
  }
}
