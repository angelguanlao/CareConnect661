import React, {useState} from 'react';
import {View, Text, TextInput, TouchableOpacity, ScrollView, StyleSheet} from 'react-native';
import {useNavigation} from '@react-navigation/native';
import {Colors, Spacing, Typography, Radius, MIN_TOUCH} from '../theme/Theme';
import {useAppState} from '../state/AppContext';
import {appStore} from '../state/AppState';

export function EditProfileScreen() {
  const state = useAppState();
  const navigation = useNavigation();
  const [name, setName] = useState(state.currentUser?.name ?? '');
  const [email, setEmail] = useState(state.currentUser?.email ?? '');
  const [saved, setSaved] = useState(false);

  const save = () => {
    appStore.updateProfile(name, email);
    setSaved(true);
    setTimeout(() => navigation.goBack(), 500);
  };

  return (
    <ScrollView contentContainerStyle={styles.container} keyboardShouldPersistTaps="handled">
      <Text style={styles.label}>Display Name</Text>
      <TextInput
        style={styles.input}
        value={name}
        onChangeText={setName}
        accessibilityLabel="Display name"
        testID="name-input"
      />
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
      <TouchableOpacity
        style={styles.saveBtn}
        onPress={save}
        accessibilityLabel="Save profile changes"
        accessibilityRole="button"
        testID="save-btn">
        <Text style={styles.saveBtnText}>{saved ? 'Saved!' : 'Save Changes'}</Text>
      </TouchableOpacity>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {padding: Spacing.lg},
  label: {...Typography.labelLarge, marginBottom: Spacing.xs, color: Colors.onSurfaceVariant},
  input: {borderWidth: 1, borderColor: '#BDBDBD', borderRadius: Radius.md, padding: Spacing.md, marginBottom: Spacing.md, ...Typography.bodyLarge, minHeight: MIN_TOUCH},
  saveBtn: {backgroundColor: Colors.primary, borderRadius: Radius.md, padding: Spacing.md, alignItems: 'center', minHeight: MIN_TOUCH},
  saveBtnText: {color: '#fff', ...Typography.labelLarge},
});
