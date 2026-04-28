import 'package:andreid_homework_gallery/general/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


Future<bool?> showDeleteConfirmationDialog(
  BuildContext context, {
  required String photoTitle,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Photo'),
      content: Text('Delete "$photoTitle"? This cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => context.pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.error,
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
