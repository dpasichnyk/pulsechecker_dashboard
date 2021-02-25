import React from 'react';
import PropTypes from "prop-types";

const PulseChecker = (props) => {
    console.log((props))
    const {name, kind, interval, url } = props.pulsechecker
  return (
    <tr>
        <td>{url}</td>
        <td>{kind}</td>
        <td>{name}</td>
        <td>{interval}</td>
        <td>
            <span className="icon is-small"><i className="fas fa-trash"> </i></span>
        </td>
    </tr>
  );
};

PulseChecker.propTypes = {
    pulsechecker: PropTypes.object.isRequired,
};

export default PulseChecker;
