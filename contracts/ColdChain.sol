// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

library CryptoSuite {
    function splitSignature(
        bytes memory sig
    ) internal pure returns (uint8 v, bytes32 r, bytes32 s) {
        require(sig.length == 65);

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

    function recoverSigner(
        bytes32 message,
        bytes memory sig
    ) internal pure returns (address) {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, message));
        return ecrecover(prefixedHash, v, r, s);
    }
}

contract ColdChain {
    enum CertificateStatus {
        MANUFACTURED,
        DELIVERING_INTERNATIONAL,
        STORED,
        DELIVERING_LOCAL,
        DELIVERED
    }

    struct Certificate {
        uint256 id;
        Entity issuer;
        Entity prover;
        bytes signature;
        CertificateStatus status;
    }

    enum EntityRole {
        ISSUER,
        PROVER,
        VERIFIER
    }

    struct Entity {
        address id;
        EntityRole role;
        uint[] certificateIds;
    }

    struct VaccineBatch {
        uint256 id;
        string brand;
        address manufacturer;
        uint[] certificateIds;
    }

    uint256 public constant MAX_CERTIFICATIONS = 2;

    uint256[] public certificateIds;
    uint256[] public vaccineBatchIds;

    mapping(uint256 => VaccineBatch) public vaccineBatches;
    mapping(uint256 => Certificate) public certificates;
    mapping(address => Entity) public entities;

    event AddEntity(address entityId, string entityRole);
    event AddVaccineBatch(uint256 vaccineBatchId, address indexed manufacturer);
    event IssueCertificate(
        address indexed issuer,
        address indexed prover,
        uint256 certificateId
    );

    function addEntity(address _id, string memory _role) public {
        EntityRole role = unmarshalRole(_role);
        uint[] memory _certificateIds = new uint[](MAX_CERTIFICATIONS);
        Entity memory entity = Entity(_id, role, _certificateIds);
        entities[_id] = entity;
        emit AddEntity(_id, _role);
    }

    function unmarshalRole(
        string memory _role
    ) private pure returns (EntityRole) {
        bytes32 encodedRole = keccak256(abi.encodePacked(_role));
        bytes32 encodedRole0 = keccak256(abi.encodePacked("ISSUER"));
        bytes32 encodedRole1 = keccak256(abi.encodePacked("PROVER"));
        bytes32 encodedRole2 = keccak256(abi.encodePacked("VERIFIER"));

        if (encodedRole == encodedRole0) return EntityRole.ISSUER;
        else if (encodedRole == encodedRole1) return EntityRole.PROVER;
        else if (encodedRole == encodedRole2) return EntityRole.VERIFIER;

        revert("invalid entity role");
    }

    function addVaccineBatch(
        string memory brand,
        address manufacturer
    ) public returns (uint256) {
        uint256 id = vaccineBatchIds.length;
        uint[] memory _certificateIds = new uint[](MAX_CERTIFICATIONS);
        VaccineBatch memory batch = VaccineBatch(
            id,
            brand,
            manufacturer,
            _certificateIds
        );

        vaccineBatches[id] = batch;
        vaccineBatchIds.push(id);

        emit AddVaccineBatch(id, manufacturer);
        return id;
    }

    function issueCertificate(
        address _issuer,
        address _prover,
        string memory _status,
        uint256 vaccineBatchId,
        bytes memory signature
    ) public returns (uint256) {
        require(
            entities[_issuer].role == EntityRole.ISSUER,
            "Issuer not authorized"
        );
        require(
            entities[_prover].role == EntityRole.PROVER,
            "Prover not authorized"
        );

        CertificateStatus status = unmarshalStatus(_status);

        uint256 id = certificateIds.length;
        Certificate memory certificate = Certificate(
            id,
            entities[_issuer],
            entities[_prover],
            signature,
            status
        );

        certificateIds.push(id);
        certificates[id] = certificate;

        VaccineBatch storage batch = vaccineBatches[vaccineBatchId];
        batch.certificateIds[uint256(status)] = id;

        emit IssueCertificate(_issuer, _prover, id);

        return id;
    }

    function unmarshalStatus(
        string memory _status
    ) private pure returns (CertificateStatus) {
        bytes32 encodedStatus = keccak256(abi.encodePacked(_status));
        bytes32 encodedStatus0 = keccak256(abi.encodePacked("MANUFACTURED"));
        bytes32 encodedStatus1 = keccak256(
            abi.encodePacked("DELIVERING_INTERNATIONAL")
        );
        bytes32 encodedStatus2 = keccak256(abi.encodePacked("STORED"));
        bytes32 encodedStatus3 = keccak256(
            abi.encodePacked("DELIVERING_LOCAL")
        );
        bytes32 encodedStatus4 = keccak256(abi.encodePacked("DELIVERED"));

        if (encodedStatus == encodedStatus0)
            return CertificateStatus.MANUFACTURED;
        else if (encodedStatus == encodedStatus1)
            return CertificateStatus.DELIVERING_INTERNATIONAL;
        else if (encodedStatus == encodedStatus2)
            return CertificateStatus.STORED;
        else if (encodedStatus == encodedStatus3)
            return CertificateStatus.DELIVERING_LOCAL;
        else if (encodedStatus == encodedStatus4)
            return CertificateStatus.DELIVERED;

        revert("invalid certificate status");
    }

    function isMatchingSignature(
        bytes32 message,
        uint256 id,
        address issuer
    ) public view returns (bool) {
        Certificate memory cert = certificates[id];
        require(cert.issuer.id == issuer);

        address recoveredSigner = CryptoSuite.recoverSigner(
            message,
            cert.signature
        );
        return recoveredSigner == cert.issuer.id;
    }
}
