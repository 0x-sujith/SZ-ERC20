// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SZtoken is ERC20, Ownable, ERC20Permit {
    constructor(address initialOwner) ERC20("SZtoken", "SZ") Ownable(initialOwner) ERC20Permit("SZtoken") {
        _mint(initialOwner, 1000000 * 10 ** decimals());
    }
}
