module.exports = {
  preset: '@react-native/jest-preset',
  collectCoverageFrom: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.d.ts',
  ],
  coverageReporters: ['lcov', 'text', 'html'],
  coverageDirectory: 'coverage',
  testPathIgnorePatterns: ['/node_modules/', '__tests__/App.test.tsx'],
  transformIgnorePatterns: [
    'node_modules/(?!(react-native|@react-native|@react-navigation|react-native-screens|react-native-safe-area-context|react-native-gesture-handler)/)',
  ],
  moduleNameMapper: {
    '@react-navigation/stack': '<rootDir>/__mocks__/@react-navigation/stack.js',
    '@react-navigation/bottom-tabs': '<rootDir>/__mocks__/@react-navigation/bottom-tabs.js',
    '@react-navigation/native': '<rootDir>/__mocks__/@react-navigation/native.js',
  },
};
