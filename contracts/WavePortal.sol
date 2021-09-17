// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint totalWaves;
    uint private seed;


    event NewWave(address indexed from, uint timestamp, string message);

    struct Wave {
        string message;
        address waver;
        uint timestamp;
    }
    Wave[] waves;

    mapping(address => uint) public lastWavedAt;

    constructor() payable {
        console.log("We have been constructed!");
    }
    function wave(string memory _message) public {

        require(lastWavedAt[msg.sender] + 30 seconds < block.timestamp, "Wait 30 seconds for next wave.");

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s waved w/ message %s", msg.sender, _message);
        console.log("Got message: %s", _message);
        waves.push(Wave(_message, msg.sender, block.timestamp));

        uint randomNumber = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %s", randomNumber);
        
        seed = randomNumber;

        if(randomNumber < 50) {
            console.log("%s won!", msg.sender);

            uint prizeAmount = 0.00001 ether;
            require(prizeAmount <= address(this).balance, "Contract doesn't have money AHHHH");
            (bool success,) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to send money");
        }
    }
    function getAllWaves() view public returns (Wave[] memory) {
        return waves;
    }
    function getTotalWaves() view public returns (uint) {
        return totalWaves;
    }
}