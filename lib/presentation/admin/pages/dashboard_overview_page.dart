import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/lead.dart';
import '../../providers/admin_providers.dart';
import '../../providers/client_config_provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/kpi_card.dart';

class DashboardOverviewPage extends ConsumerStatefulWidget {
  const DashboardOverviewPage({super.key});

  @override
  ConsumerState<DashboardOverviewPage> createState() =>
      _DashboardOverviewPageState();
}

class _DashboardOverviewPageState extends ConsumerState<DashboardOverviewPage> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    // Schedule lead loading after the first frame to avoid
    // modifying providers during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final authState = ref.read(authViewModelProvider);
    if (authState is AuthAuthenticated) {
      ref
          .read(leadListViewModelProvider.notifier)
          .loadLeads(authState.user.tenantId);
      setState(() => _loaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final config = ref.watch(clientConfigProvider);
    final primaryColor = config.primaryColor;

    if (authState is! AuthAuthenticated) {
      return const SizedBox.shrink();
    }

    final user = authState.user;
    final leads = ref.watch(leadListViewModelProvider);
    final servicesCount = ref.watch(activeServicesCountProvider);
    final popularItinerary = ref.watch(popularItineraryProvider);

    // Calculate today's leads
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final leadsToday = leads
        .where((l) => l.timestamp.isAfter(todayStart))
        .length;

    if (!_loaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome header
          Text(
            'Welcome back, ${user.displayName}! 👋',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Here\'s what\'s happening with your travel portal today.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 28),

          // KPI Cards row
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              final cards = [
                KpiCard(
                  icon: Icons.people_alt_rounded,
                  label: 'Leads Today',
                  value: '$leadsToday',
                  accentColor: primaryColor,
                ),
                KpiCard(
                  icon: Icons.card_travel_rounded,
                  label: 'Active Services',
                  value: '$servicesCount',
                  accentColor: const Color(0xFF1565C0),
                ),
                KpiCard(
                  icon: Icons.star_rounded,
                  label: 'Most Popular',
                  value: popularItinerary.length > 20
                      ? '${popularItinerary.substring(0, 18)}…'
                      : popularItinerary,
                  accentColor: const Color(0xFF6A1B9A),
                ),
              ];

              if (isWide) {
                return Row(
                  children: cards
                      .map(
                        (card) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: card,
                          ),
                        ),
                      )
                      .toList(),
                );
              }
              return Column(
                children: cards
                    .map(
                      (card) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: card,
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 32),

          // Recent Leads section
          Text(
            'Recent Leads',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: leads.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_rounded,
                            size: 48,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No leads yet',
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: leads.length > 5 ? 5 : leads.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Colors.grey.shade100),
                    itemBuilder: (context, index) {
                      final lead = leads[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: primaryColor.withAlpha(20),
                          child: Text(
                            lead.name[0].toUpperCase(),
                            style: GoogleFonts.poppins(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        title: Text(
                          lead.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          lead.serviceInterest,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: lead.status == LeadStatus.newLead
                                ? Colors.green.shade50
                                : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            lead.statusLabel,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: lead.status == LeadStatus.newLead
                                  ? Colors.green.shade700
                                  : Colors.blue.shade700,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
