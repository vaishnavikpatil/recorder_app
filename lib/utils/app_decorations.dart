
import 'package:recorder_app/exports.dart';

class AppDecorations {
  static BoxDecoration card = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(12.r),
    border: const Border(
      top: BorderSide(color: AppColors.cardBorder, width: 1.5),
    ),
  );

  static BoxDecoration iconContainer = BoxDecoration(
    color: AppColors.iconContainer,
    borderRadius: BorderRadius.circular(8.r),
  );
}
