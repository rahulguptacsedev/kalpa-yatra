import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/travel_service.dart';
import '../../providers/admin_providers.dart';
import '../../providers/client_config_provider.dart';

class ManageServicesPage extends ConsumerStatefulWidget {
  const ManageServicesPage({super.key});

  @override
  ConsumerState<ManageServicesPage> createState() => _ManageServicesPageState();
}

class _ManageServicesPageState extends ConsumerState<ManageServicesPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  String _selectedCategory = 'Adventure';
  bool _showForm = false;

  static const _categories = [
    'Adventure',
    'Spiritual',
    'Heritage',
    'Food & Culture',
    'Wellness',
  ];

  static const _categoryIcons = {
    'Adventure': 'directions_boat',
    'Spiritual': 'temple_hindu',
    'Heritage': 'museum',
    'Food & Culture': 'restaurant',
    'Wellness': 'self_improvement',
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    _priceController.clear();
    _durationController.clear();
    _selectedCategory = 'Adventure';
  }

  void _submitService() {
    if (!_formKey.currentState!.validate()) return;

    final service = TravelService(
      id: 'svc_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrl: _imageUrlController.text.trim().isNotEmpty
          ? _imageUrlController.text.trim()
          : 'https://images.unsplash.com/photo-1561361058-c24cecae35ca?w=800&q=80',
      price: double.tryParse(_priceController.text) ?? 0,
      duration: _durationController.text.trim(),
      highlights: [],
      iconName: _categoryIcons[_selectedCategory] ?? 'explore',
    );

    ref.read(serviceListViewModelProvider.notifier).addService(service);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ "${service.title}" added successfully'),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    _resetForm();
    setState(() => _showForm = false);
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(clientConfigProvider);
    final primaryColor = config.primaryColor;
    final services = ref.watch(serviceListViewModelProvider);
    final isWide = MediaQuery.of(context).size.width > 800;

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
                      'Manage Services',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      '${services.length} services active',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _showForm = !_showForm),
                icon: Icon(_showForm ? Icons.close : Icons.add_rounded),
                label: Text(_showForm ? 'Cancel' : 'Add Service'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _showForm
                      ? Colors.grey.shade600
                      : primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Content: form + list
          if (isWide && _showForm)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildServicesList(services, primaryColor),
                ),
                const SizedBox(width: 24),
                Expanded(flex: 2, child: _buildAddForm(primaryColor)),
              ],
            )
          else ...[
            if (_showForm) ...[
              _buildAddForm(primaryColor),
              const SizedBox(height: 24),
            ],
            _buildServicesList(services, primaryColor),
          ],
        ],
      ),
    );
  }

  Widget _buildServicesList(List services, Color primaryColor) {
    if (services.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inbox_rounded, size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(
                'No services yet. Add your first service!',
                style: GoogleFonts.poppins(color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: services.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: Colors.grey.shade100),
        itemBuilder: (context, index) {
          final service = services[index] as TravelService;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                service.imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: primaryColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.image_rounded, color: primaryColor),
                ),
              ),
            ),
            title: Text(
              service.title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              '₹${service.price.toStringAsFixed(0)} · ${service.duration}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: Colors.red.shade400,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      'Delete Service',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    content: Text(
                      'Are you sure you want to delete "${service.title}"?',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(serviceListViewModelProvider.notifier)
                              .deleteService(service.id);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('🗑️ "${service.title}" deleted'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Delete', style: GoogleFonts.poppins()),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddForm(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Service',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            _buildField(
              controller: _titleController,
              label: 'Service Title',
              icon: Icons.title_rounded,
              primaryColor: primaryColor,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            // Category dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: _inputDecoration(
                'Category',
                Icons.category_rounded,
                primaryColor,
              ),
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade900,
              ),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() => _selectedCategory = v);
                }
              },
            ),
            const SizedBox(height: 14),

            // Image URL
            _buildField(
              controller: _imageUrlController,
              label: 'Image URL (optional)',
              icon: Icons.image_rounded,
              primaryColor: primaryColor,
            ),
            const SizedBox(height: 14),

            // Price & Duration row
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    controller: _priceController,
                    label: 'Price (₹)',
                    icon: Icons.currency_rupee_rounded,
                    primaryColor: primaryColor,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Enter price';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildField(
                    controller: _durationController,
                    label: 'Duration',
                    icon: Icons.schedule_rounded,
                    primaryColor: primaryColor,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Enter duration';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              style: GoogleFonts.poppins(fontSize: 14),
              decoration: _inputDecoration(
                'Description',
                Icons.description_rounded,
                primaryColor,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Submit
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _submitService,
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  'Add Service',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
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
      decoration: _inputDecoration(label, icon, primaryColor),
      validator: validator,
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon,
    Color primaryColor,
  ) {
    return InputDecoration(
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
    );
  }
}
