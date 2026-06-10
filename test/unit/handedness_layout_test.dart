import 'package:care_connect661/utils/handedness_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('left-hand mode keeps primary action alignment on the left edge', () {
    expect(
      HandednessLayout.primaryButtonAlignment(true),
      Alignment.centerLeft,
    );
    expect(
      HandednessLayout.primaryButtonAlignment(false),
      Alignment.centerRight,
    );
  });

  test('fab location follows handedness preference', () {
    expect(
      HandednessLayout.fabLocation(true),
      FloatingActionButtonLocation.startFloat,
    );
    expect(
      HandednessLayout.fabLocation(false),
      FloatingActionButtonLocation.endFloat,
    );
  });

  test('comfort zone and reachability zone behave as expected', () {
    expect(
      HandednessLayout.isInComfortZone(0.5, leftHandMode: true),
      isTrue,
    );
    expect(
      HandednessLayout.isInComfortZone(0.8, leftHandMode: true),
      isFalse,
    );
    expect(
      HandednessLayout.zoneFor(0.2, leftHandMode: true),
      ReachabilityZone.easy,
    );
    expect(
      HandednessLayout.zoneFor(0.8, leftHandMode: true),
      ReachabilityZone.avoid,
    );
  });
}
