// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Ed25519} from "../../../libraries/Ed25519.sol";
import {BaseSig} from "./BaseSig.sol";

/**
 * @title Ed25519Sig
 * @notice Contract for verifying Ed25519 signatures against operator keys
 * @dev Implements BaseSig interface using Ed25519 signature verification
 */
abstract contract Ed25519Sig is BaseSig {
    bool public constant Ed25519SigEnabled = true;

    /**
     * @notice Verifies that a signature was created by the owner of a key
     * @param operator The address of the operator that owns the key
     * @param key_ The public key to verify against
     * @param signature The Ed25519 signature to verify
     * @return True if the signature was created by the key owner, false otherwise
     * @dev The key must be a valid Ed25519 public key point compressed to 32 bytes
     *      The signature must be 64 bytes containing r and s components encoded as uint256
     */
    function _verifyKeySignature(
        address operator,
        bytes memory key_,
        bytes memory signature
    ) internal override returns (bool) {
        bytes32 key = abi.decode(key_, (bytes32));
        bytes memory message = abi.encode(keccak256(abi.encodePacked(operator, key)));
        return verify(message, signature, key);
    }

    /**
     * @notice Verifies an Ed25519 signature against a message and public key
     * @param message The message that was signed
     * @param signature The Ed25519 signature to verify
     * @param key The Ed25519 public key compressed to 32 bytes
     * @return True if the signature is valid, false otherwise
     * @dev Wrapper around Ed25519.verify which handles decompression and curve operations
     */
    function verify(bytes memory message, bytes memory signature, bytes32 key) internal returns (bool) {
        return Ed25519.verify(message, signature, key);
    }
}
