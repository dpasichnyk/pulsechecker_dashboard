import requester from '../../lib/requester';

const updatePulseChecker = (token, pulseChecker) => requester.put(`/pulsecheckers/${pulseChecker.id}`, {
  authenticityToken: token,
  pulsechecker: pulseChecker,
});

export default updatePulseChecker;
