import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../ui/design_system/tokens/colors.dart';
import '../../ui/design_system/tokens/typography.dart';

class CommonRoundedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String? subtitle;

  final VoidCallback? onBack;

  final bool ellipsis;
  final double? titleSize;
  final int? maxLines;

  const CommonRoundedAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,

    this.ellipsis = false,
    this.titleSize,
    this.maxLines,
  });

  @override
  Size get preferredSize => const Size.fromHeight(110);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: AppColors.secondaryDark,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap:
                      onBack ??
                      () {
                        final router = GoRouter.of(context);
                        if (router.canPop()) {
                          router.pop();
                        } else {
                          Navigator.of(context).maybePop();
                        }
                      },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryDark,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: maxLines ?? (ellipsis ? 1 : null),
                        overflow:
                            ellipsis
                                ? TextOverflow.ellipsis
                                : TextOverflow.visible,
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          fontSize: titleSize ?? 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: AppTypography.family,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
