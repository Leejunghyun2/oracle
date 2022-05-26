create or replace trigger orders_tr01
 before insert 
 on orders
 for each row
 begin 
   select ORDER_SEQ.nextval into :new.o_seq from dual;
end;
/