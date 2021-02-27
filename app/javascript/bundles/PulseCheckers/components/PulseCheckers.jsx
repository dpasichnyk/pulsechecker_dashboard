import React, {Component} from 'react';
import PropTypes from 'prop-types';
import PulseChecker from "./PulseChecker";
import deletePulseChecker from '../actions/deletePulseChecker';
import changeStatus from '../actions/changeStatus';

class PulseCheckers extends Component {

    constructor(props) {
        super(props);
        const { pulsecheckers } = this.props;
        this.state = {
            authenticityToken: document.querySelector('meta[name=csrf-token]').content,
            pulsecheckers: pulsecheckers
        };
    }

    handleRemove = async (id) => {
        const response = await deletePulseChecker(id, this.state.authenticityToken)
        if (response.status === 204) {
            let newArray = this.state.pulsecheckers.filter(function( obj ) {
                return obj.id !== id;
            });
            this.setState({ pulsecheckers: newArray })
        } else {
            console.log(response)
        }
    }

    handleChangeStatus = async (id) => {
        const response = await changeStatus(id, this.state.authenticityToken)
        if (response.status === 204) {
            const elementsIndex = this.state.pulsecheckers.findIndex(el => el.id === id )
            let newArray = [...this.state.pulsecheckers]
            newArray[elementsIndex] = {...newArray[elementsIndex], active: !newArray[elementsIndex].active}
            this.setState({ pulsecheckers: newArray })
        } else {
            console.log(response)
        }
    }

    handleChange = (id) => {
        console.log('handleChange for id:', id)
    }

    render() {
        const { pulsecheckers } = this.state;
        return (
            <div className='pulsecheckers'>
                <table className="table is-striped is-narrow is-hoverable is-fullwidth">
                    <tbody>
                    {pulsecheckers.map(pulsechecker => (
                        <PulseChecker key={pulsechecker.id}
                                      pulsechecker={pulsechecker}
                                      handleRemove={this.handleRemove}
                                      handleChangeStatus={this.handleChangeStatus}
                                      handleChange={this.handleChange}
                        />
                    ))}
                    </tbody>
                </table>
            </div>
        )
    }
}

PulseCheckers.propTypes = {
    pulsecheckers: PropTypes.array.isRequired, // this is passed from the Rails view
};

export default PulseCheckers;
