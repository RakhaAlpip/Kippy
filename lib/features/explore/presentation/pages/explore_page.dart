import 'package:flutter/material.dart';
import '../../../../core/widgets/fullscreen_image_viewer.dart';
import '../../../auth/presentation/pages/get_started_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _exploreItems = [];
  String _searchQuery = '';
  String _selectedGenre = 'Trending';

  final List<String> _genres = [
    'Trending',
    'Nature',
    'Travel',
    'Art & Design',
    'Photography',
  ];

  @override
  void initState() {
    super.initState();
    _exploreItems = List.generate(40, (index) {
      final isSquare = index % 3 == 0;
      final genre = _genres[index % _genres.length];
      return {
        'id': index,
        'title': 'Amazing $genre Post $index',
        'genre': genre,
        'imageUrl':
            'https://picsum.photos/seed/${index + 100}/400/${isSquare ? 400 : 600}',
        'isSquare': isSquare,
      };
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredItems = _exploreItems.where((item) {
      final matchesGenre =
          _selectedGenre == 'Trending' || item['genre'] == _selectedGenre;
      final matchesSearch =
          item['title'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          item['genre'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      return matchesGenre && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Text(
                'Explore',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search Kippy...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: _genres.map((genre) {
                final icon = genre == 'Trending' ? Icons.trending_up : null;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedGenre = genre;
                    });
                  },
                  child: _buildChip(
                    genre,
                    _selectedGenre == genre,
                    icon,
                    theme,
                  ),
                );
              }).toList(),
            ),
          ),

          // Explore Grid
          Expanded(
            child: GridView.custom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio:
                    0.7, // Slightly taller cards to mimic staggered look without external package
              ),
              childrenDelegate: SliverChildBuilderDelegate((context, index) {
                // Make some items square and some tall for a mock staggered look
                final item = filteredItems[index];
                final isSquare = item['isSquare'] as bool;
                final imageUrl = item['imageUrl'] as String;
                final heroTag = 'explore_post_${item['id']}';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullscreenImageViewer(
                          imageUrl: imageUrl,
                          heroTag: heroTag,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.only(
                            bottom: isSquare ? 40 : 0,
                          ), // Mock staggering
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Hero(
                              tag: heroTag,
                              child: Image.network(imageUrl, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                      // Top right icon (optional, like reels or multiple images)
                      if (index % 5 == 0)
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: Icon(
                            Icons.collections,
                            color: Colors.white,
                            size: 20,
                            shadows: [
                              Shadow(color: Colors.black45, blurRadius: 4),
                            ],
                          ),
                        ),
                      // Mock heart overlay for aesthetics on some
                      if (index == 2)
                        const Positioned(
                          top: 12,
                          right: 12,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                );
              }, childCount: filteredItems.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    String label,
    bool isSelected,
    IconData? icon,
    ThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? GetStartedConstants.primaryColor
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.black : theme.iconTheme.color,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.black
                  : theme.textTheme.bodyMedium?.color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
