import 'package:flutter/material.dart';
import 'loading_shimmer.dart';

/// Pre-built shimmer loading layouts for common patterns.
class ShimmerLoadingList extends StatelessWidget {
  final Widget Function(BuildContext context) builder;

  const ShimmerLoadingList._({required this.builder});

  /// Feed shimmer: avatar + text + large image + action row
  factory ShimmerLoadingList.feed({int itemCount = 3}) {
    return ShimmerLoadingList._(
      builder: (context) => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0),
        itemCount: itemCount,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: avatar + username
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const LoadingShimmer(
                      width: 32,
                      height: 32,
                      borderRadius: 16,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        LoadingShimmer(width: 100, height: 12, borderRadius: 6),
                        SizedBox(height: 4),
                        LoadingShimmer(width: 60, height: 10, borderRadius: 5),
                      ],
                    ),
                  ],
                ),
              ),
              // Image placeholder
              const LoadingShimmer(
                width: double.infinity,
                height: 300,
                borderRadius: 0,
              ),
              // Actions
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: const [
                    LoadingShimmer(width: 24, height: 24, borderRadius: 4),
                    SizedBox(width: 16),
                    LoadingShimmer(width: 24, height: 24, borderRadius: 4),
                    SizedBox(width: 16),
                    LoadingShimmer(width: 24, height: 24, borderRadius: 4),
                    Spacer(),
                    LoadingShimmer(width: 24, height: 24, borderRadius: 4),
                  ],
                ),
              ),
              // Caption lines
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LoadingShimmer(width: 80, height: 12, borderRadius: 6),
                    SizedBox(height: 8),
                    LoadingShimmer(
                      width: double.infinity,
                      height: 10,
                      borderRadius: 5,
                    ),
                    SizedBox(height: 4),
                    LoadingShimmer(width: 200, height: 10, borderRadius: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Grid shimmer: 2-column grid of rounded rectangles
  factory ShimmerLoadingList.grid({int itemCount = 6, int crossAxisCount = 2}) {
    return ShimmerLoadingList._(
      builder: (context) => GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: crossAxisCount == 3 ? 1.0 : 0.7,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) => const LoadingShimmer(borderRadius: 16),
      ),
    );
  }

  /// List shimmer: rows with circle + text lines
  factory ShimmerLoadingList.list({int itemCount = 8}) {
    return ShimmerLoadingList._(
      builder: (context) => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: itemCount,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              const LoadingShimmer(width: 48, height: 48, borderRadius: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    LoadingShimmer(
                      width: double.infinity,
                      height: 12,
                      borderRadius: 6,
                    ),
                    SizedBox(height: 6),
                    LoadingShimmer(width: 120, height: 10, borderRadius: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Profile shimmer: large circle center + stat row + grid
  factory ShimmerLoadingList.profile() {
    return ShimmerLoadingList._(
      builder: (context) => SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Avatar
            const Center(
              child: LoadingShimmer(width: 80, height: 80, borderRadius: 40),
            ),
            const SizedBox(height: 12),
            const Center(
              child: LoadingShimmer(width: 120, height: 16, borderRadius: 8),
            ),
            const SizedBox(height: 8),
            const Center(
              child: LoadingShimmer(width: 80, height: 12, borderRadius: 6),
            ),
            const SizedBox(height: 24),
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3,
                (_) => Column(
                  children: const [
                    LoadingShimmer(width: 40, height: 18, borderRadius: 9),
                    SizedBox(height: 4),
                    LoadingShimmer(width: 60, height: 10, borderRadius: 5),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Button
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: LoadingShimmer(
                width: double.infinity,
                height: 40,
                borderRadius: 12,
              ),
            ),
            const SizedBox(height: 24),
            // Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: 9,
              itemBuilder: (context, index) =>
                  const LoadingShimmer(borderRadius: 0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}
