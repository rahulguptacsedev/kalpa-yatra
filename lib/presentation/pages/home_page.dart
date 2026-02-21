import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/client_config_provider.dart';
import '../providers/travel_providers.dart';
import '../widgets/hero_section.dart';
import '../widgets/service_card.dart';
import '../widgets/service_detail_drawer.dart';
import '../widgets/timeline_tile.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(clientConfigProvider);
    final servicesAsync = ref.watch(servicesProvider);
    final itinerariesAsync = ref.watch(itinerariesProvider);
    final primaryColor = config.primaryColor;

    return Scaffold(
      // App Bar
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.self_improvement, size: 22),
            ),
            const SizedBox(width: 10),
            Text(config.clientName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.email_outlined),
            tooltip: 'Contact: ${config.supportEmail}',
            onPressed: () {
              launchUrl(Uri.parse('mailto:${config.supportEmail}'));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      // Body
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Section ─────────────────────────────
            HeroSection(
              title: 'Discover the Soul\nof Varanasi',
              subtitle:
                  'Experience sacred rituals, ancient temples, and timeless traditions\nin India\'s spiritual capital',
              backgroundImageUrl:
                  'https://images.unsplash.com/photo-1590050752117-23a9d93ee6d2?w=1400&q=80',
            ),

            // ── Services Section ─────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 28,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Our Services',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade900,
                            ),
                          ),
                          Text(
                            'Curated experiences for the modern pilgrim',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Responsive grid — handles AsyncValue
                  servicesAsync.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (e, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text('Failed to load services: $e'),
                      ),
                    ),
                    data: (services) => LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = constraints.maxWidth > 900
                            ? 3
                            : constraints.maxWidth > 600
                            ? 2
                            : 1;

                        if (crossAxisCount == 1) {
                          return Column(
                            children: services.map((service) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: ServiceCard(
                                  service: service,
                                  onTap: () => ServiceDetailDrawer.show(
                                    context,
                                    service: service,
                                    clientConfig: config,
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                childAspectRatio: 0.72,
                              ),
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            final service = services[index];
                            return ServiceCard(
                              service: service,
                              onTap: () => ServiceDetailDrawer.show(
                                context,
                                service: service,
                                clientConfig: config,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // ── Signature Itineraries Section ────────────
            itinerariesAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (itineraries) {
                if (itineraries.isEmpty) return const SizedBox.shrink();
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor.withAlpha(12),
                        primaryColor.withAlpha(25),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withAlpha(30),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '✨ Signature Experience',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              itineraries.first.title,
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              itineraries.first.subtitle,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Chip(
                                  avatar: Icon(
                                    Icons.schedule,
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                  label: Text(itineraries.first.duration),
                                ),
                                const SizedBox(width: 8),
                                Chip(
                                  avatar: Icon(
                                    Icons.currency_rupee,
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                  label: Text(
                                    '${itineraries.first.price.toInt()} /person',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 650),
                          child: Column(
                            children: itineraries.first.steps
                                .asMap()
                                .entries
                                .map((entry) {
                                  final index = entry.key;
                                  final step = entry.value;
                                  return TimelineTile(
                                    step: step,
                                    isFirst: index == 0,
                                    isLast:
                                        index ==
                                        itineraries.first.steps.length - 1,
                                    primaryColor: primaryColor,
                                  );
                                })
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // ── Footer ──────────────────────────────────
            Container(
              width: double.infinity,
              color: Colors.grey.shade900,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  Text(
                    config.clientName,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    config.supportEmail,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Made with 🙏 in Varanasi',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // WhatsApp FAB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _launchWhatsApp(config),
        icon: const Icon(Icons.chat, size: 22),
        label: Text(
          'WhatsApp',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _launchWhatsApp(clientConfig) async {
    final message = Uri.encodeComponent(
      'Hi ${clientConfig.clientName}! 🙏\n\n'
      'I\'d love to know more about your Varanasi travel experiences.\n'
      'Please share your available packages!',
    );
    final url = Uri.parse(
      'https://wa.me/${clientConfig.whatsappNumber}?text=$message',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
