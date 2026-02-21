import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/lead.dart';
import '../../domain/entities/travel_service.dart';
import '../providers/lead_providers.dart';

class QuickInquiryForm extends ConsumerStatefulWidget {
  final TravelService service;

  const QuickInquiryForm({super.key, required this.service});

  @override
  ConsumerState<QuickInquiryForm> createState() => _QuickInquiryFormState();
}

class _QuickInquiryFormState extends ConsumerState<QuickInquiryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final lead = Lead(
      id: 'lead_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      serviceInterest: widget.service.title,
      timestamp: DateTime.now(),
      tenantId: 'varanasi_default',
    );

    try {
      final repo = ref.read(leadRepositoryProvider);
      await repo.submitLead(lead);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Inquiry submitted! We\'ll reach out shortly 🙏',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );

      _nameController.clear();
      _phoneController.clear();
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Something went wrong. Please try again.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section Header
          Row(
            children: [
              Icon(Icons.edit_note_rounded, color: primaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'Quick Inquiry',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Fill in your details and we will get back to you within 2 hours!',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),

          // Name field
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            style: GoogleFonts.poppins(fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Your Name',
              labelStyle: GoogleFonts.poppins(fontSize: 14),
              prefixIcon: Icon(Icons.person_outline, color: primaryColor),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Please enter your name';
              }
              if (v.trim().length < 2) return 'Name is too short';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Phone field
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: GoogleFonts.poppins(fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Phone Number',
              labelStyle: GoogleFonts.poppins(fontSize: 14),
              prefixIcon: Icon(Icons.phone_outlined, color: primaryColor),
              prefixText: '+91 ',
              prefixStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Please enter your phone number';
              }
              final digits = v.replaceAll(RegExp(r'\D'), '');
              if (digits.length != 10) return 'Enter a valid 10-digit number';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Service interest (read-only)
          TextFormField(
            initialValue: widget.service.title,
            readOnly: true,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
            decoration: InputDecoration(
              labelText: 'Service Interest',
              labelStyle: GoogleFonts.poppins(fontSize: 14),
              prefixIcon: Icon(Icons.card_travel_rounded, color: primaryColor),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 24),

          // Submit button
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.send_rounded, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Submit Inquiry',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
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
