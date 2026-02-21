import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/itinerary.dart';

/// Maps string icon names to Material Icons.
IconData _resolveIcon(String iconName) {
  switch (iconName) {
    case 'wb_sunny':
      return Icons.wb_sunny_rounded;
    case 'temple_hindu':
      return Icons.temple_hindu_rounded;
    case 'restaurant':
      return Icons.restaurant_rounded;
    case 'local_fire_department':
      return Icons.local_fire_department_rounded;
    case 'self_improvement':
      return Icons.self_improvement_rounded;
    default:
      return Icons.circle;
  }
}

class TimelineTile extends StatelessWidget {
  final ItineraryStep step;
  final bool isFirst;
  final bool isLast;
  final Color primaryColor;

  const TimelineTile({
    super.key,
    required this.step,
    this.isFirst = false,
    this.isLast = false,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator column
          SizedBox(
            width: 60,
            child: Column(
              children: [
                // Top connector
                if (!isFirst)
                  Container(
                    width: 2,
                    height: 20,
                    color: primaryColor.withAlpha(80),
                  )
                else
                  const SizedBox(height: 20),

                // Circle indicator
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withAlpha(60),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _resolveIcon(step.iconName),
                    color: Colors.white,
                    size: 22,
                  ),
                ),

                // Bottom connector
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: primaryColor.withAlpha(80),
                    ),
                  )
                else
                  const Spacer(),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Content card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16, top: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      step.time,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step.title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    step.description,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.5,
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
}
