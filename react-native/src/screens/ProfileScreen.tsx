import React from 'react';
import {View, Text, TouchableOpacity, ScrollView, Alert, StyleSheet} from 'react-native';
import {useNavigation} from '@react-navigation/native';
import {AppTheme} from '../theme/Theme';
import {useAppState} from '../state/AppContext';
import {appStore} from '../state/AppState';

export function ProfileScreen() {
  const state = useAppState();
  const navigation = useNavigation<any>();
  const user = state.currentUser;

  if (!user) {
    return (
      <View style={styles.centered}>
        <Text style={styles.missing}>Not logged in.</Text>
      </View>
    );
  }

  const initials = user.name
    .trim()
    .split(' ')
    .map((p) => p[0])
    .slice(0, 2)
    .join('')
    .toUpperCase();

  const confirmLogout = () =>
    Alert.alert('Sign out?', 'You will be returned to the login screen.', [
      {text: 'Cancel', style: 'cancel'},
      {text: 'Sign out', style: 'destructive', onPress: () => appStore.logout()},
    ]);

  return (
    <ScrollView contentContainerStyle={styles.container}>
      {/* Header */}
      <Text style={styles.header}>Your Profile</Text>

      {/* Avatar */}
      <View style={styles.avatar} accessibilityLabel={`Profile avatar, initials ${initials}`}>
        <Text style={styles.avatarText}>{initials}</Text>
      </View>

      {/* Name */}
      <Text style={styles.name}>{user.name}</Text>

      {/* Email */}
      <Text style={styles.email}>{user.email}</Text>

      {/* Member since */}
      <Text style={styles.memberDate}>Member since {user.joinDate.getFullYear()}</Text>

      {/* Health Information Card */}
      {(user.bloodGroup || user.allergies) && (
        <View style={styles.healthCard}>
          <Text style={styles.cardTitle}>Health Information</Text>

          {user.bloodGroup && (
            <>
              <View style={styles.healthRow}>
                <Text style={styles.healthIcon}>🩸</Text>
                <View style={styles.healthContent}>
                  <Text style={styles.healthLabel}>Blood Group</Text>
                  <Text style={styles.healthValue}>{user.bloodGroup}</Text>
                </View>
              </View>
              {user.allergies && <View style={styles.divider} />}
            </>
          )}

          {user.allergies && (
            <View style={styles.healthRow}>
              <Text style={styles.healthIcon}>⚠️</Text>
              <View style={styles.healthContent}>
                <Text style={styles.healthLabel}>Allergies</Text>
                <Text style={styles.healthValue}>{user.allergies}</Text>
              </View>
            </View>
          )}
        </View>
      )}

      {/* Stats Card */}
      <View style={styles.statsCard}>
        <View style={styles.stat} accessibilityLabel={`Features Active: ${state.enabledFeatures.size}`}>
          <Text style={styles.statVal}>{state.enabledFeatures.size}</Text>
          <Text style={styles.statLbl}>Features{'\n'}Active</Text>
        </View>
        <View style={styles.stat} accessibilityLabel={`Hand Mode: ${state.leftHandMode ? 'Left' : 'Right'}`}>
          <Text style={styles.statVal}>{state.leftHandMode ? 'Left' : 'Right'}</Text>
          <Text style={styles.statLbl}>Hand{'\n'}Mode</Text>
        </View>
        <View style={styles.stat} accessibilityLabel={`Text Scale: ${state.textScaleFactor.toFixed(1)}×`}>
          <Text style={styles.statVal}>{state.textScaleFactor.toFixed(1)}×</Text>
          <Text style={styles.statLbl}>Text{'\n'}Scale</Text>
        </View>
      </View>

      {/* Buttons */}
      <TouchableOpacity
        style={styles.button}
        onPress={() => navigation.navigate('EditProfile')}
        accessibilityLabel="Edit profile"
        testID="edit-profile-btn">
        <Text style={styles.buttonText}>Edit Profile</Text>
      </TouchableOpacity>

      <TouchableOpacity
        style={[styles.button, styles.logoutButton]}
        onPress={confirmLogout}
        accessibilityLabel="Sign out of CareConnect"
        testID="logout-btn">
        <Text style={styles.logoutText}>Log Out</Text>
      </TouchableOpacity>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: AppTheme.background,
    padding: 24,
    alignItems: 'center',
  },

  centered: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },

  missing: {
    fontSize: 16,
    color: AppTheme.textSecondary,
  },

  header: {
    fontSize: 28,
    fontWeight: '700',
    marginTop: 20,
    marginBottom: 30,
  },

  avatar: {
    width: 90,
    height: 90,
    borderRadius: 45,
    backgroundColor: AppTheme.primaryContainer,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 16,
  },

  avatarText: {
    fontSize: 36,
    fontWeight: '700',
    color: AppTheme.primary,
  },

  name: {
    fontSize: 22,
    fontWeight: '700',
    marginBottom: 4,
  },

  email: {
    fontSize: 15,
    color: AppTheme.textSecondary,
    marginBottom: 4,
  },

  memberDate: {
    fontSize: 14,
    color: AppTheme.textSecondary,
    marginBottom: 32,
  },

  healthCard: {
    backgroundColor: AppTheme.card,
    borderRadius: 10,
    padding: 16,
    width: '100%',
    marginBottom: 24,
    borderWidth: 1,
    borderColor: AppTheme.border,
  },

  cardTitle: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 16,
    color: AppTheme.textPrimary,
  },

  healthRow: {
    flexDirection: 'row',
    alignItems: 'flex-start',
  },

  healthIcon: {
    fontSize: 20,
    marginRight: 12,
    marginTop: 2,
  },

  healthContent: {
    flex: 1,
  },

  healthLabel: {
    fontSize: 12,
    color: AppTheme.textSecondary,
    marginBottom: 2,
  },

  healthValue: {
    fontSize: 15,
    fontWeight: '600',
    color: AppTheme.textPrimary,
  },

  divider: {
    height: 1,
    backgroundColor: AppTheme.border,
    marginVertical: 12,
  },

  statsCard: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    backgroundColor: AppTheme.card,
    borderRadius: 10,
    padding: 16,
    width: '100%',
    marginBottom: 24,
    borderWidth: 1,
    borderColor: AppTheme.border,
  },

  stat: {
    alignItems: 'center',
  },

  statVal: {
    color: AppTheme.primary,
    fontSize: 22,
    fontWeight: '700',
  },

  statLbl: {
    color: AppTheme.textSecondary,
    fontSize: 12,
    textAlign: 'center',
    marginTop: 4,
  },

  button: {
    width: '100%',
    paddingVertical: 14,
    backgroundColor: AppTheme.primary,
    borderRadius: 10,
    alignItems: 'center',
    marginBottom: 16,
  },

  buttonText: {
    color: '#FFF',
    fontSize: 16,
    fontWeight: '600',
  },

  logoutButton: {
    backgroundColor: '#C62828',
  },

  logoutText: {
    color: '#FFF',
    fontSize: 16,
    fontWeight: '700',
  },
});
