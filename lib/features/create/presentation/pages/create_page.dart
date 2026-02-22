import 'package:flutter/material.dart';
import '../../../../core/utils/mock_data.dart';
import '../../../auth/presentation/pages/get_started_page.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('New Post'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Preview (Mocked with network image for now)
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  'https://picsum.photos/seed/friends2/800/800',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Caption Input
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                hintText: 'Write a caption...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 16),
            Divider(color: theme.dividerColor.withAlpha(50)),
            const SizedBox(height: 16),

            // Settings List
            _CreateOptionTile(icon: Icons.person_outline, title: 'Tag People'),
            const SizedBox(height: 16),
            _CreateOptionTile(
              icon: Icons.location_on_outlined,
              title: 'Add Location',
            ),
            const SizedBox(height: 16),
            _CreateOptionTile(
              icon: Icons.tune,
              title: 'Advanced Settings',
              isDropdown: true,
            ),

            const SizedBox(height: 48),

            // Share Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Simulate uploading and prepend to global mock data
                  final caption = _captionController.text.trim();
                  globalFeedNotifier.value = [
                    {
                      'id': DateTime.now().millisecondsSinceEpoch,
                      'username': 'kippy_fan_123',
                      'imageUrl': 'https://picsum.photos/seed/friends2/800/800',
                      'caption': caption.isEmpty
                          ? 'Just chilling! 🐸'
                          : caption,
                      'likes': 0,
                      'isLiked': false,
                      'isSaved': false,
                    },
                    ...globalFeedNotifier.value,
                  ];

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Post Uploaded Successfully! 🐸'),
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: GetStartedConstants.primaryColor,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Share Post',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.send),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDropdown;

  const _CreateOptionTile({
    required this.icon,
    required this.title,
    this.isDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: GetStartedConstants.primaryColor.withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: GetStartedConstants.primaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
        Icon(
          isDropdown ? Icons.keyboard_arrow_down : Icons.chevron_right,
          color: Colors.grey,
        ),
      ],
    );
  }
}
