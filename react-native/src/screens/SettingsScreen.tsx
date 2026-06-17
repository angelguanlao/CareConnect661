import React from 'react';
import {View, Text, ScrollView, Switch, TouchableOpacity, StyleSheet} from 'react-native';
import {useNavigation} from '@react-navigation/native';
import {Colors, Spacing, Typography, Radius, MIN_TOUCH} from '../theme/Theme';
import {useAppState} from '../state/AppContext';
import {appStore} from '../state/AppState';

export function SettingsScreen() {
  const state = useAppState();
  const navigation = useNavigation<any>();
  const scales = [0.8, 1.0, 1.2, 1.5, 2.0];

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <Text style={styles.section} accessibilityRole="header">ACCESSIBILITY</Text>
      <View style={styles.card}>
        {[
          {label: 'Left-Hand Mode', sub: 'Positions controls on the left edge.', value: state.leftHandMode, onChange: appStore.setLeftHandMode.bind(appStore), testID: 'left-hand-toggle'},
          {label: 'High Contrast Mode', sub: 'Dark theme with 7:1 contrast ratios.', value: state.highContrast, onChange: appStore.setHighContrast.bind(appStore), testID: 'high-contrast-toggle'},
          {label: 'Large Touch Targets', sub: 'Expands tap areas to 60×60dp.', value: state.largeTargets, onChange: appStore.setLargeTargets.bind(appStore), testID: 'large-targets-toggle'},
        ].map((row, i, arr) => (
          <View key={row.label}>
            <View style={styles.switchRow}>
              <View style={{flex: 1}}>
                <Text style={styles.rowLabel}>{row.label}</Text>
                <Text style={styles.rowSub}>{row.sub}</Text>
              </View>
              <Switch
                value={row.value}
                onValueChange={row.onChange}
                accessibilityLabel={`${row.label} is ${row.value ? 'on' : 'off'}`}
                testID={row.testID}
              />
            </View>
            {i < arr.length - 1 && <View style={styles.divider} />}
          </View>
        ))}
        <View style={styles.divider} />
        <View style={styles.sliderSection}>
          <Text style={styles.rowLabel}>Text Size: {state.textScaleFactor.toFixed(1)}×</Text>
          <View style={styles.scaleRow}>
            {scales.map(v => (
              <TouchableOpacity
                key={v}
                style={[styles.scaleBtn, state.textScaleFactor === v && styles.scaleBtnActive]}
                onPress={() => appStore.setTextScaleFactor(v)}
                accessibilityLabel={`Text scale ${v}×`}
                accessibilityState={{selected: state.textScaleFactor === v}}
                testID={`scale-${v}`}>
                <Text style={state.textScaleFactor === v ? styles.scaleBtnTextActive : styles.scaleBtnText}>{v}×</Text>
              </TouchableOpacity>
            ))}
          </View>
        </View>
      </View>

      <Text style={styles.section} accessibilityRole="header">ACCOUNT</Text>
      <View style={styles.card}>
        {[
          {label: 'View Profile', onPress: () => navigation.navigate('Profile')},
          {label: 'Edit Profile', onPress: () => navigation.navigate('EditProfile')},
        ].map((row, i, arr) => (
          <View key={row.label}>
            <TouchableOpacity style={styles.navRow} onPress={row.onPress} accessibilityLabel={row.label} accessibilityRole="button" testID={`nav-${row.label.replace(' ', '-').toLowerCase()}`}>
              <Text style={styles.rowLabel}>{row.label}</Text>
              <Text style={styles.chevron}>›</Text>
            </TouchableOpacity>
            {i < arr.length - 1 && <View style={styles.divider} />}
          </View>
        ))}
      </View>

      <Text style={styles.section} accessibilityRole="header">ABOUT</Text>
      <View style={styles.card}>
        <View style={styles.infoRow}><Text style={styles.rowLabel}>App Version</Text><Text style={styles.infoVal}>1.0.0</Text></View>
        <View style={styles.divider} />
        <View style={styles.infoRow}><Text style={styles.rowLabel}>WCAG Compliance</Text><Text style={styles.infoVal}>AA + 2.5.5</Text></View>
        <View style={styles.divider} />
        <View style={styles.infoRow}><Text style={styles.rowLabel}>Course</Text><Text style={styles.infoVal}>SWEN 661 — Team 9</Text></View>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {padding: Spacing.md, paddingBottom: Spacing.xl},
  section: {fontSize: 12, fontWeight: '700', color: Colors.onSurfaceVariant, letterSpacing: 1.2, marginTop: Spacing.md, marginBottom: Spacing.sm},
  card: {backgroundColor: '#fff', borderRadius: Radius.md, marginBottom: Spacing.sm, overflow: 'hidden'},
  switchRow: {flexDirection: 'row', alignItems: 'center', padding: Spacing.md, minHeight: MIN_TOUCH},
  rowLabel: {...Typography.titleSmall, marginBottom: 2},
  rowSub: {color: Colors.onSurfaceVariant, ...Typography.bodyMedium, fontSize: 13},
  divider: {height: 1, backgroundColor: '#F0F0F0', marginLeft: Spacing.md},
  sliderSection: {padding: Spacing.md},
  scaleRow: {flexDirection: 'row', flexWrap: 'wrap', gap: Spacing.sm, marginTop: Spacing.sm},
  scaleBtn: {paddingHorizontal: Spacing.sm, paddingVertical: Spacing.xs, borderRadius: Radius.sm, borderWidth: 1, borderColor: Colors.primary, minWidth: MIN_TOUCH, minHeight: MIN_TOUCH, justifyContent: 'center', alignItems: 'center'},
  scaleBtnActive: {backgroundColor: Colors.primary},
  scaleBtnText: {color: Colors.primary, ...Typography.labelLarge},
  scaleBtnTextActive: {color: '#fff', ...Typography.labelLarge},
  navRow: {flexDirection: 'row', alignItems: 'center', padding: Spacing.md, minHeight: MIN_TOUCH},
  chevron: {fontSize: 22, color: Colors.onSurfaceVariant},
  infoRow: {flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', padding: Spacing.md, minHeight: MIN_TOUCH},
  infoVal: {color: Colors.onSurfaceVariant, ...Typography.bodyMedium},
});
