-- crear un cursor para ver todos los productos pedidos en un pedido.
-- muestra la cantidad tambien
create or replace PROCEDURE p_mostrarProductosPedido(
p_codigopedido pedido.CODIGOPEDIDO%TYPE
)
as
    CURSOR c_prod_pedido is
    select p.nombre, dp.cantidad 
    from productos p, detallePedido dp
    where p.codigoproducto = p.codigoproducto
    and dp.codigopedido = p_codigopedido;

begin 

    for registro in c_prod_pedido loop 
     dbms_output.put_line('Se ha pedido el producto llamado ' 
     || registro.nombre || ': ' || registro.cantidad ||  ' unidades');
     
     end loop;
end;
/

declare 
    p_codigopedido pedido.codigopedido%TYPE := &codigo;
begin 
    p_mostrarProductosPedido(p_codigopedido);
end;

--- crea un cursor para ver todos los empleados de un jefe

create or replace PROCEDURE P_mostrarEmpleadoJefe(
p_codigojefe empleados.codigojefe%TYPE
)
as
    CURSOR c_empleados_jefe is
    select     
        emp.nombre || ' ' || emp.apellido1 || ' ' || emp.apellido2 as nombre_empleado
    from empleados emp, empleados jefe
    where emp.codigojefe = jefe.codigoempleado
    and jefe.codigoempleado = p_codigojefe;

    v_nombre_jefe VARCHAR2(80); 
begin 
    select nombre || ' ' || apellido1 || ' ' || apellido2 into v_nombre_jefe
    from empleados
    where codigoempleado = p_codigojefe;
    
    dbms_output.put_line('El jefe: ' || v_nombre_jefe || ' tiene al mando: ');
    for registro in c_empleados_jefe loop 
     dbms_output.put_line(registro.nombre_empleado);
     
     end loop;

EXCEPTION
    when no_data_found then 
         dbms_output.put_line('El jefe no existe');
end;
/

declare 
    p_codigojefe empleados.codigojefe%TYPE:= &codigo;
begin 
    P_mostrarEmpleadoJefe(p_codigojefe);
end;

