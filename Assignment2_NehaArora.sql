/* COMP 2138  - Assignment 2
 * Name       - Neha Arora
 * Student ID - 101043939
 */
 
 /*Ques 1: */
 CREATE PROCEDURE insert_category
    ( category_num number,
      category_grpname  varchar2)
        AS 
        BEGIN 
        INSERT INTO CATEGORIES (category_id, category_name) 
        VALUES (category_num, category_grpname); 
        END;
        /
 
 CALL insert_category(5, 'Paino');
 CALL insert_category(6, 'Harmonium');
 
 
 /*Ques 2: */
 CREATE OR REPLACE FUNCTION fndiscount_price (item_num_param    NUMBER)
     RETURN NUMBER
     AS discount_price_var NUMBER;
     BEGIN
       SELECT SUM(ITEM_PRICE - DISCOUNT_AMOUNT) AS discount_price
       INTO discount_price_var
       FROM ORDER_ITEMS
       WHERE ITEM_ID = item_num_param;
     RETURN discount_price_var;
END;
/

SELECT ITEM_ID, ITEM_PRICE, DISCOUNT_AMOUNT, fndiscount_price(ITEM_ID) AS discount_price
FROM ORDER_ITEMS;
 
 
 /*Ques 3: */

 CREATE OR REPLACE TRIGGER products_before_update 
      BEFORE UPDATE OF DISCOUNT_PERCENT
      ON PRODUCTS
      FOR EACH ROW
      BEGIN
        IF (:NEW.DISCOUNT_PERCENT >= 0) OR (:NEW.DISCOUNT_PERCENT <= 1) THEN
        :NEW.DISCOUNT_PERCENT := :NEW.DISCOUNT_PERCENT * 100;
          
        ELSIF (:NEW.DISCOUNT_PERCENT < 0) AND (:NEW.DISCOUNT_PERCENT > 100) THEN
        RAISE_APPLICATION_ERROR(-20001, 'The discount percent cannot be  less than zero or greater than 100');
     END IF;
 END;
 
 UPDATE PRODUCTS SET DISCOUNT_PERCENT = -1 WHERE PRODUCT_ID = 3;
 UPDATE PRODUCTS SET DISCOUNT_PERCENT = 1 WHERE PRODUCT_ID = 5;
 SELECT PRODUCT_ID, DISCOUNT_PERCENT FROM PRODUCTS;
 
 
 /*Ques 4: */
 CREATE TRIGGER products_before_insert 
   BEFORE INSERT ON PRODUCTS
   FOR EACH ROW 
   BEGIN
   IF (:NEW.DATE_ADDED IS NULL) THEN
     :NEW.DATE_ADDED := SYSDATE;
   END IF;
   END;
  /
  
  INSERT INTO PRODUCTS 
  VALUES(7,3,'GHE-23','MIDI KEYBOARD','32 KEY MIDI CONTROLLER',200,1,NULL);