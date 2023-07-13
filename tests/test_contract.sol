// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract MyContract {

    enum State {Waiting, Active, Ready}
    State public state;

    constructor() public {
        state = State.Waiting;
    }

    function activate() public {
        state = State.Active;
    }

    function isActive() public view returns(bool) {
        return state == State.Active;
    }


    // string public constant val = "Rujullll";
    // string val;

    // constructor() {
    //     val = "Sample Value";
    // }

    // function get() public view returns (string memory) {
    //     return val;
    // }

    // function set(string memory val_arg) public {
    //     val = val_arg;
    // }

}