import React from 'react';
import PropTypes from "prop-types";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import timeConversion from '../../utils/timeConversion'

import '../style/pulsechecker.css';

const PulseChecker = (props) => {
    const { id, name, kind, interval, url, active, response_time } = props.pulsechecker
    const { handleRemove, handleChangeStatus, handleEdit } = props
  return (
    <tr className={active ? 'pulsechecker' : 'pulsechecker inactive'}>
        <td>{kind}</td>
        <td>{url}</td>
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
                    <span className="icon is-small">
                        <FontAwesomeIcon icon='eye' />
                    </span>
                </button>
                <button className='button is-primary is-light' onClick={() => handleEdit(id)}>
                    <span className="icon is-small">
                        <FontAwesomeIcon icon='edit' />
                    </span>
                </button>
                <button className='button is-danger is-light' onClick={() => handleRemove(id)}>
                    <span className="icon is-small">
                        <FontAwesomeIcon icon='trash' />
                    </span>
                </button>
            </div>
        </td>
    </tr>
  );
};

PulseChecker.propTypes = {
    pulsechecker: PropTypes.object.isRequired,
    handleRemove: PropTypes.func.isRequired,
    handleEdit: PropTypes.func.isRequired,
    handleChangeStatus: PropTypes.func.isRequired,
};

export default PulseChecker;
