import noUiSlider from 'nouislider';
import wNumb from 'wnumb';

document.addEventListener('DOMContentLoaded', () => {
    let slider = document.getElementById('slider');
    let sliderLabel = document.getElementById('slider-label');
    let intervalField = document.getElementById('interval-field');
    let range = [10000, 20000, 30000, 40000, 50000, 60000, 120000, 180000,
        240000, 300000, 360000, 420000, 480000, 540000, 600000, 720000,
        780000, 840000, 900000, 960000, 1020000, 1080000, 1140000, 1200000,
        1260000, 1320000, 1380000, 1440000, 1500000, 1560000, 1620000, 1680000,
        1740000, 1800000, 1860000, 1920000, 1980000, 2040000, 2100000, 2160000,
        2220000, 2280000, 2340000, 2400000, 2460000, 2520000, 2580000, 2640000,
        2700000, 2760000, 2820000, 2880000, 2940000, 3000000, 3060000,
        3120000, 3180000, 3240000, 3300000, 3360000, 3420000, 3480000,
        3540000, 3600000, 7200000, 10800000, 14400000, 18000000, 21600000,
        25200000, 28800000, 32400000, 36000000, 39600000, 43200000, 46800000,
        50400000, 54000000, 57600000, 61200000, 64800000, 68400000, 72000000,
        75600000, 79200000, 82800000, 86400000]

    function checkInterval(value) {
        return value >= intervalField.value;
    }

    noUiSlider.create(slider, {

        start: range.findIndex(checkInterval),
        step: 1,
        // tooltips: [wNumb({
        //     decimals: 0,
        //     edit: function( value ) {
        //         return '<div class="more-tooltip-html">' + timeConversion(range[value]) + '</div>';
        //     }
        // })],
        format: wNumb({
            decimals: 0
        }),
        range: {
            min: 0,
            max: range.length - 1
        }
    });

    slider.noUiSlider.on('update', function (values, handle) {
        let value = range[values[handle]]
        sliderLabel.innerHTML = 'Each ' + timeConversion(value);
        intervalField.value = value
    });

    function timeConversion(milliseconds) {
        let seconds = (milliseconds / 1000);
        let minutes = (milliseconds / (1000 * 60));
        let hours = (milliseconds / (1000 * 60 * 60));
        // let days = (milliseconds / (1000 * 60 * 60 * 24));

        if (seconds < 60) {
            return seconds + ' Sec';
        } else if (minutes < 60) {
            return minutes + ' Min';
        } else if (hours <= 24) {
            return hours + ' Hrs';
        } else {
            // return days + " Days"
        }
    }
});
