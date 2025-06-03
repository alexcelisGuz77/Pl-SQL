-- Funciones 
-- Realizar una funciom que me devuelva la suma de pagos que ha realizado. 
-- Pasa el codigo por un parametro

create or replace function pagosCliente(v_codigocliente clientes.codigocliente%TYPE)
RETURN NUMBER
as
-- aqui se declaran las variables de la funcion 
    v_sumapagos pagos.cantidad%TYPE := 0;

BEGIN

    select sum(cantidad) into v_sumapagos
    from pagos
    WHERE codigocliente = v_codigocliente;
    
    return v_sumapagos;

end;
/

declare 
    v_codigopedido pedido.codigopedido%type := &codigo;
    v_suma pagos.cantidad%type;
begin 
    v_suma := pagoscliente(v_codigopedido);
    dbms_output.put_line('la suma de pagos es: ' || v_suma);

end;

-- Realiza un metodo o procedimiento que muestre el total de euros de un pedido
-- pasa el codigo por un parametro


create or replace procedure P_totalPedido(v_codigopedido pedido.codigopedido%TYPE)
as 
    --Definir variables 
    v_total number(8) := 0;
begin
    select sum(dp.cantidad * dp.precio_unitario) into v_total
    from pedido p, detallePedido dp
    where p.codigopedido = dp.codigopedido and p.codigopedido = v_codigopedido;
    
    dbms_output.put_line('El pedido total es: ' || v_total);    
end;
/

DECLARE 
    v_codigopedido pedido.codigopedido%TYPE := &codigo;
begin
    P_totalPedido(v_codigopedido);
end;
    
