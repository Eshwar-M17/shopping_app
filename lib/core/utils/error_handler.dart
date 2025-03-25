import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_colors.dart';

/// A utility class for handling errors in the application.
class ErrorHandler {
  /// Returns a user-friendly error message based on the error type.
  static String getErrorMessage(Object? error) {
    if (error == null) {
      return 'An unknown error occurred. Please try again.';
    }

    if (error is SocketException) {
      return 'No internet connection. Please check your network and try again.';
    } else if (error is HttpException) {
      return 'Could not complete the request. Please try again later.';
    } else if (error is FormatException) {
      return 'Invalid response format. Please try again later.';
    } else if (error is TimeoutException) {
      return 'Connection timed out. Please try again later.';
    } else {
      return 'Something went wrong. Please try again later.';
    }
  }

  /// Displays a snackbar with the error message.
  static void showErrorSnackBar(BuildContext context, String? message) {
    final displayMessage =
        message?.isNotEmpty == true
            ? message!
            : 'Something went wrong. Please try again.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(displayMessage),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// A reusable widget for displaying error states with a retry button.
  static Widget buildErrorWidget(
    BuildContext context, {
    required String? message,
    VoidCallback? onRetry,
  }) {
    final displayMessage =
        message?.isNotEmpty == true
            ? message!
            : 'Something went wrong. Please try again.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              displayMessage,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
