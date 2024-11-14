CREATE TABLE lamps (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_product INT NOT NULL,
    location VARCHAR(255) NOT NULL,
    installation_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL
);
