import 'package:flutter/material.dart';
import '../../../models/post_model.dart';
import 'post.dart';
import 'dart:math';

class PostsWidget extends StatelessWidget {
  final String search;
  const PostsWidget({super.key, this.search = ''});

  List<Post> _getDemoPosts() {
    List<Post> posts = [];
    for (int i = 0; i < 50; i++) {
      posts.add(Post(
        id: 'p$i',
        userId: 'u${i % 10}',
        username: 'User${i % 10}',
        content: 'This is post number $i. Check out what’s trending!',
        imageUrl: i % 3 == 0 ? 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80' : null,
        timestamp: DateTime.now().subtract(Duration(minutes: i * 5)),
        likes: Random().nextInt(100),
        comments: Random().nextInt(20),
      ));
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    List<Post> posts = _getDemoPosts();
    if (search.isNotEmpty) {
      posts = posts.where((p) => p.content.toLowerCase().contains(search) || p.username.toLowerCase().contains(search)).toList();
    }
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, i) {
        return PostCard(post: posts[i]);
      },
    );
  }
}
