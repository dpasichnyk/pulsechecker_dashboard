import requester from '../../lib/requester';

const createPulseChecker = (token, pulseChecker) => requester.post('/pulsecheckers', {
  authenticityToken: token,
  pulsechecker: pulseChecker,
});

export default createPulseChecker;
