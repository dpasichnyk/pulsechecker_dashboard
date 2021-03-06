import React from 'react';
import PropTypes from "prop-types";
import { Chart, BarSeries } from "@elastic/charts";

import '../style/pulsechecker.css';
import '@elastic/charts/dist/theme_light.css';

const UpTimeChat = (props) => {
    const { data } = props
    return (
        <div className="chart">
            <Chart size={[300, 40]}>
                <BarSeries
                    id="c1"
                    name="test"
                    stackAccessors={[0]}
                    color='#54cc44'
                    data={[
                        { x: "day 1", y: 33, val: 33 },
                        { x: "day 2", y: 33, val: 12 },
                        { x: "day 3", y: 33, val: 122 },
                        { x: "day 4", y: 33, val: 122 },
                        { x: "day 5", y: 33, val: 122 },
                        { x: "day 6", y: 33, val: 3 },
                        { x: "day 7", y: 33, val: 122 },
                        { x: "day 8", y: 33, val: 4 },
                        { x: "day 9", y: 33, val: 122 },
                        { x: "day 10", y: 33, val: 122 },
                        { x: "day 11", y: 33, val: 122 },
                        { x: "day 12", y: 33, val: 32 },
                        { x: "day 13", y: 33, val: 122 },
                        { x: "day 14", y: 33, val: 122 },
                        { x: "day 15", y: 33, val: 4 },
                        { x: "day 16", y: 33, val: 122 },
                        { x: "day 17", y: 33, val: 34 },
                        { x: "day 18", y: 33, val: 122 },
                        { x: "day 19", y: 33, val: 54 },
                        { x: "day 20", y: 33, val: 122 },
                        { x: "day 21", y: 33, val: 122 },
                        { x: "day 22", y: 33, val: 122 },
                        { x: "day 23", y: 33, val: 122 },
                        { x: "day 24", y: 33, val: 122 },
                        { x: "day 25", y: 33, val: 122 },
                        { x: "day 26", y: 33, val: 122 },
                        { x: "day 27", y: 33, val: 3 },
                        { x: "day 28", y: 33, val: 122 },
                        { x: "day 29", y: 33, val: 122 },
                        { x: "day 30", y: 33, val: 122 },
                        { x: "day 31", y: 33, val: 122 }
                    ]}
                />
                <BarSeries
                    id="c2"
                    name="test2"
                    stackAccessors={[0]}
                    color='red'
                    data={[
                        { x: "day 1", y: 33, val: 33 },
                        { x: "day 2", y: 33, val: 12 },
                        { x: "day 3", y: 33, val: 122 },
                        { x: "day 4", y: 33, val: 122 },
                        { x: "day 5", y: 33, val: 122 },
                        { x: "day 6", y: 33, val: 3 },
                        { x: "day 7", y: 33, val: 122 },
                        { x: "day 8", y: 33, val: 4 },
                        { x: "day 9", y: 33, val: 122 },
                        { x: "day 10", y: 33, val: 122 },
                        { x: "day 11", y: 33, val: 122 },
                        { x: "day 12", y: 33, val: 32 },
                        { x: "day 13", y: 33, val: 122 },
                        { x: "day 14", y: 33, val: 122 },
                        { x: "day 15", y: 33, val: 4 },
                        { x: "day 16", y: 33, val: 122 },
                        { x: "day 17", y: 33, val: 34 },
                        { x: "day 18", y: 33, val: 122 },
                        { x: "day 19", y: 33, val: 54 },
                        { x: "day 20", y: 33, val: 122 },
                        { x: "day 21", y: 33, val: 122 },
                        { x: "day 22", y: 33, val: 122 },
                        { x: "day 23", y: 33, val: 122 },
                        { x: "day 24", y: 33, val: 122 },
                        { x: "day 25", y: 33, val: 122 },
                        { x: "day 26", y: 33, val: 122 },
                        { x: "day 27", y: 33, val: 3 },
                        { x: "day 28", y: 33, val: 122 },
                        { x: "day 29", y: 33, val: 122 },
                        { x: "day 30", y: 33, val: 122 },
                        { x: "day 31", y: 33, val: 122 }
                    ]}
                />
            </Chart>
        </div>
    );
};

UpTimeChat.propTypes = {
    data: PropTypes.array.isRequired,
};

export default UpTimeChat;
