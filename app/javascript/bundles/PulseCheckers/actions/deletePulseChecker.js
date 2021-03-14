import requester from '../../lib/requester';

const deletePulseChecker = (id, token) => requester.delete(`/pulsecheckers/${id}`, { data: { authenticityToken: token } });

export default deletePulseChecker;
