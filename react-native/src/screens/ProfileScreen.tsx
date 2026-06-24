import React from 'react';
import {View, Text, TouchableOpacity, ScrollView, Alert, StyleSheet} from 'react-native';
import {useNavigation} from '@react-navigation/native';
import {Colors, Spacing, Typography, Radius, MIN_TOUCH} from '../theme/Theme';
import {useAppState} from '../state/AppContext';
import {appStore} from '../state/AppState';

export function ProfileScreen() {
  const state = useAppState();
  const navigation = useNavigation<any>();
  const user = state.currentUser;

  const initials = user ? user.name.trim().split(' ').map(p => p[0]).slice(0, 2).join('').toUpperCase() : '?';

  const confirmLogout = () =>
    Alert.alert('Sign out?', 'You will be returned to the login screen.', [
      {text: 'Cancel', style: 'cancel'},
      {text: 'Sign out', style: 'destructive', onPress: () => appStore.logout()},
    ]);

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <View style={styles.avatar} accessible accessibilityLabel={`Profile avatar, initials ${initials}`}>
        <Text style={styles.avatarText} importantForAccessibility="no">{initials}</Text>
      </View>
      <Text style={styles.name}>{user?.name}</Text>
      <Text style={styles.email}>{user?.email}</Text>
      <Text style={styles.member}>Member since {user?.joinDate.getFullYear()}</Text>

      {(user?.bloodGroup || user?.allergies) && (
        <View style={styles.healthCard}>
          <Text style={styles.healthTitle}>Health Information</Text>
          {user?.bloodGroup && (
            <View style={styles.healthRow} accessible accessibilityLabel={`Blood Group: ${user.bloodGroup}`}>
              <Text style={styles.healthIcon} importantForAccessibility="no">🩸</Text>
              <View style={styles.healthContent}>
                <Text style={styles.healthLabel}>Blood Group</Text>
                <Text style={styles.healthValue}>{user.bloodGroup}</Text>
              </View>
            </View>
          )}
          {user?.bloodGroup && user?.allergies && <View style={styles.healthDivider} />}
          {user?.allergies && (
            <View style={styles.healthRow} accessible accessibilityLabel={`Allergies: ${user.allergies}`}>
              <Text style={styles.healthIcon} importantForAccessibility="no">⚠️</Text>
              <View style={styles.healthContent}>
                <Text style={styles.healthLabel}>Allergies</Text>
                <Text style={styles.healthValue}>{user.allergies}</Text>
              </View>
            </View>
          )}
        </View>
      )}

      <View style={styles.statsCard}>
        <View style={styles.stat} accessible accessibilityLabel={`Features Active: ${state.enabledFeatures.size}`}>
          <Text style={styles.statVal} importantForAccessibility="no">{state.enabledFeatures.size}</Text>
          <Text style={styles.statLbl} importantForAccessibility="no">Features{'\n'}Active</Text>
        </View>
        <View style={styles.stat} accessible accessibilityLabel={`Hand Mode: ${state.leftHandMode ? 'Left' : 'Right'}`}>
          <Text style={styles.statVal} importantForAccessibility="no">{state.leftHandMode ? 'Left' : 'Right'}</Text>
          <Text style={styles.statLbl} importantForAccessibility="no">Hand{'\n'}Mode</Text>
        </View>
        <View style={styles.stat} accessible accessibilityLabel={`Text Scale: ${state.textScaleFactor.toFixed(1)}×`}>
          <Text style={styles.statVal} importantForAccessibility="no">{state.textScaleFactor.toFixed(1)}×</Text>
          <Text style={styles.statLbl} importantForAccessibility="no">Text{'\n'}Scale</Text>
        </View>
      </View>

      <TouchableOpacity
        style={styles.outlineBtn}
        onPress={() => navigation.navigate('EditProfile')}
        accessibilityLabel="Edit profile"
        accessibilityRole="button"
        testID="edit-profile-btn">
        <Text style={styles.outlineBtnText}>Edit Profile</Text>
      </TouchableOpacity>

      <TouchableOpacity
        style={styles.dangerBtn}
        onPress={confirmLogout}
        accessibilityLabel="Sign out of CareConnect"
        accessibilityRole="button"
        testID="logout-btn">
        <Text style={styles.dangerBtnText}>Sign Out</Text>
      </TouchableOpacity>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {padding: Spacing.lg, alignItems: 'center'},
  avatar: {width: 96, height: 96, borderRadius: 48, backgroundColor: Colors.primary, justifyContent: 'center', alignItems: 'center', marginBottom: Spacing.md},
  avatarText: {color: '#fff', fontSize: 32, fontWeight: '700'},
  name: {...Typography.headlineSmall, fontWeight: '700', marginBottom: Spacing.xs},
  email: {color: Colors.onSurfaceVariant, ...Typography.bodyLarge, marginBottom: Spacing.xs},
  member: {color: Colors.onSurfaceVariant, ...Typography.bodyMedium, marginBottom: Spacing.lg},
  healthCard: {backgroundColor: '#fff', borderRadius: Radius.md, padding: Spacing.md, width: '100%', marginBottom: Spacing.lg},
  healthTitle: {color: Colors.onSurface, ...Typography.labelLarge, fontWeight: '700', marginBottom: Spacing.md},
  healthRow: {flexDirection: 'row', alignItems: 'flex-start', marginBottom: Spacing.md},
  healthIcon: {fontSize: 20, marginRight: Spacing.md},
  healthContent: {flex: 1},
  healthLabel: {color: Colors.onSurfaceVariant, ...Typography.bodySmall, marginBottom: 2},
  healthValue: {color: Colors.onSurface, ...Typography.labelLarge, fontWeight: '700'},
  healthDivider: {height: 1, backgroundColor: '#E0E0E0', marginVertical: Spacing.md},
  statsCard: {flexDirection: 'row', justifyContent: 'space-around', backgroundColor: '#fff', borderRadius: Radius.md, padding: Spacing.md, width: '100%', marginBottom: Spacing.lg},
  stat: {alignItems: 'center'},
  statVal: {color: Colors.primary, fontSize: 22, fontWeight: '700'},
  statLbl: {color: Colors.onSurfaceVariant, fontSize: 12, textAlign: 'center'},
  outlineBtn: {borderWidth: 1, borderColor: Colors.primary, borderRadius: Radius.md, padding: Spacing.md, width: '100%', alignItems: 'center', minHeight: MIN_TOUCH, marginBottom: Spacing.sm},
  outlineBtnText: {color: Colors.primary, ...Typography.labelLarge},
  dangerBtn: {backgroundColor: '#C62828', borderRadius: Radius.md, padding: Spacing.md, width: '100%', alignItems: 'center', minHeight: MIN_TOUCH},
  dangerBtnText: {color: '#fff', ...Typography.labelLarge},
});
