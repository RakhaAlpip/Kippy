import 'package:flutter/foundation.dart';

// Global notifier to mock state changes (like adding a post or bookmark)
// In a real app, this is handled by BLoC state emitting new list states.
final ValueNotifier<List<Map<String, dynamic>>> globalFeedNotifier =
    ValueNotifier(
      List.generate(
        10,
        (index) => {
          'id': index,
          'username': _getMockUsername(index),
          'imageUrl': 'https://picsum.photos/seed/${index + 40}/800/1000',
          'caption': 'Living the best life! 🍋 #kippy',
          'likes': 120 + index * 5,
          'isLiked': false,
          'isSaved': false,
        },
      ),
    );

String _getMockUsername(int index) {
  final names = [
    'the_lime_life',
    'digital_frog',
    'matcha_lover',
    'kippy_fan_123',
    'sunset_seeker',
  ];
  return names[index % names.length];
}
