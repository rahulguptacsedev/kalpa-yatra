import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/itinerary.dart';
import '../../providers/admin_providers.dart';
import '../../providers/client_config_provider.dart';

class ManageItinerariesPage extends ConsumerStatefulWidget {
  const ManageItinerariesPage({super.key});

  @override
  ConsumerState<ManageItinerariesPage> createState() =>
      _ManageItinerariesPageState();
}

class _ManageItinerariesPageState extends ConsumerState<ManageItinerariesPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController();
  final List<ItineraryStep> _steps = [];
  bool _showForm = false;

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _subtitleController.clear();
    _durationController.clear();
    _priceController.clear();
    _steps.clear();
  }

  void _submitItinerary() {
    if (!_formKey.currentState!.validate()) return;
    if (_steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one step')),
      );
      return;
    }

    final itinerary = Itinerary(
      id: 'itn_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      subtitle: _subtitleController.text.trim(),
      duration: _durationController.text.trim(),
      price: double.tryParse(_priceController.text) ?? 0,
      steps: List.from(_steps),
    );

    ref.read(itineraryListViewModelProvider.notifier).addItinerary(itinerary);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ "${itinerary.title}" added successfully')),
    );

    _resetForm();
    setState(() => _showForm = false);
  }

  void _addStep() {
    showDialog(
      context: context,
      builder: (context) {
        final timeCtrl = TextEditingController();
        final titleCtrl = TextEditingController();
        final descCtrl = TextEditingController();
        return AlertDialog(
          title: const Text('Add Step'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: timeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Time (e.g., 5:00 AM)',
                ),
              ),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _steps.add(
                    ItineraryStep(
                      time: timeCtrl.text.trim(),
                      title: titleCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                      iconName: 'place',
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(clientConfigProvider);
    final primaryColor = config.primaryColor;
    final itineraries = ref.watch(itineraryListViewModelProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manage Itineraries',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      '${itineraries.length} itineraries active',
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
                label: Text(_showForm ? 'Cancel' : 'Add Itinerary'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _showForm
                      ? Colors.grey.shade600
                      : primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_showForm) _buildAddForm(primaryColor),
          const SizedBox(height: 24),
          _buildItineraryList(itineraries, primaryColor),
        ],
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
              'Add New Itinerary',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Itinerary Title'),
              validator: (v) => v?.isEmpty ?? true ? 'Enter title' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _subtitleController,
              decoration: const InputDecoration(
                labelText: 'Subtitle (e.g., Description)',
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Enter subtitle' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: 'Duration (e.g., 2 Days)',
                    ),
                    validator: (v) =>
                        v?.isEmpty ?? true ? 'Enter duration' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Price (₹)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v?.isEmpty ?? true ? 'Enter price' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Itinerary Steps (${_steps.length})',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addStep,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Step'),
                ),
              ],
            ),
            if (_steps.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return ListTile(
                    title: Text(step.title),
                    subtitle: Text('${step.time} - ${step.description}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => _steps.removeAt(index)),
                    ),
                  );
                },
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submitItinerary,
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                child: const Text(
                  'Save Itinerary',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItineraryList(List itineraries, Color primaryColor) {
    if (itineraries.isEmpty) {
      return const Center(child: Text('No itineraries found'));
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itineraries.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final itn = itineraries[index] as Itinerary;
        return ListTile(
          title: Text(itn.title),
          subtitle: Text('${itn.duration} · ₹${itn.price}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              ref
                  .read(itineraryListViewModelProvider.notifier)
                  .deleteItinerary(itn.id);
            },
          ),
        );
      },
    );
  }
}
