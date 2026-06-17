import React from 'react';
import {View, Text, TouchableOpacity, FlatList, StyleSheet} from 'react-native';
import {Colors, Spacing, Typography, Radius, MIN_TOUCH} from '../theme/Theme';
import {useAppState} from '../state/AppContext';
import {appStore} from '../state/AppState';
import {Notification} from '../state/AppState';

export function NotificationsScreen() {
  const state = useAppState();
  const notes = state.notifications;

  const age = (t: Date) => {
    const d = Date.now() - t.getTime();
    if (d < 3600000) return `${Math.floor(d / 60000)}m ago`;
    if (d < 86400000) return `${Math.floor(d / 3600000)}h ago`;
    return `${Math.floor(d / 86400000)}d ago`;
  };

  if (notes.length === 0) {
    return (
      <View style={styles.empty} accessibilityLiveRegion="polite">
        <Text style={styles.emptyText}>No notifications yet.</Text>
      </View>
    );
  }

  return (
    <View style={{flex: 1}}>
      {state.notifications.some(n => !n.isRead) && (
        <TouchableOpacity
          style={styles.markAllBtn}
          onPress={() => appStore.markAllRead()}
          accessibilityLabel="Mark all notifications as read"
          testID="mark-all-read">
          <Text style={styles.markAllText}>Mark all read</Text>
        </TouchableOpacity>
      )}
      <FlatList
        data={notes}
        keyExtractor={n => n.id}
        contentContainerStyle={styles.list}
        ItemSeparatorComponent={() => <View style={{height: Spacing.sm}} />}
        renderItem={({item}: {item: Notification}) => (
          <TouchableOpacity
            style={[styles.card, !item.isRead && styles.cardUnread]}
            onPress={() => appStore.markRead(item.id)}
            accessibilityLabel={`${item.title}. ${item.body}. ${age(item.timestamp)}. ${item.isRead ? 'Read.' : 'Unread.'}`}
            accessibilityRole="button"
            testID={`notification-${item.id}`}>
            <View style={[styles.dot, {backgroundColor: item.isRead ? 'transparent' : Colors.primary}]} />
            <View style={{flex: 1}}>
              <Text style={[styles.title, !item.isRead && styles.titleBold]}>{item.title}</Text>
              <Text style={styles.body}>{item.body}</Text>
              <Text style={styles.age}>{age(item.timestamp)}</Text>
            </View>
          </TouchableOpacity>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  list: {padding: Spacing.md},
  markAllBtn: {margin: Spacing.md, alignSelf: 'flex-end', minHeight: MIN_TOUCH, justifyContent: 'center'},
  markAllText: {color: Colors.primary, ...Typography.labelLarge},
  card: {backgroundColor: '#fff', borderRadius: Radius.md, padding: Spacing.md, flexDirection: 'row', alignItems: 'flex-start'},
  cardUnread: {backgroundColor: Colors.primaryContainer},
  dot: {width: 10, height: 10, borderRadius: 5, marginTop: 5, marginRight: Spacing.md},
  title: {fontSize: 15, marginBottom: Spacing.xs},
  titleBold: {fontWeight: '700'},
  body: {color: Colors.onSurfaceVariant, ...Typography.bodyMedium, lineHeight: 20, marginBottom: Spacing.xs},
  age: {color: Colors.onSurfaceVariant, fontSize: 12},
  empty: {flex: 1, justifyContent: 'center', alignItems: 'center'},
  emptyText: {color: Colors.onSurfaceVariant, ...Typography.bodyLarge},
});
