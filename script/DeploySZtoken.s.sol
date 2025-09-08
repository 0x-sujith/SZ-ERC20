// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script, console2} from "forge-std/Script.sol";
import {SZtoken} from "../src/SZtoken.sol";

contract DeploySZtoken is Script {
    function run() external returns (SZtoken) {
        address initialOwner = vm.envAddress("DEPLOYER_ADDRESS");

        vm.startBroadcast();
        SZtoken token = new SZtoken(initialOwner);
        vm.stopBroadcast();

        console2.log("SZtoken deployed at:", address(token));
        console2.log("Token owner is:", initialOwner);

        return token;
    }
}
