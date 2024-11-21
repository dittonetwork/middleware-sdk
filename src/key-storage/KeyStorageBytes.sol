// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {BaseManager} from "../managers/BaseManager.sol";
import {PauseableEnumerableSet} from "../libraries/PauseableEnumerableSet.sol";

import {Time} from "@openzeppelin/contracts/utils/types/Time.sol";

/**
 * @title KeyStorageBytes
 * @notice Manages storage and validation of operator keys
 * @dev Extends BaseManager to provide key management functionality
 */
abstract contract KeyStorageBytes is BaseManager {
    using PauseableEnumerableSet for PauseableEnumerableSet.BytesSet;
    using PauseableEnumerableSet for PauseableEnumerableSet.Status;

    error DuplicateKey();
    error MaxDisabledKeysReached();

    uint256 private constant MAX_DISABLED_KEYS = 1;
    bytes private constant ZERO_BYTES = "";
    bytes32 private constant ZERO_BYTES_HASH = keccak256("");

    mapping(address => PauseableEnumerableSet.BytesSet) internal _keys;
    mapping(bytes => address) internal _keyToOperator;

    /**
     * @notice Gets the operator address associated with a key
     * @param key The key to lookup
     * @return The operator address that owns the key, or zero address if none
     */
    function operatorByKey(
        bytes memory key
    ) public view returns (address) {
        return _keyToOperator[key];
    }

    /**
     * @notice Gets an operator's active key at the current capture timestamp
     * @param operator The operator address to lookup
     * @return The operator's active key, or empty bytes if none
     */
    function operatorKey(
        address operator
    ) public view returns (bytes memory) {
        bytes[] memory active = _keys[operator].getActive(getCaptureTimestamp());
        if (active.length == 0) {
            return ZERO_BYTES;
        }
        return active[0];
    }

    /**
     * @notice Checks if a key was active at a specific timestamp
     * @param timestamp The timestamp to check
     * @param key The key to check
     * @return True if the key was active at the timestamp, false otherwise
     */
    function keyWasActiveAt(uint48 timestamp, bytes memory key) public view returns (bool) {
        return _keys[_keyToOperator[key]].wasActiveAt(timestamp, key);
    }

    /**
     * @notice Updates an operator's key
     * @dev Handles key rotation by disabling old key and registering new one
     * @param operator The operator address to update
     * @param key The new key to register
     * @custom:throws DuplicateKey if key is already registered to another operator
     * @custom:throws MaxDisabledKeysReached if operator has too many disabled keys
     */
    function _updateKey(address operator, bytes memory key) internal {
        bytes32 keyHash = keccak256(key);

        if (_keyToOperator[key] != address(0)) {
            revert DuplicateKey();
        }

        // check if we have reached the max number of disabled keys
        // this allow us to limit the number times we can change the key
        if (keyHash != ZERO_BYTES_HASH && _keys[operator].length() > MAX_DISABLED_KEYS + 1) {
            revert MaxDisabledKeysReached();
        }

        if (_keys[operator].length() > 0) {
            // try to remove disabled keys
            bytes memory prevKey = _keys[operator].array[0].value;
            if (_keys[operator].checkUnregister(Time.timestamp(), SLASHING_WINDOW, prevKey)) {
                _keys[operator].unregister(Time.timestamp(), SLASHING_WINDOW, prevKey);
                delete _keyToOperator[prevKey];
            } else if (_keys[operator].wasActiveAt(getCaptureTimestamp(), prevKey)) {
                _keys[operator].pause(Time.timestamp(), prevKey);
            }
        }

        if (keyHash != ZERO_BYTES_HASH) {
            // register the new key
            _keys[operator].register(Time.timestamp(), key);
            _keyToOperator[key] = operator;
        }
    }
}
