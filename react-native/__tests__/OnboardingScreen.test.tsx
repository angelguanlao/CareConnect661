import React from 'react';
import {render, fireEvent} from '@testing-library/react-native';
import {OnboardingScreen} from '../src/screens/OnboardingScreen';
import {appStore} from '../src/state/AppState';

beforeEach(() => appStore.logout());

describe('OnboardingScreen', () => {
  it('renders step 1 by default', () => {
    const {getByText} = render(<OnboardingScreen />);
    expect(getByText('Step 1 of 3')).toBeTruthy();
    expect(getByText('Which hand do you mainly use?')).toBeTruthy();
  });

  it('advances to step 2 on Next', () => {
    const {getByTestId, getByText} = render(<OnboardingScreen />);
    fireEvent.press(getByTestId('next-button'));
    expect(getByText('Step 2 of 3')).toBeTruthy();
  });

  it('goes back to step 1 from step 2', () => {
    const {getByTestId, getByText} = render(<OnboardingScreen />);
    fireEvent.press(getByTestId('next-button'));
    fireEvent.press(getByTestId('back-button'));
    expect(getByText('Step 1 of 3')).toBeTruthy();
  });

  it('selects right-hand option', () => {
    const {getByTestId} = render(<OnboardingScreen />);
    fireEvent.press(getByTestId('right-hand-option'));
    expect(getByTestId('right-hand-option')).toBeTruthy();
  });

  it('calls completeOnboarding on Get Started', () => {
    const spy = jest.spyOn(appStore, 'completeOnboarding');
    const {getByTestId} = render(<OnboardingScreen />);
    fireEvent.press(getByTestId('next-button'));
    fireEvent.press(getByTestId('next-button'));
    fireEvent.press(getByTestId('next-button'));
    expect(spy).toHaveBeenCalled();
    spy.mockRestore();
  });
});
