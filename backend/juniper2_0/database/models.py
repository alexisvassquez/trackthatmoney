# Track That Money
# backend/juniper2_0/database/models.py
#
# SQLAlchemy ORM model for the expenses table.
# Each ExpenseRecord row represents one logged expense.
# The schema mirrors the Pydantic Expense model in api.py
# Journal entry model

from sqlalchemy import Column, String, Float, Integer
from .database import Base

class ExpenseRecord(Base):
    """
    Maps to the 'expenses' table in trackthatmoney.db
    Created automatically on startup via Base.metadata.create_all()
    """
    __tablename__ = "expenses"

    # Server-generated fields
    # UUID
    id = Column(String, primary_key=True, index=True)
    # from auth token
    user_id = Column(String, nullable=False)
    # ISO timestamp
    posted_at = Column(String, nullable=False)

    # Core expense fields
    # Required on every submission
    merchant = Column(String, nullable=False)
    category = Column(String, nullable=False)
    amount = Column(String, nullable=False)

    # Optional fields
    # Enrich Juniper's (AI) response quality
    # 1 = essential, 0 = discretionary
    is_essential = Column(Integer, default=0)
    # 1 = is recurring payment, 0 = false
    is_subscription = Column(Integer, default=0)
    # 0.0-1.0 stress score
    mood_score = Column(Float, nullable=True)
    # e.g., "stressed", "celebratory", etc
    mood_tag = Column(String, nullable=True)
    # % this expense affects savings goals
    goal_contribution = Column(Float, default=0.0)
    # user's free-text note
    note = Column(String, nullable=True)
    # "Monday", "Tuesday", etc.
    entry_day_of_week = Column(String, nullable=True)
    # Time of day e.g., "evening", "morning"
    entry_time = Column(String, nullable=True)

    # Juniper2.0 response stored alongside the expense
    # to be resurfaced without re-calling the engine
    juniper_message = Column(String, nullable=True)

class JournalEntry(Base):
    """
    Maps to the 'journal_entries' table in trackthatmoney.db
    Each entry is an emotional annotation that is optionally linked
    to an expense.
    Created automatically on startup via Base.metadata.create_all()
    """
    __tablename__ = "journal_entries"

    # Server-generated fields
    # UUID
    id = Column(String, primary_key=True, index=True)
    # from auth token
    user_id = Column(String, nullable=False)
    # ISO timestamp
    created_at = Column(String, nullable=False)

    # Optional link to a specific expense
    # Null means the entry is a standalone reflection
    # Journal entry does not have to be linked to an expense
    expense_id = Column(String, nullable=True, index=True)

    # Core content
    # the user's written reflection
    content = Column(String, nullable=False)
    # Mood tag, e.g. "stressed", "hopeful", etc.
    mood_tag = Column(String, nullable=True)

    # Juniper2.0 response to this entry
    # Null if ceiling was triggered and redirected to resources
    juniper_response = Column(String, nullable=True)

    # Whether the ceiling was triggered
    # Stores the category: "crisis_financial", "crisis_emotional",
    # "advice_seeking"
    ceiling_triggered = Column(String, nullable=True)