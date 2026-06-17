import React, {useState} from 'react';
import {View, Text, TextInput, TouchableOpacity, FlatList, StyleSheet} from 'react-native';
import {useNavigation} from '@react-navigation/native';
import {Colors, Spacing, Typography, Radius, MIN_TOUCH} from '../theme/Theme';
import {useAppState} from '../state/AppContext';
import {ALL_FEATURES, Feature} from '../models/Feature';

const CATEGORIES = ['All', 'Navigation', 'Visual', 'Motor Accessibility'];

export function FeaturesScreen() {
  const state = useAppState();
  const navigation = useNavigation<any>();
  const [query, setQuery] = useState('');
  const [category, setCategory] = useState<string | null>(null);

  const results = ALL_FEATURES.filter(f => {
    const matchQ = !query || f.title.toLowerCase().includes(query.toLowerCase()) || f.shortDescription.toLowerCase().includes(query.toLowerCase());
    const matchC = !category || category === 'All' || f.category === category;
    return matchQ && matchC;
  });

  return (
    <View style={styles.container}>
      <TextInput
        style={styles.search}
        placeholder="Search features…"
        value={query}
        onChangeText={setQuery}
        accessibilityLabel="Search features"
        testID="search-input"
      />
      <View style={styles.chips}>
        {CATEGORIES.map(c => {
          const sel = c === 'All' ? !category || category === 'All' : category === c;
          return (
            <TouchableOpacity
              key={c}
              style={[styles.chip, sel && styles.chipSelected]}
              onPress={() => setCategory(c === 'All' ? null : c)}
              accessibilityLabel={`${c} filter`}
              accessibilityState={{selected: sel}}>
              <Text style={sel ? styles.chipTextSelected : styles.chipText}>{c}</Text>
            </TouchableOpacity>
          );
        })}
      </View>
      {results.length === 0 ? (
        <View style={styles.empty} accessibilityLiveRegion="polite">
          <Text style={styles.emptyText}>{query ? `No results for "${query}".` : 'No features in this category.'}</Text>
        </View>
      ) : (
        <FlatList
          data={results}
          keyExtractor={f => f.id}
          contentContainerStyle={styles.list}
          ItemSeparatorComponent={() => <View style={{height: Spacing.sm}} />}
          renderItem={({item}: {item: Feature}) => {
            const enabled = state.enabledFeatures.has(item.id);
            return (
              <TouchableOpacity
                style={styles.card}
                onPress={() => navigation.navigate('FeatureDetail', {featureId: item.id})}
                accessibilityLabel={`${item.title}. ${item.shortDescription}. ${enabled ? 'Enabled' : 'Disabled'}`}
                accessibilityRole="button"
                testID={`feature-${item.id}`}>
                <View style={{flex: 1}}>
                  <Text style={styles.cardTitle}>{item.title}</Text>
                  <Text style={styles.cardDesc} numberOfLines={2}>{item.shortDescription}</Text>
                  <View style={styles.badge}>
                    <Text style={styles.badgeText}>{item.category}</Text>
                  </View>
                </View>
                {enabled && <Text style={styles.onBadge}>ON</Text>}
              </TouchableOpacity>
            );
          }}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {flex: 1, backgroundColor: Colors.background},
  search: {margin: Spacing.md, borderWidth: 1, borderColor: '#BDBDBD', borderRadius: Radius.md, padding: Spacing.md, minHeight: MIN_TOUCH, ...Typography.bodyLarge},
  chips: {flexDirection: 'row', flexWrap: 'wrap', gap: Spacing.sm, paddingHorizontal: Spacing.md, marginBottom: Spacing.sm},
  chip: {paddingHorizontal: Spacing.md, paddingVertical: Spacing.sm, borderRadius: 999, backgroundColor: '#E0E0E0', minHeight: MIN_TOUCH, justifyContent: 'center'},
  chipSelected: {backgroundColor: Colors.primary},
  chipText: {color: Colors.onSurface, ...Typography.labelLarge},
  chipTextSelected: {color: '#fff', ...Typography.labelLarge},
  list: {padding: Spacing.md},
  card: {backgroundColor: '#fff', borderRadius: Radius.md, padding: Spacing.md, flexDirection: 'row', alignItems: 'center', minHeight: MIN_TOUCH},
  cardTitle: {...Typography.titleMedium, marginBottom: Spacing.xs},
  cardDesc: {color: Colors.onSurfaceVariant, ...Typography.bodyMedium},
  badge: {marginTop: Spacing.xs, backgroundColor: Colors.primaryContainer, borderRadius: Radius.sm, paddingHorizontal: Spacing.sm, paddingVertical: 2, alignSelf: 'flex-start'},
  badgeText: {color: Colors.primary, ...Typography.labelLarge, fontSize: 11},
  onBadge: {color: 'green', fontWeight: '700', marginLeft: Spacing.sm},
  empty: {flex: 1, justifyContent: 'center', alignItems: 'center', padding: Spacing.xl},
  emptyText: {color: Colors.onSurfaceVariant, ...Typography.bodyLarge},
});
