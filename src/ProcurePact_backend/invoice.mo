import T "Types";
import Nat32 "mo:base/Nat32";
import Trie "mo:base/Trie";
import Result "mo:base/Result";
import Time "mo:base/Time";
import List "mo:base/List";
import Ledger "canister:icrc1_ledger_canister";
import Array "mo:base/Array";
import Error "mo:base/Error";

actor class Invoice() = this {

  stable var nextInvoiceId : Nat32 = 1;
  stable var invoices : Trie.Trie<Nat32, T.Invoice> = Trie.empty();

  func calculateTotalAmount(items : List.List<T.Item>) : Nat32 {
    let total = List.foldLeft<T.Item, Nat32>(
      items,
      0,
      func(acc, item) {
        acc + (item.unit_price * item.quantity);
      },
    );
    return total;
  };

  public shared func createInvoice(args : T.CreateInvoiceArgs) : async Result.Result<Nat32, Text> {
    let invoiceId = nextInvoiceId;
    let now = Time.now();
    try {
      let invoice : T.Invoice = {
        contractId = args.contractId;
        issuer = args.issuer;
        recipient = args.recipient;
        dueDate = args.dueDate;
        items = args.items;
        totalAmount = calculateTotalAmount(args.items);
        penalty = args.penalty;
        status = #Pending;
        createdAt = now;
        updatedAt = now;
        notes = args.notes;
      };
      invoices := Trie.put(invoices, { hash = invoiceId; key = invoiceId }, Nat32.equal, invoice).0;
      #ok(invoiceId);
    } catch (err : Error) {
      return #err(Error.message(err));
    };
  };

  public shared func getInvoice(invoiceId : Nat32) : async ?T.Invoice {
    return Trie.get(invoices, { key = invoiceId; hash = invoiceId }, Nat32.equal);
  };

  public func getBalance(userId : Principal) : async Nat {
    let balance = await Ledger.icrc1_balance_of({
      owner = userId;
      subaccount = null;
    });
    return balance;
  };

  //pay invoice
  // 🚩 use transfer from args
  // 🚩 validate that the backend canister is calling this
  public shared ({ caller }) func payInvoice(invoiceId : Nat32) : async Result.Result<Text, Text> {
    switch (Trie.get(invoices, { key = invoiceId; hash = invoiceId }, Nat32.equal)) {
      case (?invoice) {
        //verify recipient balance is in range
        //consider transfer fees
        let issuerBal = await getBalance(invoice.issuer);
        if (issuerBal < Nat32.toNat(invoice.totalAmount)) {
          return #err("Insufficient Balance");
        };
        //
        let transferFromArgs : Ledger.TransferFromArgs = {
          from = {
            owner = invoice.recipient;
            subaccount = null;
          };
          memo = null;
          amount = Nat32.toNat(invoice.totalAmount);
          spender_subaccount = null;
          fee = null;
          to = { owner = invoice.issuer; subaccount = null };
          created_at_time = null;
        };

        //transfer
        switch (await Ledger.icrc2_transfer_from(transferFromArgs)) {
          case (#Err(transferError)) {
            return #err("Transfer failed: " # debug_show (transferError));
          };
          case (#Ok(blockIndex)) {
            // Update the invoice status to Transferred
            let updatedInvoice : T.Invoice = {
              contractId = invoice.contractId;
              issuer = invoice.issuer;
              recipient = invoice.recipient;
              dueDate = invoice.dueDate;
              items = invoice.items;
              totalAmount = invoice.totalAmount;
              status = #Paid;
              createdAt = invoice.createdAt;
              updatedAt = Time.now();
              notes = invoice.notes;
              penalty = invoice.penalty;
            };
            invoices := Trie.put(invoices, { key = invoiceId; hash = invoiceId }, Nat32.equal, updatedInvoice).0;
            #ok("Transferred: " #debug_show (blockIndex));
          };
        };
      };
      case (null) {
        #err("Invoice not found");
      };
    };
  };

  //overdue
  //get invoices and filter !paid and time.now() > expiryDate
  //mark overdue
  //calculate penalty
  //add penalty to Totalvalue

  func handleOverdue() : async () {
    let now = Time.now();
    let invoicesArray = Trie.toArray<Nat32, T.Invoice, { invoiceId : Nat32; invoice : T.Invoice }>(
      invoices,
      func(k, v) = ({ invoiceId = k; invoice = v }),
    );

    let overdue = Array.filter<({ invoiceId : Nat32; invoice : T.Invoice })>(
      invoicesArray,
      func x = x.invoice.dueDate < now and x.invoice.status == #Pending,
    );

    if (overdue.size() != 0) {
      for (item in overdue.vals()) {
        let invoice = item.invoice;
        let overdueDays = (now - invoice.dueDate) / (24 * 60 * 60 * 1_000_000_000);
        let penaltyAmount = invoice.penalty * Nat32.fromIntWrap(overdueDays);
        let updatedInvoice : T.Invoice = {
          contractId = invoice.contractId;
          issuer = invoice.issuer;
          recipient = invoice.recipient;
          dueDate = invoice.dueDate;
          items = invoice.items;
          totalAmount = invoice.totalAmount + penaltyAmount;
          status = #Overdue;
          createdAt = invoice.createdAt;
          updatedAt = now;
          notes = invoice.notes;
          penalty = invoice.penalty;
        };
        invoices := Trie.put(invoices, { key = item.invoiceId; hash = item.invoiceId }, Nat32.equal, updatedInvoice).0;

      };
    } else {
      return;
    };
  };

  system func heartbeat() : async () {
    await handleOverdue();
  };

};
