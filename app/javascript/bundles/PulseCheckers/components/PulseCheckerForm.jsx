import React from 'react';
import { Field, Control, Input, Select } from 'react-bulma-components/lib/components/form';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import PropTypes from 'prop-types';
import timeConversion from '../../utils/timeConversion';

const PulseCheckerForm = (props) => {
  const {
    handleCancelEditPulseChecker,
    handleSavePulseChecker,
    handleChangePulseChecker,
    responseTimeValues,
    showCancelButton,
    intervalValues,
    kindValues,
    pulseChecker,
  } = props;

  const { url, name, kind, interval, responseTime, id } = pulseChecker;

  return (
    <tr className="form">
      <td>
        <Field>
          <Control>
            <Select onChange={e => handleChangePulseChecker(e, id)} name="kind" value={kind}>
              { kindValues.map(kindValue => (
                <option key={kindValue} value={kindValue}>{kindValue}</option>
              ))}
            </Select>
          </Control>
        </Field>
      </td>
      <td>
        <Field>
          <Control>
            <Input onChange={e => handleChangePulseChecker(e, id)} name="url" type="text" placeholder="Url" value={url} />
          </Control>
        </Field>
      </td>
      <td>
        <Field>
          <Control>
            <Input onChange={e => handleChangePulseChecker(e, id)} name="name" type="text" placeholder="Name" value={name} />
          </Control>
        </Field>
      </td>
      <td>
        <Field>
          <Control>
            <Select onChange={e => handleChangePulseChecker(e, id)} name="interval" value={interval}>
              {intervalValues.map(intervalValue => (
                <option key={intervalValue} value={intervalValue}>{timeConversion(intervalValue)}</option>
              ))}
            </Select>
          </Control>
        </Field>
      </td>
      <td>
        <Field>
          <Control>
            <Select onChange={e => handleChangePulseChecker(e, id)} name="responseTime" value={responseTime}>
              {responseTimeValues.map(responseTimeValue => (
                <option key={responseTimeValue} value={responseTimeValue}>{timeConversion(responseTimeValue)}</option>
              ))}
            </Select>
          </Control>
        </Field>
      </td>
      <td>
        <div className="buttons are-small">
          <button className="button is-info is-light" type="button" onClick={() => handleSavePulseChecker(id)}>
            <span className="icon is-small">
              <FontAwesomeIcon icon="save" />
            </span>
          </button>
          {showCancelButton
            ? (
              <button className="button is-danger is-light" type="button" onClick={() => handleCancelEditPulseChecker(id)}>
                <span className="icon is-small">
                  <FontAwesomeIcon icon="times-circle" />
                </span>
              </button>
            ) : ''}
        </div>
      </td>
    </tr>
  );
};

PulseCheckerForm.defaultProps = { handleCancelEditPulseChecker: null };

PulseCheckerForm.propTypes = {
  showCancelButton: PropTypes.bool.isRequired,
  pulseChecker: PropTypes.arrayOf(PropTypes.object).isRequired,
  intervalValues: PropTypes.arrayOf(PropTypes.number).isRequired,
  responseTimeValues: PropTypes.arrayOf(PropTypes.number).isRequired,
  handleSavePulseChecker: PropTypes.func.isRequired,
  handleChangePulseChecker: PropTypes.func.isRequired,
  handleCancelEditPulseChecker: PropTypes.func,
  kindValues: PropTypes.arrayOf(PropTypes.string).isRequired,
};

export default PulseCheckerForm;
