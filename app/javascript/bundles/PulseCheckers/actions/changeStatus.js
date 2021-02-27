import axios from "axios";

const changeStatus = (id, token) => {
    return axios.put(`/pulsecheckers/${id}/change_status`,{
            authenticity_token: token
        })
};

export default changeStatus;
