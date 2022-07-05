// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

contract NFCContracts {
    uint256 public nfcCount = 0;

    struct NFC {
        uint256 id;
        string NFCID;
        string owner;
        string ownerDNI;
    }

    mapping(uint256 => NFC) public nfcs;


    event NFCCreated(uint256 id, string NFCID, string owner, string ownerDNI);
    event NFCDeleted(uint256 id);

    function createNFC(string memory NFCID, string memory owner, string memory ownerDNI) 
        public
    {
        nfcs[nfcCount] = NFC(nfcCount, NFCID, owner, ownerDNI);
        emit NFCCreated(nfcCount, NFCID, owner, ownerDNI);
        nfcCount++;
    }

    function deleteNFC(uint256 _id) public {
        delete nfcs[_id];
        emit NFCDeleted(_id);
        nfcCount--;
    }
}