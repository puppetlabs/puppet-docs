---
layout: default
title: "Aprende Puppet - Recursos y la RAL"
canonical: "/es/learning/ral.html"
toc: false
---

¡Bienvenidos a *Aprende Puppet*! Esta serie abarca el contenido básico para escribir código Puppet y utilizar Puppet Enterprise. Ya deberías tener una copia de la VM de *Aprende Puppet*, si no la tienes, puedes [bajarla aquí](http://info.puppetlabs.com/download-learning-puppet-VM.html).

#Comienzo

Loguéate en la VM de Learning Puppet como root, y ejecuta el siguiente comando:

    # puppet resource service

    service { 'NetworkManager':
      ensure => 'stopped',
      enable => 'false',
    }
    service { 'acpid':
     ensure => 'running',
     enable => 'true',
    }
    service { 'anacron':
     ensure => 'stopped',
     enable => 'true',
    }
    service { 'apmd':
    ensure => 'running',
    enable => 'true',
    }
    ...
    ... (etc.)

¡Listo! Has conocido tu primer recurso de Puppet.

## ¿Qué ha pasado?

+ **puppet**: La mayoría de las funciones de Puppet vienen de un sólo comando de **puppet**, el cual tiene muchos subcomandos.
+ **resource**: El subcomando **resource** puede inspeccionar y modificar recursos de forma interactiva.
+ **service**: El primer argumento del comando **puppet resource** debe ser un **tipo de recurso**, del cual aprenderás más a continuación. Puedes encontrar una lista completa de tipos en [la referencia de tipos de Puppet](http://docs.puppetlabs.com/references/latest/type.html).

Juntos, estos comandos inspeccionan cada servicio en el sistema, ya sea en ejecución o parado.

#Recursos

Imagina una configuración de sistema como una colección de muchas unidades atómicas independientes llamadas **”recursos”**; estas piezas varían en tamaño, complejidad y vida útil. Cualquiera de las siguientes (y muchas más) pueden ser modeladas como un solo recurso:

+ Una cuenta de usuario
+ Un archivo específico
+ Un directorio de archivos
+ Un paquete de software
+ Un servicio en ejecución
+ Un *cron job* programado
+ Una invocación de un comando de shell, cuando se cumplen determinadas condiciones

Cualquiera de estos recursos es muy similar a un grupo de recursos relacionados:

+ Cada archivo tiene una ruta y un owner 
+ Cada usuario tiene un nombre, un UID y un grupo

La implementación podría diferir, por ejemplo, necesitas un comando para iniciar o detener un servicio en Windows y uno diferente si es en Linux, e incluso entre las distribuciones de Linux hay algunas diferencias. Pero, conceptualmente, en ambas inicias o paras un servicio, independientemente de lo que tipees en la consola.

#Abstracción

Si piensas en los recursos de esta manera, puedes inferir dos cosas:

+ Los recursos similares pueden ser agrupados por tipos. Los servicios tienden a parecer servicios, y los usuarios tenderán a parecer usuarios.
+ La descripción de un tipo de recurso puede separarse desde su implementación. Puedes hablar del inicio de un servicio sin necesitar saber cómo iniciarlo.

A éstas, Puppet agrega una tercera:

+ Con una descripción de un tipo de recurso lo suficientemente buena, *es posible declarar un estado deseado para un recurso*: en lugar de decir “ejecuta este comando que inicia un servicio” dices “asegúrate de que este servicio se esté ejecutando”.

Estas tres cosas forman la capa de abstracción de recursos de Puppet (Resource Abstracion Layer - RAL). La RAL consiste en **tipos** (modelos de nivel superior) y **proveedores** (implementaciones específicas para cada plataforma) que al estar separados, te permite describir estados deseados de recursos en una forma que no esté atada a un OS específico.

#Anatomía de un recurso

En Puppet, cada recurso es una instancia de un **tipo de recurso** y está identificado con un **título**; tiene una cierta cantidad de **atributos** que están definidos por tipo, y cada atributo tiene un **valor**.

Puppet utiliza su propio lenguaje para describir y administrar recursos:

    user { 'dave':
        ensure     => present,
        uid        => '507',
        gid        => 'admin',
        shell      => '/bin/zsh',
        home       => '/home/dave',
        managehome => true,
    }

Esta sintaxis se llama **declaración de recurso**, lo has visto antes cuando ejecutaste **puppet resource service**, y es el corazón del lenguaje de Puppet. Describe un estado deseado para un recurso sin mencionar ningún paso que debe realizarse para alcanzar ese estado.

Intenta identificar cada una de las cuatro partes de la declaración de recurso anterior:

+ Tipo
+ Título
+ Atributos
+ Valores

#Tipos de recursos

Como hemos mencionado antes, cada recurso tiene un **tipo**.

Puppet tiene muchos tipos de recursos integrados, y tú puedes instalar aún más en forma de plugins. Cada tipo puede comportarse de forma distinta y tiene un conjunto diferente de atributos disponibles.

##Hoja de referencia

No todos los tipos de recursos son igual de comunes o igual de útiles, con lo cual, hemos creado una *hoja de referencia* para que imprimas, que describe los ocho tipos más útiles. [Puedes bajar de aquí la hoja de referencia de tipos básicos](http://docs.puppetlabs.com/puppet_core_types_cheatsheet.pdf).

##Referencia de tipos

Los usuarios de Puppet experimentados, pasan mucho tiempo en la página de [referencia de tipos](http://docs.puppetlabs.com/references/latest/type.html).

Esta página es una lista detallada de *todos* los tipos de recursos integrados. Puede ser un poco abrumador para un usuario nuevo, pero tiene casi toda la información que necesitarás en un día normal escribiendo código Puppet.

Generamos una nueva referencia de tipos para cada nueva versión de Puppet para asegurarnos de que las descripciones se mantengan precisas.

##Puppet Describe

El subcomando **puppet describe** puede realizar una lista de tipos de recursos que están actualmente instalados en una máquina determinada. A diferencia de la referencia de tipos, detecta plugins instalados por el usuario además de los tipos integrados.

+ **puppet describe -l**: Lista todos los tipos de recursos disponibles en el sistema.
+ **puppet describe –s <TIPO>**: Imprime información breve acerca de un tipo, sin describir cada atributo.
+ **puppet describe <TIPO>**: Imprime información completa, algo similar a lo que aparece en la [referencia de tipos](http://docs.puppetlabs.com/references/latest/type.html).

#Explorar e inspeccionar recursos

En los próximos capítulos hablaremos acerca del uso del lenguaje de Puppet para administrar recursos. Pero por ahora sólo echaremos un vistazo.

## “Live Management” en la consola de PE
Puppet Enterprise incluye una consola web para controlar muchas de estas características. Una de las cosas que puedes hacer, es explorar e inspeccionar recursos en cualquier sistema con Puppet Enterprise que la consola pueda detectar. Esto soporta un número limitado de tipos de recursos, pero tiene algunas características de comparación muy útiles para correlacionar información en una gran cantidad de nodos.

###Loguearse

Cuando iniciaste tu VM, debería darte la URL, el nombre de usuario y contraseña para acceder a la consola. El usuario y contraseña siempre debe ser **puppet@example.com** y **learningpuppet** respectivamente. La URL, **http://<DIRECCION IP>**. Puedes obtener la IP de la VM ejecutando **facter ipaddress** en la línea de comandos.

Una vez logueado, ve a “Live Management” en la barra de menú superior y cliquea en la pestaña “Manage Resources”, luego puedes [seguir estas instrucciones](http://docs.puppetlabs.com/pe/latest/console_live_resources.html) para encontrar e inspeccionar recursos.

Como estás utilizando un solo nodo, no verás mucho para comparar pero sí podrás ver los estados actuales de los paquetes, cuentas de usuarios, etc.

##El comando Puppet Resource

Puppet incluye un comando llamado **puppet resource**, el cual puede inspeccionar de forma interactiva y modificar recursos en un solo sistema.

Debes utilizar *puppet resource* de esta manera:

    # puppet resource <TIPO> [<NOMBRE>] [ATRIBUTO=VALOR...]

+ El primer argumento debe ser un tipo de recurso. Si no hay otros argumentos determinados, inspeccionará cada recurso de ese tipo que pueda encontrar.
+ El segundo argumento (opcional) es el nombre de un recurso. Si no hay otros argumentos determinados, inspeccionará ese recurso.
+ Luego del nombre, puedes especificar cualquier número de atributos y valores (opcional). Esto sincronizará aquellos atributos con el estado deseado, luego inspecciona el estado final del recurso.
+ Otra alternativa es, si especificas un nombre de recurso y utilizas la opción **--edit**, poder cambiar ese recurso en tu editor de texto. Luego que el buffer esté guardado y cerrado, Puppet modificará el recurso para actualizar tus cambios.

###Ejercicios

Inspecciona un solo recurso:

    # puppet resource user root

    user { 'root':
      ensure           => 'present',
      comment          => 'root',
      gid              => '0',
      groups           => ['root', 'bin', 'daemon', 'sys', 'adm', 'disk', 'wheel'],
      home             => '/root',
      password         => '$1$jrm5tnjw$h8JJ9mCZLmJvIxvDLjw1M/',
      password_max_age => '99999',
      password_min_age => '0',
      shell            => '/bin/bash',
      uid              => '0',
    }

Establece un nuevo estado deseado para un recurso

    # puppet resource user katie ensure=present shell="/bin/zsh" home="/home/katie" managehome=true
    notice: /User[katie]/ensure: created

    user { 'katie':
      ensure => 'present',
      home   => '/home/katie',
      shell  => '/bin/zsh'
    }

#Siguiente paso

**Próxima clase:**

El comando **puppet resource** puede ser útil para trabajos excepcionales, pero Puppet ha sido creado para cosas mejores. [Es tiempo de escribir algunos manifiestos](http://docs.puppetlabs.com/es/learning/manifests.html).

**Nota aparte**
La VM de Aprende Puppet es un pequeño sistema de prueba y no tiene más que lo básico. Si tienes algunas máquinas de desarrollo que se parezcan más a tus servidores actuales, ¿por qué no [bajas Puppet Enterprise](http://info.puppetlabs.com/download-pe.html) y lo investigas? Sigue [la guía para comenzar](http://docs.puppetlabs.com/pe/latest/quick_start.html) para instalar un pequeño entorno, y luego intentar utilizar la consola para inspeccionar recursos de muchos sistemas de una sola vez.

