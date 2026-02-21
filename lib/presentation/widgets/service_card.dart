import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/travel_service.dart';

/// Maps string icon names from mock data to Material Icons.
IconData _resolveIcon(String iconName) {
  switch (iconName) {
    case 'directions_boat':
      return Icons.directions_boat_rounded;
    case 'temple_hindu':
      return Icons.temple_hindu_rounded;
    case 'restaurant':
      return Icons.restaurant_rounded;
    default:
      return Icons.explore_rounded;
  }
}

class ServiceCard extends StatefulWidget {
  final TravelService service;
  final VoidCallback onTap;

  const ServiceCard({super.key, required this.service, required this.onTap});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0.0, _isHovered ? -4.0 : 0.0, 0.0),
        child: Card(
          elevation: _isHovered ? 8 : 2,
          shadowColor: primaryColor.withAlpha(_isHovered ? 60 : 30),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Image.network(
                        widget.service.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: primaryColor.withAlpha(30),
                          child: Icon(
                            _resolveIcon(widget.service.iconName),
                            size: 48,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    // Duration chip
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(150),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.service.duration,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Icon badge
                    Positioned(
                      bottom: 0,
                      left: 16,
                      child: Transform.translate(
                        offset: const Offset(0, 20),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withAlpha(80),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            _resolveIcon(widget.service.iconName),
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Content section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.service.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade900,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.service.description,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '₹${widget.service.price.toInt()}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text: ' /person',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // CTA
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Inquire Now',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
