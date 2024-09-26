import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:search_items_screen/data/model/free_fake_post_model.dart';

class FreeFakePostRepo {
  final http.Client client;

  FreeFakePostRepo({required this.client});

  Future<List<FreeFakePostModel>> fetchPosts() async {
    try {
      final response = await client.get(
        Uri.parse(
          "https://freefakeapi.io/api/posts",
        ),
      );
      final responseBody = jsonDecode(response.body);
      final result = List.of(responseBody).map((e) {
        return FreeFakePostModel.fromJson(e);
      }).toList();
      return result;
    } catch (e, s) {
      print(e);
      print(s);
      return [];
    }
  }

  Future<FreeFakePostModel?> createPost(Map<String, dynamic> data) async {
    try {
      final response = await client.post(
        Uri.parse("https://freefakeapi.io/api/posts"),
        body: data,
      );
      final responseBody = jsonDecode(response.body);
      List.of(responseBody).map(
        (e) {
          return FreeFakePostModel.fromJson(e);
        },
      );
    } catch (e, s) {
      print(e);
      print(s);
      return null;
    }
    return null;
  }
}
