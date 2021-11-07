DROP TABLE IF EXISTS mobile_obj;
CREATE TABLE mobile_obj
(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Название объекта',
	garage_number VARCHAR(10),
	is_active BIT DEFAULT 1
);

DROP TABLE IF EXISTS mobile_obj_driver;
CREATE TABLE mobile_obj_driver
( 
	id_mobile_obj BIGINT UNSIGNED NOT NULL,
	id_driver BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (id_mobile_obj, id_driver)
);

DROP TABLE IF EXISTS driver;
CREATE TABLE driver
( 
	id SERIAL PRIMARY KEY,
	fio VARCHAR(255),
	phone VARCHAR(10),
	is_active BIT DEFAULT 1
);

DROP TABLE IF EXISTS color;
CREATE TABLE color
( 
	id SERIAL PRIMARY KEY,
	name_color VARCHAR(255)
);

DROP TABLE IF EXISTS color_type;
CREATE TABLE color_type
( 
	id SERIAL PRIMARY KEY,
	name_type VARCHAR(255)
);

DROP TABLE IF EXISTS type_obj;
CREATE TABLE type_obj
( 
	id SERIAL PRIMARY KEY,
	name_type VARCHAR(255)
);

DROP TABLE IF EXISTS brand;
CREATE TABLE brand
( 
	id SERIAL PRIMARY KEY,
	name_brand VARCHAR(255)
);

DROP TABLE IF EXISTS type_driver;
CREATE TABLE type_driver
( 
	id SERIAL PRIMARY KEY,
	name_type VARCHAR(255)
);

DROP TABLE IF EXISTS sex;
CREATE TABLE sex
( 
	id SERIAL PRIMARY KEY,
	name_sex BIT DEFAULT 1 COMMENT '1 - male, 0 - female'
);


ALTER TABLE mobile_obj_driver ADD CONSTRAINT fk_mobile_obj_driver_driver
FOREIGN KEY (id_mobile_obj) REFERENCES mobile_obj(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE mobile_obj_driver ADD CONSTRAINT fk_mobile_obj_driver_mobile_obj
FOREIGN KEY (id_driver) REFERENCES driver(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE mobile_obj ADD COLUMN id_color BIGINT UNSIGNED NOT NULL, 
ADD COLUMN id_brand BIGINT UNSIGNED NOT NULL,
ADD COLUMN id_type_obj BIGINT UNSIGNED NOT NULL;

