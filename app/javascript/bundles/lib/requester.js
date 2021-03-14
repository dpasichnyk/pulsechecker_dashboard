import axios from 'axios';

const requester = () => {
  axios.defaults.headers.common['Key-Inflection'] = 'camel';
  return axios;
};

export default requester();
