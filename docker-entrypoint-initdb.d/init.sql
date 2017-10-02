psql -v ON_ERROR_STOP=1 -U postgres <<-EOSQL
    CREATE USER triangle WITH CREATEDB;
    CREATE DATABASE triangle_dev OWNER triangle;
EOSQL

