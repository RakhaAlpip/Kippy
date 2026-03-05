import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/injection_container.dart' as di;
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/shimmer_loading_list.dart';
import '../../../../core/widgets/animated_list_item.dart';
import '../../../../config/app_router.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../home/domain/entities/post.dart';
import '../bloc/profile_bloc.dart';
import '../../../social/presentation/bloc/social_bloc.dart';

class ProfilePage extends StatelessWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              di.sl<ProfileBloc>()..add(ProfileFetchRequested(userId ?? 'me')),
        ),
        BlocProvider(create: (_) => di.sl<SocialBloc>()),
      ],
      child: _ProfilePageContent(userId: userId),
    );
  }
}

class _ProfilePageContent extends StatelessWidget {
  final String? userId;
  const _ProfilePageContent({this.userId});

  bool get _isCurrentUser => userId == null || userId == 'me';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return ShimmerLoadingList.profile();
          }
          if (state is ProfileError) {
            return ErrorStateWidget(
              icon: Icons.person_off,
              title: 'Failed to load profile',
              message: state.message,
              onRetry: () => context.read<ProfileBloc>().add(
                ProfileFetchRequested(userId ?? 'me'),
              ),
            );
          }
          if (state is ProfileLoaded) {
            return _buildProfile(context, state.user, state.posts);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfile(BuildContext context, User user, List<Post> posts) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              pinned: true,
              title: Text(
                user.username,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                if (_isCurrentUser)
                  IconButton(
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: Colors.black87,
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.settings),
                  ),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Avatar
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF8DEE10),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: user.avatarUrl != null
                          ? CachedNetworkImageProvider(user.avatarUrl!)
                          : null,
                      child: user.avatarUrl == null
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (user.fullName != null)
                    Text(
                      user.fullName!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    '@${user.username}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  if (user.bio != null && user.bio!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        user.bio!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _CountUpStat(count: user.postsCount, label: 'Posts'),
                      Container(
                        width: 1,
                        height: 28,
                        color: Colors.grey.shade300,
                      ),
                      _CountUpStat(
                        count: user.followersCount,
                        label: 'Followers',
                      ),
                      Container(
                        width: 1,
                        height: 28,
                        color: Colors.grey.shade300,
                      ),
                      _CountUpStat(
                        count: user.followingCount,
                        label: 'Following',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: _isCurrentUser
                              ? OutlinedButton(
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.editProfile,
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black87,
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text('Edit Profile'),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    if (user.isFollowed) {
                                      context.read<SocialBloc>().add(
                                        SocialUnfollowUserRequested(user.id),
                                      );
                                    } else {
                                      context.read<SocialBloc>().add(
                                        SocialFollowUserRequested(user.id),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: user.isFollowed
                                        ? Colors.grey.shade200
                                        : const Color(0xFF8DEE10),
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  child: Text(
                                    user.isFollowed ? 'Following' : 'Follow',
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  indicatorColor: const Color(0xFF8DEE10),
                  labelColor: Colors.black87,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(icon: Icon(Icons.grid_on)),
                    Tab(icon: Icon(Icons.bookmark_border)),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            // Posts grid
            _buildPostsGrid(posts),
            // Saved (placeholder — use BookmarkBloc separately)
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🔖', style: TextStyle(fontSize: 40)),
                  SizedBox(height: 8),
                  Text('Saved posts', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsGrid(List<Post> posts) {
    if (posts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('📷', style: TextStyle(fontSize: 40)),
            SizedBox(height: 8),
            Text('No posts yet', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return AnimatedListItem(
          index: index,
          slideOffset: const Offset(0, 0.05),
          child: CachedNetworkImage(
            imageUrl: post.imageUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(color: const Color(0xFFE8E8E3)),
            errorWidget: (_, __, ___) => Container(
              color: const Color(0xFFE8E8E3),
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}

/// Count-up animation for profile stats
class _CountUpStat extends StatefulWidget {
  final int count;
  final String label;

  const _CountUpStat({required this.count, required this.label});

  @override
  State<_CountUpStat> createState() => _CountUpStatState();
}

class _CountUpStatState extends State<_CountUpStat>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _countAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _countAnimation = IntTween(
      begin: 0,
      end: widget.count,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _countAnimation,
          builder: (context, child) => Text(
            '${_countAnimation.value}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

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
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
