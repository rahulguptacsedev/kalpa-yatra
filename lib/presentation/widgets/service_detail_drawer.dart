import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/travel_service.dart';
import '../../domain/entities/client_config.dart';
import 'quick_inquiry_form.dart';

/// Maps string icon names to Material Icons.
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

class ServiceDetailDrawer {
  static void show(
    BuildContext context, {
    required TravelService service,
    required ClientConfig clientConfig,
  }) {
    final isWide = MediaQuery.of(context).size.width > 700;

    if (isWide) {
      _showSidePanel(context, service: service, clientConfig: clientConfig);
    } else {
      _showBottomSheet(context, service: service, clientConfig: clientConfig);
    }
  }

  static void _showSidePanel(
    BuildContext context, {
    required TravelService service,
    required ClientConfig clientConfig,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, animation, __) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: Align(
            alignment: Alignment.centerRight,
            child: Material(
              elevation: 16,
              child: Container(
                width: 440,
                height: double.infinity,
                color: const Color(0xFFFFF8F0),
                child: _DetailContent(
                  service: service,
                  clientConfig: clientConfig,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void _showBottomSheet(
    BuildContext context, {
    required TravelService service,
    required ClientConfig clientConfig,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFF8F0),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    _DetailContent(
                      service: service,
                      clientConfig: clientConfig,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _DetailContent extends StatelessWidget {
  final TravelService service;
  final ClientConfig clientConfig;

  const _DetailContent({required this.service, required this.clientConfig});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  service.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: primaryColor.withAlpha(30),
                    child: Icon(
                      _resolveIcon(service.iconName),
                      size: 48,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withAlpha(120)],
                    ),
                  ),
                ),
              ),
              // Close button
              Positioned(
                top: 12,
                right: 12,
                child: CircleAvatar(
                  backgroundColor: Colors.black45,
                  radius: 18,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              // Price tag
              Positioned(
                bottom: 12,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '₹${service.price.toInt()} /person',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  service.title,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade900,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                // Duration chip
                Row(
                  children: [
                    Icon(Icons.schedule_rounded, size: 16, color: primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      service.duration,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Description
                Text(
                  service.description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),

                // Highlights
                Text(
                  'Highlights',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 12),
                ...service.highlights.map(
                  (h) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            h,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // WhatsApp button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () => _launchWhatsApp(service, clientConfig),
                    icon: const Icon(Icons.chat_rounded, size: 20),
                    label: Text(
                      'Chat on WhatsApp',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF25D366),
                      side: const BorderSide(
                        color: Color(0xFF25D366),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Divider
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 20),

                // Inquiry form
                QuickInquiryForm(service: service),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchWhatsApp(TravelService service, ClientConfig config) async {
    final message = Uri.encodeComponent(
      'Hi ${config.clientName}! 🙏\n\n'
      'I\'m interested in: ${service.title}\n'
      'Duration: ${service.duration}\n'
      'Price: ₹${service.price.toInt()}/person\n\n'
      'Could you share more details?',
    );
    final url = Uri.parse(
      'https://wa.me/${config.whatsappNumber}?text=$message',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
