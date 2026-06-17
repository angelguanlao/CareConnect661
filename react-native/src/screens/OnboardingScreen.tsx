import React, {useState} from 'react';
import {View, Text, TouchableOpacity, StyleSheet, ScrollView, Switch} from 'react-native';
import {Colors, Spacing, Typography, Radius, MIN_TOUCH} from '../theme/Theme';
import {appStore} from '../state/AppState';

export function OnboardingScreen() {
  const [page, setPage] = useState(0);
  const [leftHand, setLeftHand] = useState(true);
  const [highContrast, setHighContrast] = useState(false);
  const [largeTargets, setLargeTargets] = useState(true);
  const [textScale, setTextScale] = useState(1.0);

  const finish = () => appStore.completeOnboarding({leftHand, highContrast, largeTargets, textScale});

  const pages = [
    <View key="hand" style={styles.page}>
      <Text style={styles.emoji}>🤚</Text>
      <Text style={styles.pageTitle}>Which hand do you mainly use?</Text>
      <Text style={styles.pageSubtitle}>CareConnect positions controls for easier reach.</Text>
      <TouchableOpacity
        style={[styles.choiceCard, leftHand && styles.choiceSelected]}
        onPress={() => setLeftHand(true)}
        accessibilityLabel="Left hand"
        accessibilityRole="radio"
        accessibilityState={{selected: leftHand}}
        testID="left-hand-option">
        <Text style={styles.choiceText}>Left hand</Text>
        {leftHand && <Text>✓</Text>}
      </TouchableOpacity>
      <TouchableOpacity
        style={[styles.choiceCard, !leftHand && styles.choiceSelected]}
        onPress={() => setLeftHand(false)}
        accessibilityLabel="Right hand"
        accessibilityRole="radio"
        accessibilityState={{selected: !leftHand}}
        testID="right-hand-option">
        <Text style={styles.choiceText}>Right hand</Text>
        {!leftHand && <Text>✓</Text>}
      </TouchableOpacity>
    </View>,
    <View key="visual" style={styles.page}>
      <Text style={styles.emoji}>👁</Text>
      <Text style={styles.pageTitle}>Visual preferences</Text>
      <View style={styles.switchRow}>
        <Text style={styles.switchLabel}>High Contrast</Text>
        <Switch
          value={highContrast}
          onValueChange={setHighContrast}
          accessibilityLabel="High contrast mode"
          testID="high-contrast-switch"
        />
      </View>
      <Text style={styles.switchLabel}>Text Size: {textScale.toFixed(1)}×</Text>
      <View style={styles.sliderRow}>
        {[0.8, 1.0, 1.2, 1.5, 2.0].map(v => (
          <TouchableOpacity
            key={v}
            style={[styles.scaleBtn, textScale === v && styles.scaleBtnSelected]}
            onPress={() => setTextScale(v)}
            accessibilityLabel={`Text scale ${v}`}
            accessibilityRole="radio"
            accessibilityState={{selected: textScale === v}}>
            <Text style={textScale === v ? {color: '#fff'} : undefined}>{v}×</Text>
          </TouchableOpacity>
        ))}
      </View>
    </View>,
    <View key="motor" style={styles.page}>
      <Text style={styles.emoji}>👆</Text>
      <Text style={styles.pageTitle}>Motor preferences</Text>
      <View style={styles.switchRow}>
        <Text style={styles.switchLabel}>Large Touch Targets</Text>
        <Switch
          value={largeTargets}
          onValueChange={setLargeTargets}
          accessibilityLabel="Large touch targets"
          testID="large-targets-switch"
        />
      </View>
    </View>,
  ];

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <View style={styles.progressRow} accessibilityLabel={`Step ${page + 1} of ${pages.length}`}>
        {pages.map((_, i) => (
          <View key={i} style={[styles.dot, i <= page && styles.dotActive]} />
        ))}
      </View>
      <Text style={styles.step}>Step {page + 1} of {pages.length}</Text>
      {pages[page]}
      <View style={styles.navRow}>
        {page > 0 && (
          <TouchableOpacity style={styles.backBtn} onPress={() => setPage(p => p - 1)} accessibilityLabel="Back" testID="back-button">
            <Text style={styles.backText}>Back</Text>
          </TouchableOpacity>
        )}
        <View style={{flex: 1}} />
        <TouchableOpacity
          style={styles.nextBtn}
          onPress={() => (page < pages.length - 1 ? setPage(p => p + 1) : finish())}
          accessibilityLabel={page === pages.length - 1 ? 'Finish setup and go to home screen' : 'Next step'}
          testID="next-button">
          <Text style={styles.nextText}>{page === pages.length - 1 ? 'Get Started' : 'Next'}</Text>
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {padding: Spacing.lg, paddingBottom: Spacing.xl},
  progressRow: {flexDirection: 'row', gap: Spacing.sm, marginBottom: Spacing.sm},
  dot: {flex: 1, height: 6, borderRadius: 3, backgroundColor: '#E0E0E0'},
  dotActive: {backgroundColor: Colors.primary},
  step: {color: Colors.onSurfaceVariant, ...Typography.bodyMedium, marginBottom: Spacing.lg},
  page: {marginBottom: Spacing.lg},
  emoji: {fontSize: 48, marginBottom: Spacing.md},
  pageTitle: {...Typography.headlineSmall, fontWeight: '700', marginBottom: Spacing.sm},
  pageSubtitle: {color: Colors.onSurfaceVariant, ...Typography.bodyLarge, marginBottom: Spacing.lg},
  choiceCard: {borderWidth: 2, borderColor: 'transparent', borderRadius: Radius.md, padding: Spacing.md, flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginBottom: Spacing.md, backgroundColor: '#F5F5F5', minHeight: MIN_TOUCH},
  choiceSelected: {borderColor: Colors.primary, backgroundColor: '#E3F2FD'},
  choiceText: {...Typography.titleMedium},
  switchRow: {flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginBottom: Spacing.md, minHeight: MIN_TOUCH},
  switchLabel: {...Typography.bodyLarge, marginBottom: Spacing.sm},
  sliderRow: {flexDirection: 'row', gap: Spacing.sm, flexWrap: 'wrap'},
  scaleBtn: {padding: Spacing.sm, borderRadius: Radius.sm, borderWidth: 1, borderColor: Colors.primary, minWidth: MIN_TOUCH, minHeight: MIN_TOUCH, justifyContent: 'center', alignItems: 'center'},
  scaleBtnSelected: {backgroundColor: Colors.primary},
  navRow: {flexDirection: 'row', alignItems: 'center'},
  backBtn: {borderWidth: 1, borderColor: Colors.primary, borderRadius: Radius.md, padding: Spacing.md, minWidth: 80, minHeight: MIN_TOUCH, justifyContent: 'center', alignItems: 'center'},
  backText: {color: Colors.primary, ...Typography.labelLarge},
  nextBtn: {backgroundColor: Colors.primary, borderRadius: Radius.md, padding: Spacing.md, minWidth: 120, minHeight: MIN_TOUCH, justifyContent: 'center', alignItems: 'center'},
  nextText: {color: '#fff', ...Typography.labelLarge},
});
