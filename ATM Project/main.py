# ============================================================
# main.py — ATM Controller (Entry Point)
# Handles PIN authentication and routes user to the correct
# module. Each feature lives in its own file but shares the
# same database.py, so all changes reflect everywhere.
#
# Run this file:  python main.py
# Test PINs:  1234 (Ali Hassan)  |  5678 (Sara Khan)
# ============================================================

import database        # shared account data
import fast_cash       # Module 1
import balance_check   # Module 2
import withdraw        # Module 3
import mini_statement  # Module 4

MAX_PIN_ATTEMPTS = 3   # lock out after 3 wrong PINs


# ──────────────────────────────────────────
# Helper: clear-style separator
# ──────────────────────────────────────────
def print_header() -> None:
    print("\n" + "=" * 40)
    print("     WELCOME TO PYTHON ATM")
    print("=" * 40)


# ──────────────────────────────────────────
# Step 1: PIN Authentication
# ──────────────────────────────────────────
def authenticate() -> str | None:
    """
    Ask for PIN up to MAX_PIN_ATTEMPTS times.
    Returns the valid PIN string on success, or None on lockout.
    """
    print_header()

    for attempt in range(1, MAX_PIN_ATTEMPTS + 1):
        # getpass could hide input, but input() keeps it simple & visible
        pin = input("  Enter your 4-digit PIN: ").strip()

        account = database.get_account(pin)
        if account:
            print(f"\n  ✓ Welcome, {account['name']}!")
            return pin  # authentication successful

        remaining = MAX_PIN_ATTEMPTS - attempt
        if remaining > 0:
            print(f"  ✗ Incorrect PIN. {remaining} attempt(s) remaining.")
        else:
            print("  ✗ Card blocked. Too many wrong attempts.")

    return None  # all attempts exhausted


# ──────────────────────────────────────────
# Step 2: Main Menu
# ──────────────────────────────────────────
def show_main_menu() -> str:
    """Display the 4 options and return the user's raw choice."""
    print("\n" + "=" * 40)
    print("          MAIN MENU")
    print("=" * 40)
    print("  [1] Fast Cash")
    print("  [2] Balance Check")
    print("  [3] Withdraw")
    print("  [4] Mini Statement")
    print("  [0] Exit")
    print("-" * 40)
    return input("  Choose an option: ").strip()


# ──────────────────────────────────────────
# Step 3: Route choice → correct module
# ──────────────────────────────────────────
def route(choice: str, pin: str) -> bool:
    """
    Call the right module based on menu choice.
    Returns False when user wants to exit, True to keep looping.

    Each module receives the PIN so it can look up the account
    from the shared database independently.
    """
    if choice == "1":
        fast_cash.run_fast_cash(pin)          # Module 1

    elif choice == "2":
        balance_check.run_balance_check(pin)  # Module 2

    elif choice == "3":
        withdraw.run_withdraw(pin)            # Module 3

    elif choice == "4":
        mini_statement.run_mini_statement(pin)  # Module 4

    elif choice == "0":
        print("\n  Thank you for using Python ATM. Goodbye!\n")
        return False  # signal the loop to stop

    else:
        print("  ✗ Invalid option. Please choose 1–4 or 0.")

    return True  # keep showing menu


# ──────────────────────────────────────────
# Main Program Loop
# ──────────────────────────────────────────
def main() -> None:
    """
    Top-level function: authenticate once, then loop the menu
    until the user exits or presses 0.
    """
    pin = authenticate()

    # If PIN auth failed (returned None), stop immediately
    if pin is None:
        return

    # Keep showing menu until user selects Exit (0)
    running = True
    while running:
        choice = show_main_menu()
        running = route(choice, pin)


# ──────────────────────────────────────────
# Guard: only run when executed directly
# (not when imported by another module)
# ──────────────────────────────────────────
if __name__ == "__main__":
    main()
