import requester from '../../lib/requester';

const changeStatus = (id, token) => requester.put(`/pulsecheckers/${id}/change_status`, { authenticityToken: token });

export default changeStatus;
