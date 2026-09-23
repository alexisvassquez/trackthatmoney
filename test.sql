CREATE TABLE test (
    id SERIAL PRIMARY KEY,
    note TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

INSERT INTO test (note) VALUES ('it works');

SELECT * FROM test;