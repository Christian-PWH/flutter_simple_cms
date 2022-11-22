import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_simple_cms/models/post_list.dart';
import 'package:flutter_simple_cms/widgets/show_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PostList> postList = [];

  List test = [];

  @override
  void initState() {
    super.initState();
    _queryAll();
  }

  void _queryAll() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: showDrawer(context),
      body: _body(),
    );
  }

  Widget _body() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: postList.isEmpty ? 1 : postList.length,
      itemBuilder: (BuildContext context, int index) {
        if (postList.isEmpty) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: Text(
                'Data is Empty!',
                style: TextStyle(fontSize: 36.0),
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            addSpace(5.0),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 150.0,
              child: postList[index].coverImagePath != null
                  ? Image.file(
                      File(postList[index].coverImagePath.toString()),
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
            addSpace(10.0),
            Row(
              children: [
                Text(
                  'Published : ${postList[index].publishDate}',
                  style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                const Spacer(),
                const Text(
                  'Color : ',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                Container(
                  width: 25.0,
                  height: 25.0,
                  decoration: BoxDecoration(
                      color: Color(postList[index].colorThemeValue!),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(50.0))),
                ),
              ],
            ),
            addSpace(10.0),
            Text(
              '${postList[index].caption}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16.0),
            ),
            addSpace(5.0),
            const Divider(
              color: Colors.grey,
              thickness: 1.0,
            )
          ],
        );
      },
    );
  }

  Widget addSpace(double? heightVal) => SizedBox(height: heightVal);
}
