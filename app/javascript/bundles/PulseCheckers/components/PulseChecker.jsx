import React from 'react';
import PropTypes from "prop-types";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'

import '../style/pulsechecker.css';

const PulseChecker = (props) => {
    const { id, name, kind, interval, url, active, response_time } = props.pulsechecker
    const { handleRemove, handleChangeStatus, handleChange } = props
  return (
    <tr className={active ? 'pulsechecker active' : 'pulsechecker'}>
        <td>{url}</td>
        <td>{kind}</td>
        <td>{name}</td>
        <td>{timeConversion(interval)}</td>
        <td>{timeConversion(response_time)}</td>
        <td>
            <div className="buttons are-small">
                <button className='button is-primary is-light' onClick={() => handleChangeStatus(id)}>
                    <span className="icon is-small">
                        <FontAwesomeIcon icon={ active ? 'toggle-on' : 'toggle-off'  } />
                    </span>
                </button>
                <button className='button is-info is-light'>
                    <span className="icon is-small"><i className="far fa-eye"> </i></span>
                </button>
                <button className='button is-primary is-light' onClick={() => handleChange(id)}>
                    <span className="icon is-small"><i className="fas fa-edit"> </i></span>
                </button>
                <button className='button is-danger is-light' onClick={() => handleRemove(id)}>
                    <span className="icon is-small"><i className="fas fa-trash"> </i></span>
                </button>
            </div>
        </td>
    </tr>
  );
};

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

PulseChecker.propTypes = {
    pulsechecker: PropTypes.object.isRequired,
    handleChange: PropTypes.func.isRequired,
    handleRemove: PropTypes.func.isRequired,
    handleChangeStatus: PropTypes.func.isRequired,
};

export default PulseChecker;
