import React, {useState} from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  ScrollView,
  ActivityIndicator,
  AccessibilityInfo,
} from 'react-native';
import {AppTheme} from '../theme/Theme';
import {appStore} from '../state/AppState';

export function LoginScreen() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [obscure, setObscure] = useState(true);

  const handleLogin = async () => {
    setError(null);
    if (!email.includes('@') || !email.includes('.')) {
      setError('Please enter a valid email address.');
      return;
    }
    if (password.length < 6) {
      setError('Password must be at least 6 characters.');
      return;
    }
    setLoading(true);
    const ok = await appStore.login(email.trim(), password);
    if (!ok) {
      setLoading(false);
      setError('Incorrect email or password. Please try again.');
      AccessibilityInfo.announceForAccessibility(
        'Incorrect email or password. Please try again.'
      );
      return;
    }
  };

  return (
    <ScrollView
      style={styles.container}
      contentContainerStyle={{padding: 24}}
      keyboardShouldPersistTaps="handled">
      {/* Brand Header */}
      <View style={styles.brandRow}>
        <View style={styles.brandIcon}>
          <Text style={styles.brandIconText}>♿</Text>
        </View>
        <Text style={styles.brandTitle}>CareConnect</Text>
      </View>

      <Text style={styles.welcome}>Welcome back</Text>
      <Text style={styles.subtitle}>Sign in to continue</Text>

      {/* Email Field */}
      <View style={styles.fieldContainer}>
        <Text style={styles.label}>Email address</Text>
        <TextInput
          accessibilityLabel="Email address text field"
          style={styles.input}
          placeholder="you@example.com"
          keyboardType="email-address"
          autoCapitalize="none"
          value={email}
          onChangeText={setEmail}
          testID="email-input"
        />
      </View>

      {/* Password Field */}
      <View style={styles.fieldContainer}>
        <Text style={styles.label}>Password</Text>
        <View style={styles.passwordRow}>
          <TextInput
            accessibilityLabel="Password text field"
            style={[styles.input, {flex: 1}]}
            placeholder="At least 6 characters"
            secureTextEntry={obscure}
            value={password}
            onChangeText={setPassword}
            onSubmitEditing={handleLogin}
            testID="password-input"
          />
          <TouchableOpacity
            accessibilityLabel={obscure ? 'Show password' : 'Hide password'}
            onPress={() => setObscure(!obscure)}
            style={styles.eyeButton}
            testID="toggle-password">
            <Text style={{fontSize: 16}}>
              {obscure ? '👁️' : '🙈'}
            </Text>
          </TouchableOpacity>
        </View>
      </View>

      {/* Error Message */}
      {error && (
        <View style={styles.errorBox} accessibilityLiveRegion="polite" testID="error-message">
          <Text style={styles.errorText}>{error}</Text>
        </View>
      )}

      {/* Sign In Button */}
      <TouchableOpacity
        accessibilityLabel="Sign in to CareConnect"
        style={styles.signInButton}
        onPress={handleLogin}
        disabled={loading}
        testID="sign-in-button">
        {loading ? (
          <ActivityIndicator color="#FFF" />
        ) : (
          <Text style={styles.signInText}>Sign In</Text>
        )}
      </TouchableOpacity>

      {/* Sign Up Button */}
      <TouchableOpacity
        accessibilityLabel="Create account"
        style={styles.signUpButton}
        onPress={() => {
          const msg = 'Sign-up feature coming soon! For now, use any email + password ≥ 6 characters to demo the app.';
          AccessibilityInfo.announceForAccessibility(msg);
          alert(msg);
        }}
        testID="sign-up-button">
        <Text style={styles.signUpText}>Create Account</Text>
      </TouchableOpacity>

      <Text style={styles.demoNote}>
        Demo: any email + password ≥ 6 characters
      </Text>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: AppTheme.background,
  },

  brandRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 24,
    marginBottom: 40,
  },
  brandIcon: {
    width: 52,
    height: 52,
    backgroundColor: AppTheme.primary,
    borderRadius: 14,
    justifyContent: 'center',
    alignItems: 'center',
  },
  brandIconText: {
    color: '#FFF',
    fontSize: 28,
  },
  brandTitle: {
    marginLeft: 12,
    fontSize: 28,
    fontWeight: '700',
    color: AppTheme.primary,
  },

  welcome: {
    fontSize: 24,
    fontWeight: '700',
  },
  subtitle: {
    marginTop: 6,
    fontSize: 16,
    color: AppTheme.textSecondary,
    marginBottom: 32,
  },

  fieldContainer: {
    marginBottom: 20,
  },
  label: {
    fontSize: 14,
    marginBottom: 6,
    fontWeight: '600',
  },
  input: {
    borderWidth: 1,
    borderColor: AppTheme.border,
    borderRadius: 10,
    paddingHorizontal: 14,
    paddingVertical: 12,
    fontSize: 16,
  },

  passwordRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  eyeButton: {
    paddingHorizontal: 12,
    paddingVertical: 10,
  },

  errorBox: {
    backgroundColor: '#FFEBEE',
    borderColor: '#D32F2F',
    borderWidth: 1,
    padding: 12,
    borderRadius: 10,
    marginBottom: 20,
  },
  errorText: {
    color: '#D32F2F',
    fontSize: 14,
  },

  signInButton: {
    backgroundColor: AppTheme.primary,
    paddingVertical: 16,
    borderRadius: 10,
    alignItems: 'center',
    marginTop: 10,
    marginBottom: 12,
  },
  signInText: {
    color: '#FFF',
    fontSize: 18,
    fontWeight: '600',
  },

  signUpButton: {
    borderWidth: 2,
    borderColor: AppTheme.primary,
    paddingVertical: 16,
    borderRadius: 10,
    alignItems: 'center',
    marginBottom: 20,
  },
  signUpText: {
    color: AppTheme.primary,
    fontSize: 18,
    fontWeight: '600',
  },

  demoNote: {
    marginTop: 20,
    textAlign: 'center',
    color: AppTheme.textSecondary,
    fontSize: 14,
  },
});
