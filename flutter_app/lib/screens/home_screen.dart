import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agricare/services/tflite_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TFLiteService _tflite = TFLiteService();
  final ImagePicker _picker = ImagePicker();
  
  File? _image;
  Map<String, dynamic>? _result;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  Future<void> _initModel() async {
    try {
      await _tflite.loadModel();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load model: $e')),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(source: source);
      if (file != null) {
        setState(() {
          _image = File(file.path);
          _isLoading = true;
          _result = null;
        });

        // Run prediction
        final imageBytes = await _image!.readAsBytes();
        final result = _tflite.predict(imageBytes);

        setState(() {
          _result = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Detection'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Preview
            if (_image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_image!, height: 250, fit: BoxFit.cover),
              )
            else
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera),
                    label: const Text('Camera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.image),
                    label: const Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Loading
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_result != null) ...[
              // Results Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detection Result',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildResultRow('Disease', _result!['disease']),
                      const SizedBox(height: 12),
                      _buildResultRow(
                        'Confidence',
                        '${(_result!['confidence'] * 100).toStringAsFixed(1)}%',
                      ),
                      const Divider(height: 24),
                      Text(
                        'Remedy',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _result!['remedy'],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontSize: 14, color: Colors.green)),
      ],
    );
  }

  @override
  void dispose() {
    _tflite.dispose();
    super.dispose();
  }
}
