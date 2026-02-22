import 'package:flutter/material.dart';
import '../../../../core/utils/mock_data.dart';
import '../../../../core/widgets/fullscreen_image_viewer.dart';
import '../../../auth/presentation/pages/get_started_page.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;
  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isFollowing = false;

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: widget.userId != null
            ? BackButton(color: theme.iconTheme.color)
            : IconButton(
                // Replaced more_horiz with settings as requested
                icon: Icon(Icons.settings, color: theme.iconTheme.color),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
        title: Text(
          'kippy_fan',
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Avatar and Name
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: GetStartedConstants.primaryColor,
                          width: 3,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=12',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Kippy Fan ✨',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '@kippy_fan',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Capturing life one lime at a time 🍋\nDigital nomad & matcha enthusiast.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 24),

                    // Stats
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatColumn(title: 'POSTS', value: '124'),
                        _StatColumn(title: 'FOLLOWERS', value: '4.5k'),
                        _StatColumn(title: 'FOLLOWING', value: '320'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: ElevatedButton(
                              onPressed: _toggleFollow,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isFollowing
                                    ? Colors.grey.shade200
                                    : GetStartedConstants.primaryColor,
                                foregroundColor: _isFollowing
                                    ? Colors.black
                                    : Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                _isFollowing ? 'Following' : 'Follow',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              child: const Icon(Icons.mail_outline),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    indicatorColor: theme.iconTheme.color,
                    labelColor: theme.iconTheme.color,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(icon: Icon(Icons.grid_on)),
                      Tab(icon: Icon(Icons.bookmark_outline)),
                    ],
                  ),
                  theme.scaffoldBackgroundColor, // passing background color
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              // Posts Grid
              GridView.builder(
                padding: const EdgeInsets.all(2),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: 15,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Image.network(
                      'https://picsum.photos/seed/${index + 100}/400/400',
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
              // Saved Tab
              ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: globalFeedNotifier,
                builder: (context, posts, child) {
                  final savedPosts = posts
                      .where((p) => p['isSaved'] == true)
                      .toList();
                  if (savedPosts.isEmpty) {
                    return const Center(
                      child: Text(
                        'No saved posts yet! 🍋',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(2),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                    itemCount: savedPosts.length,
                    itemBuilder: (context, index) {
                      final post = savedPosts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullscreenImageViewer(
                                imageUrl: post['imageUrl'],
                                heroTag: 'saved_post_${post['id']}',
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'saved_post_${post['id']}',
                          child: Container(
                            color: Colors.grey.shade200,
                            child: Image.network(
                              post['imageUrl'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String title;
  final String value;

  const _StatColumn({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final Color backgroundColor;

  _SliverAppBarDelegate(this._tabBar, this.backgroundColor);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: backgroundColor, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
