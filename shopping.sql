
CREATE TABLE member
(
	id                    VARCHAR2(20)  NOT NULL ,
	name                  VARCHAR2(50)  NULL ,
	pwd                   VARCHAR2(20)  NULL ,
	tel                   VARCHAR2(13)  NULL ,
	address               VARCHAR2(20)  NULL ,
	indate                DATE  NULL ,
	zipcide               VARCHAR2(7)  NULL 
);



CREATE UNIQUE INDEX XPK고객 ON member
(id  ASC);



ALTER TABLE member
	ADD CONSTRAINT  XPK고객 PRIMARY KEY (id);



CREATE TABLE orders
(
	id                    VARCHAR2(20)  NULL ,
	product_code          VARCHAR2(20)  NULL ,
	o_seq                 NUMBER(10)  NOT NULL ,
	product_size          VARCHAR2(5)  NULL ,
	quantity              VARCHAR2(5)  NULL ,
	result                CHAR(1)  NULL ,
	indate                DATE  NULL 
);



CREATE UNIQUE INDEX XPK주문 ON orders
(o_seq  ASC);



ALTER TABLE orders
	ADD CONSTRAINT  XPK주문 PRIMARY KEY (o_seq);



CREATE TABLE products
(
	product_code          VARCHAR2(20)  NOT NULL ,
	product_name          VARCHAR2(100)  NULL ,
	product_kind          CHAR(1)  NULL ,
	product_price1        VARCHAR2(10)  NULL ,
	product_price2        VARCHAR2(10)  NULL ,
	product_content       VARCHAR2(1000)  NULL ,
	product_image         VARCHAR2(50)  NULL ,
	sizeSt                VARCHAR2(5)  NULL ,
	sizeEt                VARCHAR2(5)  NULL ,
	product_quantity      VARCHAR2(5)  NULL ,
	indate                DATE  NULL ,
	useyn                 CHAR(1)  NULL 
);



CREATE UNIQUE INDEX XPK상품 ON products
(product_code  ASC);



ALTER TABLE products
	ADD CONSTRAINT  XPK상품 PRIMARY KEY (product_code);



CREATE TABLE tb_zipcode
(
	zipcide               VARCHAR2(7)  NOT NULL ,
	sido                  VARCHAR2(30)  NULL ,
	gugun                 VARCHAR2(30)  NULL ,
	dong                  VARCHAR2(30)  NULL ,
	bunji                 VARCHAR2(30)  NULL 
);



CREATE UNIQUE INDEX XPK우편번호 ON tb_zipcode
(zipcide  ASC);



ALTER TABLE tb_zipcode
	ADD CONSTRAINT  XPK우편번호 PRIMARY KEY (zipcide);



ALTER TABLE member
	ADD (CONSTRAINT  R_2 FOREIGN KEY (zipcide) REFERENCES tb_zipcode(zipcide) ON DELETE SET NULL);



ALTER TABLE orders
	ADD (CONSTRAINT  R_3 FOREIGN KEY (id) REFERENCES member(id) ON DELETE SET NULL);



ALTER TABLE orders
	ADD (CONSTRAINT  R_5 FOREIGN KEY (product_code) REFERENCES products(product_code) ON DELETE SET NULL);



CREATE  TRIGGER tI_member BEFORE INSERT ON member for each row
-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
-- INSERT trigger on member 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin 2022년 5월 24일 ?요일 오후 3:43:55 */
    /* tb_zipcode  member on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0000efde", PARENT_OWNER="", PARENT_TABLE="tb_zipcode"
    CHILD_OWNER="", CHILD_TABLE="member"
    P2C_VERB_PHRASE="R/2", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="zipcide" */
    UPDATE member
      SET
        /* %SetFK(member,NULL) */
        member.zipcide = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM tb_zipcode
            WHERE
              /* %JoinFKPK(:%New,tb_zipcode," = "," AND") */
              :new.zipcide = tb_zipcode.zipcide
        ) 
        /* %JoinPKPK(member,:%New," = "," AND") */
         and member.id = :new.id;


-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
END;
/

CREATE  TRIGGER tD_member AFTER DELETE ON member for each row
-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
-- DELETE trigger on member 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin 2022년 5월 24일 ?요일 오후 3:43:55 */
    /* member  orders on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0000abf5", PARENT_OWNER="", PARENT_TABLE="member"
    CHILD_OWNER="", CHILD_TABLE="orders"
    P2C_VERB_PHRASE="R/3", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="id" */
    UPDATE orders
      SET
        /* %SetFK(orders,NULL) */
        orders.id = NULL
      WHERE
        /* %JoinFKPK(orders,:%Old," = "," AND") */
        orders.id = :old.id;


-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
END;
/

CREATE  TRIGGER tU_member AFTER UPDATE ON member for each row
-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
-- UPDATE trigger on member 
DECLARE NUMROWS INTEGER;
BEGIN
  /* member  orders on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="0001dd54", PARENT_OWNER="", PARENT_TABLE="member"
    CHILD_OWNER="", CHILD_TABLE="orders"
    P2C_VERB_PHRASE="R/3", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="id" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.id <> :new.id
  THEN
    UPDATE orders
      SET
        /* %SetFK(orders,NULL) */
        orders.id = NULL
      WHERE
        /* %JoinFKPK(orders,:%Old," = ",",") */
        orders.id = :old.id;
  END IF;

  /* ERwin Builtin 2022년 5월 24일 ?요일 오후 3:43:55 */
  /* tb_zipcode  member on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="tb_zipcode"
    CHILD_OWNER="", CHILD_TABLE="member"
    P2C_VERB_PHRASE="R/2", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="zipcide" */
  SELECT count(*) INTO NUMROWS
    FROM tb_zipcode
    WHERE
      /* %JoinFKPK(:%New,tb_zipcode," = "," AND") */
      :new.zipcide = tb_zipcode.zipcide;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.zipcide IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update member because tb_zipcode does not exist.'
    );
  END IF;


-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
END;
/


CREATE  TRIGGER tI_orders BEFORE INSERT ON orders for each row
-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
-- INSERT trigger on orders 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin 2022년 5월 24일 ?요일 오후 3:43:55 */
    /* member  orders on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0001e376", PARENT_OWNER="", PARENT_TABLE="member"
    CHILD_OWNER="", CHILD_TABLE="orders"
    P2C_VERB_PHRASE="R/3", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="id" */
    UPDATE orders
      SET
        /* %SetFK(orders,NULL) */
        orders.id = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM member
            WHERE
              /* %JoinFKPK(:%New,member," = "," AND") */
              :new.id = member.id
        ) 
        /* %JoinPKPK(orders,:%New," = "," AND") */
         and orders.o_seq = :new.o_seq;

    /* ERwin Builtin 2022년 5월 24일 ?요일 오후 3:43:55 */
    /* products  orders on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="products"
    CHILD_OWNER="", CHILD_TABLE="orders"
    P2C_VERB_PHRASE="R/5", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="product_code" */
    UPDATE orders
      SET
        /* %SetFK(orders,NULL) */
        orders.product_code = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM products
            WHERE
              /* %JoinFKPK(:%New,products," = "," AND") */
              :new.product_code = products.product_code
        ) 
        /* %JoinPKPK(orders,:%New," = "," AND") */
         and orders.o_seq = :new.o_seq;


-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
END;
/

CREATE  TRIGGER tU_orders AFTER UPDATE ON orders for each row
-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
-- UPDATE trigger on orders 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin 2022년 5월 24일 ?요일 오후 3:43:55 */
  /* member  orders on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00021866", PARENT_OWNER="", PARENT_TABLE="member"
    CHILD_OWNER="", CHILD_TABLE="orders"
    P2C_VERB_PHRASE="R/3", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="id" */
  SELECT count(*) INTO NUMROWS
    FROM member
    WHERE
      /* %JoinFKPK(:%New,member," = "," AND") */
      :new.id = member.id;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.id IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update orders because member does not exist.'
    );
  END IF;

  /* ERwin Builtin 2022년 5월 24일 ?요일 오후 3:43:55 */
  /* products  orders on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="products"
    CHILD_OWNER="", CHILD_TABLE="orders"
    P2C_VERB_PHRASE="R/5", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="product_code" */
  SELECT count(*) INTO NUMROWS
    FROM products
    WHERE
      /* %JoinFKPK(:%New,products," = "," AND") */
      :new.product_code = products.product_code;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.product_code IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update orders because products does not exist.'
    );
  END IF;


-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
END;
/


CREATE  TRIGGER tD_products AFTER DELETE ON products for each row
-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
-- DELETE trigger on products 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin 2022년 5월 24일 ?요일 오후 3:43:55 */
    /* products  orders on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0000c09f", PARENT_OWNER="", PARENT_TABLE="products"
    CHILD_OWNER="", CHILD_TABLE="orders"
    P2C_VERB_PHRASE="R/5", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="product_code" */
    UPDATE orders
      SET
        /* %SetFK(orders,NULL) */
        orders.product_code = NULL
      WHERE
        /* %JoinFKPK(orders,:%Old," = "," AND") */
        orders.product_code = :old.product_code;


-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
END;
/

CREATE  TRIGGER tU_products AFTER UPDATE ON products for each row
-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
-- UPDATE trigger on products 
DECLARE NUMROWS INTEGER;
BEGIN
  /* products  orders on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="0000f12e", PARENT_OWNER="", PARENT_TABLE="products"
    CHILD_OWNER="", CHILD_TABLE="orders"
    P2C_VERB_PHRASE="R/5", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="product_code" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.product_code <> :new.product_code
  THEN
    UPDATE orders
      SET
        /* %SetFK(orders,NULL) */
        orders.product_code = NULL
      WHERE
        /* %JoinFKPK(orders,:%Old," = ",",") */
        orders.product_code = :old.product_code;
  END IF;


-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
END;
/


CREATE  TRIGGER tD_tb_zipcode AFTER DELETE ON tb_zipcode for each row
-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
-- DELETE trigger on tb_zipcode 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin 2022년 5월 24일 ?요일 오후 3:43:55 */
    /* tb_zipcode  member on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0000ba7d", PARENT_OWNER="", PARENT_TABLE="tb_zipcode"
    CHILD_OWNER="", CHILD_TABLE="member"
    P2C_VERB_PHRASE="R/2", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="zipcide" */
    UPDATE member
      SET
        /* %SetFK(member,NULL) */
        member.zipcide = NULL
      WHERE
        /* %JoinFKPK(member,:%Old," = "," AND") */
        member.zipcide = :old.zipcide;


-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
END;
/

CREATE  TRIGGER tU_tb_zipcode AFTER UPDATE ON tb_zipcode for each row
-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
-- UPDATE trigger on tb_zipcode 
DECLARE NUMROWS INTEGER;
BEGIN
  /* tb_zipcode  member on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="0000e55c", PARENT_OWNER="", PARENT_TABLE="tb_zipcode"
    CHILD_OWNER="", CHILD_TABLE="member"
    P2C_VERB_PHRASE="R/2", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="zipcide" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.zipcide <> :new.zipcide
  THEN
    UPDATE member
      SET
        /* %SetFK(member,NULL) */
        member.zipcide = NULL
      WHERE
        /* %JoinFKPK(member,:%Old," = ",",") */
        member.zipcide = :old.zipcide;
  END IF;


-- ERwin Builtin 2022년 5월 24일 화요일 오후 3:43:55
END;
/

