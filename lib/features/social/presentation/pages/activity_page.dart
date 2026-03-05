import 'package:flutter/material.dart';

import '../../../../core/widgets/animated_list_item.dart';
import '../../../auth/presentation/pages/get_started_page.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text(
          'Activity',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildActivityList(),
    );
  }

  Widget _buildActivityList() {
    // Mock activity data — in production, this would come from a BLoC
    final activities = [
      _Activity('user_1', 'started following you', ActivityType.follow, '2m'),
      _Activity('user_2', 'liked your post', ActivityType.like, '15m'),
      _Activity('user_3', 'commented on your post', ActivityType.comment, '1h'),
      _Activity('user_4', 'started following you', ActivityType.follow, '2h'),
      _Activity('user_5', 'liked your post', ActivityType.like, '5h'),
      _Activity(
        'user_6',
        'mentioned you in a comment',
        ActivityType.comment,
        '1d',
      ),
      _Activity('user_7', 'started following you', ActivityType.follow, '2d'),
      _Activity('user_8', 'liked your post', ActivityType.like, '3d'),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: activities.length,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final activity = activities[index];
        return AnimatedListItem(
          index: index,
          slideOffset: const Offset(0.15, 0.0), // Slide from right
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFE8E8E3),
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=${index + 20}',
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: activity.type == ActivityType.follow
                          ? GetStartedConstants.primaryColor
                          : activity.type == ActivityType.like
                          ? Colors.red
                          : Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      activity.type == ActivityType.follow
                          ? Icons.person_add
                          : activity.type == ActivityType.like
                          ? Icons.favorite
                          : Icons.chat_bubble,
                      size: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            title: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  TextSpan(
                    text: activity.username,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: ' ${activity.action}'),
                ],
              ),
            ),
            subtitle: Text(
              activity.timeAgo,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            trailing: activity.type == ActivityType.follow
                ? SizedBox(
                    width: 80,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GetStartedConstants.primaryColor,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Follow',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      'https://picsum.photos/100/100?random=${index + 50}',
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

enum ActivityType { follow, like, comment }

class _Activity {
  final String username;
  final String action;
  final ActivityType type;
  final String timeAgo;

  _Activity(this.username, this.action, this.type, this.timeAgo);
}
