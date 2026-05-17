# ============================================================
# withdraw.py — Module 3: Withdraw
# Allows the user to enter a custom amount to withdraw.
# Validates the amount before deducting from balance.
# ============================================================

import database  # shared data store

# ATM typically dispenses notes of 500, so amount must be multiple of 500
NOTE_DENOMINATION = 500
# Single transaction withdrawal limit
MAX_WITHDRAW_LIMIT = 25000


def get_withdraw_amount() -> float | None:
    """
    Prompt user to enter withdrawal amount and validate it.
    Returns the valid amount as float, or None if user cancels.
    """
    print("\n" + "=" * 40)
    print("       *** WITHDRAW CASH ***")
    print("=" * 40)
    print(f"  • Multiples of Rs. {NOTE_DENOMINATION} only")
    print(f"  • Max per transaction: Rs. {MAX_WITHDRAW_LIMIT:,}")
    print("  • Enter 0 to Cancel")
    print("-" * 40)

    while True:
        user_input = input("  Enter Amount: Rs. ").strip()

        # Check if input is a valid whole number (no letters/symbols)
        if not user_input.isdigit():
            print("  ✗ Please enter a valid numeric amount.")
            continue

        amount = int(user_input)

        if amount == 0:
            return None  # user wants to cancel

        if amount % NOTE_DENOMINATION != 0:
            print(f"  ✗ Amount must be a multiple of Rs. {NOTE_DENOMINATION}.")
            continue

        if amount > MAX_WITHDRAW_LIMIT:
            print(f"  ✗ Exceeds max limit of Rs. {MAX_WITHDRAW_LIMIT:,} per transaction.")
            continue

        return float(amount)  # valid amount


def run_withdraw(pin: str) -> None:
    """
    Entry point called by main menu when user selects Withdraw.
    Gets amount, checks balance, deducts, and records transaction.
    """
    account = database.get_account(pin)

    amount = get_withdraw_amount()
    if amount is None:
        print("\n  ← Returning to main menu...")
        return

    # Guard against withdrawing more than available balance
    if amount > account["balance"]:
        print(f"\n  ✗ Insufficient funds!")
        print(f"  Your balance is Rs. {account['balance']:,.2f}")
        return

    # Deduct from in-memory balance and save transaction record
    account["balance"] -= amount
    database.record_transaction(pin, "Withdraw", amount)

    print("\n" + "=" * 40)
    print(f"  ✓ Please collect Rs. {amount:,.2f}")
    print(f"  Remaining Balance: Rs. {account['balance']:,.2f}")
    print("=" * 40)
