import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'widgets/events.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
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
        title: const Text('All Events'),
        backgroundColor: Colors.pink,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search events...',
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
              child: EventsWidget(search: searchQuery, showAll: true),
            ),
          ],
        ),
      ),
    );
  }
}
