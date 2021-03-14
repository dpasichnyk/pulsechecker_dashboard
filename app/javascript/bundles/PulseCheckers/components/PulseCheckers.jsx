import React, { Component } from 'react';
import PropTypes from 'prop-types';
import PulseChecker from './PulseChecker';
import PulseCheckerForm from './PulseCheckerForm';
import deletePulseChecker from '../actions/deletePulseChecker';
import changeStatus from '../actions/changeStatus';
import createPulseChecker from '../actions/createPulseChecker';
import updatePulseChecker from '../actions/updatePulseChecker';

class PulseCheckers extends Component {
  static initPulseChecker() {
    return {
      url: '',
      name: '',
      kind: 'https',
      interval: 10000,
      responseTime: 500,
    };
  }

  constructor(props) {
    super(props);
    const { pulsecheckers } = this.props;

    this.state = {
      authenticityToken: document.querySelector('meta[name=csrf-token]').content,
      pulsecheckers,
      newPulseChecker: PulseCheckers.initPulseChecker(),
    };
  }

    handleRemove = async (id) => {
      const { authenticityToken, pulsecheckers } = this.state;
      const response = await deletePulseChecker(id, authenticityToken);

      if (response.status === 204) {
        const newArray = pulsecheckers.filter(obj => obj.id !== id);
        this.setState({ pulsecheckers: newArray });
      } else {
        console.log(response);
      }
    }

    handleChangeStatus = async (id) => {
      const { authenticityToken, pulsecheckers } = this.state;
      const response = await changeStatus(id, authenticityToken);

      if (response.status === 204) {
        const elementsIndex = pulsecheckers.findIndex(el => el.id === id);
        const newArray = [...pulsecheckers];

        newArray[elementsIndex] = { ...newArray[elementsIndex], active: !newArray[elementsIndex].active };

        this.setState({ pulsecheckers: newArray });
      } else {
        console.log(response);
      }
    }

    handleChangePulseChecker = (event, id) => {
      const { newPulseChecker: pulsechecker, pulsecheckers } = this.state;

      if (id) {
        const elementsIndex = pulsecheckers.findIndex(el => el.id === id);
        const newArray = [...pulsecheckers];
        newArray[elementsIndex] = { ...newArray[elementsIndex], [event.target.name]: event.target.value };
        this.setState({ pulsecheckers: newArray });
      } else {
        const newPulseChecker = { ...pulsechecker };
        newPulseChecker[event.target.name] = event.target.value;
        this.setState({ newPulseChecker });
      }
    }

    handleEdit = (id) => {
      const { pulsecheckers } = this.state;

      const elementsIndex = pulsecheckers.findIndex(el => el.id === id);
      const newArray = [...pulsecheckers];
      newArray[elementsIndex] = { ...newArray[elementsIndex], isEdit: true };
      this.setState({ pulsecheckers: newArray });
    }

    handleCancelEditPulseChecker = (id) => {
      const { pulsecheckers } = this.state;

      const elementsIndex = pulsecheckers.findIndex(el => el.id === id);
      const newArray = [...pulsecheckers];
      newArray[elementsIndex] = { ...newArray[elementsIndex], isEdit: false };
      this.setState({ pulsecheckers: newArray });
    }

    handleSavePulseChecker = async (id) => {
      if (id) {
        await this.handleUpdatePulseChecker(id);
      } else {
        await this.handleCreatePulseChecker();
      }
    }

    handleCreatePulseChecker = async () => {
      const { authenticityToken, newPulseChecker, pulsecheckers } = this.state;
      const response = await createPulseChecker(authenticityToken, newPulseChecker);

      if (response.status === 200) {
        const newArray = [...pulsecheckers, response.data];

        this.setState({
          pulsecheckers: newArray,
          newPulseChecker: PulseCheckers.initPulseChecker(),
        });
      } else {
        console.log(response);
      }
    }

    handleUpdatePulseChecker = async (id) => {
      const { authenticityToken, pulsecheckers } = this.state;
      const pulseChecker = pulsecheckers.find(element => element.id === id);
      const response = await updatePulseChecker(authenticityToken, pulseChecker);

      if (response.status === 200) {
        const elementsIndex = pulsecheckers.findIndex(el => el.id === id);
        const newArray = [...pulsecheckers];
        newArray[elementsIndex] = response.data;
        this.setState({ pulsecheckers: newArray });
      } else {
        console.log(response);
      }
    }

    renderEditForm(pulsechecker) {
      const { intervalValues, responseTimeValues, kindValues } = this.props;

      return (
        <PulseCheckerForm
          key={pulsechecker.id}
          showCancelButton
          pulseChecker={pulsechecker}
          intervalValues={intervalValues}
          responseTimeValues={responseTimeValues}
          kindValues={kindValues}
          handleSavePulseChecker={this.handleSavePulseChecker}
          handleChangePulseChecker={this.handleChangePulseChecker}
          handleCancelEditPulseChecker={this.handleCancelEditPulseChecker}
        />
      );
    }

    renderPulseCheckerRow(pulsechecker) {
      return (
        <PulseChecker
          key={pulsechecker.id}
          pulsechecker={pulsechecker}
          handleRemove={this.handleRemove}
          handleEdit={this.handleEdit}
          handleChangeStatus={this.handleChangeStatus}
        />
      );
    }

    render() {
      const { pulsecheckers, newPulseChecker } = this.state;
      const { intervalValues, responseTimeValues, kindValues } = this.props;

      return (
        <div className="pulsecheckers">
          <table className="table is-striped is-narrow is-hoverable is-fullwidth">
            <tbody>
              {pulsecheckers.map(pulsechecker => (
                pulsechecker.isEdit ? this.renderEditForm(pulsechecker) : this.renderPulseCheckerRow(pulsechecker)
              ))}
              <PulseCheckerForm
                showCancelButton={false}
                pulseChecker={newPulseChecker}
                intervalValues={intervalValues}
                responseTimeValues={responseTimeValues}
                kindValues={kindValues}
                handleSavePulseChecker={this.handleSavePulseChecker}
                handleChangePulseChecker={this.handleChangePulseChecker}
              />
            </tbody>
          </table>
        </div>
      );
    }
}

PulseCheckers.propTypes = {
  pulsecheckers: PropTypes.arrayOf(PropTypes.object).isRequired,
  intervalValues: PropTypes.arrayOf(PropTypes.number).isRequired,
  responseTimeValues: PropTypes.arrayOf(PropTypes.number).isRequired,
  kindValues: PropTypes.arrayOf(PropTypes.string).isRequired,
};

export default PulseCheckers;
