import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'widgets/posts.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  String searchQuery = '';

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value.trim().toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Posts'),
        backgroundColor: Colors.pink,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search posts...',
                prefixIcon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PostsWidget(search: searchQuery),
            ),
          ],
        ),
      ),
    );
  }
}
