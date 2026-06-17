import React from 'react';
import {View, Text, TouchableOpacity, ScrollView, StyleSheet} from 'react-native';
import {useNavigation, useRoute} from '@react-navigation/native';
import {Colors, Spacing, Typography, Radius, MIN_TOUCH} from '../theme/Theme';
import {useAppState} from '../state/AppContext';
import {appStore} from '../state/AppState';
import {ALL_FEATURES} from '../models/Feature';

export function FeatureDetailScreen() {
  const route = useRoute<any>();
  const navigation = useNavigation();
  const state = useAppState();
  const feature = ALL_FEATURES.find(f => f.id === route.params?.featureId);

  if (!feature) {
    return (
      <View style={styles.center}>
        <Text>Feature not found.</Text>
      </View>
    );
  }

  const enabled = state.enabledFeatures.has(feature.id);

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <View style={styles.hero}>
        <View>
          <View style={styles.badge}>
            <Text style={styles.badgeText}>{feature.category}</Text>
          </View>
          <Text
            style={[styles.statusText, {color: enabled ? 'green' : Colors.onSurfaceVariant}]}
            accessibilityLabel={enabled ? 'Feature is enabled' : 'Feature is disabled'}>
            {enabled ? '● Enabled' : '○ Disabled'}
          </Text>
        </View>
      </View>

      <TouchableOpacity
        style={[styles.toggleBtn, {backgroundColor: enabled ? '#C62828' : Colors.primary}]}
        onPress={() => appStore.toggleFeature(feature.id)}
        accessibilityLabel={enabled ? `Disable ${feature.title}` : `Enable ${feature.title}`}
        accessibilityRole="button"
        testID="toggle-feature">
        <Text style={styles.toggleText}>{enabled ? 'Disable Feature' : 'Enable Feature'}</Text>
      </TouchableOpacity>

      <Text style={styles.sectionTitle} accessibilityRole="header">About</Text>
      <Text style={styles.body}>{feature.fullDescription}</Text>

      <Text style={styles.sectionTitle} accessibilityRole="header">How to use</Text>
      {feature.steps.map((step, i) => (
        <View key={i} style={styles.step} accessibilityLabel={`Step ${i + 1}: ${step}`}>
          <View style={styles.stepNum}>
            <Text style={styles.stepNumText}>{i + 1}</Text>
          </View>
          <Text style={styles.stepText}>{step}</Text>
        </View>
      ))}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {padding: Spacing.lg},
  center: {flex: 1, justifyContent: 'center', alignItems: 'center'},
  hero: {flexDirection: 'row', alignItems: 'flex-start', marginBottom: Spacing.lg},
  badge: {backgroundColor: Colors.primaryContainer, borderRadius: Radius.sm, paddingHorizontal: Spacing.sm, paddingVertical: 4, alignSelf: 'flex-start', marginBottom: Spacing.xs},
  badgeText: {color: Colors.primary, fontWeight: '700', fontSize: 12},
  statusText: {fontWeight: '600', ...Typography.bodyMedium},
  toggleBtn: {borderRadius: Radius.md, padding: Spacing.md, alignItems: 'center', minHeight: MIN_TOUCH, marginBottom: Spacing.lg},
  toggleText: {color: '#fff', ...Typography.titleMedium},
  sectionTitle: {...Typography.titleMedium, fontWeight: '700', marginBottom: Spacing.sm, marginTop: Spacing.md},
  body: {color: Colors.onSurfaceVariant, ...Typography.bodyMedium, lineHeight: 22, marginBottom: Spacing.md},
  step: {flexDirection: 'row', alignItems: 'flex-start', marginBottom: Spacing.md},
  stepNum: {width: 28, height: 28, borderRadius: 14, backgroundColor: Colors.primary, justifyContent: 'center', alignItems: 'center', marginRight: Spacing.md, marginTop: 2},
  stepNumText: {color: '#fff', fontWeight: '700', fontSize: 13},
  stepText: {flex: 1, ...Typography.bodyMedium, lineHeight: 20},
});
