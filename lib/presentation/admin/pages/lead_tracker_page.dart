import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/entities/lead.dart';
import '../../providers/admin_providers.dart';
import '../../providers/client_config_provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class LeadTrackerPage extends ConsumerStatefulWidget {
  const LeadTrackerPage({super.key});

  @override
  ConsumerState<LeadTrackerPage> createState() => _LeadTrackerPageState();
}

class _LeadTrackerPageState extends ConsumerState<LeadTrackerPage> {
  LeadStatus? _statusFilter;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authViewModelProvider);
      if (authState is AuthAuthenticated) {
        ref
            .read(leadListViewModelProvider.notifier)
            .loadLeads(authState.user.tenantId);
        setState(() => _loaded = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final config = ref.watch(clientConfigProvider);
    final primaryColor = config.primaryColor;

    if (authState is! AuthAuthenticated) {
      return const SizedBox.shrink();
    }

    if (!_loaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final leadsNotifier = ref.read(leadListViewModelProvider.notifier);
    final allLeads = ref.watch(leadListViewModelProvider);
    final leads = _statusFilter == null
        ? allLeads
        : allLeads.where((l) => l.status == _statusFilter).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lead Tracker',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      '${allLeads.length} total leads',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              // Refresh button
              IconButton(
                onPressed: () => leadsNotifier.refresh(),
                icon: Icon(Icons.refresh_rounded, color: primaryColor),
                tooltip: 'Refresh',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Filter chips
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: Text('All', style: GoogleFonts.poppins(fontSize: 13)),
                selected: _statusFilter == null,
                onSelected: (_) => setState(() => _statusFilter = null),
                selectedColor: primaryColor.withAlpha(25),
                checkmarkColor: primaryColor,
              ),
              FilterChip(
                label: Text('New', style: GoogleFonts.poppins(fontSize: 13)),
                selected: _statusFilter == LeadStatus.newLead,
                onSelected: (_) =>
                    setState(() => _statusFilter = LeadStatus.newLead),
                selectedColor: Colors.green.shade50,
                checkmarkColor: Colors.green.shade700,
              ),
              FilterChip(
                label: Text(
                  'Contacted',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
                selected: _statusFilter == LeadStatus.contacted,
                onSelected: (_) =>
                    setState(() => _statusFilter = LeadStatus.contacted),
                selectedColor: Colors.blue.shade50,
                checkmarkColor: Colors.blue.shade700,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // DataTable
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: leads.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(48),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No leads found',
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        Colors.grey.shade50,
                      ),
                      headingTextStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                      dataTextStyle: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                      ),
                      columnSpacing: 24,
                      horizontalMargin: 20,
                      columns: const [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Customer Name')),
                        DataColumn(label: Text('Phone')),
                        DataColumn(label: Text('Service Requested')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: leads.map((lead) {
                        return DataRow(
                          cells: [
                            DataCell(Text(_formatDate(lead.timestamp))),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: primaryColor.withAlpha(20),
                                    child: Text(
                                      lead.name[0].toUpperCase(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(lead.name),
                                ],
                              ),
                            ),
                            DataCell(Text(lead.phone)),
                            DataCell(
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 200,
                                ),
                                child: Text(
                                  lead.serviceInterest,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(
                              _buildStatusDropdown(
                                lead,
                                leadsNotifier,
                                primaryColor,
                              ),
                            ),
                            DataCell(_buildWhatsAppButton(lead)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(Lead lead, dynamic notifier, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: lead.status == LeadStatus.newLead
            ? Colors.green.shade50
            : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<LeadStatus>(
          value: lead.status,
          isDense: true,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: lead.status == LeadStatus.newLead
                ? Colors.green.shade700
                : Colors.blue.shade700,
          ),
          icon: Icon(Icons.expand_more, size: 18, color: Colors.grey.shade600),
          items: LeadStatus.values.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(status == LeadStatus.newLead ? 'New' : 'Contacted'),
            );
          }).toList(),
          onChanged: (newStatus) {
            if (newStatus != null && newStatus != lead.status) {
              notifier.updateStatus(lead.id, newStatus);
            }
          },
        ),
      ),
    );
  }

  Widget _buildWhatsAppButton(Lead lead) {
    return SizedBox(
      height: 32,
      child: ElevatedButton.icon(
        onPressed: () => _launchWhatsApp(lead),
        icon: const Icon(Icons.chat_rounded, size: 14),
        label: Text(
          'WhatsApp',
          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF25D366),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      ),
    );
  }

  void _launchWhatsApp(Lead lead) async {
    final message = Uri.encodeComponent(
      'Hi ${lead.name}! 🙏\n\n'
      'Thank you for your interest in "${lead.serviceInterest}".\n'
      'We\'d love to help you plan your Varanasi experience!\n\n'
      'Could you share your preferred dates?',
    );
    final url = Uri.parse('https://wa.me/${lead.phone}?text=$message');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '${months[date.month - 1]} ${date.day}, $hour:$minute $amPm';
  }
}
