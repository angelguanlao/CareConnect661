const React = require('react');
module.exports = {
  createBottomTabNavigator: () => ({
    Navigator: ({children}) => children,
    Screen: ({component: C, ...p}) => React.createElement(C, p),
  }),
};
