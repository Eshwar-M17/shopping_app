import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;
  final IconData titleIcon;
  final List<Widget> actions;
  final VoidCallback? onLeadingTap;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.leadingIcon,
    required this.titleIcon,
    this.actions = const [],
    this.onLeadingTap,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.surface,
      centerTitle: false,
      leading:
          leadingIcon != null
              ? IconButton(
                icon: Icon(leadingIcon, color: AppColors.primary),
                onPressed: onLeadingTap,
              )
              : null,
      title: Row(
        children: [
          Icon(titleIcon, color: AppColors.primary, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
        ],
      ),
      actions: [...actions, const SizedBox(width: 8)],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    bottom != null
        ? kToolbarHeight + bottom!.preferredSize.height
        : kToolbarHeight,
  );
}
