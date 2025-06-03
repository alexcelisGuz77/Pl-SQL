--Mostar el nombre del cliente dado su codigo. controla en caso de que no se encuentre,
-- mostrando un mensaje
declare
    v_codigo_cliente clientes.codigocliente%TYPE := &codigo;
    v_nombre_cliente clientes.nombrecliente%TYPE;
    
begin

    select nombrecliente into v_nombre_cliente
    from clientes
    WHERE codigocliente = v_codigo_cliente;
    
    dbms_output.put_line('el nombre es ' || v_nombre_cliente);
    
EXCEPTION
    WHEN no_data_found THEN
    dbms_output.put_line('El cliente no existe');
end;



--- realizar uan funcio que me devuelva la suma de pagos que ha 
-- realizado. pasa el codigo por parametro. Conreola en caso de que no se 
-- encuentre en este caso devuelva -1

create or replace function pagosCliente(v_codigocliente clientes.codigocliente%TYPE)
RETURN NUMBER
as
-- aqui se declaran las variables de la funcion 
    v_sumapagos pagos.cantidad%TYPE := 0;

BEGIN

    -- cuando hay un sum este no retorna no_data_found
    -- retorna un null en caso de no encomtarnada 
    select sum(cantidad) into v_sumapagos
    from pagos
    WHERE codigocliente = v_codigocliente;
    
    -- arrorjar no data found
    if v_sumapagos is null then
        raise no_data_found;
    else 
        return v_sumapagos;
    end if;
    
    --expcion
Exception 
    when no_data_found then
    return -1;
    
end;
/

declare 
    v_codigopedido pedido.codigopedido%type := &codigo;
    v_suma pagos.cantidad%type;
begin 
    v_suma := pagoscliente(v_codigopedido);
    
    if v_suma = -1 then 
    dbms_output.put_line('El cliente no existe');
    else
    dbms_output.put_line('la suma de pagos es: ' || v_suma);
    end if;
end;

--- realiza un metodo o procedimiento que muestre el total en 
-- eruos de un pedido. pasandole el codigo por parametro. control
-- en caso de que nos encuentre, en ese caso devuelve un 0, pasale
-- otra parametro si supera ese limite, lanzaremos una exepcion propia u devolveremos un 0.



