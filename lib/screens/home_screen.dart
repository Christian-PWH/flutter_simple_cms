import 'package:flutter/material.dart';
import 'package:flutter_simple_cms/api/parse_services.dart';
import 'package:flutter_simple_cms/screens/update_post_screen.dart';
import 'package:flutter_simple_cms/widgets/show_drawer.dart';
import 'package:flutter_simple_cms/widgets/show_snackbar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ParseObject> getPostList = [];
  bool isDeleting = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        drawer: showDrawer(context),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<List<ParseObject>>(
        initialData: getPostList,
        stream: ParseService().getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 75.0,
                width: 75.0,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                  child: ElevatedButton(
                child: const Text("Refresh"),
                onPressed: () {
                  setState(() {});
                },
              ));
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('NO DATA', style: TextStyle(fontSize: 36.0)),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(top: 10.0),
                itemCount: snapshot.hasData ? snapshot.data!.length : 1,
                itemBuilder: (BuildContext context, int index) {
                  if (snapshot.data!.isEmpty) {
                    return SizedBox(
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
                  final postData = snapshot.data![index];
                  ParseFile? postImageCover =
                      snapshot.data![index].get<ParseFile>('postImageCover');
                  final postTitle = postData.get<String>('postTitle')!;
                  final postContent = postData.get<String>('postContent')!;
                  return Card(
                    elevation: 7.0,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        width: 1.5,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            child: PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    value: 0,
                                    child: Row(
                                      children: const [
                                        Icon(Icons.edit_note),
                                        SizedBox(
                                          // sized box with width 10
                                          width: 10,
                                        ),
                                        Text("Edit post")
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 1,
                                    child: Row(
                                      children: const [
                                        Icon(Icons.delete),
                                        SizedBox(
                                          // sized box with width 10
                                          width: 10,
                                        ),
                                        Text("Delete post")
                                      ],
                                    ),
                                  ),
                                ];
                              },
                              onSelected: (value) {
                                if (value == 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UpdatePost(postObject: postData),
                                    ),
                                  );
                                } else {
                                  isDeleting = true;
                                  ParseService()
                                      .deletePost(postData.objectId)
                                      .then((response) {
                                    if (response.success) {
                                      setState(() => isDeleting = false);
                                      showSnackbar(
                                        context,
                                        'Post Deleted!',
                                        Colors.greenAccent,
                                        Icons.check_circle_outline,
                                        Colors.greenAccent,
                                      );
                                    } else {
                                      isDeleting = false;
                                      showSnackbar(
                                        context,
                                        response.error?.message,
                                        Colors.red,
                                        Icons.error_outline,
                                        Colors.red,
                                      );
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          addSpace(10.0),
                          Visibility(
                            visible: postImageCover != null,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 300.0,
                              child: postImageCover == null
                                  ? null
                                  : Image.network(
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                          child: SizedBox(
                                            height: 50.0,
                                            width: 50.0,
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                      postImageCover.url!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          addSpace(10.0),
                          Text(
                            postTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20.0),
                          ),
                          addSpace(10.0),
                          Text(
                            postContent,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          addSpace(5.0),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('NO DATA', style: TextStyle(fontSize: 36.0)),
              );
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }

  Widget addSpace(double? heightVal) => SizedBox(height: heightVal);
}
