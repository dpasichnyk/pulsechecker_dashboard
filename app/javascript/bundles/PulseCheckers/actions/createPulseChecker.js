import axios from "axios";

const createPulseChecker = (token, pulseChecker) => {
  return axios.post(`/pulsecheckers`,{
    authenticity_token: token,
    pulsechecker : pulseChecker
  })
};

export default createPulseChecker;
