pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 public data;

    function set(uint256 _data) public {
        data = _data;
    }

    function get() public view returns (uint256) {
        return data;
    }
}
