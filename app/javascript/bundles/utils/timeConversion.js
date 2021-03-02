function timeConversion(milliseconds) {
    let seconds = (milliseconds / 1000);
    let minutes = (milliseconds / (1000 * 60));
    let hours = (milliseconds / (1000 * 60 * 60));
    let days = (milliseconds / (1000 * 60 * 60 * 24));

    if (seconds < 60) {
        return seconds + ' Sec';
    } else if (minutes < 60) {
        return minutes + ' Min';
    } else if (hours <= 24) {
        return hours + ' Hrs';
    } else {
        return days + " Days"
    }
}

export default timeConversion;
