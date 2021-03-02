import axios from "axios";

const updatePulseChecker = (token, pulseChecker) => {
    return axios.put(`/pulsecheckers/${pulseChecker.id}`,{
        authenticity_token: token,
        pulsechecker : pulseChecker
    })
};

export default updatePulseChecker;
