# ============================================================
# database.py — Central data store for the ATM system
# All modules import from here so data stays in sync across
# the entire session (one shared source of truth).
# ============================================================

from datetime import datetime

# ------------------------------------
# Sample accounts: PIN → account info
# ------------------------------------
# Each account holds: name, balance, and a transaction log
ACCOUNTS = {
    "1234": {
        "name": "Ali Hassan",
        "balance": 50000.00,
        "transactions": [
            {"type": "Deposit",   "amount": 50000.00, "date": "2025-04-01 09:00"},
            {"type": "Withdraw",  "amount":  5000.00, "date": "2025-04-10 14:30"},
            {"type": "Fast Cash", "amount":  2000.00, "date": "2025-04-15 11:15"},
            {"type": "Deposit",   "amount": 10000.00, "date": "2025-04-20 16:45"},
            {"type": "Withdraw",  "amount":  3000.00, "date": "2025-04-25 10:00"},
        ],
    },
    "5678": {
        "name": "Sara Khan",
        "balance": 25000.00,
        "transactions": [
            {"type": "Deposit",   "amount": 25000.00, "date": "2025-03-15 10:00"},
            {"type": "Withdraw",  "amount":  2000.00, "date": "2025-04-05 13:00"},
            {"type": "Fast Cash", "amount":  1000.00, "date": "2025-04-18 09:30"},
        ],
    },
}


def get_account(pin: str) -> dict | None:
    """Return the account dict for the given PIN, or None if not found."""
    return ACCOUNTS.get(pin)


def record_transaction(pin: str, txn_type: str, amount: float) -> None:
    """
    Append a new transaction to account history.
    Called by fast_cash / withdraw after every successful deduction.
    datetime.now() captures the exact moment of transaction.
    """
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")
    ACCOUNTS[pin]["transactions"].append({
        "type":   txn_type,
        "amount": amount,
        "date":   timestamp,
    })
