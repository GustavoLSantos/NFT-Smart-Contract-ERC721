// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.1/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@5.0.1/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts@5.0.1/access/Ownable.sol";

contract GustavoLSantos is ERC721, ERC721Enumerable, ERC721Pausable, Ownable {

    // =========== 1. Property Variables =========== //

    uint256 private _nextTokenId;

    uint256 public MINT_PRICE = 0.05 ether;
    uint256 public MAX_SUPPLY = 10000;

    // =========== 2. Lifecycle Methods =========== //

    constructor(address initialOwner)
        ERC721("GustavoLSantos", "GLS")
        Ownable(initialOwner)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://gustavoLSantosBaseURI/";
    }

    function withdraw() public onlyOwner() {
        require(address(this).balance > 0, "Balance is zero");
        payable(owner()).transfer(address(this).balance);
    }

    // =========== 3. Pausable Functions =========== //

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    // =========== 4. Minting Functions =========== //

    function safeMint(address to) public payable{
        require(msg.value >= MINT_PRICE, "Not enough ether sent.");
        require(totalSupply() < MAX_SUPPLY, "Can't mint anymore tokens");
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }

    // =========== 5. Other Functions =========== //

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
