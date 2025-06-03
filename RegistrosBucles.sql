create or replace procedure creaCoches(
    p_id_marca coche.id_marca%TYPE,
    p_numero_coches number)
as

BEGIN

    for contador IN 1..p_numero_coches LOOP
        insert into coche values('A00'||contador, p_id_marca, p_id_marca, null );
    END LOOP;
exception
    when dup_val_on_index then
     dbms_output.put_line('Registro duplicado');
end;


declare 
    p_id_marca coche.id_marca%TYPE := &id;
    p_numero_coches number(8) := &num;
begin 
    creaCoches(p_id_marca, p_numero_coches);
end;