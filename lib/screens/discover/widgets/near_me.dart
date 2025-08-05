import 'package:flutter/material.dart';
import '../../../models/near_me.dart';
import 'dart:math';

class NearMeWidget extends StatelessWidget {
  final String search;
  final bool showAll;
  const NearMeWidget({super.key, this.search = '', this.showAll = false});

  List<NearMeUser> _getDemoUsers() {
    return [
      NearMeUser(id: '1', name: 'Alice', avatarUrl: 'https://randomuser.me/api/portraits/women/1.jpg', distance: 0.5, isOnline: true),
      NearMeUser(id: '2', name: 'Bob', avatarUrl: 'https://randomuser.me/api/portraits/men/2.jpg', distance: 1.2, isOnline: false),
      NearMeUser(id: '3', name: 'Charlie', avatarUrl: 'https://randomuser.me/api/portraits/men/3.jpg', distance: 2.0, isOnline: true),
      NearMeUser(id: '4', name: 'Diana', avatarUrl: 'https://randomuser.me/api/portraits/women/4.jpg', distance: 0.8, isOnline: true),
      NearMeUser(id: '5', name: 'Eve', avatarUrl: 'https://randomuser.me/api/portraits/women/5.jpg', distance: 1.5, isOnline: false),
      NearMeUser(id: '6', name: 'Frank', avatarUrl: 'https://randomuser.me/api/portraits/men/6.jpg', distance: 2.3, isOnline: true),
      NearMeUser(id: '7', name: 'Grace', avatarUrl: 'https://randomuser.me/api/portraits/women/7.jpg', distance: 1.9, isOnline: false),
      NearMeUser(id: '8', name: 'Henry', avatarUrl: 'https://randomuser.me/api/portraits/men/8.jpg', distance: 0.7, isOnline: true),
      NearMeUser(id: '9', name: 'Ivy', avatarUrl: 'https://randomuser.me/api/portraits/women/9.jpg', distance: 1.1, isOnline: true),
      NearMeUser(id: '10', name: 'Jack', avatarUrl: 'https://randomuser.me/api/portraits/men/10.jpg', distance: 2.5, isOnline: false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<NearMeUser> users = _getDemoUsers();
    if (search.isNotEmpty) {
      users = users.where((u) => u.name.toLowerCase().contains(search)).toList();
    }
    if (!showAll && users.length > 5) {
      users.shuffle(Random());
      users = users.take(5).toList();
    }
    return Column(
      children: users.map((u) => ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(u.avatarUrl),
              radius: 22,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: u.isOnline ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ],
        ),
        title: Text(u.name),
        subtitle: Text('Distance: ${u.distance} mi'),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
          onPressed: () {},
          child: const Text('Connect'),
        ),
      )).toList(),
    );
  }
}
