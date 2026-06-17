const React = require('react');
module.exports = {
  createStackNavigator: () => ({
    Navigator: ({children}) => children,
    Screen: ({component: C, ...p}) => React.createElement(C, p),
  }),
};
