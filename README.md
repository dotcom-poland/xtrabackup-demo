Percona XtraBackup demo
=======================

Live Percona XtraBackup tool demo application in
[Docker](https://docs.docker.com/engine/install/ubuntu/).

* [Support my work](https://medium.com/@dotcom.software/membership)

## Usage

1. `make start` to create the project
2. `make list_customers` to dump customers
3. `make backup` to create the backup
4. `make corrupt` to corrupt the database!
5. `make list_customers` to try to dump customers again
6. `make restore` to restore the database from the backup
7. `make list_customers` to verify customers were restored
8. `make stop` to stop and clean everything

# Description

The project spawns two containers: `mysql` and `percona`. Both containers share the same volume
mounted to `/var/lib/mysql`. When the `mysql` container starts it's pre-populated using sql files
from the `mysqlsampledatabase.sql.gz`.

After the `make backup` step you will be able to see the backup files inside the local `mysql-backup`
directory. Contents of this directory can be removed with `make clean`. The contents of this directory
is also removed automatically during the `make stop`.

The `make stop`:
  * stops both containers
  * removes the volume
  * clears the `mysql-backup` directory
  * removes used images

## Credits

* [XtraBackup by Percona](https://www.percona.com/software/mysql-database/percona-xtrabackup)
* [MySQL 5.7](https://hub.docker.com/_/mysql)
* [Sample MySQL database by mysqltutorial.org](https://www.mysqltutorial.org/mysql-sample-database.aspx)
