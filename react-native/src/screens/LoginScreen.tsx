import React, {useState} from 'react';
import {View, Text, TextInput, TouchableOpacity, StyleSheet, ScrollView, ActivityIndicator, AccessibilityInfo} from 'react-native';
import {Colors, Spacing, Typography, Radius, MIN_TOUCH} from '../theme/Theme';
import {appStore} from '../state/AppState';

export function LoginScreen() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [showPassword, setShowPassword] = useState(false);

  const handleLogin = async () => {
    setError(null);
    setLoading(true);
    const ok = await appStore.login(email, password);
    setLoading(false);
    if (!ok) {
      const msg = 'Incorrect email or password. Please try again.';
      setError(msg);
      AccessibilityInfo.announceForAccessibility(msg);
    }
  };

  return (
    <ScrollView contentContainerStyle={styles.container} keyboardShouldPersistTaps="handled">
      <View accessible accessibilityRole="header" style={styles.header}>
        <View style={styles.logoBox} accessibilityLabel="CareConnect logo">
          <Text style={styles.logoIcon}>♿</Text>
        </View>
        <Text style={styles.brand}>CareConnect</Text>
      </View>

      <Text style={styles.welcome}>Welcome back</Text>
      <Text style={styles.subtitle}>Sign in to continue</Text>

      <TextInput
        style={styles.input}
        placeholder="Email address"
        value={email}
        onChangeText={setEmail}
        keyboardType="email-address"
        autoCapitalize="none"
        accessibilityLabel="Email address"
        accessibilityHint="Enter your email address"
        testID="email-input"
      />
      <View style={styles.passwordRow}>
        <TextInput
          style={[styles.input, {flex: 1}]}
          placeholder="Password (6+ characters)"
          value={password}
          onChangeText={setPassword}
          secureTextEntry={!showPassword}
          accessibilityLabel="Password"
          accessibilityHint="Enter your password, at least 6 characters"
          testID="password-input"
        />
        <TouchableOpacity
          onPress={() => setShowPassword(v => !v)}
          style={styles.visibilityBtn}
          accessibilityLabel={showPassword ? 'Hide password' : 'Show password'}
          testID="toggle-password">
          <Text>{showPassword ? '🙈' : '👁'}</Text>
        </TouchableOpacity>
      </View>

      {error && (
        <View
          style={styles.errorBox}
          accessible
          accessibilityLiveRegion="polite"
          accessibilityLabel={error}
          testID="error-message">
          <Text style={styles.errorText}>{error}</Text>
        </View>
      )}

      <TouchableOpacity
        style={styles.button}
        onPress={handleLogin}
        disabled={loading}
        accessibilityLabel="Sign in to CareConnect"
        accessibilityRole="button"
        testID="sign-in-button">
        {loading ? (
          <ActivityIndicator color="#fff" />
        ) : (
          <Text style={styles.buttonText}>Sign In</Text>
        )}
      </TouchableOpacity>

      <TouchableOpacity
        style={styles.signupBtn}
        onPress={() => {
          const msg = 'Sign-up feature coming soon! For now, use any email + password ≥ 6 characters to demo the app.';
          AccessibilityInfo.announceForAccessibility(msg);
          alert(msg);
        }}
        accessibilityLabel="Create account"
        accessibilityRole="button"
        testID="sign-up-button">
        <Text style={styles.signupBtnText}>Create Account</Text>
      </TouchableOpacity>

      <Text style={styles.hint}>Demo: any email + password ≥ 6 characters</Text>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {padding: Spacing.lg, paddingTop: Spacing.xl * 2},
  header: {flexDirection: 'row', alignItems: 'center', marginBottom: Spacing.xl},
  logoBox: {width: 52, height: 52, backgroundColor: Colors.primary, borderRadius: Radius.md, justifyContent: 'center', alignItems: 'center'},
  logoIcon: {fontSize: 28, color: '#fff'},
  brand: {...Typography.headlineMedium, color: Colors.primary, fontWeight: '700', marginLeft: Spacing.md},
  welcome: {...Typography.headlineSmall, fontWeight: '700', marginBottom: Spacing.xs},
  subtitle: {...Typography.bodyLarge, color: Colors.onSurfaceVariant, marginBottom: Spacing.lg},
  input: {borderWidth: 1, borderColor: '#BDBDBD', borderRadius: Radius.md, padding: Spacing.md, marginBottom: Spacing.md, ...Typography.bodyLarge, backgroundColor: Colors.surface, minHeight: MIN_TOUCH},
  passwordRow: {flexDirection: 'row', alignItems: 'center', marginBottom: Spacing.md},
  visibilityBtn: {padding: Spacing.md, minWidth: MIN_TOUCH, minHeight: MIN_TOUCH, justifyContent: 'center', alignItems: 'center'},
  errorBox: {backgroundColor: Colors.errorContainer, borderRadius: Radius.sm, padding: Spacing.md, marginBottom: Spacing.md},
  errorText: {color: Colors.error, ...Typography.bodyMedium},
  button: {backgroundColor: Colors.primary, borderRadius: Radius.md, padding: Spacing.md, alignItems: 'center', minHeight: MIN_TOUCH, marginBottom: Spacing.md},
  buttonText: {color: '#fff', ...Typography.titleMedium},
  signupBtn: {borderWidth: 2, borderColor: Colors.primary, borderRadius: Radius.md, padding: Spacing.md, alignItems: 'center', minHeight: MIN_TOUCH, marginBottom: Spacing.md},
  signupBtnText: {color: Colors.primary, ...Typography.labelLarge},
  hint: {textAlign: 'center', color: Colors.onSurfaceVariant, ...Typography.bodyMedium},
});
