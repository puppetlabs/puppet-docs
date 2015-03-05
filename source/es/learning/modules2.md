---
layout: default
title: "Aprende Puppet – Parámetros de clase"
canonical: "/es/learning/modules2.html"
toc: false
---

#Comienzo

	    class echo_class ($to_echo = "default value") {
	      notify {"What are we echoing? ${to_echo}.":}
	    }

	    class {'echo_class':
	      to_echo => 'Custom value',
	    }

Hay algo diferente acerca de esta variable.

#Investigar vs. pedir ayuda
La mayoría de las clases tienen que hacer cosas ligeramente diferentes en sistemas diferentes. Ya conoces algunas maneras de hacerlo, todos los módulos que has escrito hasta ahora han cambiado su comportamiento buscando facts de sistema. Digamos que “investigan”: Esperan que la información esté en determinado lugar (en el caso de los facts, una variable top-scope), y la buscan cuando la necesitan.

Pero no siempre es la mejor manera de hacerlo, y comienza a fallar una vez que necesitas cambiar el comportamiento de un módulo basándote en información que no se relaciona claramente con los facts de sistema. Es un servidor de base de datos? Un servidor NTP local? Un nodo de prueba? Un nodo de producción? Estos no son necesariamente facts; generalmente son decisiones tomadas por humanos.

En estos casos, lo mejor suele ser *configurar* la clase y decirle lo que necesita saber cuando la declaras. Para permitir esto, las clases necesitan alguna forma de pedir información del mundo externo.

#Parámetros de clase
Cuando defines una clase, puedes darle una lista de *parámetros*. Los parámetros van en un conjunto opcional de paréntesis, entre el nombre y la primera llave. Cada parámetro es un nombre de variable y puede tener un valor por defecto opcional. Cada parámetro está separado del siguiente por una coma.

	    class mysql ($user = 'mysql', $port = 3306) {
	      ...
	    }

Esto es una puerta para pasar información a una clase:

	    class {'mysql':
	      user => mysqlserver,
	    }

+ Si declaras la clase con una [declaración de clase tipo recurso](http://docs.puppetlabs.com/es/learning/modules1.html#resource-like-class-declarations), los parámetros están disponibles como **atributos de recurso**.
+ Dentro de la definición de la clase, aparecen como **variables locales**.

##Valores por defecto
Cuando defines la clase, puedes darle un valor por defecto a cualquier parámetro. Esto lo hace opcional cuando declaras la clase; si no especificas un valor, utilizará el que tiene por defecto. Los parámetros sin default se vuelven obligatorios cuando declaras la clase.

##Qué pasa con las declaraciones de clase tipo recurso

###En Puppet Entreprise 2.x

En Puppet 2.7, que es utilizado en la serie Puppet Entreprise 2.x, debes utilizar [declaraciones de clase tipo recurso](http://docs.puppetlabs.com/puppet/latest/reference/lang_classes.html#using-resource-like-declarations) si quieres especificar parámetros de clase; no puedes especificar parámetros con **include** o en la consola de PE. Si cada parámetro tiene un default y no necesitas sobreescribir ninguno de ellos, puedes declarar la clase con **include**; de lo contrario, debes utilizar declaraciones de clase tipo recurso.

Las declaraciones tipo recurso no cooperan del todo con **include**, y si las estás utilizando necesitas organizar tus manifiestos para que nunca intenten declarar una clase más de una vez. Tradicionalmente esto ha sido una molestia, pero los parámetros de clase todavía son superiores a otras formas más antiguas de configurar clases, y las buenas prácticas desarrolladas en el curso de la serie de Puppet 2.7 es crear módulos de “rol” y “perfil” que combinen tus clases funcionales en descripciones de nodo más completas. Una vez que te encuentres manejando múltiples nodos con Puppet, debes [leer el texto de Craig Dunn “Roles y perfiles”](http://www.craigdunn.org/2012/05/239/), que reúne las mejores prácticas utilizadas por los ingenieros de servicio de Puppet Labs.

Para volver tus roles y perfiles más flexibles y evitar repeticiones, también puedes instalar y configurar [Hiera](http://docs.puppetlabs.com/hiera/1/) en tu Puppet Master y especificar las [funciones de búsqueda de Hiera](http://docs.puppetlabs.com/hiera/1/puppet.html#hiera-lookup-functions) como valores de parámetros de clase.

###Por qué **include** no puede tomar parámetros de clase directamente

El problema es que las clases son Singletons, los parámetros configuran la forma en que se comportan, e **include** puede declarar la misma clase más de una vez.

Si fueras a declarar una clase muchas veces con diferentes valores de parámetros, qué conjunto de valores debería ganar? La pregunta no parece tener una respuesta satisfactoria. El [método antiguo de utilizar variables mágicas](http://docs.puppetlabs.com/es/learning/modules2.html#older-ways-to-configure-classes) también tenía este problema: dependiendo del orden de parseo, podían ser varias cadenas de scope diferentes que proveían un valor determinado, y la que tú tenías era efectivamente al azar. Horrible.

La solución que los diseñadores de Puppet establecieron fue que los valores de los parámetros o bien tenían que ser explícitos y no conflictivos, o venir de algún lugar de *afuera* de Puppet y estar ya resueltos al momento que el parseo de Puppet comenzara ([La búsqueda automática de parámetros de Puppet 3](http://docs.puppetlabs.com/hiera/1/puppet.html#automatic-parameter-lookup)).

##Antiguas formas de configurar clases

Los parámetros de clase se agregaron a Puppet en la versión 2.6.0, para hacer frente a la necesidad de una forma estándar y visible de configurar clases.

Antes que eso, la gente generalmente configuraba clases eligiendo un nombre de variable arbitrario externo, y pidiendo a la clase que traiga esa variable con una [búsqueda de variables con scope dinámico](http://docs.puppetlabs.com/guides/scope_and_puppet.html):

	    $some_variable
	    include some_class
	    # Esta clase va a buscar por fuera de su scope y rezar
	    # que pueda encontrar un valor para $some_variable.

Había algunos problemas con esto:

+ Cada clase competía por nombres de variable en un namespace efectivamente global. Si accidentalmente elegías un nombre que no era único para tus variables mágicas, pasaría algo malo.
+ Cuando se escribían módulos para compartir con el mundo, debían ser muy cuidadosos de documentar todas las variables mágicas; no había un lugar estándar que el usuario pudiera chequear para ver qué información necesitaba una clase.
+ Esto inspiró a mucha gente a intentar hacer jerarquías de información complejas con herencia de nodo, lo que raramente funcionaba y tendía a fallar de forma dramática y confusa.

#Ejemplo: NTP (otra vez)
Entonces, volvamos al módulo NTP. La primera cosa de la que hablamos acerca de esperar para configurar fue el conjunto de servidores, es un buen lugar para comenzar. Primero, agrega un parámetro:

	    class ntp ($servers = undef) {
	      ...

Luego, cambiaremos cómo configurar la variable **$servers_real** que utiliza el template:

	      if $servers == undef {
	        $servers_real = $default_servers
	      }
	      else {
	        $servers_real = $servers
	      }

Si especificamos un array de servidores, utilizaremos ese; de lo contrario, utilizaremos los defaults. Eso es todo lo que necesita. 

Si declaras la clase sin atributos:

	    include ntp

Funcionará de la misma manera que siempre. Si la declaras con un atributo **servers** conteniendo un array de servidores (con o sin las declaraciones **iburst** y **dynamic** adjuntas):

	    class {'ntp':
	      servers => [ "ntp1.example.com dynamic", "ntp2.example.com dynamic", ],
	    }

Sobreescribirá los servidores por defecto en el archivo **ntp.conf**.

Hay algunos trucos a tener en cuenta: puede parecer raro asignar una variable o parámetro a **undef**, y lo hacemos sólo porque queremos poder acceder a los servidores por defecto sin tener que pedirlos. Recuerda que los parámetros no pueden ser opcionales sin un valor por defecto explícito.

Recuerdas la cuestión de la variable **$servers_real**? Eso es porque el lenguaje de Puppet no nos permitirá reasignar la variable **$servers** dentro de un scope determinado. Si el valor por defecto que queremos era el mismo independientemente del sistema operativo, podíamos utilizarlo como un parámetro por defecto, pero la lógica extra para acomodar los defaults según sistema operativo significa tener que hacer una copia de la variable.

Mientras estamos en el módulo NTP, qué más podemos transformar en un parámetro? Bueno, digamos que a veces quieres prevenir que el daemon de NTP sea utilizado como servidor por otros nodos, o quizás quieres instalar y configurar NTP pero sin el daemon funcionando. Podías exponer todo eso como parámetros extra de la clase, y hacer cambios en el manifiesto y los templates para utilizarlos.

Todos esos cambios están basados en decisiones desde el módulo puppetlabs/ntp. [Puedes ver el código fuente de este módulo](https://github.com/puppetlabs/puppetlabs-ntp) y ver cómo estos parámetros extra evolucionan en manifiestos y templates.

#Documentación del módulo
En este momento tienes un módulo NTP bastante funcional, faltaría la documentación:

	    # = Class: ntp
	    #
	    # Esta clase instala/configura/maneja NTP. Opcionalmente puede deshabilitar NTP
	    # en máquinas virtuales. Soportada sólo en Sistemas operativos derivados Debian y RedHat.
	    #
	    # == Parámetros:
	    #
	    # $servers:: Un array de servidores NTP, con o sin +iburst+ y
	    #            declaraciones +dynamic+ anexadas. Asume por defecto los defaults del sistema operativo.
	    # $enable::  iniciar el servicio NTP en el arranque o no. El valor predeterminado es verdadero. 
	    #            Valores válidos: true y false.
	    # $ensure::  ejecutar el servicio NTP o no. El valor predeterminado es running. Valores válidos:
	    #            running y stopped.
	    #
	    # == Requiere:
	    #
	    # Nada.
	    #
	    # == Ejemplos de uso:
	    #
	    #   class {'ntp':
	    #     servers => [ "ntp1.example.com dynamic",
	    #                  "ntp2.example.com dynamic", ],
	    #   }
	    #   class {'ntp':
	    #     enable => false,
	    #     ensure => stopped,
	    #   }
	    #
	    class ntp ($servers = undef, $enable = true, $ensure = running) {
	      case $operatingsystem { ...
	      ...

No necesitas ser Tolstoi para escribir esto; pero debes, al menos, escribir qué son los parámetros y qué tipo de información toman. En el futuro te lo agradecerás.

También! Si escribes tu documentación en formato [RDoc]() y la colocas en un bloque de comentario directamente antes del principio de la definición de clase, puedes generar automáticamente un sitio explorable estilo Rdoc con información para todos tus módulos. De hecho, puedes probarlo ahora:

	# puppet doc --mode rdoc --outputdir ~/moduledocs --modulepath /etc/puppetlabs/puppet/modules

#Siguiente paso
**Próxima clase**

Ok, ahora podemos pasar parámetros a clases y cambiar su comportamiento. Fantástico! Pero las clases siguen siendo singletons, no puedes declarar más de una copia y obtener dos conjuntos diferentes de comportamiento en simultáneo, pero eventualmente querrás hacerlo!

Qué pasa si tienes una colección de recursos que crea una definición de host virtual para un servidor web; o clona un repositorio Git; o maneja una cuenta de usuario completa con un grupo, clave SSH, contenidos del home, entradas de sudoers, y archivos *.bashrc/.vimrc/etc.*? Qué pasa si quieres más de un repositorio Git, una cuenta de usuario o vhost en una sola máquina?

Bueno, deberías [armar un tipo de recurso definido](http://docs.puppetlabs.com/es/learning/definedtypes.html).
