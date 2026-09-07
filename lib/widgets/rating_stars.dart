import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;
  final bool showValue;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 20,
    this.color,
    this.showValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final starColor = color ?? theme.colorScheme.tertiary;
    final displayRating = rating.clamp(0.0, 10.0) / 2;
    final fullStars = displayRating.floor();
    final hasHalfStar = (displayRating - fullStars) >= 0.5;
    final emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < fullStars; i++)
          Icon(
            Icons.star,
            size: size,
            color: starColor,
          ),
        if (hasHalfStar)
          Icon(
            Icons.star_half,
            size: size,
            color: starColor,
          ),
        for (int i = 0; i < emptyStars; i++)
          Icon(
            Icons.star_border,
            size: size,
            color: starColor.withOpacity(0.4),
          ),
        if (showValue) ...[
          const SizedBox(width: 8),
          Text(
            rating.toStringAsFixed(1),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
