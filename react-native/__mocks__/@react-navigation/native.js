const React = require('react');
module.exports = {
  NavigationContainer: ({children}) => children,
  useNavigation: () => ({navigate: jest.fn(), goBack: jest.fn(), push: jest.fn()}),
  useRoute: () => ({params: {featureId: 'left-nav'}}),
  useFocusEffect: jest.fn(),
};
