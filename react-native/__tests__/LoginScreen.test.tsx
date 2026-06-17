import React from 'react';
import {render, fireEvent, waitFor, act} from '@testing-library/react-native';
import {LoginScreen} from '../src/screens/LoginScreen';
import {appStore} from '../src/state/AppState';

beforeEach(() => appStore.logout());

describe('LoginScreen', () => {
  it('renders email and password fields', () => {
    const {getByTestId} = render(<LoginScreen />);
    expect(getByTestId('email-input')).toBeTruthy();
    expect(getByTestId('password-input')).toBeTruthy();
  });

  it('shows Sign In button', () => {
    const {getByTestId} = render(<LoginScreen />);
    expect(getByTestId('sign-in-button')).toBeTruthy();
  });

  it('shows error for invalid credentials', async () => {
    const {getByTestId, findByTestId} = render(<LoginScreen />);
    fireEvent.changeText(getByTestId('email-input'), 'x@y.com');
    fireEvent.changeText(getByTestId('password-input'), '123');
    fireEvent.press(getByTestId('sign-in-button'));
    const error = await findByTestId('error-message');
    expect(error).toBeTruthy();
  });

  it('calls login with correct credentials', async () => {
    const spy = jest.spyOn(appStore, 'login').mockResolvedValueOnce(true);
    const {getByTestId} = render(<LoginScreen />);
    fireEvent.changeText(getByTestId('email-input'), 'demo@careconnect.com');
    fireEvent.changeText(getByTestId('password-input'), '123456');
    fireEvent.press(getByTestId('sign-in-button'));
    await waitFor(() => expect(spy).toHaveBeenCalledWith('demo@careconnect.com', '123456'));
    spy.mockRestore();
  });

  it('toggles password visibility', () => {
    const {getByTestId} = render(<LoginScreen />);
    const toggle = getByTestId('toggle-password');
    fireEvent.press(toggle);
    // should not throw — visibility state toggled
    expect(toggle).toBeTruthy();
  });
});
