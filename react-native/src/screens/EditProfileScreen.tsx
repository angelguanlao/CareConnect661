import React, {useState} from 'react';
import {View, Text, TextInput, TouchableOpacity, ScrollView, StyleSheet} from 'react-native';
import {useNavigation} from '@react-navigation/native';
import {AppTheme} from '../theme/Theme';
import {useAppState} from '../state/AppContext';
import {appStore} from '../state/AppState';

export function EditProfileScreen() {
  const state = useAppState();
  const navigation = useNavigation();
  const [name, setName] = useState(state.currentUser?.name ?? '');
  const [email, setEmail] = useState(state.currentUser?.email ?? '');
  const [bloodGroup, setBloodGroup] = useState(state.currentUser?.bloodGroup ?? '');
  const [allergies, setAllergies] = useState(state.currentUser?.allergies ?? '');
  const [saved, setSaved] = useState(false);

  const save = () => {
    appStore.updateProfile(name, email, bloodGroup, allergies);
    setSaved(true);
    setTimeout(() => navigation.goBack(), 500);
  };

  return (
    <ScrollView contentContainerStyle={styles.container} keyboardShouldPersistTaps="handled">
      <Text style={styles.header}>Edit Profile</Text>

      {/* Name Field */}
      <View style={styles.fieldContainer}>
        <Text style={styles.label}>Display Name</Text>
        <TextInput
          style={styles.input}
          value={name}
          onChangeText={setName}
          accessibilityLabel="Display name"
          testID="name-input"
        />
      </View>

      {/* Email Field */}
      <View style={styles.fieldContainer}>
        <Text style={styles.label}>Email Address</Text>
        <TextInput
          style={styles.input}
          value={email}
          onChangeText={setEmail}
          keyboardType="email-address"
          autoCapitalize="none"
          accessibilityLabel="Email address"
          testID="email-input"
        />
      </View>

      {/* Blood Group Field */}
      <View style={styles.fieldContainer}>
        <Text style={styles.label}>Blood Group</Text>
        <TextInput
          style={styles.input}
          value={bloodGroup}
          onChangeText={setBloodGroup}
          placeholder="e.g., B+"
          accessibilityLabel="Blood group"
          testID="blood-group-input"
        />
      </View>

      {/* Allergies Field */}
      <View style={styles.fieldContainer}>
        <Text style={styles.label}>Allergies</Text>
        <TextInput
          style={[styles.input, {minHeight: 100}]}
          value={allergies}
          onChangeText={setAllergies}
          placeholder="Separate multiple allergies with commas"
          multiline
          accessibilityLabel="Allergies"
          testID="allergies-input"
        />
      </View>

      {/* Save Button */}
      <TouchableOpacity
        style={styles.saveBtn}
        onPress={save}
        accessibilityLabel="Save profile changes"
        accessibilityRole="button"
        testID="save-btn">
        <Text style={styles.saveBtnText}>{saved ? 'Saved!' : 'Save Changes'}</Text>
      </TouchableOpacity>

      {/* Cancel Button */}
      <TouchableOpacity
        style={styles.cancelBtn}
        onPress={() => navigation.goBack()}
        accessibilityLabel="Cancel"
        testID="cancel-btn">
        <Text style={styles.cancelBtnText}>Cancel</Text>
      </TouchableOpacity>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: AppTheme.background,
    padding: 24,
  },

  header: {
    fontSize: 28,
    fontWeight: '700',
    marginBottom: 24,
    marginTop: 12,
  },

  fieldContainer: {
    marginBottom: 20,
  },

  label: {
    fontSize: 14,
    marginBottom: 6,
    fontWeight: '600',
    color: AppTheme.textPrimary,
  },

  input: {
    borderWidth: 1,
    borderColor: AppTheme.border,
    borderRadius: 10,
    paddingHorizontal: 14,
    paddingVertical: 12,
    fontSize: 16,
    backgroundColor: AppTheme.background,
  },

  saveBtn: {
    backgroundColor: AppTheme.primary,
    borderRadius: 10,
    padding: 14,
    alignItems: 'center',
    marginBottom: 12,
  },

  saveBtnText: {
    color: '#FFF',
    fontSize: 16,
    fontWeight: '600',
  },

  cancelBtn: {
    borderWidth: 1,
    borderColor: AppTheme.border,
    borderRadius: 10,
    padding: 14,
    alignItems: 'center',
  },

  cancelBtnText: {
    color: AppTheme.textSecondary,
    fontSize: 16,
    fontWeight: '600',
  },
});
