"""is_planned not null with server default

Revision ID: d2af1bcb09cc
Revises: 0ddf4478481c
Create Date: 2026-11-10 15:58:01.764517

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'd2af1bcb09cc'
down_revision: Union[str, Sequence[str], None] = '0ddf4478481c'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    op.execute("UPDATE expenses SET is_planned = 0 WHERE is_planned IS NULL")
    op.alter_column("expenses", "is_planned", server_default="0", nullable=False)


def downgrade() -> None:
    """Downgrade schema."""
    op.alter_column("expenses", "is_planned", server_default=None, nullable=True)
    
