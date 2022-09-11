start:
	docker-compose up -d

stop:	clean
	-docker-compose down --remove-orphans -v --rmi all

clean:
	-docker-compose exec ubuntu bash -c 'rm -rf /mysql-backup/*'

install:
	docker-compose exec ubuntu apt update
	docker-compose exec ubuntu apt install -y curl ca-certificates
	docker-compose exec ubuntu curl -o x.deb https://downloads.percona.com/downloads/Percona-XtraBackup-2.4/Percona-XtraBackup-2.4.26/binary/debian/focal/x86_64/percona-xtrabackup-24_2.4.26-1.focal_amd64.deb
	-docker-compose exec ubuntu dpkg -i x.deb
	docker-compose exec ubuntu rm x.deb
	docker-compose exec ubuntu apt-get -y -f install

backup:
	docker-compose exec ubuntu xtrabackup --backup --target_dir=/mysql-backup

corrupt:
	@docker-compose stop mysql
	docker-compose exec ubuntu bash -c 'rm -rf /var/lib/mysql/classicmodels/customers* || true'
	@docker-compose start mysql

list_customers:
	docker-compose exec mysql mysqldump -uroot -ptoor classicmodels customers

restore:
	-docker-compose stop mysql
	-docker-compose exec ubuntu bash -c 'rm -rf /var/lib/mysql/*'
	docker-compose exec ubuntu xtrabackup --prepare --target_dir=/mysql-backup
	docker-compose exec ubuntu xtrabackup --copy-back --target_dir=/mysql-backup --datadir=/var/lib/mysql
	docker-compose exec ubuntu bash -c 'chown 999:999 /var/lib/mysql -R'
	docker-compose start mysql
