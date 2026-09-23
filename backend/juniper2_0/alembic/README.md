# Migrations

Run from `backend/juniper2_0/`.

- After changing models: `alembic revision --autogenerate -m "describe the change"`
- Review the new file in `alembic/versions/`
- Apply locally: `alembic upgrade head`
- Railway applies migrations automatically via the pre-deploy command