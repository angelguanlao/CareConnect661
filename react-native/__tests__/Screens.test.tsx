import React from 'react';
import {render, fireEvent} from '@testing-library/react-native';
import {HomeScreen} from '../src/screens/HomeScreen';
import {FeaturesScreen} from '../src/screens/FeaturesScreen';
import {NotificationsScreen} from '../src/screens/NotificationsScreen';
import {SettingsScreen} from '../src/screens/SettingsScreen';
import {ProfileScreen} from '../src/screens/ProfileScreen';
import {FeatureDetailScreen} from '../src/screens/FeatureDetailScreen';
import {AppProvider} from '../src/state/AppContext';
import {appStore} from '../src/state/AppState';

function wrap(ui: React.ReactElement) {
  return render(<AppProvider>{ui}</AppProvider>);
}

beforeEach(async () => {
  appStore.logout();
  await appStore.login('demo@careconnect.com', '123456');
  appStore.completeOnboarding({leftHand: true, highContrast: false, largeTargets: true, textScale: 1.0});
});

describe('HomeScreen', () => {
  it('renders greeting banner', () => {
    const {getByText} = wrap(<HomeScreen />);
    expect(getByText('Alex')).toBeTruthy();
  });

  it('renders Quick Actions section', () => {
    const {getByText} = wrap(<HomeScreen />);
    expect(getByText('Quick Actions')).toBeTruthy();
  });

  it('renders accessibility profile section', () => {
    const {getByText} = wrap(<HomeScreen />);
    expect(getByText('Your Accessibility Profile')).toBeTruthy();
  });

  it('tapping High Contrast tile toggles state', () => {
    const {getByTestId} = wrap(<HomeScreen />);
    fireEvent.press(getByTestId('tile-high-contrast'));
    expect(appStore.getState().highContrast).toBe(true);
  });

  it('tapping Large Targets tile toggles state', () => {
    const {getByTestId} = wrap(<HomeScreen />);
    fireEvent.press(getByTestId('tile-large-targets'));
    expect(appStore.getState().largeTargets).toBe(false);
  });

  it('renders tip of the day', () => {
    const {getByText} = wrap(<HomeScreen />);
    expect(getByText('Tip of the Day')).toBeTruthy();
  });
});

describe('FeaturesScreen', () => {
  it('renders search input', () => {
    const {getByTestId} = wrap(<FeaturesScreen />);
    expect(getByTestId('search-input')).toBeTruthy();
  });

  it('renders feature list items', () => {
    const {getByTestId} = wrap(<FeaturesScreen />);
    expect(getByTestId('feature-left-nav')).toBeTruthy();
  });

  it('filters results by search query', () => {
    const {getByTestId, queryByTestId} = wrap(<FeaturesScreen />);
    fireEvent.changeText(getByTestId('search-input'), 'voice');
    expect(queryByTestId('feature-voice-input')).toBeTruthy();
  });

  it('shows empty state for no results', () => {
    const {getByTestId, getByText} = wrap(<FeaturesScreen />);
    fireEvent.changeText(getByTestId('search-input'), 'xyznonexistent');
    expect(getByText(/No results for/)).toBeTruthy();
  });
});

describe('FeatureDetailScreen', () => {
  it('renders feature detail for left-nav', () => {
    const {getByText} = wrap(<FeatureDetailScreen />);
    expect(getByText('About')).toBeTruthy();
  });

  it('shows enable/disable toggle', () => {
    const {getByTestId} = wrap(<FeatureDetailScreen />);
    expect(getByTestId('toggle-feature')).toBeTruthy();
  });

  it('toggles feature on press', () => {
    const before = appStore.isFeatureEnabled('left-nav');
    const {getByTestId} = wrap(<FeatureDetailScreen />);
    fireEvent.press(getByTestId('toggle-feature'));
    expect(appStore.isFeatureEnabled('left-nav')).toBe(!before);
  });
});

describe('NotificationsScreen', () => {
  it('renders notification items', () => {
    const {getByTestId} = wrap(<NotificationsScreen />);
    expect(getByTestId('notification-1')).toBeTruthy();
  });

  it('shows mark all read button when there are unread notifications', () => {
    const {getByTestId} = wrap(<NotificationsScreen />);
    expect(getByTestId('mark-all-read')).toBeTruthy();
  });

  it('marks notification as read on press', () => {
    const {getByTestId} = wrap(<NotificationsScreen />);
    fireEvent.press(getByTestId('notification-1'));
    const note = appStore.getState().notifications.find(n => n.id === '1');
    expect(note?.isRead).toBe(true);
  });

  it('marks all as read', () => {
    const {getByTestId} = wrap(<NotificationsScreen />);
    fireEvent.press(getByTestId('mark-all-read'));
    expect(appStore.unreadCount).toBe(0);
  });
});

describe('SettingsScreen', () => {
  it('renders Accessibility section', () => {
    const {getByText} = wrap(<SettingsScreen />);
    expect(getByText('ACCESSIBILITY')).toBeTruthy();
  });

  it('toggles high contrast switch', () => {
    const {getByTestId} = wrap(<SettingsScreen />);
    fireEvent(getByTestId('high-contrast-toggle'), 'valueChange', true);
    expect(appStore.getState().highContrast).toBe(true);
  });

  it('toggles large targets switch', () => {
    const {getByTestId} = wrap(<SettingsScreen />);
    fireEvent(getByTestId('large-targets-toggle'), 'valueChange', false);
    expect(appStore.getState().largeTargets).toBe(false);
  });

  it('toggles left hand mode switch', () => {
    const {getByTestId} = wrap(<SettingsScreen />);
    fireEvent(getByTestId('left-hand-toggle'), 'valueChange', false);
    expect(appStore.getState().leftHandMode).toBe(false);
  });

  it('selects text scale', () => {
    const {getByTestId} = wrap(<SettingsScreen />);
    fireEvent.press(getByTestId('scale-1.5'));
    expect(appStore.getState().textScaleFactor).toBe(1.5);
  });

  it('renders Account and About sections', () => {
    const {getByText} = wrap(<SettingsScreen />);
    expect(getByText('ACCOUNT')).toBeTruthy();
    expect(getByText('ABOUT')).toBeTruthy();
  });
});

describe('ProfileScreen', () => {
  it('renders user name and email', () => {
    const {getByText} = wrap(<ProfileScreen />);
    expect(getByText('Alex Johnson')).toBeTruthy();
    expect(getByText('demo@careconnect.com')).toBeTruthy();
  });

  it('renders edit profile button', () => {
    const {getByTestId} = wrap(<ProfileScreen />);
    expect(getByTestId('edit-profile-btn')).toBeTruthy();
  });

  it('renders logout button', () => {
    const {getByTestId} = wrap(<ProfileScreen />);
    expect(getByTestId('logout-btn')).toBeTruthy();
  });

  it('shows user stats', () => {
    const {getByText} = wrap(<ProfileScreen />);
    expect(getByText('Features\nActive')).toBeTruthy();
  });
});
