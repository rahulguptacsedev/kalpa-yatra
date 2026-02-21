import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/client_config_provider.dart';

class TenantSettingsPage extends ConsumerStatefulWidget {
  const TenantSettingsPage({super.key});

  @override
  ConsumerState<TenantSettingsPage> createState() => _TenantSettingsPageState();
}

class _TenantSettingsPageState extends ConsumerState<TenantSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _clientNameController;
  late TextEditingController _contactPersonController;
  late TextEditingController _colorController;
  late TextEditingController _logoUrlController;
  late TextEditingController _whatsappController;
  late TextEditingController _emailController;
  bool _initialized = false;

  @override
  void dispose() {
    _clientNameController.dispose();
    _contactPersonController.dispose();
    _colorController.dispose();
    _logoUrlController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _initControllers(config) {
    if (!_initialized) {
      _clientNameController = TextEditingController(text: config.clientName);
      _contactPersonController = TextEditingController(
        text: config.contactPersonName,
      );
      _colorController = TextEditingController(text: config.primaryColorHex);
      _logoUrlController = TextEditingController(text: config.logoUrl);
      _whatsappController = TextEditingController(text: config.whatsappNumber);
      _emailController = TextEditingController(text: config.supportEmail);
      _initialized = true;
    }
  }

  void _saveSettings() {
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(clientConfigProvider.notifier)
        .updateField(
          clientName: _clientNameController.text.trim(),
          contactPersonName: _contactPersonController.text.trim(),
          primaryColorHex: _colorController.text.trim(),
          logoUrl: _logoUrlController.text.trim(),
          whatsappNumber: _whatsappController.text.trim(),
          supportEmail: _emailController.text.trim(),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              'Settings saved! Portal updated instantly.',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(clientConfigProvider);
    final primaryColor = config.primaryColor;
    _initControllers(config);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tenant Settings',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Customize your travel portal\'s branding and contact info',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 28),

          // Settings form
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(6),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel('Branding'),
                  const SizedBox(height: 12),

                  // Client Name
                  _buildField(
                    controller: _clientNameController,
                    label: 'Portal Name',
                    icon: Icons.business_rounded,
                    primaryColor: primaryColor,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Enter portal name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Primary Color
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildField(
                          controller: _colorController,
                          label: 'Primary Color (hex)',
                          icon: Icons.palette_rounded,
                          primaryColor: primaryColor,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Enter color hex';
                            }
                            final hex = v.replaceFirst('#', '');
                            if (hex.length != 6) {
                              return 'Use 6-char hex like #E65100';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 56,
                        height: 56,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: _parseColor(_colorController.text),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Logo URL
                  _buildField(
                    controller: _logoUrlController,
                    label: 'Logo URL',
                    icon: Icons.link_rounded,
                    primaryColor: primaryColor,
                  ),
                  const SizedBox(height: 24),

                  _buildSectionLabel('Contact Information'),
                  const SizedBox(height: 12),

                  // Contact Person
                  _buildField(
                    controller: _contactPersonController,
                    label: 'Contact Person Name',
                    icon: Icons.person_rounded,
                    primaryColor: primaryColor,
                  ),
                  const SizedBox(height: 14),

                  // WhatsApp
                  _buildField(
                    controller: _whatsappController,
                    label: 'WhatsApp Number',
                    icon: Icons.chat_rounded,
                    primaryColor: primaryColor,
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Enter WhatsApp number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Support Email
                  _buildField(
                    controller: _emailController,
                    label: 'Support Email',
                    icon: Icons.email_rounded,
                    primaryColor: primaryColor,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Enter support email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _saveSettings,
                      icon: const Icon(Icons.save_rounded),
                      label: Text(
                        'Save Changes',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Live preview card
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Colors.blue.shade700,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Changes are applied instantly to the public travel portal. '
                    'The portal theme, name, and contact details update in real-time.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color primaryColor,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 14),
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 14),
        prefixIcon: Icon(icon, color: primaryColor, size: 20),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  Color _parseColor(String hex) {
    try {
      final cleaned = hex.replaceFirst('#', '');
      if (cleaned.length == 6) {
        return Color(int.parse('FF$cleaned', radix: 16));
      }
    } catch (_) {}
    return Colors.grey.shade300;
  }
}
