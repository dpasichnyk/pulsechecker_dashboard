function timeConversion(milliseconds) {
  const seconds = (milliseconds / 1000);
  const minutes = (milliseconds / (1000 * 60));
  const hours = (milliseconds / (1000 * 60 * 60));
  const days = (milliseconds / (1000 * 60 * 60 * 24));

  if (seconds < 60) {
    return `${seconds} Sec`;
  } if (minutes < 60) {
    return `${minutes} Min`;
  } if (hours <= 24) {
    return `${hours} Hrs`;
  }
  return `${days} Days`;
}

export default timeConversion;
