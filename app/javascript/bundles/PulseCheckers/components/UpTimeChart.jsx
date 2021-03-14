import React from 'react';
import PropTypes from 'prop-types';
import { Chart, BarSeries } from '@elastic/charts';

import '../style/pulsechecker.css';
import '@elastic/charts/dist/theme_light.css';

const UpTimeChart = (props) => {
  const { data } = props;

  return (
    <div className="chart">
      <Chart size={[300, 40]}>
        <BarSeries
          id="c1"
          name="test"
          stackAccessors={[0]}
          color="#54cc44"
          data={data}
        />
        <BarSeries
          id="c2"
          name="test2"
          stackAccessors={[0]}
          color="red"
          data={data}
        />
      </Chart>
    </div>
  );
};

UpTimeChart.propTypes = { data: PropTypes.shape([]).isRequired };

export default UpTimeChart;
