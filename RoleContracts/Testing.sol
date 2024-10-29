pragma solidity ^0.6.6;
pragma experimental ABIEncoderV2;

import "./RawMaterial.sol";
// import './Supplier.sol';
// import './Transporter.sol';
import "./Medicine.sol";
// import './Manufacturer.sol';
import "./MedicineW_D.sol";
// import './Wholesaler.sol';
import "./MedicineD_C.sol";
// import './Distributor.sol';
// import './Customer.sol';

//// New supply chain : supplier -> transporter -> manufacturer -> transporter -> whole-saler -> transporter -> distributor -> transporter -> customer/hospital/pharmacy

contract SupplyChain {
    address Owner;

    constructor() public {
        Owner = msg.sender;
    }

    modifier onlyOwner() {
        require(Owner == msg.sender);
        _;
    }

    modifier checkUser(address addr) {
        require(addr == msg.sender);
        _;
    }

    enum roles {
        noRole,
        supplier,
        transporter,
        manufacturer,
        wholesaler,
        distributor,
        customer
    }

    //////////////// Events ////////////////////

    event UserRegister(address indexed _address, bytes32 name);
    event buyEvent(
        address buyer,
        address indexed seller,
        address packageAddr,
        bytes signature,
        uint indexed timestamp
    );
    event respondEvent(
        address buyer,
        address indexed seller,
        address packageAddr,
        bytes signature,
        uint indexed timestamp
    );
    event sendEvent(
        address indexed seller,
        address buyer,
        address packageAddr,
        bytes signature,
        uint indexed timestamp
    );
    event receivedEvent(
        address indexed buyer,
        address seller,
        address packageAddr,
        bytes signature,
        uint indexed timestamp
    );

    /////////////// Users (Only Owner Executable) //////////////////////

    struct userData {
        bytes32 name;
        string[] userLoc;
        roles role;
        address userAddr;
    }

    mapping(address => userData) public userInfo;

    function registerUser(
        bytes32 name,
        string[] memory loc,
        uint role,
        address _userAddr
    ) external onlyOwner {
        userInfo[_userAddr].name = name;
        userInfo[_userAddr].userLoc = loc;
        userInfo[_userAddr].role = roles(role);
        userInfo[_userAddr].userAddr = _userAddr;

        emit UserRegister(_userAddr, name);
    }

    function changeUserRole(
        uint _role,
        address _addr
    ) external onlyOwner returns (string memory) {
        userInfo[_addr].role = roles(_role);
        return "Role Updated!";
    }

    function getUserInfo(
        address _address
    ) external view onlyOwner returns (userData memory) {
        return userInfo[_address];
    }

    /////////////// Supplier //////////////////////

    mapping(address => address[]) public supplierRawMaterials;

    function respondToManufacturer(
        address buyer,
        address seller,
        address packageAddr,
        bytes memory signature
    ) external {
        emit respondEvent(buyer, seller, packageAddr, signature, now);
    }

    function createRawMaterialPackage(
        bytes32 _description,
        uint _quantity,
        address _transporterAddr,
        address _manufacturerAddr
    ) external {
        RawMaterial rawMaterial = new RawMaterial(
            msg.sender,
            address(bytes20(sha256(abi.encodePacked(msg.sender, now)))),
            _description,
            _quantity,
            _transporterAddr,
            _manufacturerAddr
        );

        supplierRawMaterials[msg.sender].push(address(rawMaterial));
    }

    function getNoOfPackagesOfSupplier() external view returns (uint) {
        return supplierRawMaterials[msg.sender].length;
    }

    function getAllPackages() external view returns (address[] memory) {
        uint len = supplierRawMaterials[msg.sender].length;
        address[] memory ret = new address[](len);
        for (uint i = 0; i < len; i++) {
            ret[i] = supplierRawMaterials[msg.sender][i];
        }
        return ret;
    }

    ///////////////  Transporter ///////////////

    function transporterHandlePackage(
        address _addr,
        uint transportertype,
        address cid
    ) external {
        require(
            userInfo[msg.sender].role == roles.transporter,
            "Only Transporter can call this function"
        );
        require(transportertype > 0, "Transporter Type is incorrect");

        if (transportertype == 1) {
            /// Supplier -> Manufacturer
            RawMaterial(_addr).pickPackage(msg.sender);
        } else if (transportertype == 2) {
            /// Manufacturer -> Wholesaler
            Medicine(_addr).pickMedicine(msg.sender);
        } else if (transportertype == 3) {
            // Wholesaler to Distributer
            MedicineW_D(cid).pickWD(_addr, msg.sender);
        } else if (transportertype == 4) {
            // Distrubuter to Customer
            MedicineD_C(cid).pickDC(_addr, msg.sender);
        }
    }

    ///////////////  Manufacturer ///////////////

    mapping(address => address[]) public manufacturerRawMaterials;
    mapping(address => address[]) public manufacturerMedicines;

    function requestRawMaterial(
        address supplierAddr,
        address manuAddr,
        address rawMaterialAddr,
        bytes memory signature
    ) external {
        emit buyEvent(supplierAddr, manuAddr, rawMaterialAddr, signature, now);
    }

    function manufacturerReceivedPackage(
        address _addr,
        address _manufacturerAddress,
        address _sellerAddr,
        bytes memory signature
    ) external {
        RawMaterial(_addr).receivedPackage(_manufacturerAddress);
        manufacturerRawMaterials[_manufacturerAddress].push(_addr);
        emit receivedEvent(msg.sender, _sellerAddr, _addr, signature, now);
    }

    function manufacturerCreatesMedicine(
        address _manufacturerAddr,
        bytes32 _description,
        address[] memory _rawAddr,
        uint _quantity,
        address[] memory _transporterAddr,
        address _recieverAddr,
        uint RcvrType
    ) external {
        Medicine _medicine = new Medicine(
            _manufacturerAddr,
            _description,
            _rawAddr,
            _quantity,
            _transporterAddr,
            _recieverAddr,
            RcvrType
        );

        manufacturerMedicines[_manufacturerAddr].push(address(_medicine));
    }
}
