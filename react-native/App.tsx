import React from 'react';
import {AppProvider} from './src/state/AppContext';
import {AppNavigator} from './src/AppNavigator';

function App(): React.JSX.Element {
  return (
    <AppProvider>
      <AppNavigator />
    </AppProvider>
  );
}

export default App;
