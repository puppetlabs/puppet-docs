---
layout: default
title: "PE 3.8 » Inicio Rápido » Clasificando Agentes (*nix)"
subtitle: "Guía de Inicio Rápido sobre Agregar Clases"
canonical: "/es/pe/latest/quick_start_adding_class_nix.html"
---


## Resúmen

[classification_selector]: ./images/quick/classification_selector.png
[apache_add_group]: ./images/quick/apache_add_group.png

Cada módulo contiene una o más **clases**. Las [clases](/puppet/3.8/reference/lang_classes.html) son la unidad mínima de código de Puppet que usa Puppet Enterprise para configurar nodos. El módulo puppetlabs-apache que instalaste previamente en la [GIR sobre Instalación de Módulos](./quick_start_module_install_nix.html) contiene una clase llamada `apache`. En este ejemplo, utilizarán la clase `apache` para configurar el virtual host de Apache por defecto. Crearán un grupo llamado __ejemplo_apache__ y agregarán la `apache` a este grupo.

> **Prerequisitos**: Esta guía asume que ya existe en funcionamiento un [entorno de PE monolítico], al menos un [nodo agente *nix](./quick_start_install_agents_nix.html) y el [módulo puppetlabs-apache](./quick_start_module_install_nix.html).


## Creando el Grupo ejemplo_apache

1. Desde la consola, haz clic __Classification__ en la barra de navegación.
2. En el campo __Node group name__, asígnale un nombre a tu grupo (ej., **ejemplo_apache**).
3. Haz clic en __Add group__.
4. Haz clic en el grupo __ejemplo_apache__.
5. En la pestaña __Rules__, en el area de __Certname__, en el campo __Node name__, ingresa el nombre del nodo administrado por PE que deseas agregar al grupo.

   **Nota**: Deja los campos **Parent name** y **Environment** en sus valores por defecto. (**default** y **production**, respectivamente).  

6. Haz clic en __Pin node__.
7. Haz clic __Commit 1 change__.

   ![adding node to apache group][apache_add_group]

8. Repite los pasos 5-7 para cualquier nodo adicional que desees agregar.

   **Consejo**: Agregan nodos individualmente es referido como agregar nodos de forma **estática**. En entornos más complejos (más allá de los objetivos de esta GIR), es muy probable que [agregues nodos de forma "dinámica"](./console_classes_groups.html#adding-nodes-dynamically) mediante la creación de reglas basadas en información (facts) de los nodos.


## Añadiendo la Clase `apache` al Grupo Ejemplo

A menos que hayas navegado a alguna otra parte de la consola, el grupo de nodos __ejemplo_apache__ debería estar presente en el área de __Classification__.

**Para agregar la clase `apache` al grupo ejemplo:**

1. Haz clic en la pestaña __Classes__.

2. En el campo __Class name__ , comienza a escribir `apache`, y haz clic sobre la opción cuando aparezca en la lista de auto-compleción.

3. Haz clic en __Add class__ y luego en __Commit 1 change__.

   La clase `apache` debería aparecer ahora entre la lista de clases para el nodo agente. Puedes comprobarlo haciendo clic en __Nodes__ y luego en el nombre de nodo entre la lista de __Nodes__. Aparecera una pagina con los detalles del nodo.

4. Desde el nodo agente, ve al directorio `/var/www/html/`, y crea un archivo llamado `index.html`.

5. Edita el archivo `index.html` añadiendo algún contenido (ej., "Hola Mundo").

6. Desde la línea de comandos del Puppet master, ejecuta `puppet agent -t`.

7. Desde la línea de comandos del nodo(s) administrado por PE, ejecuta `puppet agent -t`.

   Este comando configurará el nodo con la clase recientmenente asignada. Espera uno o dos minutos.

8. Abre un navegador, e ingresa la dirección IP del nodo agente, agregando el puerto al final (ej., `http://IPdeminodoagende:80`).

   Verás los contenidos de `/var/www/html/index.html` mostrados en la ventana del explorador.

> Puppet Enterprise  ahora esta administrando el vhost por defecto de Apache en el nodo agente. A partir de ahora, puedes revisar el "ReadMe" del módulo de Apache en el Forge para explorar la opciones sobre como administrar instancias de Apache acorde a tus requerimientos. La [GIR sobre desarrollo de módulos para *Nix](./quick_writing_nix.html) documenta como escribir una clase a medida para administrar una aplicación web en un virtual host de Apache.

## Editando parametros de la clase en la consola

Puedes usar la consola para establecer o editar los parámetros por defecto de una clase sin necesidad de editar el código del módulo.

**Para editar los parámetros de la clase** `apache`:

1. Desde la consola, haz clic en __Classification__ en la barra de navegación.
2. Desde __la página de Classification__, haz clic en el grupo __ejemplo_apache__ group.
3. Haz clic en la pestaña __Classes__, y busca la clase `apache` entre la lista de clases.

4. Desde el desplegable __Parameter Name__, elije el parametro que deseas editar. (Para este ejemplo, utilizaremos `docroot`.)

   **Nota**:  El texto gris que aparece como valor de algunos parametros es el valor por defecto, que puede ser literal o una variable de Puppet. Puedes volver al valor por defecto haciendo clic en __Discard changes__ luego de que hayas agregado o editado el parámetro.

5. En el campo __Value__, ingresa `"/var/www"`.
6. Haz clic en __Add parameter__.
7. Haz clic en __Commit 1 change__.
8. Desde la línea de comandos del Puppet master, ejecuta `puppet agent -t`.
9. Desde la línea de comandos del nodo administrado por PE, ejecuta `puppet agent -t`.

   Esto iniciará la ejecución de Puppet de forma de que Puppet Enterprise ajuste el sistema a la nueva configuración.

----------

Siguiente: [Inicio Rápido: Clasificando Nodos y Asignando Permisos a Usuarios](./quick_start_nc_rbac.html)
