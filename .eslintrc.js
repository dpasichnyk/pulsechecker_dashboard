module.exports = {
  parser: './node_modules/@babel/eslint-parser',
  env: {
    browser: true,
    es2021: true,
  },
  extends: [
    'plugin:react/recommended',
    'airbnb',
  ],
  parserOptions: {
    ecmaFeatures: { jsx: true },
    ecmaVersion: 12,
    sourceType: 'module',
  },
  plugins: [
    'react',
  ],
  rules: {
    // Place to specify ESLint rules. Can be used to overwrite rules specified from the extended configs
    // e.g. '@typescript-eslint/explicit-function-return-type': 'off',
    'no-restricted-syntax': ['error', 'WithStatement'],
    'class-methods-use-this': 'off',
    'arrow-body-style': ['error', 'as-needed'],
    'arrow-parens': ['error', 'as-needed', { requireForBlockBody: true }],
    'no-param-reassign': ['error', { props: false }],
    'object-curly-newline': [
      'error', { ObjectExpression: { multiline: true, minProperties: 6 } },
    ],
    'max-len': ['error', { code: 170 }],
  },
};
