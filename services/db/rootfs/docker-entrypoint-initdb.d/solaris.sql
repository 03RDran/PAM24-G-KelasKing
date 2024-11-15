CREATE TABLE `users` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) UNIQUE NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `lamps` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `id_product` INT NOT NULL,
  `location` VARCHAR(255) NOT NULL,
  `installation_date` DATE NOT NULL,
  `status` VARCHAR(50) NOT NULL,
  `owner_id` INT NOT NULL
);

CREATE TABLE `settings` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `setting_key` VARCHAR(100) NOT NULL,
  `setting_value` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  `updated_at` TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `sensor_data` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `lamp_id` INT NOT NULL,
  `sensor_key` VARCHAR(100) NOT NULL,
  `sensor_value` FLOAT NOT NULL,
  `recorded_at` TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

ALTER TABLE `lamps` ADD FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`);

ALTER TABLE `settings` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `sensor_data` ADD FOREIGN KEY (`lamp_id`) REFERENCES `lamps` (`id`);
