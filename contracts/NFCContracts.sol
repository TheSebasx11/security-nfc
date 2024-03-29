// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

contract NFCContracts {
    uint256 public nfcCount = 0;

    struct NFC {
        uint256 id;
        string owner;
        string title;
    }

    mapping(uint256 => NFC) public nfcs;

    event NFCCreated(uint256 id, string owner, string title);
    event NFCDeleted(uint256 id);

    function createNFC(string memory owner, string memory title) public {
        nfcs[nfcCount] = NFC(nfcCount, owner, title);
        emit NFCCreated(nfcCount, owner, title);
        nfcCount++;
    }

    function getBlockNumber() public view returns (uint256) {
        return block.number;
    }

    function calculateStructHash(
        NFC memory _myStruct
    ) public pure returns (bytes32) {
        return keccak256(abi.encode(_myStruct));
    }

    function deleteNFC(uint256 _id) public {
        delete nfcs[_id];
        emit NFCDeleted(_id);
        nfcCount--;
    }
}
