// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract MyToken is ERC1155, ERC1155Supply {
    constructor() ERC1155("") {}

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    function reentrancyAttack() public {
        // Call the function that is vulnerable to reentrancy
        vulnerableFunction();

        if (address(this).balance > 0) {
            // Recursive call
            reentrancyAttack();
        }
    }

    function vulnerableFunction() public payable {
        require(msg.value >= 1 ether, "Insufficient ether");
        (bool success, ) = msg.sender.call{value: 1 ether}("");
        require(success, "Transfer failed.");
    }
}
