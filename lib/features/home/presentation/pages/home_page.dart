import 'package:flutter/material.dart';
import '../../../../core/widgets/fullscreen_image_viewer.dart';
import '../../../../core/utils/mock_data.dart';
import '../../../social/presentation/widgets/comment_bottom_sheet.dart';
import '../../../auth/presentation/pages/get_started_page.dart'; // for GetStartedConstants

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    globalFeedNotifier.addListener(_refreshFeed);
  }

  @override
  void dispose() {
    globalFeedNotifier.removeListener(_refreshFeed);
    super.dispose();
  }

  void _refreshFeed() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Kippy ',
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: -0.5,
              ),
            ),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: GetStartedConstants.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        color: GetStartedConstants.primaryColor,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1)); // Mock refresh
        },
        child: CustomScrollView(
          slivers: [
            // Suggested to Follow Section
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 16,
                      bottom: 8,
                    ),
                    child: Text(
                      'Suggested to Follow',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 30, // 60x60
                                    backgroundColor: Colors.grey.shade200,
                                    backgroundImage: NetworkImage(
                                      'https://i.pravatar.cc/150?img=${index + 15}',
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: GetStartedConstants.primaryColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: theme.scaffoldBackgroundColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        size: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'user_mock_$index',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      theme.textTheme.bodyMedium?.color ??
                                      Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            SliverToBoxAdapter(
              child: Divider(color: Colors.grey.shade200, height: 1),
            ),

            // Feed Section
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final posts = globalFeedNotifier.value;
                if (index >= posts.length) return null;
                final post = posts[index];

                return _PostCard(
                  key: ValueKey(post['id']),
                  index: post['id'] as int,
                  username: post['username'] as String,
                  imageUrl: post['imageUrl'] as String,
                  caption: post['caption'] as String,
                  likes: post['likes'] as int,
                  isLiked: post['isLiked'] as bool,
                  isSaved: post['isSaved'] as bool,
                );
              }, childCount: globalFeedNotifier.value.length),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final int index;
  final String username;
  final String imageUrl;
  final String caption;
  final int likes;
  final bool isLiked;
  final bool isSaved;

  const _PostCard({
    super.key,
    required this.index,
    required this.username,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.isLiked,
    required this.isSaved,
  });

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard>
    with SingleTickerProviderStateMixin {
  bool _isLiked = false;
  bool _isSaved = false;
  int _likesCount = 0;

  // Animation for the double-tap heart
  bool _isHeartAnimating = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _isSaved = widget.isSaved;
    _likesCount = widget.likes;
  }

  void _doubleTapLike() {
    setState(() {
      _isHeartAnimating = true;
      if (!_isLiked) {
        _isLiked = true;
        _likesCount++;
        _updateGlobalState();
      }
    });

    // Hide the heart after animation
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _isHeartAnimating = false;
        });
      }
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _isLiked ? _likesCount++ : _likesCount--;
    });
    _updateGlobalState();
  }

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;
    });
    _updateGlobalState();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isSaved ? 'Post saved to Bookmarks' : 'Removed from Bookmarks',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _updateGlobalState() {
    final currentPosts = globalFeedNotifier.value;
    final existingIndex = currentPosts.indexWhere(
      (p) => p['id'] == widget.index,
    );
    if (existingIndex != -1) {
      currentPosts[existingIndex] = {
        ...currentPosts[existingIndex],
        'isLiked': _isLiked,
        'isSaved': _isSaved,
        'likes': _likesCount,
      };
      globalFeedNotifier.value = List.from(currentPosts);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      color: theme.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=${widget.index + 20}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      const Text(
                        'San Francisco, CA',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz, color: theme.iconTheme.color),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Image / Media with Double Tap Heart effect
          GestureDetector(
            onDoubleTap: _doubleTapLike,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullscreenImageViewer(
                    imageUrl: widget.imageUrl,
                    heroTag: 'home_post_${widget.index}',
                  ),
                ),
              );
            },
            child: AspectRatio(
              aspectRatio: 4 / 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: Hero(
                      tag: 'home_post_${widget.index}',
                      child: Image.network(widget.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  // Animated Large Heart
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isHeartAnimating ? 1.0 : 0.0,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 0.5,
                        end: _isHeartAnimating ? 1.2 : 0.5,
                      ),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.elasticOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 100,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 20,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Actions Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                // Animated small like button
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 1.0, end: _isLiked ? 1.2 : 1.0),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: IconButton(
                        icon: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked
                              ? GetStartedConstants.primaryColor
                              : theme.iconTheme.color,
                        ),
                        onPressed: () {
                          // Bounce effect by resetting the tween end manually inside toggle
                          _toggleLike();
                        },
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    color: theme.iconTheme.color,
                  ),
                  onPressed: () {
                    // Open bottom sheet
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => FractionalTranslation(
                        translation: Offset(0, 0),
                        child: FractionallySizedBox(
                          heightFactor: 0.85,
                          child: const CommentBottomSheet(),
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send_outlined, color: theme.iconTheme.color),
                  onPressed: () {},
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    _isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: _isSaved
                        ? GetStartedConstants.primaryColor
                        : theme.iconTheme.color,
                  ),
                  onPressed: _toggleSave,
                ),
              ],
            ),
          ),

          // Likes Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$_likesCount likes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),

          // Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color ?? Colors.black,
                ),
                children: [
                  TextSpan(
                    text: '${widget.username} ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(text: widget.caption),
                ],
              ),
            ),
          ),

          // View Comments Link
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'View all 12 comments',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),

          // Time Ago
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '2 HOURS AGO',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
