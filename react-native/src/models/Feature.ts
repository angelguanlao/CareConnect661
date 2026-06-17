export interface Feature {
  id: string;
  title: string;
  shortDescription: string;
  fullDescription: string;
  category: string;
  steps: string[];
}

export const ALL_FEATURES: Feature[] = [
  {id: 'left-nav', title: 'Left-Hand Navigation', shortDescription: 'Moves primary controls to the left edge.', fullDescription: 'Repositions all primary navigation controls to the left edge of the screen.', category: 'Navigation', steps: ['Open Settings', 'Toggle Left-Hand Mode', 'Controls shift to left edge']},
  {id: 'large-targets', title: 'Large Touch Targets', shortDescription: 'Enlarges all interactive elements beyond 48dp.', fullDescription: 'Expands buttons and tap areas to 60×60dp.', category: 'Motor Accessibility', steps: ['Go to Settings', 'Enable Large Touch Targets', 'Buttons expand']},
  {id: 'high-contrast', title: 'High Contrast Mode', shortDescription: 'Dark theme with 7:1 contrast ratios.', fullDescription: 'Applies a high-contrast dark theme exceeding WCAG AA.', category: 'Visual', steps: ['Navigate to Settings', 'Toggle High Contrast', 'Theme switches immediately']},
  {id: 'text-scaling', title: 'Dynamic Text Scaling', shortDescription: 'Adjusts text size without breaking layouts.', fullDescription: 'Sets a custom text scale factor. All layouts adapt gracefully.', category: 'Visual', steps: ['Open Settings', 'Use Text Size slider', 'Layouts update live']},
  {id: 'voice-input', title: 'Voice Input Assistance', shortDescription: 'Enables hands-free text entry.', fullDescription: 'Integrates with device speech recognition for hands-free input.', category: 'Motor Accessibility', steps: ['Grant microphone permission', 'Tap mic icon in any text field', 'Speak clearly']},
  {id: 'simple-nav', title: 'Simplified Navigation', shortDescription: 'Reduces menu depth to two levels.', fullDescription: 'Restructures navigation so every destination is reachable within two taps.', category: 'Navigation', steps: ['Simplified navigation is active by default', 'Common destinations in bottom nav']},
];
