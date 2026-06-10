import 'package:flutter/material.dart';

/// Utility functions for positioning UI elements based on the user's
/// preferred hand (left or right).
///
/// This satisfies CareConnect's core WCAG 2.5.5 / 2.5.1 constraint by
/// providing a single source of truth for layout decisions that depend
/// on handedness — rather than scattering conditional checks across widgets.
class HandednessLayout {
  HandednessLayout._();

  // ── Alignment helpers ──────────────────────────────────────────────────────

  /// Returns the horizontal [Alignment] for primary action buttons.
  /// Left-hand mode → [Alignment.centerLeft]; right-hand → [Alignment.centerRight].
  static Alignment primaryButtonAlignment(bool leftHandMode) =>
      leftHandMode ? Alignment.centerLeft : Alignment.centerRight;

  /// Returns the [FloatingActionButtonLocation] that keeps the FAB within
  /// comfortable thumb reach for the user's preferred hand.
  static FloatingActionButtonLocation fabLocation(bool leftHandMode) =>
      leftHandMode
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat;

  /// Returns the [MainAxisAlignment] that places primary content on the
  /// preferred-hand side of a [Row].
  static MainAxisAlignment rowAlignment(bool leftHandMode) =>
      leftHandMode ? MainAxisAlignment.start : MainAxisAlignment.end;

  // ── Padding helpers ────────────────────────────────────────────────────────

  /// Returns horizontal padding that adds extra space on the preferred-hand
  /// side, giving the thumb more comfortable tap area.
  ///
  /// [outerPadding] is the standard padding on the non-dominant side.
  /// [thumbPadding] is the extra padding added on the dominant side.
  static EdgeInsets asymmetricPadding({
    bool leftHandMode = true,
    double outerPadding = 16.0,
    double thumbPadding = 24.0,
  }) {
    return EdgeInsets.only(
      left:  leftHandMode ? thumbPadding : outerPadding,
      right: leftHandMode ? outerPadding : thumbPadding,
    );
  }

  // ── Reachability zone helpers ──────────────────────────────────────────────

  /// Returns true if the given horizontal position (as a fraction 0.0–1.0
  /// of screen width) falls within the comfortable reach zone for the
  /// user's preferred hand.
  ///
  /// Comfortable zone is defined as the inner 60 % of the screen on the
  /// dominant side (0.0–0.6 for left hand, 0.4–1.0 for right hand).
  static bool isInComfortZone(double xFraction, {required bool leftHandMode}) {
    assert(xFraction >= 0.0 && xFraction <= 1.0);
    return leftHandMode ? xFraction <= 0.6 : xFraction >= 0.4;
  }

  /// Categorises a horizontal position into a reachability level.
  static ReachabilityZone zoneFor(
    double xFraction, {
    required bool leftHandMode,
  }) {
    assert(xFraction >= 0.0 && xFraction <= 1.0);
    final pos = leftHandMode ? xFraction : 1.0 - xFraction;
    if (pos <= 0.45) return ReachabilityZone.easy;
    if (pos <= 0.70) return ReachabilityZone.stretch;
    return ReachabilityZone.avoid;
  }

  static void quickActionAlignment(bool bool) {}

  static void contentPadding(bool bool) {}
}

/// Represents how easy it is to reach a screen position with the dominant thumb.
enum ReachabilityZone {
  /// Comfortable — no grip adjustment needed.
  easy,

  /// Reachable with a small stretch — acceptable for infrequent actions.
  stretch,

  /// Requires repositioning the hand — avoid for primary actions.
  avoid,
}
