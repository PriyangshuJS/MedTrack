<a name="readme-top"></a>
<div align="center">
  <a href="https://gat.ac.in/">
<!--     <img src="https://github.com/user-attachments/assets/015ad848-2ba5-4528-87e7-a3f1d276c988" alt="Logo" width="280" height="230"> -->
<div align="center">
  <img src="https://github.com/user-attachments/assets/cc3c6cd5-1440-42a4-8b69-a0f8c99dd526" alt="LogoMedTrack" width="400" height="400">
</div>



  </a>
  <h3 align="center">Counterfeit Medicine Authentication System</h3>
  <p align="center">
    A Blockchain and IoT-based solution to enhance transparency and prevent counterfeit drug distribution. 
    <br />
   
  </p>
</div>

---

## 🛠️ About the Project

The **Counterfeit Medicine Authentication System** addresses the critical issue of counterfeit drugs in global supply chains. Leveraging **Blockchain** for transparency and immutability and **IoT** for real-time tracking, this system ensures authenticity in pharmaceutical distribution.  

### Key Features:
- Tracks medicine and raw materials across the supply chain.
- Prevents tampering and enhances trust among entities.
- Uses **smart contracts** for secure and automated processes.
- Verifies authenticity through distributed ledgers and event-driven mechanisms.

---

## 💻 System Design


<img src="https://github.com/user-attachments/assets/6fe1bfe5-0300-4b9d-9eec-dc490b5d2799" alt="System Design">


---

## 🔍 Smart Contract Design

### Supply Chain Contract:
- **Role-Based Access:** Ensures only authorized entities can execute specific functions.
- **Entities Registered:** Owner, Supplier, Transporter, Manufacturer, Wholesaler, Distributor, and Customer.
- **Event Management:** Facilitates real-time front-end updates and tracks entity interactions.

### Raw Material Contract:
- Deployed by Suppliers for tracking raw materials.
- Includes data fields such as Ethereum Addresses, timestamps, and statuses.
- Tracks the transfer of raw materials to the Transporter and Manufacturer.

### Medicine Contract:
- Deployed by Manufacturers for tracking medicines.
- Includes Ethereum Addresses of the raw materials used and transaction details.
- Tracks medicine ownership through entities like Wholesaler, Distributor, and Customer.

### Transaction Contract:
- Auto-deployed by Raw Material and Medicine Contracts.
- Records transaction details such as sender, receiver, location, and hash values for immutability.
- Facilitates source verification of products in the supply chain.

<img src="https://github.com/user-attachments/assets/bf299024-534f-4012-99b9-af3ef5387d99" alt="Request-Response Flow">


---

## 🔄 Process Flow

1. **Owner Deploys Contracts:** Registers and authenticates all entities in the supply chain.
2. **Raw Material Registration:** Suppliers register raw materials, deploying Raw Material and Transaction Contracts.
3. **Material Transfer:** 
    - Supplier → Transporter → Manufacturer.
    - Status updates and transactions logged at each step.
4. **Medicine Creation:** 
    - Manufacturer registers medicines, deploying Medicine and Transaction Contracts.
5. **Distribution:** 
    - Manufacturer → Transporter → Wholesaler → Transporter → Distributor → Transporter → Customer.
6. **Verification:** Each entity verifies the source and updates product status.

<img src="https://github.com/user-attachments/assets/fcddfb9d-e45d-455b-9b09-894e71b6eb27" alt="Request-Response Flow">

---

## 🐱‍💻 Prerequisites

1. **Ethereum Account.**  
2. **Ganache Software** for a local blockchain simulation.  
3. **Node Modules** and **Yarn Package Manager.**  
4. **React Development Environment** (e.g., Visual Studio Code).  

---

## 🚀 Getting Started

### Deploying the Smart Contracts:

1. **Install Prerequisites:**
   - Install Node.js, Truffle, Ganache, and MetaMask.
   - Globally install **Truffle**:
     ```sh
     npm install -g truffle
     ```

2. **Create and Compile a Smart Contract:**
   - **Create a Truffle Project:**
     ```sh
     mkdir myProject
     cd myProject
     truffle init
     ```
   - **Write a Simple Smart Contract (`MyContract.sol`):**
     ```sh
     echo 'pragma solidity ^0.8.0;

     contract MyContract {
         string public name = "My First Smart Contract";
     }' > contracts/MyContract.sol
     ```
   - **Create a Migration File (`2_deploy_contracts.js`):**
     ```sh
     echo 'const MyContract = artifacts.require("MyContract");

     module.exports = function (deployer) {
       deployer.deploy(MyContract);
     };' > migrations/2_deploy_contracts.js
     ```

3. **Set Up Ganache:**
   - Open **Ganache** and create a new workspace.
   - Set **Server Settings** to port `7545` and ensure the local blockchain is started with 10 accounts, each holding 100 ETH.

4. **Configure Truffle to Use Ganache:**
   - Update `truffle-config.js` to use Ganache:
     ```sh
     module.exports = {
       networks: {
         development: {
           host: "127.0.0.1",  // Localhost (Ganache)
           port: 7545,         // Port for Ganache
           network_id: "*",    // Match any network id
         }
       },
       compilers: {
         solc: {
           version: "0.8.0",  // Solidity version
         }
       }
     };
     ```

5. **Migrate the Smart Contracts to Ganache:**
   ```sh
   truffle migrate
## 📈 RESULTS
<img src="images/ganache.png"/>
   <br />
    <img src="images/home.png"/>
   <br />
<img src="images/ownerAdd.png"/>
   <br />
<img src="images/ownerView.png"/>
   <br />
   <img src="images/popup.png"/>
   <br />
     <img src="images/transporter.png"/>
   <br />
      <img src="images/manufactDetail.png"/>
   <br />
 
