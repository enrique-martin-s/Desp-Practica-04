Create USER IF NOT EXISTS pma_user@'%' IDENTIFIED BY 'pma_password';
GRANT ALL PRIVILEGES ON phpmyadmin.* TO pma_user@'%';
FLUSH PRIVILEGES;