--Crear un cursor para ver todos los clientes que no hayan hecho pagos. Hazlo con un loop

declare 
    v_nombreCliente clientes.nombrecliente%TYPE;
    cursor c_clientes_sin_pagos is 
    select nombreCliente
    from clientes c
    where not exists(select codigocliente from pagos
    where codigocliente = c.codigocliente );
begin

    open c_clientes_sin_pagos; --- Siempre cerrar el cursor

    loop
        -- fetch "Toma el valor que se esta iterando"
        fetch c_clientes_sin_pagos into v_nombreCliente;
        
        -- %notfound;"cuando no halla nada" Exit
        EXIT WHEN c_clientes_sin_pagos%notfound;
        dbms_output.put_line('Name: ' || v_nombreCliente);
    end loop;

    close c_clientes_sin_pagos; --

end;
/

--Crea un cursor para ver todos klos clientes que no hayan hecho pagos. hazlo con un for 

declare 
    cursor c_clientes_sin_pagos is 
    select nombreCliente
    from clientes c
    where not exists(select codigocliente from pagos
    where codigocliente = c.codigocliente );
begin
    for nombre in c_clientes_sin_pagos loop
        dbms_output.put_line('Name: ' || nombre.nombrecliente);
    end loop;

end;
/