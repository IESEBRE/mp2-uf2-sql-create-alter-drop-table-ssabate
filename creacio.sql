-- Borrem totes les relacions i restriccions
DROP TABLE regions CASCADE CONSTRAINTS;
DROP TABLE countries CASCADE CONSTRAINTS;
DROP TABLE locations CASCADE CONSTRAINTS;
DROP TABLE inventories CASCADE CONSTRAINTS;
DROP TABLE warehouses CASCADE CONSTRAINTS;
DROP TABLE products CASCADE CONSTRAINTS;
DROP TABLE product_categories CASCADE CONSTRAINTS;
DROP TABLE contacts CASCADE CONSTRAINTS;
DROP TABLE customers CASCADE CONSTRAINTS;
DROP TABLE orders CASCADE CONSTRAINTS;
DROP TABLE order_items CASCADE CONSTRAINTS;
DROP TABLE employees CASCADE CONSTRAINTS;

-- Apartat b.

CREATE TABLE regions(
    REGION_ID NUMBER CONSTRAINT reg_region_id_pk PRIMARY KEY,
    REGION_NAME VARCHAR2(50 BYTE) CONSTRAINT reg_regio_name_nn NOT NULL
    );
    
    
CREATE TABLE countries(
    COUNTRY_ID CHAR(2 BYTE) CONSTRAINT cou_country_id_pk PRIMARY KEY,
    COUNTRY_NAME VARCHAR2(40 BYTE) CONSTRAINT cou_country_name_nn NOT NULL,
    REGION_ID NUMBER CONSTRAINT cou_region_id_fk REFERENCES REGIONS(REGION_ID) ON DELETE SET NULL
    );
    
CREATE TABLE locations(
    LOCATION_ID NUMBER CONSTRAINT loc_location_id_pk PRIMARY KEY,
    ADDRESS VARCHAR2(255 BYTE) CONSTRAINT loc_address_nn NOT NULL,
    POSTAL_CODE VARCHAR2(20 BYTE),
    CITY VARCHAR2(50 BYTE),
    STATE VARCHAR2(50 BYTE),
    COUNTRY_ID CHAR(2 BYTE) CONSTRAINT loc_country_id_fk REFERENCES COUNTRIES ON DELETE SET NULL
    );

/*
A continuació ficaré les sentències de creació dels
apartats c,d i e
*/

CREATE TABLE inventories(
    QUANTITY NUMBER
);

CREATE TABLE warehouses(
    WAREHOUSE_ID NUMBER CONSTRAINT war_warehouse_id_pk PRIMARY KEY,
    WAREHOUSE_NAME VARCHAR2(255 BYTE),
    LOCATION_ID NUMBER(12) CONSTRAINT war_location_id_fk REFERENCES LOCATIONS ON DELETE SET NULL
    );
    
CREATE TABLE products(
    PRODUCT_ID NUMBER CONSTRAINT pro_product_id_pk PRIMARY KEY,
    PRODUCT_NAME VARCHAR2(255 BYTE) CONSTRAINT pro_product_name_nn NOT NULL,
    DESCRIPTION VARCHAR2(2000 BYTE),
    STANDARD_COST NUMBER(9, 2),
    LIST_PRICE NUMBER(9, 2));


-- Fem sentències apartat f

ALTER TABLE inventories
    ADD(PRODUCT_ID NUMBER(12) CONSTRAINT inv_product_id_fk REFERENCES PRODUCTS ON DELETE CASCADE,
        WAREHOUSE_ID NUMBER(12) ,  -- CONSTRAINT inv_warehouse_id_fk REFERENCES warehouses ON DELETE SET NULL,
        CONSTRAINT inv_product_id_warehouse_id_pk PRIMARY KEY(PRODUCT_ID,WAREHOUSE_ID),
        CONSTRAINT inv_warehouse_id_fk FOREIGN KEY(warehouse_id) REFERENCES warehouses ON DELETE SET NULL
);

ALTER TABLE inventories
    MODIFY( QUANTITY NUMBER(8) CONSTRAINT inv_quantity_nn NOT NULL

);

-- Fem sentències apartat g

-- i.
CREATE TABLE PRODUCT_CATEGORIES(
    CATEGORY_ID NUMBER CONSTRAINT pro_ca_category_id_pk PRIMARY KEY,
    CATEGORY_NAME VARCHAR2(255 BYTE) DEFAULT 'ANONIMA' CONSTRAINT pro_ca_category_name_nn NOT NULL
);

-- ii.
ALTER TABLE products
    ADD(CATEGORY_ID NUMBER CONSTRAINT pro_category_id_nn NOT NULL CONSTRAINT pro_category_id_fk REFERENCES product_categories ON DELETE CASCADE--,
    --CONSTRAINT pro_category_id_fk FOREIGN KEY(CATEGORY_ID) REFERENCES product_categories ON DELETE CASCADE 
);

-- iii.
--ALTER TABLE products
--    MODIFY(LIST_PRICE CONSTRAINT pro_list_price_ck CHECK(LIST_PRICE>=0)    
--);
ALTER TABLE products
    ADD(CONSTRAINT pro_list_price_ck CHECK(LIST_PRICE>=0)    
);

-- iv. Relació CONTACTS
CREATE TABLE contacts(
    contact_id NUMBER CONSTRAINT con_contact_id_pk PRIMARY KEY,
    FIRST_NAME VARCHAR2(255) CONSTRAINT con_first_name_nn NOT NULL,
    LAST_NAME VARCHAR2(255) CONSTRAINT con_last_name_nn NOT NULL,
    email VARCHAR2(255)  CONSTRAINT con_email_nn NOT NULL,
    phone VARCHAR2(20 BYTE)
);

-- vi.
ALTER TABLE contacts
    MODIFY( email CONSTRAINT con_email_ck CHECK(email like '%_@_%._%')
);

-- iv. Relació CUSTOMERS
CREATE TABLE customers(
    customer_id NUMBER CONSTRAINT cus_customer_id_pk PRIMARY KEY,
    NAME VARCHAR2(255) CONSTRAINT cus_name_nn NOT NULL,
    ADDRESS VARCHAR2(255),
    WEBSITE VARCHAR2(255),
    CREDIT_LIMIT NUMBER(8, 2)
);

-- v. Relació ORDERS
CREATE TABLE orders(
    customer_id NUMBER CONSTRAINT ord_customer_id_nn NOT NULL CONSTRAINT ord_customer_id_fk REFERENCES customers ON DELETE CASCADE,
    order_id NUMBER(6) CONSTRAINT ord_order_id_pk PRIMARY KEY,
    status VARCHAR2(20 BYTE) CONSTRAINT ord_status_nn NOT NULL,
    order_date DATE CONSTRAINT ord_order_date_nn NOT NULL    ,
    salesman_id NUMBER(6)       --no la vaig posar a classe
);

-- vii. Relació ORDER_ITEMS
CREATE TABLE order_items(
    item_id NUMBER(12),
    order_id NUMBER(12) CONSTRAINT ord_it_order_id_fk REFERENCES orders ON DELETE CASCADE,
    product_id NUMBER(12) CONSTRAINT ord_it_product_id_fk REFERENCES products ON DELETE CASCADE,
    quantity NUMBER(8,2) DEFAULT 1 CONSTRAINT ord_it_quantity_nn NOT NULL, 
    unit_price NUMBER(8,2) CONSTRAINT ord_it_unit_price_ck CHECK(unit_price>=0) CONSTRAINT ord_it_unit_price_nn NOT NULL,  
    CONSTRAINT ord_it_order_id_item_id_pk PRIMARY KEY(order_id, item_id)    
);


-- viii. Relació EMPLOYEES 
CREATE TABLE employees(
    employee_id NUMBER CONSTRAINT emp_employee_id_pk PRIMARY KEY,
    first_name VARCHAR2(255) CONSTRAINT emp_first_name_nn NOT NULL,
    last_name VARCHAR2(255) CONSTRAINT emp_last_name_nn NOT NULL,
    email VARCHAR2(255) CONSTRAINT emp_email_nn NOT NULL,
    phone VARCHAR2(50 BYTE) CONSTRAINT emp_phone_nn NOT NULL,
    hire_date DATE CONSTRAINT emp_hire_date_nn NOT NULL,
    job_title VARCHAR2(255) CONSTRAINT emp_job_title_nn NOT NULL,
    manager_id NUMBER(12) CONSTRAINT emp_manager_id_fk REFERENCES employees(employee_id) ON DELETE SET NULL    
);

-- ix. Claus foranes entre ORDERS en EMPLOYEES, i entre CUSTOMERS en CONTACTS 
-- entre ORDERS en EMPLOYEES
ALTER TABLE orders
    ADD(CONSTRAINT ord_salesman_id_fk FOREIGN KEY(salesman_id) REFERENCES employees(employee_id) ON DELETE SET NULL
);

-- entre CUSTOMERS en CONTACTS 
ALTER TABLE contacts
    ADD(customer_id NUMBER CONSTRAINT con_customer_id_fk REFERENCES customers ON DELETE SET NULL
);

