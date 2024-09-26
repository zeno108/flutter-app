import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:search_items_screen/data/model/free_fake_post_model.dart';
import 'package:search_items_screen/data/repo/free_fake_post_repo_dio.dart';
import 'package:search_items_screen/helper/shared_pref_helper.dart';

void main() {
  runApp(const MyApp());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              textStyle: const TextStyle(color: Colors.white)),
        ),
        // textButtonTheme: TextButtonThemeData(
        //   style: ButtonStyle(
        //     textStyle: WidgetStateProperty.all(
        //       TextStyle(color: Colors.white),
        //     ),
        //   ),
        // ),
        // buttonTheme: ButtonThemeData(
        //   buttonColor: Colors.blueAccent,
        //   textTheme: ButtonTextTheme.normal,
        // ),
      ),
      home: const Home(),
    );
  }
}


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var posts = <FreeFakePostModel>[];
  late final FreeFakePostRepoDio freeFakePostRepo;
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final slugController = TextEditingController();
  final pictureController = TextEditingController();
  bool isPostsLoading = false;
  bool isCreatingPostsLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    freeFakePostRepo = FreeFakePostRepoDio(client: Dio());

    futureInit();
  }

  Future<void> futureInit() async {
    if (isPostsLoading) return;
    isPostsLoading = true;
    setState(() {});
    posts = await freeFakePostRepo.fetchPosts();
    isPostsLoading = false;
    setState(() {});
  }

  Future<FreeFakePostModel?> createPost() async {
    if (isCreatingPostsLoading) return null;
    isCreatingPostsLoading = true;
    final response = freeFakePostRepo.createPost(postFrom.toJson());
    isCreatingPostsLoading = false;
    return response;
  }

  FreeFakePostModel get postFrom => FreeFakePostModel(
        title: titleController.text,
        content: contentController.text,
        slug: slugController.text,
        picture: "https://fakeimg.pl/350x200/?text=FreeFakeAPI",
        userId: 5,
      );

  @override
  Widget build(BuildContext context) {
    // if (isPostsLoading) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Posts is loading...")),
    //   );
    // }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPostDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: isPostsLoading
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              isPostsLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: const BorderSide(
                                color: Colors.black54, width: 1),
                          ),
                        ),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return ListTile(
                              title: Text(post?.title ?? "default"),
                              subtitle: Column(
                                children: [
                                  Text(post?.content ?? "default"),
                                  post!.picture != null
                                      ? Image.network(post!.picture!)
                                      : const Placeholder()
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(
                              color: Colors.black,
                              thickness: 5,
                            );
                          },
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  void _showAddPostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Add a new post.",
                      style: TextStyle(
                        fontSize: 21,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const Gap(16),
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 8.0),
                    child: Text(
                      "Title",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  CustomTextField(
                    controller: titleController,
                  ),
                  const Gap(16),
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 8.0),
                    child: Text(
                      "Content",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  CustomTextField(
                    controller: contentController,
                  ),
                  const Gap(16),
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 8.0),
                    child: Text(
                      "Slug",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  CustomTextField(
                    controller: slugController,
                  ),
                  const Gap(16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final snackBar = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);
                        final newPost = await createPost();
                        setState(() {});
                        if (newPost != null) {
                          posts.add(newPost);
                          navigator.pop();
                          setState(() {});
                        } else {
                          navigator.overlay?.deactivate();
                          snackBar.showSnackBar(
                            SnackBar(
                              content: const Text("Failed to create post."),
                              action: SnackBarAction(
                                label: "OK",
                                onPressed: () {
                                  snackBar.deactivate();
                                },
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.borderColor,
  });

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? Colors.black54,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
