# ============================================================
# balance_check.py — Module 2: Balance Check
# Displays the current account balance and account holder name.
# Simple read-only operation — no data is changed here.
# ============================================================

import database  # shared data store


def run_balance_check(pin: str) -> None:
    """
    Entry point called by main menu when user selects Balance Check.
    Fetches live balance from the shared database dict.
    """
    account = database.get_account(pin)

    print("\n" + "=" * 40)
    print("       *** BALANCE CHECK ***")
    print("=" * 40)
    print(f"  Account Holder : {account['name']}")

    # :,.2f formats the number with commas and 2 decimal places
    # e.g. 50000 → "50,000.00"
    print(f"  Available Bal  : Rs. {account['balance']:,.2f}")
    print("=" * 40)
    input("\n  Press Enter to return to menu...")
