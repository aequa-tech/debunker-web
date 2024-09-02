import React from 'react';
import ActionCable from 'actioncable';

const CableContext = React.createContext();

const CableProvider = ({ children }) => {
  const actionCableUrl = 'ws://debunker-web.isunder.review/cable';
  const CableApp = {};

  CableApp.cable = ActionCable.createConsumer(actionCableUrl);
  return(<CableContext.Provider value={CableApp}>{children}</CableContext.Provider>);
};

export { CableProvider, CableContext };
