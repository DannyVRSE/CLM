# `ProcurePact`
ProcurePact offers Full Contract Lifecycle Mangement for vendor agreements including final transactions.

We aim to solve liquidity challenges for Micro, Small, and Medium Enterprises by offering immediate payments for goods and services delivered and easy access to short-term credit.

## 🚀 Current Features

- **Contract Creation**
  Create and manage legally binding vendor agreements.

  **Connection Management**
  For buyers and vendors to collaborate on a contract, they need to be Mutual Connections. This allows only known users to invite a party to a contract.

- **Party Invitation**
  Invite all stakeholders to collaborate on the contract (Buyer, Supplier, Third-Party)

- **E-signing of Contracts**
  Sign contracts electronically, eliminating the need for physical paperwork.

  **Flexible Payment Terms**
  Supports various payment configurations:
  1. On Delivery  
  - Payment is made to a supplier immediately the buyer confirms delivery of goods.

  2. Deferred Payment
  - This payment term utilizes invoices.

- **Locking of Assets in Escrow**
  If the payment term is "On Delivery", the buyer has to lock tokens in an escrow account. This incentivices the Supplier to deliver as they will be paid immediately and Buyers can get their funds back if the delivery is not made.

- **Delivery Note Generation**
  The supplier can generate delivery notes for goods delivered. Issued delivery notes are confimed by the buyer to ascertain the delivery was made.

- **Invoices**
  The supplier can create invoices directly from delivery data, which the buyer pays from their connected wallet.

- **Internet Identity**
  All users are authenticated using Internet Identity

- **Late Penalties**
  Buyer is charged penalty fees for late invoice payment.


## 🚀 Key Future Features
- **Collaterization of Invoices**
  Collateralize pending invoices to access short-term credit.

- **Dispute Resolution**
  Built-in mechanisms to manage and resolve disputes efficiently.

- **Native Wallet**

- **Cross-Chain Payments**


## 🚀 Running the project locally
1. **Clone the repository**
```bash
git clone <repo-url>
cd <repo-url>
```
2. **Deploy**
- Run ```local_deploy.sh script```. This will create new identities and deploy all canisters.
- This script will deploy a dummy ICRC1 token locally to be used for transactions,
- Each new user is allocated some tokens.
