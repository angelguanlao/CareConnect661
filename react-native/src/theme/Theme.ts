// ─────────────────────────────────────────────
// SWEN661-style Theme for CareConnect
// ─────────────────────────────────────────────

export const AppTheme = {
  // Core Colors
  primary: '#007AFF',
  primaryContainer: '#E3F2FD',

  secondary: '#FF9800',
  secondaryContainer: '#FFE0B2',

  success: '#4CAF50',
  danger: '#D32F2F',
  warning: '#FFA000',
  info: '#0288D1',

  // Text Colors
  textPrimary: '#222222',
  textSecondary: '#666666',
  textMuted: '#999999',
  textOnPrimary: '#FFFFFF',

  // Background / Surface
  background: '#FFFFFF',
  surface: '#F7F7F7',
  card: '#FFFFFF',
  border: '#E0E0E0',

  // Spacing Tokens
  spacing: {
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
  },

  // Radius Tokens
  radius: {
    sm: 6,
    md: 12,
    lg: 18,
    xl: 24,
  },

  // Shadows
  shadow: {
    light: {
      shadowColor: '#000',
      shadowOpacity: 0.05,
      shadowRadius: 4,
      shadowOffset: { width: 0, height: 2 },
      elevation: 2,
    },
    medium: {
      shadowColor: '#000',
      shadowOpacity: 0.1,
      shadowRadius: 6,
      shadowOffset: { width: 0, height: 3 },
      elevation: 4,
    },
  },

  // Typography Scale
  typography: {
    h1: { fontSize: 32, fontWeight: '700' as const },
    h2: { fontSize: 26, fontWeight: '700' as const },
    h3: { fontSize: 22, fontWeight: '600' as const },
    body: { fontSize: 16, fontWeight: '400' as const },
    small: { fontSize: 14, fontWeight: '400' as const },
    tiny: { fontSize: 12, fontWeight: '400' as const },
  },
};

// Legacy exports for backward compatibility
export const Colors = {
  primary: AppTheme.primary,
  primaryContainer: AppTheme.primaryContainer,
  secondary: AppTheme.secondary,
  surface: AppTheme.surface,
  surfaceVariant: AppTheme.surface,
  background: AppTheme.background,
  onSurface: AppTheme.textPrimary,
  onSurfaceVariant: AppTheme.textSecondary,
  error: AppTheme.danger,
  errorContainer: '#FFEBEE',
  darkBackground: '#121212',
  darkSurface: '#1E1E1E',
  darkOnSurface: '#FFFFFF',
};

export const Spacing = AppTheme.spacing;

export const Typography = {
  displaySmall: {fontSize: 36, fontWeight: '400' as const},
  headlineMedium: {fontSize: 28, fontWeight: '400' as const},
  headlineSmall: {fontSize: 24, fontWeight: '400' as const},
  titleLarge: {fontSize: 22, fontWeight: '700' as const},
  titleMedium: {fontSize: 16, fontWeight: '600' as const},
  titleSmall: {fontSize: 14, fontWeight: '600' as const},
  bodyLarge: {fontSize: 16, fontWeight: '400' as const},
  bodyMedium: {fontSize: 14, fontWeight: '400' as const},
  labelLarge: {fontSize: 14, fontWeight: '600' as const},
};

export const Radius = AppTheme.radius;

export const MIN_TOUCH = 48;
