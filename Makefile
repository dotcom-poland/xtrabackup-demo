start:
	docker-compose up -d

stop:	clean
	-docker-compose down --remove-orphans -v --rmi all

clean:
	-docker-compose exec percona bash -c 'rm -rf /mysql-backup/*'

backup:
	docker-compose exec percona xtrabackup --backup --target_dir=/mysql-backup

corrupt:
	@docker-compose stop mysql
	docker-compose exec percona bash -c 'rm -rf /var/lib/mysql/classicmodels/customers* || true'
	@docker-compose start mysql

list_customers:
	docker-compose exec mysql mysqldump -uroot -ptoor classicmodels customers

restore:
	-docker-compose stop mysql
	-docker-compose exec percona bash -c 'rm -rf /var/lib/mysql/*'
	docker-compose exec percona xtrabackup --prepare --target_dir=/mysql-backup
	docker-compose exec percona xtrabackup --copy-back --target_dir=/mysql-backup --datadir=/var/lib/mysql
	docker-compose exec percona bash -c 'chown 999:999 /var/lib/mysql -R'
	docker-compose start mysql
