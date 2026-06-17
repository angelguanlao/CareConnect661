import React from 'react';
import {View, Text, TouchableOpacity, StyleSheet, ScrollView} from 'react-native';
import {useNavigation} from '@react-navigation/native';
import {Colors, Spacing, Typography, Radius, MIN_TOUCH} from '../theme/Theme';
import {useAppState} from '../state/AppContext';
import {appStore} from '../state/AppState';
import {ALL_FEATURES} from '../models/Feature';

export function HomeScreen() {
  const state = useAppState();
  const navigation = useNavigation<any>();
  const user = state.currentUser;
  const hour = new Date().getHours();
  const salutation = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
  const enabled = state.enabledFeatures.size;
  const total = ALL_FEATURES.length;

  return (
    <ScrollView
      contentContainerStyle={styles.container}
      testID="home-scroll">
      <View style={styles.banner}>
        <Text style={styles.bannerSub}>{salutation},</Text>
        <Text style={styles.bannerName}>{user?.name.split(' ')[0] ?? 'there'}</Text>
        <Text style={styles.bannerNote}>Your accessibility settings are active.</Text>
      </View>

      <Text style={styles.sectionTitle} accessibilityRole="header">Your Accessibility Profile</Text>
      <View style={styles.statsRow}>
        {[
          {value: `${enabled}`, label: 'Active', color: Colors.primary},
          {value: `${total - enabled}`, label: 'Available', color: Colors.secondary},
          {value: state.leftHandMode ? 'Left' : 'Right', label: 'Hand Mode', color: '#F57C00'},
        ].map(s => (
          <View key={s.label} style={styles.statPill} accessibilityLabel={`${s.label}: ${s.value}`}>
            <View style={[styles.statBox, {backgroundColor: s.color + '22'}]}>
              <Text style={[styles.statValue, {color: s.color}]}>{s.value}</Text>
            </View>
            <Text style={styles.statLabel}>{s.label}</Text>
          </View>
        ))}
      </View>

      <Text style={styles.sectionTitle} accessibilityRole="header">Quick Actions</Text>
      <View style={styles.grid}>
        {[
          {label: 'High Contrast', active: state.highContrast, onPress: () => appStore.setHighContrast(!state.highContrast)},
          {label: 'Large Targets', active: state.largeTargets, onPress: () => appStore.setLargeTargets(!state.largeTargets)},
          {label: state.leftHandMode ? 'Left Mode ON' : 'Right Mode', active: state.leftHandMode, onPress: () => appStore.setLeftHandMode(!state.leftHandMode)},
          {label: 'All Settings', active: false, onPress: () => navigation.navigate('Settings')},
        ].map(tile => (
          <TouchableOpacity
            key={tile.label}
            style={[styles.tile, tile.active && styles.tileActive]}
            onPress={tile.onPress}
            accessibilityLabel={tile.label}
            accessibilityRole="button"
            accessibilityState={{selected: tile.active}}
            testID={`tile-${tile.label.replace(/\s/g, '-').toLowerCase()}`}>
            <Text style={[styles.tileLabel, tile.active && styles.tileLabelActive]}>{tile.label}</Text>
          </TouchableOpacity>
        ))}
      </View>

      <Text style={styles.sectionTitle} accessibilityRole="header">Tip of the Day</Text>
      <View style={styles.tip}>
        <Text style={styles.tipTitle}>Left-Hand Reachability</Text>
        <Text style={styles.tipBody}>Place your most-used actions within the lower-left 40% of the screen — the natural resting zone for the left thumb.</Text>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {padding: Spacing.md, paddingBottom: Spacing.xl},
  banner: {borderRadius: Radius.lg, padding: Spacing.lg, marginBottom: Spacing.md, backgroundColor: Colors.primary},
  bannerSub: {color: 'rgba(255,255,255,0.75)', ...Typography.bodyLarge},
  bannerName: {color: '#fff', ...Typography.displaySmall, fontWeight: '700'},
  bannerNote: {color: 'rgba(255,255,255,0.75)', ...Typography.bodyMedium},
  sectionTitle: {...Typography.titleMedium, fontWeight: '700', marginBottom: Spacing.sm, marginTop: Spacing.md},
  statsRow: {flexDirection: 'row', justifyContent: 'space-around', backgroundColor: '#fff', borderRadius: Radius.md, padding: Spacing.md, marginBottom: Spacing.md},
  statPill: {alignItems: 'center'},
  statBox: {width: 52, height: 52, borderRadius: Radius.md, justifyContent: 'center', alignItems: 'center', marginBottom: Spacing.xs},
  statValue: {fontWeight: '700', fontSize: 18},
  statLabel: {color: Colors.onSurfaceVariant, fontSize: 12},
  grid: {flexDirection: 'row', flexWrap: 'wrap', gap: Spacing.sm, marginBottom: Spacing.md},
  tile: {width: '47%', backgroundColor: '#fff', borderRadius: Radius.md, padding: Spacing.md, minHeight: MIN_TOUCH * 1.5, justifyContent: 'flex-end'},
  tileActive: {backgroundColor: Colors.primary},
  tileLabel: {color: Colors.onSurface, ...Typography.titleSmall},
  tileLabelActive: {color: '#fff'},
  tip: {backgroundColor: Colors.primaryContainer, borderRadius: Radius.md, padding: Spacing.md},
  tipTitle: {color: Colors.primary, fontWeight: '700', marginBottom: Spacing.xs},
  tipBody: {color: Colors.onSurface, ...Typography.bodyMedium},
});
