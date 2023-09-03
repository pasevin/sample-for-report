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

    // Test function with the reentrancy vulnerability
    function testReentrancy(address _token, uint256 _amount) public {
        // Transfer tokens to this contract
        ERC1155(_token).safeTransferFrom(msg.sender, address(this), 0, _amount, "");

        // Transfer tokens back to the sender
        ERC1155(_token).safeTransferFrom(address(this), msg.sender, 0, _amount, "");
    }
}
