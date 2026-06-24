import React from 'react';
import {NavigationContainer} from '@react-navigation/native';
import {createStackNavigator} from '@react-navigation/stack';
import {createBottomTabNavigator} from '@react-navigation/bottom-tabs';
import {Text} from 'react-native';
import {useAppState} from './state/AppContext';
import {LoginScreen} from './screens/LoginScreen';
import {OnboardingScreen} from './screens/OnboardingScreen';
import {HomeScreen} from './screens/HomeScreen';
import {FeaturesScreen} from './screens/FeaturesScreen';
import {FeatureDetailScreen} from './screens/FeatureDetailScreen';
import {NotificationsScreen} from './screens/NotificationsScreen';
import {ProfileScreen} from './screens/ProfileScreen';
import {EditProfileScreen} from './screens/EditProfileScreen';
import {SettingsScreen} from './screens/SettingsScreen';
import {Colors} from './theme/Theme';
import {appStore} from './state/AppState';

const Stack = createStackNavigator();
const Tab = createBottomTabNavigator();

function FeaturesStack() {
  return (
    <Stack.Navigator>
      <Stack.Screen name="FeaturesList" component={FeaturesScreen} options={{title: 'Accessibility Features'}} />
      <Stack.Screen name="FeatureDetail" component={FeatureDetailScreen} options={({route}: any) => ({title: route.params?.featureId ?? 'Feature'})} />
    </Stack.Navigator>
  );
}

function ProfileStack() {
  return (
    <Stack.Navigator>
      <Stack.Screen name="Profile" component={ProfileScreen} options={{title: 'Profile'}} />
      <Stack.Screen name="EditProfile" component={EditProfileScreen} options={{title: 'Edit Profile'}} />
    </Stack.Navigator>
  );
}

function SettingsStack() {
  return (
    <Stack.Navigator>
      <Stack.Screen name="Settings" component={SettingsScreen} options={{title: 'Settings'}} />
      <Stack.Screen name="Profile" component={ProfileScreen} options={{title: 'Profile'}} />
      <Stack.Screen name="EditProfile" component={EditProfileScreen} options={{title: 'Edit Profile'}} />
    </Stack.Navigator>
  );
}

function MainTabs() {
  const state = useAppState();
  const unread = appStore.unreadCount;
  return (
    <Tab.Navigator
      screenOptions={{tabBarActiveTintColor: Colors.primary}}
      initialRouteName="HomeTab">
      <Tab.Screen name="HomeTab" component={HomeScreen} options={{title: 'Home', tabBarLabel: 'Home', tabBarAccessibilityLabel: 'Home tab', tabBarIcon: () => <Text importantForAccessibility="no" accessibilityElementsHidden>🏠</Text>}} />
      <Tab.Screen name="FeaturesTab" component={FeaturesStack} options={{title: 'Features', headerShown: false, tabBarLabel: 'Features', tabBarAccessibilityLabel: 'Features tab', tabBarIcon: () => <Text importantForAccessibility="no" accessibilityElementsHidden>♿</Text>}} />
      <Tab.Screen name="AlertsTab" component={NotificationsScreen} options={{title: 'Alerts', tabBarLabel: 'Alerts', tabBarAccessibilityLabel: unread > 0 ? `Alerts tab, ${unread} unread` : 'Alerts tab', tabBarBadge: unread > 0 ? unread : undefined, tabBarIcon: () => <Text importantForAccessibility="no" accessibilityElementsHidden>🔔</Text>}} />
      <Tab.Screen name="SettingsTab" component={SettingsStack} options={{title: 'Settings', headerShown: false, tabBarLabel: 'Settings', tabBarAccessibilityLabel: 'Settings tab', tabBarIcon: () => <Text importantForAccessibility="no" accessibilityElementsHidden>⚙️</Text>}} />
    </Tab.Navigator>
  );
}

export function AppNavigator() {
  const state = useAppState();
  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{headerShown: false}}>
        {!state.isLoggedIn ? (
          <Stack.Screen name="Login" component={LoginScreen} options={{headerShown: true, title: ''}} />
        ) : !state.isOnboarded ? (
          <Stack.Screen name="Onboarding" component={OnboardingScreen} options={{headerShown: true, title: 'Get Started'}} />
        ) : (
          <Stack.Screen name="Main" component={MainTabs} />
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
}

export default AppNavigator;
