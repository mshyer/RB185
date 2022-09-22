DATABASE_NAME=$1

dropdb $DATABASE_NAME
createdb $DATABASE_NAME

psql -d $DATABASE_NAME < schema.sql