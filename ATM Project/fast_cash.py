# ============================================================
# fast_cash.py — Module 1: Fast Cash
# Lets the user pick a preset amount (no manual typing needed).
# Internally calls withdraw logic to keep balance consistent.
# ============================================================

import database  # shared data store


# Preset denominations shown as quick-pick options
FAST_CASH_OPTIONS = [500, 1000, 2000, 3000, 5000, 10000]


def show_fast_cash_menu() -> int | None:
    """
    Display preset cash options and return the user's chosen amount.
    Returns None if the user cancels (presses 0).
    """
    print("\n" + "=" * 40)
    print("       *** FAST CASH ***")
    print("=" * 40)

    # Print each option with a number key, formatted in two columns
    for i, amount in enumerate(FAST_CASH_OPTIONS, start=1):
        print(f"  [{i}] Rs. {amount:,}")

    print("  [0] Cancel / Back")
    print("-" * 40)

    while True:
        choice = input("Select option: ").strip()

        if choice == "0":
            return None  # user wants to go back

        # isdigit() ensures no letters or symbols entered
        if choice.isdigit() and 1 <= int(choice) <= len(FAST_CASH_OPTIONS):
            return FAST_CASH_OPTIONS[int(choice) - 1]

        print("  ✗ Invalid choice. Please select a valid option.")


def run_fast_cash(pin: str) -> None:
    """
    Entry point called by main menu when user selects Fast Cash.
    Validates balance and deducts the chosen preset amount.
    """
    account = database.get_account(pin)

    amount = show_fast_cash_menu()
    if amount is None:
        print("\n  ← Returning to main menu...")
        return

    # Check if account has enough funds before proceeding
    if amount > account["balance"]:
        print(f"\n  ✗ Insufficient balance! Your balance is Rs. {account['balance']:,.2f}")
        return

    # Deduct amount and record the transaction in shared database
    account["balance"] -= amount
    database.record_transaction(pin, "Fast Cash", amount)

    print("\n" + "=" * 40)
    print(f"  ✓ Please collect Rs. {amount:,}")
    print(f"  Remaining Balance: Rs. {account['balance']:,.2f}")
    print("=" * 40)
