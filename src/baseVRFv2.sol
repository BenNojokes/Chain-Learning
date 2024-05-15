// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {VRFCoordinatorV2Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract Pears is VRFConsumerBaseV2 {
    /* Errors */
    error Pears__EntranceFeeTooLow();

    /* Game State Variables */
    uint256 private s_entranceFee; // currently static, Could add to createGame() instead of constructor

    /* VRF Variables */
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    bytes32 private immutable i_keyHash;
    uint32 private immutable i_callbackGasLimit;
    uint64 private i_subscriptionId;

    constructor(
        address vrfCoordinator, //Chain Specific
        uint64 subscriptionId,
        bytes32 keyHash,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinator) {
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_keyHash = keyHash;
        i_callbackGasLimit = callbackGasLimit;
        i_subscriptionId = subscriptionId;
    }

    function createGame() public payable {}

    function joinGame() public payable {}

    function rollDice() public payable {
        if (msg.value < s_entranceFee) {
            revert Pears__EntranceFeeTooLow();
        }

        // Request random words from the VRF Coordinator
        i_vrfCoordinator.requestRandomWords(
            i_keyHash,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal virtual override {}
}
