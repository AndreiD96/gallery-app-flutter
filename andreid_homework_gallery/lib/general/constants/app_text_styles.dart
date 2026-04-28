import 'package:andreid_homework_gallery/general/constants/app_colors.dart';
import 'package:flutter/material.dart';

final class AppTextStyles {
  static TextStyle s24w400({Color color = AppColors.textPrimary}) {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle s22w400({Color color = AppColors.textPrimary}) {
    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle s16w500({Color color = AppColors.textPrimary}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle s16w400({Color color = AppColors.textPrimary}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle s14w500({Color color = AppColors.textPrimary}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle s14w400({Color color = AppColors.textPrimary}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle s12w500({Color color = AppColors.textSecondary}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle s11w500({Color color = AppColors.textSecondary}) {
    return TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }
}
