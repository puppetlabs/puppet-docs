---
layout: default
title: "Aprende Puppet – Variables, condicionales y facts"
canonical: "/es/learning/variables.html"
---

## Comienzo

    $my_variable = "A bunch of text"
    notify {$my_variable:}

Sí, eso es una variable. Bien.

## Variables

Variables! Seguramente ya usaste variables en otro lenguaje de programación o scripting, así que cubriremos los conceptos básicos rápidamente. Hay una explicación más completa acerca de la sintaxis y el comportamiento de las variables disponible en [el capítulo de variables en el manual de referencia de Puppet](http://docs.puppetlabs.com/puppet/latest/reference/lang_variables.html).

+ Las **$variables** siempre comienzan con un signo de dólar. Tú asignas variables con el operador **=**.
+ Las variables pueden contener strings, números, booleanos, arrays, hashes y el valor especial **undef**. Mira [el capítulo de tipos de datos en el manual de referencia de Puppet](http://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html) para más información.
+ Si nunca has asignado una variable, de todos modos puedes utilizarla, su valor será **undef**.
+ Puedes utilizar variables como valor para cualquier atributo de recurso, o como el título de uno.
+ Puedes también interpolar variables dentro de strings con comillas dobles. Para distinguir una variable del texto que la rodea, puedes colocar su nombre entre llaves (**”Esto es el nombre de la ${variable}.”**). No es obligatorio, pero sí recomendable.
+ Toda variable tiene dos nombres:
    + Nombre corto local
    + Nombre completo

El nombre completo de las variables se ven así: **$scope::variable**. Las variables top scope son iguales, excepto por que su scope no tiene nombre, por ejemplo: **$::top_scope_variable**.

+ Si haces referencia a una variable con su nombre corto y ésta no está presente en el scope local, Puppet también chequeará el top scope global, es decir, que puedes referirte casi siempre a las variables globales con sus nombres cortos. Puedes ver más sobre esto en el capítulo de scope en el manual de referencia: [scope en Puppet Enterprise 2.x y Puppet 2.7](http://docs.puppetlabs.com/puppet/2.7/reference/lang_scope.html), y [scope en Puppet 3](http://docs.puppetlabs.com/puppet/latest/reference/lang_scope.html).
+ Sólo puedes asignar la misma variable **una vez** en un scope determinado. De esta forma, son más como las constantes de otros lenguajes de programación.

        $longthing = "Imagine I have something really long in here. Like an SSH key, let's say."

        file {'authorized_keys':
          path    => '/root/.ssh/authorized_keys',
          content => $longthing,
        }

Simple.

### Nota aparte: ¿Por qué todos los manifiestos parecen utilizar $::ipaddress?

La gente que escribe manifiestos para compartir con otros, a menudo tiene el hábito de utilizar siempre la notación **$::variable** cuando hacen referencia a facts.

Como hemos dicho antes, el prefijo de dos puntos doble especifica que debe encontrarse una variable determinada en el top scope; pero esto no es necesario ya que la búsqueda de variables siempre llegará al top scope. Mira [el capítulo de scope en el manual de referencia de Puppet](http://docs.puppetlabs.com/puppet/latest/reference/lang_scope.html).

Sin embargo, pedir explícitamente el top scope ayuda a esquivar dos cuestiones que pueden hacer que el código público se comporte de forma impredecible. Una afecta a todas las versiones de Puppet 2.x, y la otra a versiones tempranas de Puppet 2.7.x:

    + En Puppet 2.x: Si un usuario declara una clase de un módulo público dentro de una de sus propias clases, y su clase personal establece una variable cuyo nombre coincide con el nombre del fact que la clase pública intenta acceder, la clase pública usará la variable local en lugar del fact. Esto causará que la clase pública falle o tenga un comportamiento extraño.
    + En versiones tempranas a Puppet 2.7.x: Las "deprecation warnings" del scope dinámico puede que se activen de forma inapropiada cuando un manifiesto accede a variables top scope sin el prefijo de dos puntos. Esto se arregló en versiones posteriores, pero fue muy molesto por un tiempo.

Ninguna de estas cuestiones son relevantes en Puppet 3, pero no todos lo utilizan todavía y una versión de Puppet Enterprise basada en Puppet 3 llegará a fin de año. Como mucha gente todavía escribe código público utilizando Puppet 2.7, todavía verás mucho estas frases.

## Facts
Puppet tiene un montón de variables integradas pre asignadas que puedes utilizar. Fíjate:


        # /root/examples/motd.pp

        file {'motd':
          ensure  => file,
          path    => '/etc/motd',
          mode    => 0644,
          content => "This Learning Puppet VM's IP address is ${ipaddress}. It thinks its
        hostname is ${fqdn}, but you might not be able to reach it there
        from your host machine. It is running ${operatingsystem} ${operatingsystemrelease} and
        Puppet ${puppetversion}.
        Web console login:
          URL: https://${ipaddress_eth0}
          User: puppet@example.com
          Password: learningpuppet
        ",
        }


    # puppet apply /root/examples/motd.pp

    notice: /Stage[main]//Host[puppet]/ensure: created
    notice: /Stage[main]//File[motd]/ensure: defined content as '{md5}bb1a70a2a2ac5ed3cb83e1a8caa0e331'

    # cat /etc/motd
    This Learning Puppet VM's IP address is 172.16.52.135. It thinks its
    hostname is learn.localdomain, but you might not be able to reach it there
    from your host machine. It is running CentOS 5.7 and
    Puppet 2.7.21 (Puppet Enterprise 2.8.1).
    Web console login:
      URL: https://172.16.52.135
      User: puppet@example.com
      Password: learningpuppet


Los manifiestos se vuelven más flexibles, sin necesidad de una inversión de tiempo de nuestra parte.

### Qué son estas variables de IPaddress y Hostname?

Y de dónde vienen?

Son [“facts”](http://docs.puppetlabs.com/puppet/latest/reference/lang_variables.html#facts-and-built-in-variables), Puppet utiliza una herramienta llamada Facter, la cual descubre  información del sistema, la normaliza en un conjunto de variables y los pasa a Puppet. El compilador de Puppet tiene acceso a esos facts cuando lee un manifiesto.

+ [Mira esta lista de facts fundamentales incluídos en Facter](http://docs.puppetlabs.com/facter/latest/core_facts.html). La mayoría de ellos están siempre disponibles para Puppet aunque algunos estén presentes sólo en determinados tipos de sistemas.
+ Puedes ver lo que Facter sabe sobre un sistema determinado ejecutando **facter** en la línea de comandos.
+ También puedes ver el resto de los facts de cualquier nodo en tu implementación de Puppet Enterprise ingresando a la página de ese nodo en la consola y [yendo a la información de inventario](http://docs.puppetlabs.com/pe/latest/console_reports.html#viewing-inventory-data)
+ También puedes agregar nuevos facts customizados a Puppet; mira [la guía de facts customizados](http://docs.puppetlabs.com/guides/custom_facts.html) para más información.

### Otras variables integradas
Además de los facts de Facter, Puppet tiene algunas variables integradas más. Puedes ver la lista en [el capítulo de variables del manual de referencia de Puppet](http://docs.puppetlabs.com/puppet/latest/reference/lang_variables.html#facts-and-built-in-variables).

## Declaraciones condicionales
Puppet tiene varios tipos de declaraciones condicionales. Puedes ver información más completa acerca de esto en [el capítulo de declaraciones condicionales del manual de referencia de Puppet](http://docs.puppetlabs.com/puppet/latest/reference/lang_conditional.html). Utilizando facts como condiciones, puedes pedirle fácilmente a Puppet que realice diferentes cosas en diferentes tipos de sistemas.

### If

Comencemos con la declaración más básica: [**if**](http://docs.puppetlabs.com/puppet/latest/reference/lang_conditional.html#if-statements). Igual que siempre:

    if condición {
        bloque de código
    }
    elsif condición {
        bloque de código
    }
    else {
        bloque de código
    }


+ Las declaraciones **else** y cualquier cantidad de **elsif** son opcionales.
+ El bloque de código de cada condición puede contener cualquier código Puppet.
+ Las condiciones pueden ser cualquier fragmento de código Puppet que resuelva a un booleano de valor verdadero/falso, incluyendo [expresiones](http://docs.puppetlabs.com/puppet/latest/reference/lang_expressions.html), [funciones](http://docs.puppetlabs.com/puppet/latest/reference/lang_functions.html) que devuelvan variables, y variables. Chequea los links para descripciones más detalladas de expresiones y funciones.

Un ejemplo de declaración **if**:


      if str2bool("$is_virtual") {
          service {'ntpd':
            ensure => stopped,
            enable => false,
          }
        }
        else {
          service { 'ntpd':
            name       => 'ntpd',
            ensure     => running,
            enable     => true,
            hasrestart => true,
            require => Package['ntp'],
          }
        }

### Nota aparte: Cuidado con el “False” falso!
En el ejemplo anterior, vimos algo nuevo: ** str2bool("$is_virtual")**.

La condición para una declaración **if** tiene que resolver a un valor booleano verdadero/falso. Sin embargo, todos los facts son [strings](http://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html#strings), y todos los strings que no estén vacíos, incluyendo el string **”False”**, son verdaderos. Esto significa que los facts que sean “false” tienen que ser transformados antes que Puppet los pueda interpretarlos como falsos.

En este caso: 

+ Colocamos la variable entre comillas dobles, si por algún motivo contiene un booleano real (lo que no es lo más usual) esto lo convertiría en un un string.
+ Pasamos el string a la función **str2bool**, la cual convierte un string que *parece* un booleano en uno de valor real verdadero/falso.

La [función](http://docs.puppetlabs.com/puppet/latest/reference/lang_functions.html)  **str2bool** es parte del módulo [puppetlabs/stdlib](http://forge.puppetlabs.com/puppetlabs/stdlib), incluido en Puppet Enterprise. Si estás ejecutando Puppet open source, puedes instalarlo ejecutando **sudo puppet module install puppetlabs/stdlib**.

También es posible utilizar la expresión **$is_virtual == 'true'**, la cual resolvería a *true* si el fact **is_virtual** tiene el valor verdadero, y *false* en caso contrario. 

### Case

Otro tipo de condicional es la [declaración de *case*](http://docs.puppetlabs.com/puppet/latest/reference/lang_conditional.html#case-statements), (o *switch*, o como se diga en tu lenguaje preferido).

        case $operatingsystem {
          centos: { $apache = "httpd" }
          # Note that these matches are case-insensitive.
          redhat: { $apache = "httpd" }
          debian: { $apache = "apache2" }
          ubuntu: { $apache = "apache2" }
          default: { fail("Unrecognized operating system for webserver") }
        }
        package {'apache':
          name   => $apache,
          ensure => latest,
        }

En lugar de probar una condición al principio, **case** compara una variable contra un grupo de valores posibles. **_default_ es un valor especial**, que hace exactamente lo que parece. 

En este ejemplo, también vemos la [función **fail**](http://docs.puppetlabs.com/references/latest/function.html#fail). A diferencia de la función **str2bool** que vimos antes, **fail** no resuelve a un valor; por el contrario, se produce inmediatamente un error de compilación con un mensaje de error.

#### Coincidencia de casos

Los casos coincidentes pueden ser strings simples como los anteriores, [expresiones regulares](http://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html#regular-expressions), o listas de uno u otro separadas por comas.

Aquí un ejemplo de lo dicho anteriormente, re escrito para utilizar una lista de strings separados por comas:

        case $operatingsystem {
          centos, redhat: { $apache = "httpd" }
          debian, ubuntu: { $apache = "apache2" }
          default: { fail("Unrecognized operating system for webserver") }
        }

Y aquí un exemplo con regex:

        case $ipaddress_eth0 {
          /^127[\d.]+$/: {
            notify {'misconfig':
              message => "Possible network misconfiguration: IP address of $0",
            }
          }
        }

La coincidencia de strings no distingue entre mayúsculas y minúsculas, como [el operador de comparación ==](http://docs.puppetlabs.com/puppet/latest/reference/lang_expressions.html#equality). Las expresiones regulares se denotan entre barras (/), como se hace en Perl y Ruby; las cuales por defecto tampoco distinguen entre mayúsculas y minúsculas, pero puedes utilizar los switches **(?i)** y **(?-i)** para activar y desactivar esta distinción dentro del patrón. Las coincidencias de regex también asignan subpatrones capturados a **$1**, **$2**, etc. dentro del bloque de código asociado, con **$0** conteniendo todo el string coincidente. Mira [la sección de expresiones regulares en la página de tipos de datos del manual de referencia de Puppet ](http://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html#regular-expressions) para más detalles.

### Selectores
Los selectores te pueden parecer menos familiares, son algo así como el [operador ternario](http://en.wikipedia.org/wiki/%3F:) común y también como la declaración de *case*.

En lugar de elegir entre un conjunto de bloques de código, los selectores eligen entre un grupo de valores posibles. No puedes utilizarlos solos; por el contrario, generalmente se utilizan para asignar una variable.

        $apache = $operatingsystem ? {
          centos                => 'httpd',
          redhat                => 'httpd',
          /(?i)(ubuntu|debian)/ => 'apache2',
          default               => undef,
        }

Ten cuidado con la sintaxis: Parece como si dijéramos **$apache = $operatingsystem**, pero no. El signo de interrogación marca a **$operatingsystem** como la variable de control de un selector, y el valor real que es asignado está determinado por la opción que coindice con **$operatingsystem**. También ten en cuenta cómo la sintaxis difiere de la sintaxis de *case*: utiliza flecha de hash (=>) y comas al final de la línea en lugar de dos puntos y bloques, y no puedes utilizar listas de valores en una coincidencia. Si quieres hacer coincidencias con una lista de valores, tienes que “falsificarlo” con una expresión regular.

Esto puede parecer un poco incómodo, pero hay muchas situaciones donde ésta es la forma más efectiva de resolver un valor. Si no te sientes cómodo con esto, puedes utilizar una declaración de *case* para asignar la variable.

Los selectores también pueden utilizarse directamente como valores para un atributo de recurso, pero trata de no hacerlo porque se complica rápidamente.

## Ejercicios
### Ejercicio: Entorno de compilación


Utiliza el fact $operatingsystem para escribir un manifiesto que instale un entorno de compilación de C en máquinas basadas en Debian (“debian”, “ubuntu”) y Enterprise Linux (“centos”, “redhat”). Ambos tipos de sistemas requieren el paquete **gcc**, los sistemas tipo Debian también requieren **build-essential**.

### Ejercicio: NTP simple
Escribe un manifiesto que instale y configure NTP para sistemas Linux basados en Debian y Entreprise Linux. Será un patrón paquete/archivo/servicio donde ambos tipos de sistemas utilicen el mismo nombre de paquete (**ntp**), pero tu enviarás archivos de configuración diferentes ([versión Debian](http://docs.puppetlabs.com/learning/files/examples/modules/ntp/files/ntp.conf.debian), [versión RedHat](http://docs.puppetlabs.com/learning/files/examples/modules/ntp/files/ntp.conf.el)- recuerda el atributo “source” del tipo de archivo) y utilizarás diferentes nombres de servicio (**ntp** y **ntpd** respectivamente).

##  
Paso Siguiente
**Próxima clase:**
Ahora que tus manifiestos se pueden adaptar a los diferentes tipos de sistemas, es momento de comenzar a agrupar recursos y condicionales en unidades significativas. Sigamos adelante hacia las [clases, tipos de recurso definidos y módulos](http://docs.puppetlabs.com/es/learning/modules1.html)!

**Nota aparte:**
Como los facts de cada nodo aparecen en la consola, Puppet Enterprise puede ser una poderosa herramienta de inventario. [Descarga gratis Puppet Enterprise](http://info.puppetlabs.com/download-pe.html), sigue [la guía de comienzo rápido](http://docs.puppetlabs.com/pe/latest/quick_start.html) para obtener un pequeño entorno instalado y luego navega por el inventario de la consola para obtener una visión central de las versiones de tu sistema operativo, perfiles de hardware y más.
