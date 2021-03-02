import React  from 'react';
import {
    Field,
    Control,
    Input,
    Select
} from 'react-bulma-components/lib/components/form';
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import timeConversion from '../../utils/timeConversion'
import PropTypes from "prop-types";

const PulseCheckerForm = (props) => {
    const { url, name, kind, interval, response_time, id } = props.pulseChecker
    const {
        handleCancelEditPulseChecker,
        handleSavePulseChecker,
        handleChangePulseChecker,
        responseTimeValues,
        showCancelButton,
        intervalValues,
        kindValues
    } = props
    return (
        <tr className='form'>
            <td>
                <Field>
                    <Control>
                        <Select onChange={(e) => handleChangePulseChecker(e, id)} name="kind" value={kind}>
                            {kindValues.map(kind => (
                                <option key={kind} value={kind}>{kind}</option>
                            ))}
                        </Select>
                    </Control>
                </Field>
            </td>
            <td>
                <Field>
                    <Control>
                        <Input onChange={(e) => handleChangePulseChecker(e, id)} name="url" type="text" placeholder="Url" value={url} />
                    </Control>
                </Field>
            </td>
            <td>
                <Field>
                    <Control>
                        <Input onChange={(e) => handleChangePulseChecker(e, id)} name="name" type="text" placeholder="Name" value={name} />
                    </Control>
                </Field>
            </td>
            <td>
                <Field>
                    <Control>
                        <Select onChange={(e) => handleChangePulseChecker(e, id)} name="interval" value={interval}>
                            {intervalValues.map(interval => (
                                <option key={interval} value={interval}>{timeConversion(interval)}</option>
                            ))}
                        </Select>
                    </Control>
                </Field>
            </td>
            <td>
                <Field>
                    <Control>
                        <Select onChange={(e) => handleChangePulseChecker(e, id)} name="response_time" value={response_time}>
                            {responseTimeValues.map(responseTime => (
                                <option key={responseTime} value={responseTime}>{timeConversion(responseTime)}</option>
                            ))}
                        </Select>
                    </Control>
                </Field>
            </td>
            <td>
                <div className="buttons are-small">
                    <button className='button is-info is-light' onClick={() => handleSavePulseChecker(id)}>
                            <span className="icon is-small">
                                <FontAwesomeIcon icon='save' />
                            </span>
                    </button>
                    {showCancelButton ?
                        <button className='button is-danger is-light' onClick={() => handleCancelEditPulseChecker(id)}>
                            <span className="icon is-small">
                                <FontAwesomeIcon icon='times-circle' />
                            </span>
                        </button> : ''}
                </div>
            </td>
        </tr>
    );
};

PulseCheckerForm.propTypes = {
    showCancelButton: PropTypes.bool.isRequired,
    pulseChecker: PropTypes.object.isRequired,
    intervalValues: PropTypes.array.isRequired,
    responseTimeValues: PropTypes.array.isRequired,
    handleSavePulseChecker: PropTypes.func.isRequired,
    handleChangePulseChecker: PropTypes.func.isRequired,
    handleCancelEditPulseChecker: PropTypes.func,
};

export default PulseCheckerForm;
