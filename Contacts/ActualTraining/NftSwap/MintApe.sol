//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MintApe is ERC721 {
    //总量
    uint256 public MAX_APES = 10000;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {}

    //BAYC的baseURI为ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/
    //基础url
    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
    }

    /**
     * 铸造
     * @param to 目标地址
     * @param tokenId tokenID
     */
    function mint(address to, uint256 tokenId) external {
        require(tokenId >= 0 && tokenId < MAX_APES, "tokenId out fof range");
        _mint(to, tokenId);
    }
}
