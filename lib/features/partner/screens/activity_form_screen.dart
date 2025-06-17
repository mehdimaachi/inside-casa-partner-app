// In: lib/features/partner/screens/activity_form_screen.dart

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../models/activity.dart'; // Corrected: Added missing import

class ActivityFormScreen extends StatefulWidget {
  final String authToken;
  final int partnerId;
  final Activity? activityToEdit;

  const ActivityFormScreen({
    super.key,
    required this.authToken,
    required this.partnerId,
    this.activityToEdit,
  });

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();

  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  bool get _isEditMode => widget.activityToEdit != null;

  @override
  void initState() {
    super.initState();

    if (_isEditMode) {
      final activity = widget.activityToEdit!;
      _titleController.text = activity.title;
      _descriptionController.text = activity.description;
      _locationController.text = activity.location;
      _priceController.text = activity.price.toString();
      _durationController.text = activity.duration.toString();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_isEditMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image updates are not supported in this version.')),
      );
      return;
    }
    if (_selectedImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You have already selected the maximum of 5 images.')),);
      return;
    }
    try {
      final List<XFile> newImages = await _picker.pickMultiImage(limit: 5 - _selectedImages.length,);
      if (newImages.isNotEmpty) {
        setState(() { _selectedImages.addAll(newImages); });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking images: $e')),);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!_isEditMode && _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one image.')),
      );
      return;
    }

    setState(() { _isLoading = true; });

    try {
      if (_isEditMode) {
        await _apiService.updateActivity(
          token: widget.authToken,
          activityId: widget.activityToEdit!.id!,
          partnerId: widget.partnerId, // Corrected: Added missing parameter
          title: _titleController.text,
          description: _descriptionController.text,
          location: _locationController.text,
          price: double.parse(_priceController.text),
          duration: int.parse(_durationController.text),
          categoryId: widget.activityToEdit!.categoryId, // We use the existing categoryId
        );
      } else {
        await _apiService.createActivity(
          token: widget.authToken,
          partnerId: widget.partnerId,
          title: _titleController.text,
          description: _descriptionController.text,
          location: _locationController.text,
          price: double.parse(_priceController.text),
          duration: int.parse(_durationController.text),
          images: _selectedImages,
          categoryId: 1, // Placeholder: You should add a dropdown for this
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Activity ${_isEditMode ? "updated" : "created"} successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(true);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save activity: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if(mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  // Corrected: Only ONE build method now
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Activity' : 'Add New Activity'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g., Guided Tour of the Medina',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Please enter a title';
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price', suffixText: 'MAD', border: OutlineInputBorder()),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter a price';
                        if (double.tryParse(value) == null) return 'Please enter a valid number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(labelText: 'Duration', suffixText: 'minutes', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter a duration';
                        if (int.tryParse(value) == null) return 'Please enter a valid number';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Please enter a description';
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location', hintText: 'e.g., Old Medina, Casablanca', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Please enter a location';
                  return null;
                },
              ),
              const SizedBox(height: 24.0),

              // In edit mode, we will hide the image picker for now
              if (!_isEditMode) ...[
                const Text('Images (max 5)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8.0),
                OutlinedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Add Images'),
                ),
                const SizedBox(height: 16.0),
                if (_selectedImages.isNotEmpty)
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Image.file(File(_selectedImages[index].path), width: 100, height: 100, fit: BoxFit.cover),
                              Positioned(top: -14, right: -14, child: IconButton(icon: const Icon(Icons.remove_circle, color: Colors.red), onPressed: () => _removeImage(index))),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],

              if(_isEditMode)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Image updates are not supported in this version.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(_isEditMode ? 'SAVE CHANGES' : 'SAVE ACTIVITY'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}