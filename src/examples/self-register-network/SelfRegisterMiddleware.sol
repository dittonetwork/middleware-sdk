// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {BaseMiddleware} from "../../middleware/BaseMiddleware.sol";
import {SharedVaults} from "../../extensions/SharedVaults.sol";
import {SelfRegisterOperators} from "../../extensions/operators/SelfRegisterOperators.sol";

import {ECDSASig} from "../../extensions/managers/sigs/ECDSASig.sol";
import {NoAccessManager} from "../../extensions/managers/access/NoAccessManager.sol";
import {TimestampCapture} from "../../extensions/managers/capture-timestamps/TimestampCapture.sol";
import {EqualStakePower} from "../../extensions/managers/stake-powers/EqualStakePower.sol";
import {KeyManager256} from "../../extensions/managers/keys/KeyManager256.sol";

contract SelfRegisterMiddleware is
    SharedVaults,
    SelfRegisterOperators,
    KeyManager256,
    ECDSASig,
    NoAccessManager,
    TimestampCapture,
    EqualStakePower
{
    /*
     * @notice Constructor for initializing the SelfRegisterMiddleware contract.
     * @param network The address of the network.
     * @param operatorRegistry The address of the operator registry.
     * @param vaultRegistry The address of the vault registry.
     * @param operatorNetOptin The address of the operator network opt-in service.
     * @param owner The address of the contract owner.
     * @param slashingWindow The duration of the slashing window
     */
    constructor(
        address network,
        uint48 slashingWindow,
        address vaultRegistry,
        address operatorRegistry,
        address operatorNetOptin,
        address readHelper
    ) {
        initialize(network, slashingWindow, vaultRegistry, operatorRegistry, operatorNetOptin, readHelper);
    }

    function initialize(
        address network,
        uint48 slashingWindow,
        address vaultRegistry,
        address operatorRegistry,
        address operatorNetOptIn,
        address readHelper
    ) internal initializer {
        __BaseMiddleware_init(network, slashingWindow, vaultRegistry, operatorRegistry, operatorNetOptIn, readHelper);
        __SelfRegisterOperators_init("SelfRegisterMiddleware");
    }
}
