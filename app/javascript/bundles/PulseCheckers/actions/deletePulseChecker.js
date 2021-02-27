import axios from 'axios';

const deletePulseChecker = (id, token) => {
    return axios.delete(`/pulsecheckers/${id}`,{data: {
            authenticity_token: token
        }})
};

export default deletePulseChecker;
