import React from 'react';
import PropTypes from 'prop-types';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import timeConversion from '../../utils/timeConversion';
import UpTimeChart from './UpTimeChart';

import '../style/pulsechecker.css';

const PulseChecker = (props) => {
  const { pulsechecker, handleRemove, handleChangeStatus, handleEdit } = props;
  const { id, name, kind, interval, url, active, responseTime } = pulsechecker;

  const mockedData = [
    { x: 'day 1', y: 33, val: 33 },
    { x: 'day 2', y: 33, val: 12 },
    { x: 'day 3', y: 33, val: 122 },
    { x: 'day 4', y: 33, val: 122 },
    { x: 'day 5', y: 33, val: 122 },
    { x: 'day 6', y: 33, val: 3 },
    { x: 'day 7', y: 33, val: 122 },
    { x: 'day 8', y: 33, val: 4 },
    { x: 'day 9', y: 33, val: 122 },
    { x: 'day 10', y: 33, val: 122 },
    { x: 'day 11', y: 33, val: 122 },
    { x: 'day 12', y: 33, val: 32 },
    { x: 'day 13', y: 33, val: 122 },
    { x: 'day 14', y: 33, val: 122 },
    { x: 'day 15', y: 33, val: 4 },
    { x: 'day 16', y: 33, val: 122 },
    { x: 'day 17', y: 33, val: 34 },
    { x: 'day 18', y: 33, val: 122 },
    { x: 'day 19', y: 33, val: 54 },
    { x: 'day 20', y: 33, val: 122 },
    { x: 'day 21', y: 33, val: 122 },
    { x: 'day 22', y: 33, val: 122 },
    { x: 'day 23', y: 33, val: 122 },
    { x: 'day 24', y: 33, val: 122 },
    { x: 'day 25', y: 33, val: 122 },
    { x: 'day 26', y: 33, val: 122 },
    { x: 'day 27', y: 33, val: 3 },
    { x: 'day 28', y: 33, val: 122 },
    { x: 'day 29', y: 33, val: 122 },
    { x: 'day 30', y: 33, val: 122 },
    { x: 'day 31', y: 33, val: 122 },
  ];

  return (
    <tr className={active ? 'pulsechecker' : 'pulsechecker inactive'}>
      <td>{kind}</td>
      <td>{url}</td>
      <td>{name}</td>
      <td>{timeConversion(interval)}</td>
      <td>{timeConversion(responseTime)}</td>
      <td><UpTimeChart data={mockedData} /></td>
      <td>
        <div className="buttons are-small">
          <button className="button is-primary is-light" type="button" onClick={() => handleChangeStatus(id)}>
            <span className="icon is-small">
              <FontAwesomeIcon icon={active ? 'toggle-on' : 'toggle-off'} />
            </span>
          </button>
          <button className="button is-info is-light" type="button">
            <span className="icon is-small">
              <FontAwesomeIcon icon="eye" />
            </span>
          </button>
          <button className="button is-primary is-light" type="button" onClick={() => handleEdit(id)}>
            <span className="icon is-small">
              <FontAwesomeIcon icon="edit" />
            </span>
          </button>
          <button className="button is-danger is-light" type="button" onClick={() => handleRemove(id)}>
            <span className="icon is-small">
              <FontAwesomeIcon icon="trash" />
            </span>
          </button>
        </div>
      </td>
    </tr>
  );
};

PulseChecker.propTypes = {
  pulsechecker: PropTypes.oneOfType([PropTypes.object]).isRequired,
  handleRemove: PropTypes.func.isRequired,
  handleEdit: PropTypes.func.isRequired,
  handleChangeStatus: PropTypes.func.isRequired,
};

export default PulseChecker;
