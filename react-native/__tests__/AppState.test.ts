import {appStore} from '../src/state/AppState';

describe('AppStore – authentication', () => {
  beforeEach(() => appStore.logout());

  it('starts logged out and not onboarded', () => {
    const s = appStore.getState();
    expect(s.isLoggedIn).toBe(false);
    expect(s.isOnboarded).toBe(false);
    expect(s.currentUser).toBeNull();
  });

  it('login returns true and sets user for valid credentials', async () => {
    const ok = await appStore.login('demo@careconnect.com', '123456');
    expect(ok).toBe(true);
    const s = appStore.getState();
    expect(s.isLoggedIn).toBe(true);
    expect(s.currentUser).not.toBeNull();
    expect(s.currentUser?.name).toBe('Alex Johnson');
  });

  it('login returns false for short password', async () => {
    const ok = await appStore.login('demo@careconnect.com', '123');
    expect(ok).toBe(false);
    expect(appStore.getState().isLoggedIn).toBe(false);
  });

  it('login returns false for empty email', async () => {
    const ok = await appStore.login('', '123456');
    expect(ok).toBe(false);
  });

  it('login seeds sample notifications', async () => {
    await appStore.login('demo@careconnect.com', '123456');
    expect(appStore.getState().notifications.length).toBe(3);
    expect(appStore.unreadCount).toBe(2);
  });

  it('logout resets all state', async () => {
    await appStore.login('demo@careconnect.com', '123456');
    appStore.logout();
    const s = appStore.getState();
    expect(s.isLoggedIn).toBe(false);
    expect(s.currentUser).toBeNull();
    expect(s.notifications.length).toBe(0);
  });
});

describe('AppStore – onboarding', () => {
  it('completeOnboarding stores all preferences', () => {
    appStore.completeOnboarding({leftHand: false, highContrast: true, largeTargets: false, textScale: 1.5});
    const s = appStore.getState();
    expect(s.isOnboarded).toBe(true);
    expect(s.leftHandMode).toBe(false);
    expect(s.highContrast).toBe(true);
    expect(s.largeTargets).toBe(false);
    expect(s.textScaleFactor).toBe(1.5);
  });
});

describe('AppStore – accessibility settings', () => {
  it('toggles high contrast and notifies listeners', () => {
    const cb = jest.fn();
    const unsub = appStore.subscribe(cb);
    appStore.setHighContrast(true);
    expect(appStore.getState().highContrast).toBe(true);
    expect(cb).toHaveBeenCalled();
    unsub();
  });

  it('updates left hand mode', () => {
    appStore.setLeftHandMode(false);
    expect(appStore.getState().leftHandMode).toBe(false);
  });

  it('updates text scale factor', () => {
    appStore.setTextScaleFactor(1.8);
    expect(appStore.getState().textScaleFactor).toBe(1.8);
  });

  it('updates large targets', () => {
    appStore.setLargeTargets(false);
    expect(appStore.getState().largeTargets).toBe(false);
  });
});

describe('AppStore – features', () => {
  beforeEach(() => appStore.logout());

  it('has left-nav and large-targets enabled by default', () => {
    expect(appStore.isFeatureEnabled('left-nav')).toBe(true);
    expect(appStore.isFeatureEnabled('large-targets')).toBe(true);
  });

  it('toggleFeature enables disabled features', () => {
    appStore.toggleFeature('high-contrast');
    expect(appStore.isFeatureEnabled('high-contrast')).toBe(true);
  });

  it('toggleFeature disables already-enabled features', () => {
    appStore.toggleFeature('left-nav');
    expect(appStore.isFeatureEnabled('left-nav')).toBe(false);
  });
});

describe('AppStore – notifications', () => {
  beforeEach(async () => {
    appStore.logout();
    await appStore.login('a@b.com', '123456');
  });

  it('markRead marks a single notification read', () => {
    appStore.markRead('1');
    const note = appStore.getState().notifications.find(n => n.id === '1');
    expect(note?.isRead).toBe(true);
    expect(appStore.unreadCount).toBe(1);
  });

  it('markAllRead clears all unread', () => {
    appStore.markAllRead();
    expect(appStore.unreadCount).toBe(0);
  });
});

describe('AppStore – profile update', () => {
  beforeEach(async () => {
    appStore.logout();
    await appStore.login('a@b.com', '123456');
  });

  it('updateProfile changes user name and email', () => {
    appStore.updateProfile('Jane Doe', 'jane@example.com');
    const user = appStore.getState().currentUser;
    expect(user?.name).toBe('Jane Doe');
    expect(user?.email).toBe('jane@example.com');
  });

  it('updateProfile is a no-op when not logged in', () => {
    appStore.logout();
    appStore.updateProfile('Ghost', 'ghost@example.com');
    expect(appStore.getState().currentUser).toBeNull();
  });
});
