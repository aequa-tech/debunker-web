import React from 'react';
import App from './src/components/App';
import { CableProvider } from './src/context/cable';
import './src/assets/stylesheets/style.css';

const DebunkerReactApp = () => {
  return (
    <CableProvider>
      <App />
    </CableProvider>
  );
}

export default DebunkerReactApp;
