// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {VRFCoordinatorV2Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract RNGzus is VRFConsumerBaseV2 {

  /* VRF Variables */
  VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
  uint16 private constant REQUEST_CONFIRMATIONS = 3;
  uint32 private constant NUM_WORDS = 3;
  bytes32 private immutable i_keyHash;
  uint32 private immutable i_callbackGasLimit;
  uint64 private i_subscriptionId;

    event RNGRolled(
    uint256 indexed gameId,
    address indexed player,
    uint256[3] diceResults
  );

  constructor(
    address vrfCoordinator, 
    uint64 subscriptionId,
    bytes32 keyHash,
    uint32 callbackGasLimit
  ) VRFConsumerBaseV2(vrfCoordinator) {
    i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
    i_keyHash = keyHash;
    i_callbackGasLimit = callbackGasLimit;
    i_subscriptionId = subscriptionId;
  }

  function fulfillRandomWords(
      uint256 requestId,
      uint256[] memory randomWords
  ) internal virtual override {
    uint256 RNG1Result = (randomWords[0]) % 6 + 1;
    uint256 RNG2Result = (randomWords[1]) % 6 + 1;
    uint256 RNG3Result = (randomWords[2]) % 6 + 1;
    emit RNGRolled(requestId, msg.sender, [RNG1Result, RNG2Result, RNG3Result]);
  }
}