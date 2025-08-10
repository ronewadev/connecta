import 'package:connecta/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/functions/update_database.dart';

class BioSectionWidget extends StatefulWidget {
  final String? bio;
  final VoidCallback onBioUpdated;

  const BioSectionWidget({
    Key? key,
    required this.bio,
    required this.onBioUpdated,
  }) : super(key: key);

  @override
  State<BioSectionWidget> createState() => _BioSectionWidgetState();
}

class _BioSectionWidgetState extends State<BioSectionWidget> {
  bool _isEditing = false;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _bioController.text = widget.bio ?? '';
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _bioController.clear();
    });
  }

  Future<void> _saveBio() async {
    final newBio = _bioController.text.trim();
    if (newBio.length < 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bio must be at least 20 characters long'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final success = await ProfileUpdateService.updateBio(newBio);
    if (success) {
      setState(() {
        _isEditing = false;
        _bioController.clear();
      });
      widget.onBioUpdated();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bio updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update bio. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.penToSquare,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Bio',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _isEditing ? _cancelEditing : _startEditing,
                  icon: FaIcon(
                    _isEditing ? FontAwesomeIcons.times : FontAwesomeIcons.edit,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isEditing) ...[
              TextFormField(
                controller: _bioController,
                maxLines: 4,
                maxLength: 300,
                decoration: InputDecoration(
                  hintText: 'Tell us about yourself...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _cancelEditing,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _saveBio,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  widget.bio?.isNotEmpty == true
                      ? widget.bio!
                      : 'No bio added yet. Tap edit to add your bio.',
                  style: TextStyle(
                    color: widget.bio?.isNotEmpty == true
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
