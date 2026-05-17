# ============================================================
# mini_statement.py — Module 4: Mini Statement
# Shows the last 5 transactions of the account.
# Read-only — no changes to account data.
# ============================================================

import database  # shared data store

# Number of recent transactions to display
STATEMENT_LIMIT = 5


def run_mini_statement(pin: str) -> None:
    """
    Entry point called by main menu when user selects Mini Statement.
    Fetches transaction history and displays the most recent entries.
    """
    account = database.get_account(pin)
    transactions = account["transactions"]

    print("\n" + "=" * 50)
    print("         *** MINI STATEMENT ***")
    print("=" * 50)
    print(f"  Account Holder : {account['name']}")
    print("-" * 50)

    if not transactions:
        print("  No transactions found.")
    else:
        # [-STATEMENT_LIMIT:] slices the last N items from the list
        # reversed() shows newest transaction at the top
        recent = list(reversed(transactions[-STATEMENT_LIMIT:]))

        print(f"  {'Date':<17} {'Type':<12} {'Amount':>12}")
        print("  " + "-" * 44)

        for txn in recent:
            # ljust / rjust align columns neatly in fixed-width terminal
            date   = txn["date"]
            t_type = txn["type"]
            amt    = f"Rs. {txn['amount']:>9,.2f}"
            print(f"  {date:<17} {t_type:<12} {amt:>12}")

    print("-" * 50)
    print(f"  Current Balance: Rs. {account['balance']:,.2f}")
    print("=" * 50)
    input("\n  Press Enter to return to menu...")
