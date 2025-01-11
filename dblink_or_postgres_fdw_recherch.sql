


CREATE DATABASE test1;

CREATE TABLE products (
 product_id serial PRIMARY KEY,
 product_name VARCHAR (255) NOT NULL,
 category_id INT NOT NULL
);

INSERT INTO products (product_name, category_id)
VALUES
 ('iPhone', 1),
 ('Samsung Galaxy', 1),
 ('HP Elite', 2),
 ('Lenovo Thinkpad', 2),
 ('iPad', 3),
 ('Kindle Fire', 3);
 
SELECT * from products;

CREATE DATABASE test2;

CREATE TABLE categories (
 category_id serial PRIMARY KEY,
 category_name VARCHAR (255) NOT NULL
);

INSERT INTO categories (category_name)
VALUES
 ('Smart Phone'),
 ('Laptop'),
 ('Tablet');

SELECT * from categories;


Now you have two tables test1.products and test2.categories.

You can configure  postgres_fdw extenstion in test2 database for cross database querying

=============================================PROCESS-1=======================================

https://www.youtube.com/watch?v=C3F2JFTcg8g


1) Install the extension

CREATE EXTENSION postgres_fdw;

2) Create the server connection

CREATE SERVER fdw_serv FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'localhost', dbname 'societyadmin_single_test', port '5432');

3) Create the user mapping

CREATE USER MAPPING FOR postgres SERVER fdw_serv OPTIONS (user 'postgres', password 'netware');

4) Import the data

DROP TABLE login_otp

IMPORT FOREIGN SCHEMA public FROM SERVER fdw_serv INTO public;


SELECT  * FROM  module_master ;


=============================================PROCESS-2=======================================


https://www.youtube.com/watch?v=G6gVuVms0tA

ALL ARE DONE IN test database FOR CONNECTION WITH societyadmin_single_test database

1>Create extension:-->

CREATE EXTENSION postgres_fdw;

2>Create a foreign server connection to societyadmin_single_test:-->

CREATE SERVER societyadmin_single_test_server FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'localhost', dbname 'societyadmin_single_test', port '5432')

3>Create user mapping:-->

CREATE USER MAPPING FOR postgres SERVER societyadmin_single_test_server OPTIONS (user 'postgres',password 'netware')

4>Create foreign table:-->

CREATE FOREIGN TABLE foreign_society_master_dtl_table
(
    config_id integer,
    branch_id integer,
    param_key character varying,
    param_value character varying,
    active_ind character varying(2),
    effective_from timestamp without time zone,
    create_user character varying(50),
    create_date timestamp without time zone NOT NULL,
    update_user character varying(50),
    update_date timestamp without time zone
)
SERVER societyadmin_single_test_server OPTIONS (table_name 'society_master_dtl')

CREATE FOREIGN TABLE foreign_block_master_table
(
    block_id integer,
    block_name character varying,
    dist_code character varying
)
SERVER societyadmin_single_test_server OPTIONS (table_name 'block_master')


=============================================PROCESS-3=======================================


CREATE EXTENSION dblink;

SELECT * FROM public.dblink ('host=localhost dbname=societyadmin_single port=5432 user=postgres password=netware','SELECT config_id,branch_id,param_key,param_value,active_ind FROM society_master_dtl')
AS DATA( config_id integer,branch_id integer, param_key character varying, param_value character varying,active_ind character varying(2))

CREATE EXTENSION dblink;

SELECT * FROM public.dblink ('host=localhost dbname=societyadmin_single port=5432 user=postgres password=netware','SELECT block_id,block_name,dist_code FROM block_master order by block_id desc')
AS DATA( block_id integer,block_name character varying, dist_code character varying)

============================================================================================


postgres=# SELECT * FROM postgres_fdw_get_connections() ORDER BY 1;

postgres=# SELECT postgres_fdw_disconnect('loopback1');

postgres=# SELECT postgres_fdw_disconnect_all();


============================================================================================


















