// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// --- start JS ---
import Rails from '@rails/ujs';
import * as ActiveStorage from '@rails/activestorage';
import '../channels';
import '@fortawesome/fontawesome-free/js/all';
import './src/index';

// --- start stylesheets ---
import '../stylesheets/application.scss';

Rails.start();
ActiveStorage.start();
// --- end JS ---

require.context('../images', true);
// --- end stylesheets ---
