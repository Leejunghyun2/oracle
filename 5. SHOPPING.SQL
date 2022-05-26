
CREATE TABLE inouts
(
	inout_number          NUMBER(10)  NOT NULL ,
	inout                 VARCHAR2(5)  NULL ,
	inout_date            DATE  NULL ,
	inout_quantity        VARCHAR2(20)  NULL ,
	product_code          VARCHAR2(20)  NULL ,
	store_code            VARCHAR2(20)  NULL 
);



CREATE UNIQUE INDEX XPK입출고 ON inouts
(inout_number  ASC);



ALTER TABLE inouts
	ADD CONSTRAINT  XPK입출고 PRIMARY KEY (inout_number);



CREATE TABLE job
(
	job_code              VARCHAR2(10)  NOT NULL ,
	job_name              VARCHAR2(20)  NULL ,
	yn                    CHAR(1)  NULL ,
	insert_date           DATE  NULL ,
	insert_name           VARCHAR2(10)  NULL 
);



CREATE UNIQUE INDEX XPK직업 ON job
(job_code  ASC);



ALTER TABLE job
	ADD CONSTRAINT  XPK직업 PRIMARY KEY (job_code);



CREATE TABLE member
(
	id                    VARCHAR2(20)  NOT NULL ,
	name                  VARCHAR2(50)  NULL ,
	pwd                   VARCHAR2(20)  NULL ,
	tel                   VARCHAR2(13)  NULL ,
	address               VARCHAR2(100)  NULL ,
	indate                DATE  NULL ,
	zipcode               VARCHAR2(7)  NULL ,
	job_code              VARCHAR2(10)  NULL 
);



CREATE UNIQUE INDEX XPK고객 ON member
(id  ASC);



ALTER TABLE member
	ADD CONSTRAINT  XPK고객 PRIMARY KEY (id);



CREATE TABLE orders
(
	id                    VARCHAR2(20)  NULL ,
	product_code          VARCHAR2(20)  NULL ,
	indate                DATE  NULL ,
	quantity              VARCHAR2(5)  NULL ,
	result                CHAR(1)  NULL ,
	o_seq                 NUMBER(10)  NOT NULL ,
	product_size          VARCHAR2(5)  NULL 
);



CREATE UNIQUE INDEX XPK주문 ON orders
(o_seq  ASC);



ALTER TABLE orders
	ADD CONSTRAINT  XPK주문 PRIMARY KEY (o_seq);



CREATE TABLE products
(
	product_code          VARCHAR2(20)  NOT NULL ,
	product_name          VARCHAR2(100)  NULL ,
	useyn                 CHAR(1)  NULL ,
	product_kind          CHAR(1)  NULL ,
	product_price1        VARCHAR2(10)  NULL ,
	product_price2        VARCHAR2(10)  NULL ,
	product_content       VARCHAR2(1000)  NULL ,
	product_image         VARCHAR2(50)  NULL ,
	sizeSt                VARCHAR2(5)  NULL ,
	sizeEt                VARCHAR2(5)  NULL ,
	product_quantity      VARCHAR2(5)  NULL ,
	indate                DATE  NULL 
);



CREATE UNIQUE INDEX XPK상품 ON products
(product_code  ASC);



ALTER TABLE products
	ADD CONSTRAINT  XPK상품 PRIMARY KEY (product_code);



CREATE TABLE store
(
	store_code            VARCHAR2(20)  NOT NULL ,
	store_name            VARCHAR2(20)  NULL ,
	store_place           VARCHAR2(30)  NULL ,
	store_date            DATE  NULL ,
	store_onner           VARCHAR2(10)  NULL 
);



CREATE UNIQUE INDEX XPK창고 ON store
(store_code  ASC);



ALTER TABLE store
	ADD CONSTRAINT  XPK창고 PRIMARY KEY (store_code);



CREATE TABLE tb_zipcode
(
	zipcode               VARCHAR2(7)  NOT NULL ,
	sido                  VARCHAR2(30)  NULL ,
	gugun                 VARCHAR2(30)  NULL ,
	dong                  VARCHAR2(30)  NULL ,
	bunji                 VARCHAR2(30)  NULL 
);



CREATE UNIQUE INDEX XPK우편번호 ON tb_zipcode
(zipcode  ASC);



ALTER TABLE tb_zipcode
	ADD CONSTRAINT  XPK우편번호 PRIMARY KEY (zipcode);



ALTER TABLE inouts
	ADD (CONSTRAINT  R_12 FOREIGN KEY (product_code) REFERENCES products(product_code) ON DELETE SET NULL);



ALTER TABLE inouts
	ADD (CONSTRAINT  R_13 FOREIGN KEY (store_code) REFERENCES store(store_code) ON DELETE SET NULL);



ALTER TABLE member
	ADD (CONSTRAINT  R_5 FOREIGN KEY (zipcode) REFERENCES tb_zipcode(zipcode) ON DELETE SET NULL);



ALTER TABLE member
	ADD (CONSTRAINT  R_11 FOREIGN KEY (job_code) REFERENCES job(job_code) ON DELETE SET NULL);



ALTER TABLE orders
	ADD (CONSTRAINT  R_7 FOREIGN KEY (id) REFERENCES member(id) ON DELETE SET NULL);



ALTER TABLE orders
	ADD (CONSTRAINT  R_9 FOREIGN KEY (product_code) REFERENCES products(product_code) ON DELETE SET NULL);



CREATE  TRIGGER tI_inouts BEFORE INSERT ON inouts for each row
-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
-- INSERT trigger on inouts 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
    /* products  inouts on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0001fe22", PARENT_OWNER="", PARENT_TABLE="products"
    CHILD_OWNER="", CHILD_TABLE="inouts"
    P2C_VERB_PHRASE="R/12", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="product_code" */
    UPDATE inouts
      SET
        /* %SetFK(inouts,NULL) */
        inouts.product_code = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM products
            WHERE
              /* %JoinFKPK(:%New,products," = "," AND") */
              :new.product_code = products.product_code
        ) 
        /* %JoinPKPK(inouts,:%New," = "," AND") */
         and inouts.inout_number = :new.inout_number;

    /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
    /* store  inouts on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="store"
    CHILD_OWNER="", CHILD_TABLE="inouts"
    P2C_VERB_PHRASE="R/13", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="store_code" */
    UPDATE inouts
      SET
        /* %SetFK(inouts,NULL) */
        inouts.store_code = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM store
            WHERE
              /* %JoinFKPK(:%New,store," = "," AND") */
              :new.store_code = store.store_code
        ) 
        /* %JoinPKPK(inouts,:%New," = "," AND") */
         and inouts.inout_number = :new.inout_number;


-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
END;
/

CREATE  TRIGGER tU_inouts AFTER UPDATE ON inouts for each row
-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
-- UPDATE trigger on inouts 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
  /* products  inouts on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002230b", PARENT_OWNER="", PARENT_TABLE="products"
    CHILD_OWNER="", CHILD_TABLE="inouts"
    P2C_VERB_PHRASE="R/12", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="product_code" */
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
      'Cannot update inouts because products does not exist.'
    );
  END IF;

  /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
  /* store  inouts on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="store"
    CHILD_OWNER="", CHILD_TABLE="inouts"
    P2C_VERB_PHRASE="R/13", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="store_code" */
  SELECT count(*) INTO NUMROWS
    FROM store
    WHERE
      /* %JoinFKPK(:%New,store," = "," AND") */
      :new.store_code = store.store_code;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.store_code IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update inouts because store does not exist.'
    );
  END IF;


-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
END;
/


CREATE  TRIGGER tD_job AFTER DELETE ON job for each row
-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
-- DELETE trigger on job 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
    /* job  member on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0000b528", PARENT_OWNER="", PARENT_TABLE="job"
    CHILD_OWNER="", CHILD_TABLE="member"
    P2C_VERB_PHRASE="R/11", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="job_code" */
    UPDATE member
      SET
        /* %SetFK(member,NULL) */
        member.job_code = NULL
      WHERE
        /* %JoinFKPK(member,:%Old," = "," AND") */
        member.job_code = :old.job_code;


-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
END;
/

CREATE  TRIGGER tU_job AFTER UPDATE ON job for each row
-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
-- UPDATE trigger on job 
DECLARE NUMROWS INTEGER;
BEGIN
  /* job  member on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="0000d532", PARENT_OWNER="", PARENT_TABLE="job"
    CHILD_OWNER="", CHILD_TABLE="member"
    P2C_VERB_PHRASE="R/11", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="job_code" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.job_code <> :new.job_code
  THEN
    UPDATE member
      SET
        /* %SetFK(member,NULL) */
        member.job_code = NULL
      WHERE
        /* %JoinFKPK(member,:%Old," = ",",") */
        member.job_code = :old.job_code;
  END IF;


-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
END;
/


CREATE  TRIGGER tI_member BEFORE INSERT ON member for each row
-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
-- INSERT trigger on member 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
    /* tb_zipcode  member on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0001d64f", PARENT_OWNER="", PARENT_TABLE="tb_zipcode"
    CHILD_OWNER="", CHILD_TABLE="member"
    P2C_VERB_PHRASE="R/5", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="zipcode" */
    UPDATE member
      SET
        /* %SetFK(member,NULL) */
        member.zipcode = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM tb_zipcode
            WHERE
              /* %JoinFKPK(:%New,tb_zipcode," = "," AND") */
              :new.zipcode = tb_zipcode.zipcode
        ) 
        /* %JoinPKPK(member,:%New," = "," AND") */
         and member.id = :new.id;

    /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
    /* job  member on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="job"
    CHILD_OWNER="", CHILD_TABLE="member"
    P2C_VERB_PHRASE="R/11", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="job_code" */
    UPDATE member
      SET
        /* %SetFK(member,NULL) */
        member.job_code = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM job
            WHERE
              /* %JoinFKPK(:%New,job," = "," AND") */
              :new.job_code = job.job_code
        ) 
        /* %JoinPKPK(member,:%New," = "," AND") */
         and member.id = :new.id;


-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
END;
/

CREATE  TRIGGER tD_member AFTER DELETE ON member for each row
-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
-- DELETE trigger on member 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
    /* member  orders on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0000ab6f", PARENT_OWNER="", PARENT_TABLE="member"
    CHILD_OWNER="", CHILD_TABLE="orders"
    P2C_VERB_PHRASE="R/7", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="id" */
    UPDATE orders
      SET
        /* %SetFK(orders,NULL) */
        orders.id = NULL
      WHERE
        /* %JoinFKPK(orders,:%Old," = "," AND") */
        orders.id = :old.id;


-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
END;
/

CREATE  TRIGGER tU_member AFTER UPDATE ON member for each row
-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
-- UPDATE trigger on member 
DECLARE NUMROWS INTEGER;
BEGIN
  /* member  orders on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="0002ef1f", PARENT_OWNER="", PARENT_TABLE="member"
    CHILD_OWNER="", CHILD_TABLE="orders"
    P2C_VERB_PHRASE="R/7", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="id" */
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

  /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
  /* tb_zipcode  member on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="tb_zipcode"
    CHILD_OWNER="", CHILD_TABLE="member"
    P2C_VERB_PHRASE="R/5", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="zipcode" */
  SELECT count(*) INTO NUMROWS
    FROM tb_zipcode
    WHERE
      /* %JoinFKPK(:%New,tb_zipcode," = "," AND") */
      :new.zipcode = tb_zipcode.zipcode;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.zipcode IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update member because tb_zipcode does not exist.'
    );
  END IF;

  /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
  /* job  member on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="job"
    CHILD_OWNER="", CHILD_TABLE="member"
    P2C_VERB_PHRASE="R/11", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="job_code" */
  SELECT count(*) INTO NUMROWS
    FROM job
    WHERE
      /* %JoinFKPK(:%New,job," = "," AND") */
      :new.job_code = job.job_code;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.job_code IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update member because job does not exist.'
    );
  END IF;


-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
END;
/


CREATE  TRIGGER tI_orders BEFORE INSERT ON orders for each row
-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
-- INSERT trigger on orders 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
    /* member  orders on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0001dbd6", PARENT_OWNER="", PARENT_TABLE="member"
    CHILD_OWNER="", CHILD_TABLE="orders"
    P2C_VERB_PHRASE="R/7", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="id" */
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

    /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
    /* products  orders on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="products"
    CHILD_OWNER="", CHILD_TABLE="orders"
    P2C_VERB_PHRASE="R/9", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="product_code" */
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


-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
END;
/

CREATE  TRIGGER tU_orders AFTER UPDATE ON orders for each row
-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
-- UPDATE trigger on orders 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
  /* member  orders on child update no action */
  /* ERWIN_RELATION:CHECKSUM="000216fe", PARENT_OWNER="", PARENT_TABLE="member"
    CHILD_OWNER="", CHILD_TABLE="orders"
    P2C_VERB_PHRASE="R/7", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="id" */
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

  /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
  /* products  orders on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="products"
    CHILD_OWNER="", CHILD_TABLE="orders"
    P2C_VERB_PHRASE="R/9", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="product_code" */
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


-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
END;
/


CREATE  TRIGGER tD_products AFTER DELETE ON products for each row
-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
-- DELETE trigger on products 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
    /* products  orders on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00019cec", PARENT_OWNER="", PARENT_TABLE="products"
    CHILD_OWNER="", CHILD_TABLE="orders"
    P2C_VERB_PHRASE="R/9", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="product_code" */
    UPDATE orders
      SET
        /* %SetFK(orders,NULL) */
        orders.product_code = NULL
      WHERE
        /* %JoinFKPK(orders,:%Old," = "," AND") */
        orders.product_code = :old.product_code;

    /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
    /* products  inouts on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="products"
    CHILD_OWNER="", CHILD_TABLE="inouts"
    P2C_VERB_PHRASE="R/12", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="product_code" */
    UPDATE inouts
      SET
        /* %SetFK(inouts,NULL) */
        inouts.product_code = NULL
      WHERE
        /* %JoinFKPK(inouts,:%Old," = "," AND") */
        inouts.product_code = :old.product_code;


-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
END;
/

CREATE  TRIGGER tU_products AFTER UPDATE ON products for each row
-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
-- UPDATE trigger on products 
DECLARE NUMROWS INTEGER;
BEGIN
  /* products  orders on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="0001cb4e", PARENT_OWNER="", PARENT_TABLE="products"
    CHILD_OWNER="", CHILD_TABLE="orders"
    P2C_VERB_PHRASE="R/9", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="product_code" */
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

  /* products  inouts on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="products"
    CHILD_OWNER="", CHILD_TABLE="inouts"
    P2C_VERB_PHRASE="R/12", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="product_code" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.product_code <> :new.product_code
  THEN
    UPDATE inouts
      SET
        /* %SetFK(inouts,NULL) */
        inouts.product_code = NULL
      WHERE
        /* %JoinFKPK(inouts,:%Old," = ",",") */
        inouts.product_code = :old.product_code;
  END IF;


-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
END;
/


CREATE  TRIGGER tD_store AFTER DELETE ON store for each row
-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
-- DELETE trigger on store 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
    /* store  inouts on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0000bad1", PARENT_OWNER="", PARENT_TABLE="store"
    CHILD_OWNER="", CHILD_TABLE="inouts"
    P2C_VERB_PHRASE="R/13", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="store_code" */
    UPDATE inouts
      SET
        /* %SetFK(inouts,NULL) */
        inouts.store_code = NULL
      WHERE
        /* %JoinFKPK(inouts,:%Old," = "," AND") */
        inouts.store_code = :old.store_code;


-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
END;
/

CREATE  TRIGGER tU_store AFTER UPDATE ON store for each row
-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
-- UPDATE trigger on store 
DECLARE NUMROWS INTEGER;
BEGIN
  /* store  inouts on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="0000e2eb", PARENT_OWNER="", PARENT_TABLE="store"
    CHILD_OWNER="", CHILD_TABLE="inouts"
    P2C_VERB_PHRASE="R/13", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="store_code" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.store_code <> :new.store_code
  THEN
    UPDATE inouts
      SET
        /* %SetFK(inouts,NULL) */
        inouts.store_code = NULL
      WHERE
        /* %JoinFKPK(inouts,:%Old," = ",",") */
        inouts.store_code = :old.store_code;
  END IF;


-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
END;
/


CREATE  TRIGGER tD_tb_zipcode AFTER DELETE ON tb_zipcode for each row
-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
-- DELETE trigger on tb_zipcode 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58 */
    /* tb_zipcode  member on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0000b74f", PARENT_OWNER="", PARENT_TABLE="tb_zipcode"
    CHILD_OWNER="", CHILD_TABLE="member"
    P2C_VERB_PHRASE="R/5", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="zipcode" */
    UPDATE member
      SET
        /* %SetFK(member,NULL) */
        member.zipcode = NULL
      WHERE
        /* %JoinFKPK(member,:%Old," = "," AND") */
        member.zipcode = :old.zipcode;


-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
END;
/

CREATE  TRIGGER tU_tb_zipcode AFTER UPDATE ON tb_zipcode for each row
-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
-- UPDATE trigger on tb_zipcode 
DECLARE NUMROWS INTEGER;
BEGIN
  /* tb_zipcode  member on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="0000da22", PARENT_OWNER="", PARENT_TABLE="tb_zipcode"
    CHILD_OWNER="", CHILD_TABLE="member"
    P2C_VERB_PHRASE="R/5", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="zipcode" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.zipcode <> :new.zipcode
  THEN
    UPDATE member
      SET
        /* %SetFK(member,NULL) */
        member.zipcode = NULL
      WHERE
        /* %JoinFKPK(member,:%Old," = ",",") */
        member.zipcode = :old.zipcode;
  END IF;


-- ERwin Builtin 2022년 5월 26일 목요일 오후 3:59:58
END;
/

