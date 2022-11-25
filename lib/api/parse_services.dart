import 'dart:io';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ParseService {
  Future<ParseResponse> createPost(
      File? postImageCover, String? postTitle, String? postContent) async {
    ParseObject createPost;

    if (postImageCover != null) {
      ParseFileBase? parseFile = ParseFile(postImageCover);

      await parseFile.save();

      createPost = ParseObject('PostList')
        ..set('postImageCover', parseFile)
        ..set('postTitle', postTitle)
        ..set('postContent', postContent);
      return createPost.save();
    } else {
      createPost = ParseObject('PostList')
        ..set('postTitle', postTitle)
        ..set('postContent', postContent);

      return createPost.save();
    }
  }

  Stream<List<ParseObject>>? getPosts() async* {
    ParseObject? getPostObject = ParseObject('PostList');
    QueryBuilder<ParseObject> queryPosts =
        QueryBuilder<ParseObject>(getPostObject);
    final ParseResponse apiResponse = await queryPosts.query();

    if (apiResponse.success && apiResponse.results != null) {
      yield apiResponse.results as List<ParseObject>;
    } else {
      yield [];
    }
  }

  Future<ParseResponse> updatePost(String? id, File? postImageCover,
      String? postTitle, String? postContent) async {
    ParseObject updatePost;

    if (postImageCover != null) {
      ParseFileBase? parseFile = ParseFile(postImageCover);

      await parseFile.save();

      updatePost = ParseObject('PostList')
        ..objectId = id
        ..set('postImageCover', parseFile)
        ..set('postTitle', postTitle)
        ..set('postContent', postContent);
      return updatePost.save();
    } else {
      updatePost = ParseObject('PostList')
        ..objectId = id
        ..set('postTitle', postTitle)
        ..set('postContent', postContent);

      return updatePost.save();
    }
  }

  Future<ParseResponse> deletePost(String? id) async {
    ParseObject deletePost = ParseObject('PostList')..objectId = id;
    return deletePost.delete();
  }
}
