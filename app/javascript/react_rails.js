import React from 'react';
import ReactDOM from 'react-dom/client';
import DebunkerReactApp from './debunker_react_app'

const mountComponent = (component, componentName) => {
  const nodes = Array.from(
    document.getElementsByClassName(`react-${componentName}`)
  );

  nodes.forEach((node) => {
    const data = node.getAttribute("data");
    const props = data && data.length > 2 ? JSON.parse(data) : {};
    const el = React.createElement(component, { ...props }, []);
    node.innerHTML = ''

    const root = ReactDOM.createRoot(node);
    root.render(el);
  });
};

document.addEventListener("turbo:load", () => {
  mountComponent(DebunkerReactApp, "debunker-react-app");
})
