import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import 'glass_container.dart';
import 'shimmer_loading.dart';

/// Clean explicit states required per module: Initial, Loading, Success, Empty, Error
abstract class UiState<T> {
  const UiState();
}

class InitialState<T> extends UiState<T> {
  const InitialState();
}

class LoadingState<T> extends UiState<T> {
  final String? message;
  const LoadingState([this.message]);
}

class SuccessState<T> extends UiState<T> {
  final T data;
  final bool isFromCache;
  const SuccessState(this.data, {this.isFromCache = false});
}

class EmptyState<T> extends UiState<T> {
  final String? message;
  const EmptyState([this.message]);
}

class ErrorState<T> extends UiState<T> {
  final String message;
  final int? statusCode;
  const ErrorState(this.message, [this.statusCode]);
}

class StateView<T> extends StatelessWidget {
  final UiState<T> state;
  final Widget Function(BuildContext context, T data) onSuccess;
  final Widget Function(BuildContext context)? onLoading;
  final Widget Function(BuildContext context, String message)? onEmpty;
  final Widget Function(BuildContext context, String error)? onError;
  final VoidCallback? onRetry;
  final double loadingHeight;

  const StateView({
    super.key,
    required this.state,
    required this.onSuccess,
    this.onLoading,
    this.onEmpty,
    this.onError,
    this.onRetry,
    this.loadingHeight = 160,
  });

  @override
  Widget build(BuildContext context) {
    if (state is LoadingState<T>) {
      if (onLoading != null) return onLoading!(context);
      return ShimmerCard(height: loadingHeight);
    }

    if (state is SuccessState<T>) {
      final success = state as SuccessState<T>;
      final content = onSuccess(context, success.data);

      if (!success.isFromCache) {
        return content;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.cloud_off, size: 16, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.tr('offline_banner'),
                    style: const TextStyle(fontSize: 11, color: Colors.amber, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: content),
        ],
      );
    }

    if (state is EmptyState<T>) {
      final empty = state as EmptyState<T>;
      final msg = empty.message ?? context.tr('empty');
      if (onEmpty != null) return onEmpty!(context, msg);
      return GlassContainer(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_outlined, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: 12),
              Text(
                msg,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: Text(context.tr('retry')),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (state is ErrorState<T>) {
      final err = state as ErrorState<T>;
      if (onError != null) return onError!(context, err.message);
      return GlassContainer(
        padding: const EdgeInsets.all(20),
        backgroundColor: Colors.red.withValues(alpha: 0.08),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 36, color: Colors.redAccent),
            const SizedBox(height: 10),
            Text(
              context.tr('error'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.redAccent),
            ),
            const SizedBox(height: 6),
            Text(
              err.message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85)),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                icon: const Icon(Icons.refresh, size: 16),
                label: Text(context.tr('retry')),
              ),
            ],
          ],
        ),
      );
    }

    // InitialState
    return const SizedBox.shrink();
  }
}
