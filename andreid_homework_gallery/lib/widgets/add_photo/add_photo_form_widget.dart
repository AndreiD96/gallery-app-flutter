import 'package:andreid_homework_gallery/general/constants/app_colors.dart';
import 'package:andreid_homework_gallery/general/constants/app_dimensions.dart';
import 'package:andreid_homework_gallery/general/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class AddPhotoFormWidget extends StatefulWidget {
  const AddPhotoFormWidget({
    required this.onSubmit,
    required this.initialTitle,
    required this.initialDescription,
    required this.dateTaken,
    super.key,
  });

  final void Function(String title, String description) onSubmit;
  final String? initialTitle;
  final String? initialDescription;
  final String? dateTaken;

  @override
  State<AddPhotoFormWidget> createState() => _AddPhotoFormWidgetState();
}

class _AddPhotoFormWidgetState extends State<AddPhotoFormWidget> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _descriptionController = TextEditingController(
      text: widget.initialDescription ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    widget.onSubmit(title, description);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'Enter a title for this photo',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Title is required';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppDimensions.paddingMd),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Enter a description (optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: AppDimensions.paddingMd),
          RichText(
            text: TextSpan(
              text: 'Date Taken: ',
              style: AppTextStyles.s14w400(),
              children: [
                TextSpan(
                  text: widget.dateTaken ?? 'Unknown',
                  style: AppTextStyles.s14w400(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLg),
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.save),
            label: const Text('Save Photo'),
          ),
        ],
      ),
    );
  }
}
