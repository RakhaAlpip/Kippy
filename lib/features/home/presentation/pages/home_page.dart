import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/injection_container.dart' as di;
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/shimmer_loading_list.dart';
import '../../../../core/widgets/animated_list_item.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/story.dart';
import '../bloc/home_bloc.dart';
import '../../../social/presentation/bloc/social_bloc.dart';
import '../../../social/presentation/widgets/comment_bottom_sheet.dart';
import '../../../../core/widgets/broken_image_fallback.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<HomeBloc>()..add(HomeFetchRequested()),
        ),
        BlocProvider(create: (_) => di.sl<SocialBloc>()),
      ],
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Kippy',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF8DEE10),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.send_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return ShimmerLoadingList.feed();
          }
          if (state is HomeError) {
            return ErrorStateWidget(
              icon: Icons.wifi_off,
              title: 'Failed to load feed',
              message: state.message,
              onRetry: () => context.read<HomeBloc>().add(HomeFetchRequested()),
            );
          }
          if (state is HomeLoaded) {
            return _buildLoadedFeed(context, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadedFeed(BuildContext context, HomeLoaded state) {
    return RefreshIndicator(
      color: const Color(0xFF8DEE10),
      onRefresh: () async {
        context.read<HomeBloc>().add(HomeRefreshRequested());
        // Wait a tick for UX
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: CustomScrollView(
        slivers: [
          // Stories
          if (state.stories.isNotEmpty)
            SliverToBoxAdapter(child: _buildStories(state.stories)),
          // Posts
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index >= state.posts.length) {
                // Load more trigger
                if (!state.hasReachedMax) {
                  context.read<HomeBloc>().add(HomeLoadMoreRequested());
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF8DEE10),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        "You're all caught up! 🐸",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }
              }
              return AnimatedListItem(
                index: index,
                child: _PostCard(post: state.posts[index]),
              );
            }, childCount: state.posts.length + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildStories(List<Story> stories) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final story = stories[index];
          return AnimatedListItem(
            index: index,
            slideOffset: const Offset(0.2, 0.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: story.isSeen
                          ? Colors.grey.shade300
                          : const Color(0xFF8DEE10),
                      width: 2,
                    ),
                  ),
                  child: story.userAvatarUrl == null
                      ? const Icon(Icons.person)
                      : CachedNetworkImage(
                          imageUrl: story.userAvatarUrl!,
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: imageProvider,
                              ),
                          placeholder: (context, url) => const CircleAvatar(
                            radius: 28,
                            backgroundColor: Color(0xFFE8E8E3),
                          ),
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                                radius: 28,
                                child: Icon(Icons.person),
                              ),
                        ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 60,
                  child: Text(
                    story.username,
                    style: const TextStyle(fontSize: 11),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final Post post;

  const _PostCard({required this.post});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard>
    with SingleTickerProviderStateMixin {
  bool _isLiked = false;
  bool _isSaved = false;
  int _likesCount = 0;
  bool _showHeart = false;

  late AnimationController _heartController;
  late Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;
    _isSaved = widget.post.isBookmarked;
    _likesCount = widget.post.likesCount;

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _heartAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
    );
    _heartController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) setState(() => _showHeart = false);
        });
      }
    });
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _doubleTapLike() {
    if (!_isLiked) {
      setState(() {
        _isLiked = true;
        _likesCount++;
        _showHeart = true;
      });
      // Dispatch like via BLoC
      context.read<SocialBloc>().add(SocialLikePostRequested(widget.post.id));
    } else {
      setState(() => _showHeart = true);
    }
    _heartController.forward(from: 0);
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
    });
    if (_isLiked) {
      context.read<SocialBloc>().add(SocialLikePostRequested(widget.post.id));
    } else {
      context.read<SocialBloc>().add(SocialUnlikePostRequested(widget.post.id));
    }
  }

  void _toggleBookmark() {
    setState(() => _isSaved = !_isSaved);
  }

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                widget.post.userAvatarUrl == null
                    ? const CircleAvatar(
                        radius: 16,
                        child: Icon(Icons.person, size: 16),
                      )
                    : CachedNetworkImage(
                        imageUrl: widget.post.userAvatarUrl!,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 16,
                          backgroundImage: imageProvider,
                        ),
                        placeholder: (context, url) => const CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFFE8E8E3),
                        ),
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                              radius: 16,
                              child: Icon(Icons.person, size: 16),
                            ),
                      ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_horiz, color: Colors.grey.shade600),
              ],
            ),
          ),

          // Image
          GestureDetector(
            onDoubleTap: _doubleTapLike,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 4 / 5,
                  child: CachedNetworkImage(
                    imageUrl: widget.post.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: const Color(0xFFE8E8E3)),
                    errorWidget: (_, __, ___) => const BrokenImageFallback(),
                  ),
                ),
                // Heart animation overlay
                if (_showHeart)
                  AnimatedBuilder(
                    animation: _heartAnimation,
                    builder: (context, child) => Transform.scale(
                      scale: _heartAnimation.value,
                      child: AnimatedOpacity(
                        opacity: _showHeart ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _AnimatedActionButton(
                  icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : Colors.black87,
                  onPressed: _toggleLike,
                ),
                const SizedBox(width: 12),
                _AnimatedActionButton(
                  icon: Icons.chat_bubble_outline,
                  color: Colors.black87,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => BlocProvider.value(
                        value: context.read<SocialBloc>(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: CommentBottomSheet(postId: widget.post.id),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                _AnimatedActionButton(
                  icon: Icons.send_outlined,
                  color: Colors.black87,
                  onPressed: () {},
                ),
                const Spacer(),
                _AnimatedActionButton(
                  icon: _isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: _isSaved ? const Color(0xFF8DEE10) : Colors.black87,
                  onPressed: _toggleBookmark,
                ),
              ],
            ),
          ),

          // Likes count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$_likesCount likes',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),

          // Caption
          if (widget.post.caption != null && widget.post.caption!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                  children: [
                    TextSpan(
                      text: '${widget.post.username} ',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: widget.post.caption!),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // View comments
          if (widget.post.commentsCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => BlocProvider.value(
                      value: context.read<SocialBloc>(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: CommentBottomSheet(postId: widget.post.id),
                      ),
                    ),
                  );
                },
                child: Text(
                  'View all ${widget.post.commentsCount} comments',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ),
            ),

          // Timestamp
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              _timeAgo(widget.post.createdAt).toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade400,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedActionButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _AnimatedActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
        widget.onPressed();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Icon(widget.icon, color: widget.color, size: 24),
      ),
    );
  }
}
