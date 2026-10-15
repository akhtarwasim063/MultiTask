import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkResilienceState {
  final bool isOffline;
  final int rateLimitCountdownSeconds;
  final String? rateLimitApiName;

  const NetworkResilienceState({
    this.isOffline = false,
    this.rateLimitCountdownSeconds = 0,
    this.rateLimitApiName,
  });

  bool get isBackoffActive => rateLimitCountdownSeconds > 0;

  NetworkResilienceState copyWith({
    bool? isOffline,
    int? rateLimitCountdownSeconds,
    String? rateLimitApiName,
  }) {
    return NetworkResilienceState(
      isOffline: isOffline ?? this.isOffline,
      rateLimitCountdownSeconds:
          rateLimitCountdownSeconds ?? this.rateLimitCountdownSeconds,
      rateLimitApiName: rateLimitApiName ?? this.rateLimitApiName,
    );
  }
}

class NetworkResilienceNotifier extends StateNotifier<NetworkResilienceState> {
  Timer? _countdownTimer;

  NetworkResilienceNotifier() : super(const NetworkResilienceState());

  bool get isBackoffActive => state.isBackoffActive;
  String? get activeApiName => state.rateLimitApiName;
  int get countdownSeconds => state.rateLimitCountdownSeconds;

  void setOffline(bool offline) {
    state = state.copyWith(isOffline: offline);
  }

  void triggerRateLimitBackoff(String apiName, {int seconds = 30}) {
    _countdownTimer?.cancel();
    state = state.copyWith(
      rateLimitCountdownSeconds: seconds,
      rateLimitApiName: apiName,
    );

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.rateLimitCountdownSeconds <= 1) {
        timer.cancel();
        state = state.copyWith(
          rateLimitCountdownSeconds: 0,
          rateLimitApiName: null,
        );
      } else {
        state = state.copyWith(
          rateLimitCountdownSeconds: state.rateLimitCountdownSeconds - 1,
        );
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}

final networkResilienceProvider =
    StateNotifierProvider<NetworkResilienceNotifier, NetworkResilienceState>((ref) {
  return NetworkResilienceNotifier();
});
