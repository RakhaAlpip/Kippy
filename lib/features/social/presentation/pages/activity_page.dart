import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: const Text(
          'Activity',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.separated(
        itemCount: 20,
        separatorBuilder: (context, index) =>
            Divider(color: Colors.grey.shade200, height: 1),
        itemBuilder: (context, index) {
          final isFollow = index % 3 == 0;
          final time = '${index + 1}h ago';

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=${index + 40}',
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isFollow ? Colors.blue : Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      isFollow ? Icons.person_add : Icons.favorite,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            title: RichText(
              text: TextSpan(
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                children: [
                  TextSpan(
                    text: 'user_${index + 40} ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: isFollow
                        ? 'started following you.'
                        : 'liked your photo.',
                  ),
                ],
              ),
            ),
            subtitle: Text(
              time,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            trailing: isFollow
                ? ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.textTheme.bodyLarge?.color,
                      foregroundColor: theme.scaffoldBackgroundColor,
                      minimumSize: const Size(80, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Follow'),
                  )
                : Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://picsum.photos/seed/${index + 10}/200/200',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
