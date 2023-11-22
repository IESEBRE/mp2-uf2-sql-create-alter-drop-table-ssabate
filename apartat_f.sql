ALTER TABLE inventories
    ADD(PRODUCT_ID NUMBER(12) CONSTRAINT inv_product_id REFERENCES products ON DELETE CASCADE,
        WAREHOUSE_ID NUMBER(12) CONSTRAINT inv_warehouse_id REFERENCES warehouses ON DELETE CASCADE,
        CONSTRAINT inv_product_id_warehouse_id_pk PRIMARY KEY(PRODUCT_ID, WAREHOUSE_ID)
        
);

ALTER TABLE inventories
    MODIFY(QUANTITY NUMBER(8) CONSTRAINT inv_quantity_nn NOT NULL);

