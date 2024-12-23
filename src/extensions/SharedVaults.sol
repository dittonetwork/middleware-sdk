// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {BaseMiddleware} from "../middleware/BaseMiddleware.sol";
import {ISharedVaults} from "../interfaces/extensions/ISharedVaults.sol";

/**
 * @title SharedVaults
 * @notice Contract for managing shared vaults that can be used by multiple operators
 * @dev Extends BaseMiddleware to provide access control for vault management functions
 */
abstract contract SharedVaults is BaseMiddleware, ISharedVaults {
    uint64 public constant SharedVaults_VERSION = 1;

    /**
     * @inheritdoc ISharedVaults
     */
    function registerSharedVault(
        address sharedVault
    ) public checkAccess {
        _beforeRegisterSharedVault(sharedVault);
        _registerSharedVault(sharedVault);
        _afterRegisterSharedVault(sharedVault);
    }

    /**
     * @inheritdoc ISharedVaults
     */
    function pauseSharedVault(
        address sharedVault
    ) public checkAccess {
        _beforePauseSharedVault(sharedVault);
        _pauseSharedVault(sharedVault);
        _afterPauseSharedVault(sharedVault);
    }

    /**
     * @inheritdoc ISharedVaults
     */
    function unpauseSharedVault(
        address sharedVault
    ) public checkAccess {
        _beforeUnpauseSharedVault(sharedVault);
        _unpauseSharedVault(sharedVault);
        _afterUnpauseSharedVault(sharedVault);
    }

    /**
     * @inheritdoc ISharedVaults
     */
    function unregisterSharedVault(
        address sharedVault
    ) public checkAccess {
        _beforeUnregisterSharedVault(sharedVault);
        _unregisterSharedVault(sharedVault);
        _afterUnregisterSharedVault(sharedVault);
    }

    /**
     * @notice Hook called before registering a shared vault
     * @param sharedVault The vault address
     */
    function _beforeRegisterSharedVault(
        address sharedVault
    ) internal virtual {}

    /**
     * @notice Hook called after registering a shared vault
     * @param sharedVault The vault address
     */
    function _afterRegisterSharedVault(
        address sharedVault
    ) internal virtual {}

    /**
     * @notice Hook called before pausing a shared vault
     * @param sharedVault The vault address
     */
    function _beforePauseSharedVault(
        address sharedVault
    ) internal virtual {}

    /**
     * @notice Hook called after pausing a shared vault
     * @param sharedVault The vault address
     */
    function _afterPauseSharedVault(
        address sharedVault
    ) internal virtual {}

    /**
     * @notice Hook called before unpausing a shared vault
     * @param sharedVault The vault address
     */
    function _beforeUnpauseSharedVault(
        address sharedVault
    ) internal virtual {}

    /**
     * @notice Hook called after unpausing a shared vault
     * @param sharedVault The vault address
     */
    function _afterUnpauseSharedVault(
        address sharedVault
    ) internal virtual {}

    /**
     * @notice Hook called before unregistering a shared vault
     * @param sharedVault The vault address
     */
    function _beforeUnregisterSharedVault(
        address sharedVault
    ) internal virtual {}

    /**
     * @notice Hook called after unregistering a shared vault
     * @param sharedVault The vault address
     */
    function _afterUnregisterSharedVault(
        address sharedVault
    ) internal virtual {}
}
