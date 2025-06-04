--crea un procedimuento al que le pasaremos el dni_cliente y la matricula. El procedimiento
--debera controlar en las ventas de los coches(tabla vende) los siguientes supuestos:

--  A.SI NO EXISTE UN REGISTRO CON DNI_CLIENTE Y ESA MATRILULA SALTAR A LA ZONA DE EXCEPCIONES
-- MOSTART UN MENSAJE
-- "NO EXISTE LA VENTA INTRODUCIDA"
-- B.SI EXISTE LA VENTA INPRODUCIDA 
--      I. MOSTRAT EL PRECIO ANTIGUO
--      II. ACTUALIZAR EL PRECIO SUBIENDO 1000
--      III DEVOLUCION EN UN PARAMETRO DE SALIDA DEL PROCEDIMIENTO(PS_NUEVO_PRECIO) EL PRECIO 
-- NUEVO TRAS CREAR UN BLOQIE ANONIMO QUE LLAME EL PRECEDIMIENTO ANTERIOR Y MUESTRE EL PRECIO
-- DEVUELTO POR EL PRECEDIMIENTO

create or replace procedure actualizaVenta(
    p_dni_cliente vende.DNI_CLIENTE%type,
    p_matricula vende.matricula%type,
    ps_nuevo_precio out vende.precio%type
)
as
    venta vende%rowtype;
begin 

    select * into venta
    from vende
    where dni_cliente = p_dni_cliente
    and matricula = p_matricula;
    
    dbms_output.put_line('El precio antiguo es: ' || venta.precio);
    
    ps_nuevo_precio := venta.precio + 1000;
    
    update vende 
    set precio = ps_nuevo_precio
    where dni_cliente = p_dni_cliente
    and matricula = p_matricula; 
    
EXCEPTION
    when no_data_found then
    dbms_output.put_line('No existe la venta introducida');

end;

declare
    v_dni_cliente vende.DNI_CLIENTE%type := &dni;
    v_matricula vende.matricula%type := &matricula;
    v_nuevo_precio vende.precio%type;
begin 
    actualizaVenta(v_dni_cliente, v_matricula, v_nuevo_precio);
    if v_nuevo_precio is not null then
    dbms_output.put_line('El nuevo precio es: ' || v_nuevo_precio);
    
    end if; 
end;