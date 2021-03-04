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
                    data={[
                        { x: "day 1", y: 39, val: 122 },
                        { x: "day 2", y: 23, val: 122 },
                        { x: "day 3", y: 75, val: 122 },
                        { x: "day 4", y: 84, val: 122 },
                        { x: "day 5", y: 84, val: 122 },
                        { x: "day 6", y: 84, val: 3 },
                        { x: "day 7", y: 84, val: 122 },
                        { x: "day 8", y: 84, val: 4 },
                        { x: "day 9", y: 84, val: 122 },
                        { x: "day 10", y: 84, val: 122 },
                        { x: "day 11", y: 32, val: 122 },
                        { x: "day 12", y: 84, val: 32 },
                        { x: "day 13", y: 32, val: 122 },
                        { x: "day 14", y: 84, val: 122 },
                        { x: "day 15", y: 2, val: 4 },
                        { x: "day 16", y: 84, val: 122 },
                        { x: "day 17", y: 1, val: 34 },
                        { x: "day 18", y: 32, val: 122 },
                        { x: "day 19", y: 1, val: 54 },
                        { x: "day 20", y: 1, val: 122 },
                        { x: "day 21", y: 84, val: 122 },
                        { x: "day 22", y: 84, val: 122 },
                        { x: "day 23", y: 43, val: 122 },
                        { x: "day 24", y: 84, val: 122 },
                        { x: "day 25", y: 4, val: 122 },
                        { x: "day 26", y: 84, val: 122 },
                        { x: "day 27", y: 84, val: 3 },
                        { x: "day 28", y: 84, val: 122 },
                        { x: "day 29", y: 5, val: 122 },
                        { x: "day 30", y: 84, val: 122 },
                        { x: "day 31", y: 6, val: 122 }
                    ]}
                />
                <BarSeries
                    id="c2"
                    name="test2"
                    stackAccessors={[0]}
                    data={[
                        { x: "day 1", y: 39, val: 122 },
                        { x: "day 2", y: 23, val: 122 },
                        { x: "day 3", y: 75, val: 122 },
                        { x: "day 4", y: 84, val: 122 },
                        { x: "day 5", y: 84, val: 122 },
                        { x: "day 6", y: 84, val: 3 },
                        { x: "day 7", y: 84, val: 122 },
                        { x: "day 8", y: 84, val: 4 },
                        { x: "day 9", y: 84, val: 122 },
                        { x: "day 10", y: 84, val: 122 },
                        { x: "day 11", y: 32, val: 122 },
                        { x: "day 12", y: 84, val: 32 },
                        { x: "day 13", y: 32, val: 122 },
                        { x: "day 14", y: 84, val: 122 },
                        { x: "day 15", y: 2, val: 4 },
                        { x: "day 16", y: 84, val: 122 },
                        { x: "day 17", y: 1, val: 34 },
                        { x: "day 18", y: 32, val: 122 },
                        { x: "day 19", y: 1, val: 54 },
                        { x: "day 20", y: 1, val: 122 },
                        { x: "day 21", y: 84, val: 122 },
                        { x: "day 22", y: 84, val: 122 },
                        { x: "day 23", y: 43, val: 122 },
                        { x: "day 24", y: 84, val: 122 },
                        { x: "day 25", y: 4, val: 122 },
                        { x: "day 26", y: 84, val: 122 },
                        { x: "day 27", y: 84, val: 3 },
                        { x: "day 28", y: 84, val: 122 },
                        { x: "day 29", y: 5, val: 122 },
                        { x: "day 30", y: 84, val: 122 },
                        { x: "day 31", y: 6, val: 122 }
                    ]}
                />
                <BarSeries
                    id="c3"
                    name="test3"
                    stackAccessors={[0]}
                    data={[
                        { x: "day 1", y: 39, val: 122 },
                        { x: "day 2", y: 23, val: 122 },
                        { x: "day 3", y: 75, val: 122 },
                        { x: "day 4", y: 84, val: 122 },
                        { x: "day 5", y: 84, val: 122 },
                        { x: "day 6", y: 84, val: 3 },
                        { x: "day 7", y: 84, val: 122 },
                        { x: "day 8", y: 84, val: 4 },
                        { x: "day 9", y: 84, val: 122 },
                        { x: "day 10", y: 84, val: 122 },
                        { x: "day 11", y: 32, val: 122 },
                        { x: "day 12", y: 84, val: 32 },
                        { x: "day 13", y: 32, val: 122 },
                        { x: "day 14", y: 84, val: 122 },
                        { x: "day 15", y: 2, val: 4 },
                        { x: "day 16", y: 84, val: 122 },
                        { x: "day 17", y: 1, val: 34 },
                        { x: "day 18", y: 32, val: 122 },
                        { x: "day 19", y: 1, val: 54 },
                        { x: "day 20", y: 1, val: 122 },
                        { x: "day 21", y: 84, val: 122 },
                        { x: "day 22", y: 84, val: 122 },
                        { x: "day 23", y: 43, val: 122 },
                        { x: "day 24", y: 84, val: 122 },
                        { x: "day 25", y: 4, val: 122 },
                        { x: "day 26", y: 84, val: 122 },
                        { x: "day 27", y: 84, val: 3 },
                        { x: "day 28", y: 84, val: 122 },
                        { x: "day 29", y: 5, val: 122 },
                        { x: "day 30", y: 84, val: 122 },
                        { x: "day 31", y: 6, val: 122 }
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
