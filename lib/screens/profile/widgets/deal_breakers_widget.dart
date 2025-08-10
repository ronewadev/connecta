import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DealBreakersManager {
  final BuildContext context;
  final List<String> initialDealBreakers;
  final Future<bool> Function(List<String>) onSave;
  final int maxItems;

  List<String> _tempDealBreakers = [];
  bool _isEditing = false;

  DealBreakersManager({
    required this.context,
    required this.initialDealBreakers,
    required this.onSave,
    this.maxItems = 5,
  });

  Widget buildContent() {
    return _buildEditableSubSection(
      title: 'Deal Breakers',
      icon: FontAwesomeIcons.ban,
      color: const Color(0xFFDC2626),
      items: _isEditing ? _tempDealBreakers : initialDealBreakers,
      isEditing: _isEditing,
      tempItems: _tempDealBreakers,
      maxItems: maxItems,
      context: context,
      onEdit: startEditing,
      onSave: saveDealBreakers,
      onCancel: cancelEditing,
      onAdd: addDealBreaker,
      onRemove: removeDealBreaker,
    );
  }

  void startEditing() {
    _tempDealBreakers = List.from(initialDealBreakers);
    _isEditing = true;
  }

  void cancelEditing() {
    _tempDealBreakers.clear();
    _isEditing = false;
  }

  void addDealBreaker(String dealBreaker) {
    if (!_tempDealBreakers.contains(dealBreaker) && _tempDealBreakers.length < maxItems) {
      _tempDealBreakers.add(dealBreaker);
    }
  }

  void removeDealBreaker(String dealBreaker) {
    _tempDealBreakers.remove(dealBreaker);
  }

  Future<void> saveDealBreakers() async {
    final success = await onSave(_tempDealBreakers);
    if (success) {
      _isEditing = false;
      _tempDealBreakers.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deal breakers updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update deal breakers'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildEditableSubSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
    required bool isEditing,
    required List<String> tempItems,
    required int maxItems,
    required BuildContext context,
    required VoidCallback onEdit,
    required VoidCallback onSave,
    required VoidCallback onCancel,
    required Function(String) onAdd,
    required Function(String) onRemove,
  }) {
    // Your existing _buildEditableSubSection implementation
    return Container(); // Replace with actual implementation
  }
}