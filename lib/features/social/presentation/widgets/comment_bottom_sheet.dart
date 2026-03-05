import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/animated_list_item.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../auth/presentation/pages/get_started_page.dart';
import '../../domain/entities/comment.dart';
import '../bloc/social_bloc.dart';

class CommentBottomSheet extends StatefulWidget {
  final String postId;

  const CommentBottomSheet({super.key, required this.postId});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SocialBloc>().add(SocialFetchCommentsRequested(widget.postId));
  }

  void _postComment() {
    if (_commentController.text.trim().isNotEmpty) {
      context.read<SocialBloc>().add(
        SocialAddCommentRequested(
          postId: widget.postId,
          content: _commentController.text.trim(),
        ),
      );
      _commentController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Comments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 32),
          // Comments List
          Expanded(
            child: BlocBuilder<SocialBloc, SocialState>(
              builder: (context, state) {
                if (state is SocialLoading) {
                  return _buildCommentShimmer();
                }
                if (state is SocialError) {
                  return ErrorStateWidget(
                    icon: Icons.chat_bubble_outline,
                    title: 'Failed to load comments',
                    message: state.message,
                    onRetry: () => context.read<SocialBloc>().add(
                      SocialFetchCommentsRequested(widget.postId),
                    ),
                  );
                }
                if (state is SocialCommentsLoaded) {
                  if (state.comments.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('💬', style: TextStyle(fontSize: 40)),
                          const SizedBox(height: 12),
                          Text(
                            'No comments yet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Start the conversation!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return _buildCommentList(state.comments);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          // Comment Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFE8E8E3),
                    child: Icon(Icons.person, size: 18, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.black87),
                      onSubmitted: (_) => _postComment(),
                    ),
                  ),
                  TextButton(
                    onPressed: _postComment,
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        color: GetStartedConstants.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentList(List<Comment> comments) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return AnimatedListItem(
          index: index,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFE8E8E3),
                  backgroundImage: comment.userAvatarUrl != null
                      ? NetworkImage(comment.userAvatarUrl!)
                      : null,
                  child: comment.userAvatarUrl == null
                      ? const Icon(Icons.person, size: 16, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(
                              text: '${comment.username} ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: comment.content),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _timeAgo(comment.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<SocialBloc>().add(
                      SocialDeleteCommentRequested(
                        postId: widget.postId,
                        commentId: comment.id,
                      ),
                    );
                  },
                  child: Icon(
                    Icons.favorite_border,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommentShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 6,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            LoadingShimmer(width: 32, height: 32, borderRadius: 16),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoadingShimmer(width: 100, height: 12, borderRadius: 6),
                  SizedBox(height: 6),
                  LoadingShimmer(
                    width: double.infinity,
                    height: 10,
                    borderRadius: 5,
                  ),
                  SizedBox(height: 4),
                  LoadingShimmer(width: 60, height: 10, borderRadius: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
