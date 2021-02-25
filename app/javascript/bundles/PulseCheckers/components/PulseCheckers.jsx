import React, {Component} from 'react';
import PropTypes from 'prop-types';
import PulseChecker from "./PulseChecker";

class PulseCheckers extends Component {
    constructor(props) {
        super(props);
        const { pulsecheckers } = this.props;
        this.state = {
            authenticityToken: document.querySelector('meta[name=csrf-token]').content,
            pulsecheckers: pulsecheckers
        };
    }

    render() {
        console.log('state', this.state)
        const { pulsecheckers } = this.state;
        return (
            <div className='pulsecheckers'>
                <table className="table is-striped is-narrow is-hoverable is-fullwidth">
                    {/*<thead>*/}
                    {/*<tr>*/}
                    {/*    <th><abbr title="Position">Pos</abbr></th>*/}
                    {/*    <th>Team</th>*/}
                    {/*    <th><abbr title="Played">Pld</abbr></th>*/}
                    {/*    <th><abbr title="Won">W</abbr></th>*/}
                    {/*    <th><abbr title="Drawn">D</abbr></th>*/}
                    {/*    <th><abbr title="Lost">L</abbr></th>*/}
                    {/*    <th><abbr title="Goals for">GF</abbr></th>*/}
                    {/*    <th><abbr title="Goals against">GA</abbr></th>*/}
                    {/*    <th><abbr title="Goal difference">GD</abbr></th>*/}
                    {/*    <th><abbr title="Points">Pts</abbr></th>*/}
                    {/*    <th>Qualification or relegation</th>*/}
                    {/*</tr>*/}
                    {/*</thead>*/}
                    <tbody>
                    {pulsecheckers.map(pulsechecker => (
                        <PulseChecker key={pulsechecker.id} pulsechecker={pulsechecker} />
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
