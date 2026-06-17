import React, {createContext, useContext, useEffect, useState} from 'react';
import {appStore, AppStateType} from './AppState';

const AppContext = createContext<AppStateType>(appStore.getState());

export function AppProvider({children}: {children: React.ReactNode}) {
  const [state, setState] = useState<AppStateType>(appStore.getState());
  useEffect(() => appStore.subscribe(() => setState({...appStore.getState()})), []);
  return <AppContext.Provider value={state}>{children}</AppContext.Provider>;
}

export const useAppState = () => useContext(AppContext);
