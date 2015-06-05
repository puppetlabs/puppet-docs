---
layout: default
title: "PE 3.8 » Inicio Rápido » DNS"
subtitle: "Guía de Inicio Rápido sobre DNS"
canonical: "/pe/latest/quick_start_dns.html"
---

[downloads]: http://info.puppetlabs.com/download-pe.html
[sys_req]: /pe/latest/install_system_requirements.html
[agent_install]: /pe/latest/install_agents.html
[install_overview]: /pe/latest/install_basic.html

Bienvenido a la Guía de Inicio Rápido sobre administración de DNS con Puppet Enterprise. Este documento provee instrucciones para comenzar a administar los archivos de configuración de un servidor de nombres DNS simple con PE. Un servidor de nombres tiene con función resolver los nombres de dominio que escribes en tu navegador (ej. `google.com`) puedan ser convertidos en direcctiones IP que tu computadora pueda entender.  

Los administradores de sistemas normalmente tienen que mantener un archivo con la dirección de los servidores de nombre de dominio para recursos internos que no esten publicados en servidores de nombres de dominio públicos. Por ejemplo, digamos que tienes varios servidores en tu entorno, y que el servidor DNS asignado a esos servidores, son los servidores públicos de Google, en la dirección `8.8.8.8`. Mas allá de eso, asumamos que también existén varios recursos detras del firewall de tu compañia a los cuales los empleados requieren acceso de forma regular. En este caso, tendrías un servidor de nombres privado (digamos, en la dirección `10.16.22.10`), y luego utilizarás PE para asegurarte que todos los servidores en tu entorno esten configurados para tener acceso al mismo.

Dentro de este caso de ejemplo, esta guía te permitirá:

* [escribit un módulo simple que contenga una clase llamada `resolver` para administrar un archivo llamado `/etc/resolv.conf`](#escribe-la-clase-resolver).
* [utilizar la consola de PE para agregar la clase `resolver`a tu nodo agente](#agregando-la-clase-resolver-en-la-consola).
* [cambiar los contenidos del archivo que lista los servidores de dominio para demostrar como PE configura el estado deseado que especificas en la consola de PE](#asegurando-el-estado-deseado-de-la-clase-resolver).


### Instalar Puppet Enterprise y el Agente de Puppet Enterprise

Si aún no lo has hecho, previo a esta guía debes tener PE instalado. Refiere a la página de [requerimientos del sistema][sys_req] para ver que plataformas están soportadas.

1. [Descarga y verifica el archivo comprimido][downloads].
2. Refiere al [resúmen de instalación][install_overview] para asistirte con la instalación de PE, luego sigue las instrucciones.
3. Refiere a las [instrucciones de instalación de agentes][agent_install] para asistirte con la instalación de nodo(s) agente(s), luego sigue las instrucciones.

>**Sugerencia**: Sigue las instrucciones en la [Guía de Inicio Rápido sobre NTP](/pe/latest/quick_start_ntp.html) para configurar PE de forma que asegures que la hora este sincronizada en todo los equipos de tu entorno.

>**Nota**: Puedes agregar la clase que administra los servidores de nombre de dominio a cuantos agentes lo desees. Para simplificar esta guía, las imágenes o instrucciones pueden mostrar un único nodo.

### Escribe la Clase `resolver`

Algunos modulos pueden ser grandes, complejos, y requieren una significativa cantidad de prueba y error, mientras otros, como los [Modulos soportados por PE](https://forge.puppetlabs.com/supported), generalmente están "listo para usarse". El modulo de este ejemplo es muy simple de escribir, y contendrá solo una clase y una plantilla (template).

> #### Un breve comentario sobre módulos
>
>Lo primero que debes saber es que, por defecto, los módulos que utilizarás para administrar sistemas (incluyendo los que instala PE, los que descargas del Forge, y aquellos que desarrolles tu mismo) estan ubicados en el directorio `/etc/puppetlabs/puppet/environments/production/modules`.
>
>**Nota**: PE también instala módulos en  `/opt/puppet/share/puppet/modules`, pero no modifiques ni agregues nada en este directorio.
>
>Existe una abundante cantidad de recursos sobre desarrollo de módulos que puedes utilizar como referencia. Refiere a [Módulos y Manifiestos](/pe/latest/puppet_modules_manifests.html), o la [Guía para Principiantes sobre Módulos](/guides/module_guides/bgtm.html), y el [Puppet Forge](https://forge.puppetlabs.com/).

 Los Módulos son simplemente estructuras de directorios. Para esta tarea, crearás los siguientes archivos:

 - `resolver` (el nombre del módulo)
   - `manifests/`
      - `init.pp` (contiene la clase `resolver`)
   - `templates/`
      - `resolv.conf.erb` (contiene la plantilla para el archivo `/etc/resolv.conf`, los contenidos se completarán luego de añadir la clase y ejecutar PE.)

**Para escribir la clase `resolver`**:

1. Desde la línea de comandos del Puppet Master, cambia al directorio de módulos (`cd /etc/puppetlabs/puppet/modules`).
2. Ejecuta `mkdir -p resolver/manifests` para crear un nuevo directorio para un módulo y su correspondiente directorio `manifests`.
3. Desde el directorio `manifests`, utiliza un editor de texto para crear un archivo llamado `init.pp` que contenga el siguiente código de Puppet.

        class resolver (
          $nameservers,
        ) {

          file { '/etc/resolv.conf':
            ensure  => file,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template('resolver/resolv.conf.erb'),
          }
        }

4. Salva el archivo y cierra el editor.
5. Desde el directorio `/etc/puppetlabs/puppet/modules`, ejecuta `mkdir -p resolver/templates` para crear el directorio de plantillas del módulo.
6. Utiliza un editor de texto para crear el archivo `resolver/templates/resolv.conf.erb`.
7. Edita el archivo `resolv.conf.erb` de forma de que contenga el siguiente código de ruby.

        # Resolv.conf generado por Puppet

        <% [@nameservers].flatten.each do |ns| -%>
        nameserver <%= ns %>
        <% end -%>

        # Otros valores pueden ser agregados a esta plantilla de ser necesario.

8. Salva el archivo y cierra el editor.

> Listo! Acabas de crear un modulo que contiene una clase que, una vez aplicada, se asegurará que tus nodos agentes consulten a tu servidor de nombres internos. Tendrás que esperar algo de tiempo para que el servidor de Puppet refresque la lista de clases antes de que esten disponibles para agregarlas a tus nodos agente.
>
> Nota lo siguiente sobre tu nueva clase:
>
> * La clase `resolver` tiene como objetivo la creación del archivo `/etc/resolv.conf`.
> * El contenido del archivo `/etc/resolv.conf` es modificado y administrado por la plantilla `resolv.conf.erb`. Definiras el contenido en el próximo paso.


### Agregando la Clase `resolver` en la consola

[classification_selector]: ./images/quick/classification_selector.png

Para llevar a cabo este procedimiento, vas a agregar la clase `resolver`a un grupo de nodos que crearas llamado **DNS**, que contendrá todos tus nodos.

Si bien el grupo **DNS** incluirá a todos los nodos en tu despliegue, (incluyendo al Puppet Master), puedes crear [tus propios grupos](/pe/latest/console_classes_groups.html#creating-classification-node-groups), dependiendo de tus necesidades.

**Para crear el grupo de nodos DNS**:

1. Desde la consola, haz clic en __Classification__ en la barra de navegación.

   ![classification selection][classification_selector]

2. En el campo **Node group name**, nombra el grupo **DNS**. 
3. Haz clic en **Add group**.

   **Nota**: Deja los campos **Parent name** y **Environment** en sus valores por defecto (**default** y **production**, respectivamente).

4. Desde la página __Classification__, elije el grupo __DNS__, y haz click en la pestaña __Rules_.
5. En el campo **Fact**, ingresa "name" (sin las comillas dobles).
6. En el campo **Operator**, elije **matches regex**.
7. En el campo **Value**, ingresa ".x" (sin las comillas dobles). 
8. Haz clic en **Add rule**.

   Esta regla va a agregar de forma ["dinámica" todos los nodos]((/pe/latest/console_classes_groups.html#adding-nodes-dynamically) al grupo **DNS**. (Ten en cuenta que esta regla es solo una muestra, y que la configuración puede cambiar dependiendo de las necesidades de cada usuario.) 

**Para agregar la clase** `resolver` **al grupo DNS**:

1. Desde la página __Classification__, elije el grupo __DNS__.
2. Haz clic en la pestaña __Classes__.
3. En el campo __Class name__, comienza a escribir `resolver`, y elije la clase desde la lista de autocompleción.
4. Haz clic en __Add class__.
5. Haz clic en __Commit 1 change__.

   **Nota**: La clase `resolver` aparecerá en la lista de clases para el grupo __DNS__, pero aún no ha sico configurada en los nodos. Para que eso suceda, puedes ejecutar el agente de Puppet manualmente.

7. Desde la línea de comandos de el Puppet master, ejecuta `puppet agent -t`.

8. Desde la línea de comandos de tus nodos administrados por PE, ejecuta `puppet agent -t`.

   Esto configurará tus nodos con la clase recientemente asignada. Espera uno o dos minutos.

> Todavía no terminaste! La clase `resolver` ahora aparece en la lista de clases para tu grupo, pero aún no ha sido configurada completamente. Todavía necesitas agregar una dirección IP como parametro para que la clase configure. Puedes hacerlo directamente desde la consola.

#### Agregando la dirección IP del servidor de nombres como parámetro deste la consola.

Puedes agregar los valores en el código de tu modulo, pero es más fácil hacerlo desde la consola de PE.

**Para editar los parametros de la clase** `resolver`:

1. Desde la consola, haz clic en __Classification__ en la barra de navegación.
2. Desde la página __Classification__, elije el grupo __DNS__.
3. Haz clic en la pestaña __Classes__, y busca la clase `resolver` en la lista.
4. Desde el menú __parameter__, elije __nameservers__.
5. En el campo __Value__, ingresa la dirección IP de el servidor de nombres que deseas configurar (e.j., `8.8.8.8`).

   **Nota**: El texto gris que aparece como valor de algunos parámetros es el valor por defecto, que puede ser literal o una variable de Puppet.

6. Haz clic en __Add parameter__.
7. Haz clic en __Commit 1 change__.
8. Desde la línea de comandos de el Puppet master, ejecuta `puppet agent -t`.
9. Desde la línea de comandos de tus nodos administrados por PE, ejecuta `puppet agent -t`.

  Este comando iniciará una ejecución del agente de Puppet que configurará los nodos. 

10. Abre el archivo `/etc/resolv.conf`. Este archivo ahora contendrá la plantilla `resolv.conf.erb` con la dirección IP que configuraste previamente.

> ¡Felicitaciones! Puppet Enterprise ahora utilizará la dirección IP que especificaste para configurar los nodos.
>
> #### Revisando los cambios con el Event Inspector
>
>El event inspector de la consola de PE permite visualizar e investigar cambios ("eventos"). Puedes analizar los cambios por **clases**, **recursos** o **nodos**. Por ejemplo, luego de aplicar la clase `resolver`, puedes usar el inspector de eventos para confirmar que los cambios (o "eventos") fueron aplicados correctamente en tu infraestructura. En este caso, verás qe la clase creo el archivo `/etc/resolv.conf` y configuro el contenido de acuerdo a la plantilla del modulo.
>
>Cuanto mas navegues el Event Inspector, verás información mas detallada. De existir un problema aplicando la clase `resolver`, esta informacion te dira exáctamente cual es y que línea de código necesitas corregir para remediarlo.
>
>En la esquina superior derecha verás un vínculo para generar un reporte, que contiene la información sobre los cambios realizados durante la ejecución del agente, incluyendo registros y métricas. Para mas información, visita la [página de reportes](/pe/latest/console_reports.html#reading-reports).
>
>Para mas información sobre el Event Inspector de la consola de PE, refiere a [la documentación del Event Inspector](/pe/latest/console_event_inspector).

### Asegurando el estado deseado de la clase `resolver`.

Finalmente, veamos como PE asegurará el estado deseado de la clase `resolver` en tus nodos agentes. En la tarea previa, configuraste la dirección IP de tu servidor de nombres. Ahora asume un escenario en el que un miembro de tu equipo cambia los contenidos del archivo `/etc/resolv.conf` para utilizar un servidor de nombres diferente, de modo que el nodo pierda acceso a los recursos internos.

1. En cualquier nodo agente en el que hayas aplicado la clase `resolver`, edita el archivo `resolv.conf` para que tenga cualquier dirección IP distinta a la que configuraste previamente.
2. Guarda el archivo y sal del editor de texto.
3. Ejecuta `puppet agent -t` para forzar la ejecución del agente.
4. Vuelve a revisar el contenido del archivo `/etc/resolv.conf`, y encontrarás que PE ha mitigado la diferencia de configuración y vuelto a configurar la IP a su estado deseado.

> Listo --- ¡PE ha asegurado el estado deseado de tu nodo agente!
>
> Y recuerda, tal como antes, puedes revisar los cambios desde el punto de vista de la clase o el nodo utilizando el inspector de eventos.

### Otros Recursos

Para mas información sobre la como Puppet Enterprise trabaja con servidores DNS, revisa la página [Solucionando Problemas relacionados a la resolución de nombres](http://puppetlabs.com/blog/resolving-dns-issues).

Puppet Labs tiene una amplia oferta de herramientas para aprendizaje, desde certificaciones y cursos formales a lecciones online. Sigue los vinculos debajo, o ve a [las páginas de aprendizaje de Puppet (en inglés)](https://puppetlabs.com/learn).

* [Aprendiendo Puppet](http://docs.puppetlabs.com/learning/) es una serie de ejercicios sobre varios temas esenciales relacionados al uso y el despliegue de PE.
* Los seminarios de Puppet Labs contienen lecciones que puedes seguir a tu propio paso sobre una variedad de temas. Puedes crear una cuenta para acceder a los contenidos en [las páginas de aprendizaje de Puppet (en inglés)](https://puppetlabs.com/learn).


