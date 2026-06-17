export interface User {
  id: string;
  name: string;
  email: string;
  joinDate: Date;
  bloodGroup?: string;
  allergies?: string;
}

export interface Notification {
  id: string;
  title: string;
  body: string;
  timestamp: Date;
  isRead: boolean;
}

export interface AppStateType {
  isLoggedIn: boolean;
  isOnboarded: boolean;
  currentUser: User | null;
  highContrast: boolean;
  leftHandMode: boolean;
  textScaleFactor: number;
  largeTargets: boolean;
  enabledFeatures: Set<string>;
  notifications: Notification[];
}

const DEFAULT_STATE: AppStateType = {
  isLoggedIn: false,
  isOnboarded: false,
  currentUser: null,
  highContrast: false,
  leftHandMode: true,
  textScaleFactor: 1.0,
  largeTargets: true,
  enabledFeatures: new Set(['left-nav', 'large-targets']),
  notifications: [],
};

type Listener = () => void;

class AppStore {
  private state: AppStateType = {...DEFAULT_STATE, enabledFeatures: new Set(['left-nav', 'large-targets'])};
  private listeners: Set<Listener> = new Set();

  getState(): AppStateType {
    return this.state;
  }

  subscribe(listener: Listener): () => void {
    this.listeners.add(listener);
    return () => this.listeners.delete(listener);
  }

  private notify() {
    this.listeners.forEach(l => l());
  }

  async login(email: string, password: string): Promise<boolean> {
    await new Promise(r => setTimeout(r, 700));
    if (email.trim().length > 0 && password.length >= 6) {
      this.state = {
        ...this.state,
        isLoggedIn: true,
        currentUser: {
          id: '1',
          name: 'Alex Johnson',
          email: email.trim(),
          joinDate: new Date(2024, 0, 15),
          bloodGroup: 'B+',
          allergies: 'Penicillin, seafood',
        },
        notifications: [
          {id: '1', title: 'Accessibility Tip', body: 'Try enabling high-contrast mode for better visibility.', timestamp: new Date(Date.now() - 3600000), isRead: false},
          {id: '2', title: 'New Feature Available', body: 'Voice Input Assistance is now available.', timestamp: new Date(Date.now() - 10800000), isRead: false},
          {id: '3', title: 'Weekly Reminder', body: 'Review your accessibility preferences.', timestamp: new Date(Date.now() - 86400000), isRead: true},
        ],
      };
      this.notify();
      return true;
    }
    return false;
  }

  logout() {
    this.state = {...DEFAULT_STATE, enabledFeatures: new Set(['left-nav', 'large-targets'])};
    this.notify();
  }

  completeOnboarding(prefs: {leftHand: boolean; highContrast: boolean; largeTargets: boolean; textScale: number}) {
    this.state = {
      ...this.state,
      isOnboarded: true,
      leftHandMode: prefs.leftHand,
      highContrast: prefs.highContrast,
      largeTargets: prefs.largeTargets,
      textScaleFactor: prefs.textScale,
    };
    this.notify();
  }

  setHighContrast(v: boolean) { this.state = {...this.state, highContrast: v}; this.notify(); }
  setLeftHandMode(v: boolean) { this.state = {...this.state, leftHandMode: v}; this.notify(); }
  setTextScaleFactor(v: number) { this.state = {...this.state, textScaleFactor: v}; this.notify(); }
  setLargeTargets(v: boolean) { this.state = {...this.state, largeTargets: v}; this.notify(); }

  toggleFeature(id: string) {
    const next = new Set(this.state.enabledFeatures);
    if (next.has(id)) { next.delete(id); } else { next.add(id); }
    this.state = {...this.state, enabledFeatures: next};
    this.notify();
  }

  isFeatureEnabled(id: string): boolean {
    return this.state.enabledFeatures.has(id);
  }

  markRead(id: string) {
    this.state = {
      ...this.state,
      notifications: this.state.notifications.map(n => n.id === id ? {...n, isRead: true} : n),
    };
    this.notify();
  }

  markAllRead() {
    this.state = {
      ...this.state,
      notifications: this.state.notifications.map(n => ({...n, isRead: true})),
    };
    this.notify();
  }

  get unreadCount(): number {
    return this.state.notifications.filter(n => !n.isRead).length;
  }

  updateProfile(name: string, email: string) {
    if (this.state.currentUser) {
      this.state = {...this.state, currentUser: {...this.state.currentUser, name, email}};
      this.notify();
    }
  }
}

export const appStore = new AppStore();
