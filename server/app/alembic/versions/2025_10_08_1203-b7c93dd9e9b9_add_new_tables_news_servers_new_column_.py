"""add new tables news, servers; new column in settings.skin_url

Revision ID: b7c93dd9e9b9
Revises: 7bdaef20ca27
Create Date: 2025-10-08 12:03:38.652423

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'b7c93dd9e9b9'
down_revision: Union[str, Sequence[str], None] = '7bdaef20ca27'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    pass


def downgrade() -> None:
    """Downgrade schema."""
    pass
