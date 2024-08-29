# Med Track - Blockchain-Based Authentication of Medicine

## Project Overview
This project is a Proof of Concept (POC) aimed at solving the issue of trust within the medicine supply chain using blockchain technology. The system is designed to address problems such as the falsification of medicine passports, the maintenance of quality standards across facilities, and the verification of credentials issued within the supply chain.
![Vaccine-Cold-Chain-02 width-2880](https://github.com/user-attachments/assets/adb5df15-e596-4328-b526-14c49c0f11d4)
## Features
- **Tamper-Proof Provenance:** Ensures that the label on a medicine’s vial accurately represents its contents and confirms that the medicine comes from an inspected batch.
- **Credential Issuance & Verification:** Uses cryptographic signatures that are easily verified with on-chain identities.
- **Data Redundancy:** Ensures that data cannot be lost, even if a user misplaces their device or if vials are damaged.

## System Actors
- **Manufacturer:** Processes raw materials into medicines.
- **Distributor:** Transports medicines between locations.
- **Inspector:** Performs quality checks on medicines and manufacturing plants.
- **Storage Facility:** Stores medicines at required conditions.
- **Immunizer (Doctors, Nurses):** Administers medicines and provides passports/certificates.
- **Traveller (Patient):** Receives the medicine and passport, presents it when necessary.
- **Border Agent:** Verifies medicine certificates/passports.
  
![services](https://github.com/user-attachments/assets/0dd85754-dfec-4c8f-818e-736dc37625c1)
## Problem-Solution Map

| No. | Problems                                | Affected Actors               | Proposed Solutions                                      |
|-----|-----------------------------------------|--------------------------------|---------------------------------------------------------|
| 1   | Medicine passports can be falsified     | Border Agent                   | Cryptographically verify using on-chain data            |
| 2   | Facilities may not meet quality standards | All                           | Publish inspection results to blockchain; verify results |
| 3   | Medicine passports may not be recognized | Distributor, Traveller, Immunizer | Verify signatures in presented certificates              |

## System Design


### Flow
1. Inspector issues a certificate for a batch to the Manufacturer.
2. Manufacturer updates the batch status to `MANUFACTURED` and presents the certificate to the Distributor.
3. Distributor verifies each certificate, updates the batch status to `DELIVERING_INTERNATIONAL`, and passes it to the Storage Facility.
4. Storage Facility verifies and stores the batch, updating the status to `STORED`.
5. Distributor retrieves the batch, updates the status to `DELIVERING_LOCAL`, and hands it to the Immunizer.
6. Immunizer verifies certificates, administers the medicine, and issues a medicine passport with status `VACCINATED`.
7. Traveller presents the medicine passport to the Border Agent for verification.

### High-Level Architecture
- **3-Tiered Architecture:** Describes the system’s flow and interactions between the actors.
- **2-Tiered dApp Architecture:** Details the decentralized application design used for interactions between users and the blockchain.

## Out of Scope
- Payments between system agents
- Dishonest doctors/immunizers
- Suppliers of raw materials to the manufacturers
- Image capture & QR code scanning
- Scalability
- Distribution to areas without internet access
- IoT integration
- Machine learning
- Regulatory compliance (e.g., GDPR, HIPAA, etc.)

## References
- [BBC News: COVID-19 Vaccine Certificates](https://www.bbc.com/news/uk-northern-ireland-58054973)
- [Vanguard: Nigeria's Vaccine Certificate Issues](https://www.vanguardngr.com/2021/10/fg-shocked-as-nigeria-loses-out-of-uk-recognised-covid-19-vaccine-certificates/)
- [Health Policy Watch: Sputnik-V Manufacturing Practices](https://healthpolicy-watch.news/russia-pushes-ahead-with-open-license-approach-to-sputnik-v-despite-who-concerns-over-manufacturing-practices/)




