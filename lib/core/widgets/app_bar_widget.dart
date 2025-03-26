/// A customized app bar for consistent header styling across the app.
///
/// This reusable app bar provides a standardized look and feel with:
/// - An optional leading icon with customizable action
/// - A title with an icon prefix
/// - Customizable action buttons
/// - Optional bottom widget (like tabs or search field)
import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_colors.dart';

/// A custom app bar that implements PreferredSizeWidget for proper sizing.
///
/// This widget extends AppBar with app-specific styling and layout,
/// ensuring consistent header appearance throughout the application.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Title text displayed in the app bar
  final String title;

  /// Optional icon for the leading position (typically a back button)
  final IconData? leadingIcon;

  /// Icon displayed before the title text
  final IconData titleIcon;

  /// List of action widgets displayed at the end of the app bar
  final List<Widget> actions;

  /// Callback when the leading icon is tapped
  final VoidCallback? onLeadingTap;

  /// Optional widget to display below the app bar (e.g., TabBar, search field)
  final PreferredSizeWidget? bottom;

  /// Creates a custom app bar with the given parameters.
  ///
  /// The [title] and [titleIcon] are required, while other parameters are optional.
  /// If [leadingIcon] is provided, [onLeadingTap] should also be provided for proper interaction.
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
      // Only show the leading icon if one is provided
      leading:
          leadingIcon != null
              ? IconButton(
                icon: Icon(leadingIcon, color: AppColors.primary),
                onPressed: onLeadingTap,
              )
              : null,
      // Title with an icon prefix for visual appeal
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
      // Add a bit of padding after the last action item
      actions: [...actions, const SizedBox(width: 8)],
      bottom: bottom,
    );
  }

  /// Calculates the preferred size based on whether there's a bottom widget.
  ///
  /// This ensures the app bar has the correct height including any bottom widget.
  @override
  Size get preferredSize => Size.fromHeight(
    bottom != null
        ? kToolbarHeight + bottom!.preferredSize.height
        : kToolbarHeight,
  );
}
