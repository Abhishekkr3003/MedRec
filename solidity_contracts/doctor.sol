// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.8.0;

contract Doctor {
    mapping(address => uint256) fee;
    mapping(address => bool) isExists;

    function addDoctor(address doc) public {
        require(!isExists[doc], "Doctor already exists");
        fee[doc] = 0;
        isExists[doc] = true;
    }

    function updateFee(address doc, uint256 amount) public {
        fee[doc] = amount;
    }

    function getFee(address doc) public view returns (uint256) {
        return fee[doc];
    }

    function isDoctor(address doc) public view returns (bool) {
        return isExists[doc];
    }
}
