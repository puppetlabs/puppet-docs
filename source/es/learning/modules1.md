---
layout: default
title: "Aprende Puppet – Módulos y clases"
canonical: "/es/learning/modules1.html"
toc: false
---

#Comienzo

    class my_class {
      notify {"This actually did something":}
    }

Este manifiesto no hace nada.

    class my_class {
      notify {"This actually did something":}
    }

    include my_class


Este sí hace algo.
¿Puedes ver la diferencia?

#El fin de un gran manifiesto

Ya puedes escribir manifiestos bonitos y sofisticados a esta altura, pero hasta ahora los has puesto en un solo archivo (**/etc/puppetlabs/puppet/manifests/site.pp** o uno de un sólo uso con puppet apply)

Con más de 4 o 5 recursos, esto se pone difícil de manejar. Probablemente ya puedes ver el camino al manifiesto de 3 mil líneas de la muerte, y no quieres terminar allí. Es mucho mejor cortar trozos de código relacionados lógicamente en sus propios archivos y luego hacer referencia a esos trozos por el nombre cuando lo necesites.

Las **clases** son la forma de Puppet de separar trozos de código, y los **módulos** son la forma de Puppet de organizar clases para que puedas referirte a ellas por su nombre.

#Clases
Las clases son bloques de código Puppet con nombre, y pueden crearse en un lugar e invocarse en cualquier otro.

+ **Definir** una clase la pone a disposición por su nombre, pero no evalúa automáticamente el código dentro de ella.
+ **Declarar** una clase evalúa el código en la clase, y aplica todos sus recursos.

Por los próximos cinco minutos, vamos a trabajar en un solo archivo de manifiesto: uno de un solo uso, o bien site.pp. Dentro de algunos párrafos comenzaremos a separar código en archivos adicionales.

##Definir una clase
Antes que puedas utilizar una clase, debes **definirla**, lo que se hace con la palabra clave **class**, un nombre, llaves y un bloque de código:


	class my_class {
	  ... puppet code ...
	}


¿Qué es lo que pasa en ese bloque de código? ¿Qué hay de la respuesta del ejercicio NTP del último capítulo? Debería ser algo así:


	    # /root/examples/modules1-ntp1.pp

	    class ntp {
	      case $operatingsystem {
	        centos, redhat: {
	          $service_name = 'ntpd'
	          $conf_file    = 'ntp.conf.el'
	        }
	        debian, ubuntu: {
	          $service_name = 'ntp'
	          $conf_file    = 'ntp.conf.debian'
	        }
	      }

	      package { 'ntp':
	        ensure => installed,
	      }
	      file { 'ntp.conf':
	        path    => '/etc/ntp.conf',
	        ensure  => file,
	        require => Package['ntp'],
	        source  => "/root/examples/answers/${conf_file}"
	      }
	      service { 'ntp':
	        name      => $service_name,
	        ensure    => running,
	        enable    => true,
	        subscribe => File['ntp.conf'],
	      }
	    }


¡Eso es una definición de clase que funciona!

Nota: Puedes descargar algunos archivos básicos de configuración aquí: [versión Debian](http://docs.puppetlabs.com/learning/files/examples/modules/ntp/files/ntp.conf.debian), [versión Red Hat](http://docs.puppetlabs.com/learning/files/examples/modules/ntp/files/ntp.conf.el).

**Nota aparte: Nombres de clases**

[Los nombres de clase](http://docs.puppetlabs.com/puppet/latest/reference/lang_reserved.html#classes-and-types) deben comenzar con minúscula y pueden contener minúscula, letras, números y subrayado.

Los nombres de clase también pueden utilizar cuatro puntos **(::)** como separador de namespace. Esto debe [sonarte conocido](http://docs.puppetlabs.com/learning/variables.html#variables).

Los namespaces se deben corresponder con el layout del módulo, del cual hablaremos luego.

**Nota aparte: Scope de variables**

Cada definición de clase introduce un nuevo scope de variables. Esto quiere decir que:

+ Una variable asignada dentro de una clase no estará disponible con su nombre corto fuera de la clase; para acceder a ella, deberás usar su nombre completo (por ejemplo, **$ntp::service_name**, en el ejemplo anterior).
+ Puedes asignar valores locales nuevos a nombres de variables que ya han sido usados en el top scope, por ejemplo, puedes especificar un valor local para $fqdn.

##Declarar
Ok, recuerdas que dijimos que *definir* pone a disposición a la clase y *declarar* la evalúa? Podemos ver eso en acción intentando aplicar nuestro manifiesto anterior:

	# puppet apply /root/examples/modules1-ntp1.pp
	notice: Finished catalog run in 0.04 seconds

Lo que no hace nada, porque sólo definimos la clase.

Para **declarar** una clase, utiliza la función **include** con el nombre de clase:


	    # /root/examples/modules1-ntp2.pp

	    class ntp {
	      case $operatingsystem {
	        centos, redhat: {
	          $service_name = 'ntpd'
	          $conf_file    = 'ntp.conf.el'
	        }
	        debian, ubuntu: {
	          $service_name = 'ntp'
	          $conf_file    = 'ntp.conf.debian'
	        }
	      }

	      package { 'ntp':
	        ensure => installed,
	      }
	      file { 'ntp.conf':
	        path    => '/etc/ntp.conf',
	        ensure  => file,
	        require => Package['ntp'],
	        source  => "/root/examples/answers/${conf_file}"
	      }
	      service { 'ntp':
	        name      => $service_name,
	        ensure    => running,
	        enable    => true,
	        subscribe => File['ntp.conf'],
	      }
	    }

	    include ntp

Esta vez, Puppet aplicará todos esos recursos:

	# puppet apply /root/examples/ntp-class1.pp

	notice: /Stage[main]/Ntp/File[ntp.conf]/content: content changed '{md5}5baec8bdbf90f877a05f88ba99e63685' to '{md5}dc20e83b436a358997041a4d8282c1b8'
	notice: /Stage[main]/Ntp/Service[ntp]/ensure: ensure changed 'stopped' to 'running'
	notice: /Stage[main]/Ntp/Service[ntp]: Triggered 'refresh' from 1 events
	notice: Finished catalog run in 0.76 seconds

Clases: Primero definirlas, luego declararlas.

#Módulos
Ya sabes cómo definir y declarar clases, pero seguimos haciendo todo en un sólo manifiesto, lo que no es muy útil.

Para ayudarte a partir tus manifiestos en una estructura más simple de entender, Puppet utiliza **módulos** y la **carga automática de módulos**.

Funciona de la siguiente manera:

+ Los módulos son simplemente directorios con archivos, ordenados en una estructura específica y predecible. Los archivos de manifiesto dentro de un módulo tienen que obedecer a determinadas restricciones.
+ Puppet busca módulos en un lugar (o lista de lugares) específico. Este conjunto de directorios se conoce como el **modulepath**, el cual es [configurable](http://docs.puppetlabs.com/references/stable/configuration.html#modulepath)
+ Si una clase está definida en un módulo, puedes declararla por su nombre en *cualquier manifiesto*. Puppet la encontrará automáticamente y cargará el manifiesto que contiene la definición de clase.

Esto significa que puedes tener una pila de módulos con código Puppet sofisticado, y que tu manifiesto site.pp puede verse así:

	    # /etc/puppetlabs/puppet/manifests/site.pp
	    include ntp
	    include apache
	    include mysql
	    include mongodb
	    include build_essential


Al esconder la *implementación* de una característica en un módulo, tu manifiesto principal puede volverse mucho más pequeño, más legible y enfocado en las pólizas. Puedes ver a primera vista qué se configurará en tus nodos y si necesitas detalles de implementación de cualquier cosa, puedes ahondar en el módulo.

#El Modulepath
Antes de hacer un módulo, necesitamos saber dónde colocarlo; así que buscaremos nuestro modulepath, el conjunto de directorios donde Puppet busca módulos.

El archivo de configuración de Puppet se llama puppet.conf, y en Puppet Entreprise se encuentra en **/etc/puppetlabs/puppet/puppet.conf**:


	# less /etc/puppetlabs/puppet/puppet.conf

	[main]
	    vardir = /var/opt/lib/pe-puppet
	    logdir = /var/log/pe-puppet
	    rundir = /var/run/pe-puppet
	    modulepath = /etc/puppetlabs/puppet/modules:/opt/puppet/share/puppet/modules
	    user = pe-puppet
	    group = pe-puppet
	    archive_files = true
	    archive_file_server = learn.localdomain

	[master]
	    ... etc.


El formato de puppet.conf [está explicado en la guía de configuración](http://docs.puppetlabs.com/guides/configuring.html), pero en resumen, la sección **[main]** contiene opciones de configuración que se aplican a todo (puppet master, puppet apply, puppet agent, etc.) y establece el valor de **modulepath** para una lista de dos directorios separados por dos puntos:

+ **/etc/puppetlabs/puppet/modules**
+ **/opt/puppet/share/puppet/modules**

La primera, **/etc/puppetlabs/puppet/modules**, es el directorio principal de módulos que utilizaremos. El otro contiene módulos especiales que Puppet Enterprise utiliza para configurar sus propias características; puedes echar un vistazo, pero no debes cambiarlas ni agregarles nada.


**Nota aparte: Configprint**
También puedes obtener el valor del modulepath ejecutando **puppet master --configprint modulepath**. La opción **--configprint** te permite obtener el valor de cualquier [opción de configuración](http://docs.puppetlabs.com/references/latest/configuration.html) de Puppet, utilizando el subcomando **master**, nos aseguraremos de obtener el valor que el puppet master utilizará.


# Estructura de un módulo

+ Un módulo es un directorio
+ El nombre del módulo debe ser el nombre del directorio
+ El directorio **manifests** siempre debe contener un archivo **init.pp**
	+ Este archivo debe contener una sola definición de clase. El nombre de la clase debe ser el mismo que el del módulo.

Hay más que aprender, pero con esto podemos comenzar. Transformemos la clase NTP en un módulo real:


	# cd /etc/puppetlabs/puppet/modules
	# mkdir -p ntp/manifests
	# touch ntp/manifests/init.pp

Edita el archivo init.pp y pega la definición de la clase NTP en él. Asegúrate de no pegar la declaración **include**, no es necesaria aquí.


	    # /etc/puppetlabs/puppet/modules/ntp/manifests/init.pp

	    class ntp {
	      case $operatingsystem {
	        centos, redhat: {
	          $service_name = 'ntpd'
	          $conf_file    = 'ntp.conf.el'
	        }
	        debian, ubuntu: {
	          $service_name = 'ntp'
	          $conf_file    = 'ntp.conf.debian'
	        }
	      }

	      package { 'ntp':
	        ensure => installed,
	      }
	      file { 'ntp.conf':
	        path    => '/etc/ntp.conf',
	        ensure  => file,
	        require => Package['ntp'],
	        source  => "/root/examples/answers/${conf_file}"
	      }
	      service { 'ntp':
	        name      => $service_name,
	        ensure    => running,
	        enable    => true,
	        subscribe => File['ntp.conf'],
	      }
	    }


##Declarar clases desde módulos
Ahora que tenemos un módulo funcionando, puedes editar el archivo site.pp: Si queda algún recurso relacionado a NTP en él, asegúrate de borrarlo, y luego agrega esta línea:

	include ntp

Apaga el servicio NTP y luego ejecuta el agente en el foreground para ver la acción:

	# service ntpd stop
	# puppet agent --test

	notice: /Stage[main]/Ntp/Service[ntp]/ensure: ensure changed 'stopped' to 'running'

¡Funcionó!

#Más acerca de declarar clases
Una vez que una clase se almacena en un módulo, existen varias formas de declarar o asignarlas. Debes intentar cada una de estas ahora mismo: apagas manualmente el servicio ntpd, declaras o asignas la clase y ejecuta el agente de Puppet en el foreground.

##Include
Ya hemos visto esto: Puedes declarar clases colocando **include ntp** en el manifiesto principal.

La función **include** declara una clase si ésta no ha sido declarada en otro lugar. Si una YA HA SIDO declarada, **include** lo notará y no hará nada.

Esto te permite declarar una clase de manera segura en varios lugares. Si alguna clase depende de algo en otra clase, se puede declarar esa clase sin problemas si también se declara en site.pp.

## Declaraciones de clase tipo recurso
Éstas parecen declaraciones de recurso, pero con un tipo de recurso de “clase”:

	    class {'ntp':}

Se comportan de forma diferente, actúan más como recursos que como la función **include**. 

¿Recuerdas que vimos que no puedes declarar el mismo recurso más de una vez? Lo mismo se puede decir de las declaraciones de clase tipo recurso. Si Puppet intenta evaluar una, y la clase ya ha sido declarada, fallará la compilación con un error.

Sin embargo, a diferencia de **include**, las declaraciones tipo recurso te permiten especificar *parámetros de clase*. Hablaremos de esto en otro [capítulo más adelante](http://docs.puppetlabs.com/learning/modules2.html), y ahondaremos en por qué las declaraciones tipo recurso son tan estrictas.

##La consola de PE
También puedes asignar clases a nodos específicos utilizando la consola web de Puppet Enterprise. Tienes que [agregar la clase a la consola](http://docs.puppetlabs.com/pe/latest/console_classes_groups.html#adding-a-new-class), luego ir a la página del nodo y [asignar la clase a ese nodo](http://docs.puppetlabs.com/pe/latest/console_classes_groups.html#assigning-classes-and-groups-to-nodes).

Más adelante hablaremos con más detalle acerca del trabajo con múltiples nodos.

# Estructura de un módulo, Parte 2
Todavía no hemos terminado con este módulo. ¿Te has dado cuenta de que el atributo **source** del archivo de configuración apunta a una ruta local arbitraria? Podemos mover esos archivos dentro del módulo, y volver todo más independiente:

	# mkdir /etc/puppetlabs/puppet/modules/ntp/files
	# mv /root/examples/answers/ntp.conf.* /etc/puppetlabs/puppet/modules/ntp/files/

Luego, edita el manifiesto init.pp; utilizaremos el formato de URL especial **puppet:///** para decirle a Puppet dónde están los archivos:

	    # ...
	      file { 'ntp.conf':
	        path    => '/etc/ntp.conf',
	        ensure  => file,
	        require => Package['ntp'],
	        source  => "puppet:///modules/ntp/${conf_file}",
	      }
	    }

Ahora, todo lo que el módulo necesita está en un solo lugar. Mejor aún, ahora un puppet master puede servir esos archivos a nodos agentes en la red. Al utilizar las rutas **/root/examples/etc...**, Puppet sólo encontraría la fuente de los archivos si éstos ya existieran en la máquina de destino.

##Los otros subdirectorios
Hemos visto dos de los subdirectorios en un módulo, pero hay muchos más disponibles:

+ **manifests/**: Contiene todos los manifiestos del módulo.
+ **files/**: Contiene archivos estáticos que los nodos administrados por Puppet pueden descargar.
+ **templates/**: Contiene templates, a los que se puede hacer referencia desde los manifiestos del módulo. [Luego hablaremos más acerca de templates](http://docs.puppetlabs.com/learning/templates.html).
+ **lib/**: Contiene plugins como facts customizados y tipos de recurso customizados.
+ **tests/** o **examples/**: Contienen ejemplos de manifiestos que muestran cómo declarar las clases del módulo y tipos definidos.
+ **spec/**: Contienen archivos de prueba escritos con rspec-puppet.

La [hoja de repaso de *módulo*](http://docs.puppetlabs.com/module_cheat_sheet.pdf) que puedes imprimir, te muestra cómo diseñar un módulo y explica cómo los nombres *en manifiestos* se corresponden con los archivos subyacentes; es una buena referencia cuando estás comenzando. El manual de referencia también tiene una [página de información sobre diseño de módulos](http://docs.puppetlabs.com/puppet/latest/reference/modules_fundamentals.html).

Es un buen momento para explicar más acerca de cómo funcionan los directorios **manifests** y **files**:

##Organizar y hacer referencia a manifiestos
Cada manifiesto en un módulo debe contener exactamente una clase o tipo definido (más detalle luego acerca de *tipos definidos*).

El nombre de cada manifiesto se debe corresponder con el nombre de la clase o tipo definido que contiene. El archivo init.pp que utilizamos antes, es especial: siempre contiene una clase o tipo definido con el mismo nombre que el módulo. El resto de los archivos deben contener una clase o tipo definido así:

	<NOMBRE DEL MÓDULO>::<NOMBRE DEL ARCHIVO>

O, si el archivo está dentro de un subdirectorio de **manifests/**, se debe llamar:

	<NOMBRE DEL MÓDULO>::<NOMBRE DEL SUBDIRECTORIO>::<NOMBRE DEL ARCHIVO>

Entonces, por ejemplo, si tenemos un módulo apache que contiene una clase mod_passenger:

+ Archivo en disco: **apache/manifests/mod_passenger.pp**
+ Nombre de clase en el archivo: **apache::mod_passenger**

Puedes ver más acerca de esta correspondencia en [la página de namespaces y carga automática (autoloading) del manual de referencia de Puppet](http://docs.puppetlabs.com/puppet/latest/reference/lang_namespaces.html).

##Organizar y hacer referencia a archivos
Los archivos estáticos pueden ser ordenados en cualquier estructura de directorio dentro del directorio **files/**. Cuando haces referencia a estos archivos en los manifiestos Puppet, como los atributos de **source** de recursos de archivos, debes utilizar la URL **puppet:///**.  Deben estar estructurados de cierta forma:

<table>
 <thead>
	<tr>
	 <th>Protocolo</th>
	 <th>3 barras</th>
	 <th>“módulos”/</th>
	 <th>Nombre del módulo/</th>
	 <th>Nombre del archivo</th>
	</tr>
 </thead>
 <tbody>
	<tr>
	 <td>puppet:</td>
	 <td>///</td>
	 <td>modules/</td>
	 <td>ntp/</td>
	 <td>ntp.conf.el</td>
	</tr>
 </tbody>
</table>

Ten en cuenta que el segmento final de la URL comienza dentro del directorio **files/** del módulo. Si hay otros subdirectorios, funcionan como esperas, así que puede que tengas algo parecido a **puppet:///modules/ntp/config_files/linux/ntp.conf.el**.

# Puppet Forge: Cómo evitar escribir módulos
Ahora que sabes cómo funcionan los módulos, puedes utilizar módulos escritos por otros usuarios.

[Puppet forge](http://forge.puppetlabs.com/) es un repositorio de módulos gratuitos que puedes instalar y utilizar. La mayoría son open source, y puedes contribuir con actualizaciones y cambios para mejorarlos. Así como también puedes aportar tus propios módulos.

# El subcomando de Puppet Module
Puppet viene con un subcomando para instalar y manejar módulos desde Puppet Forge. Puedes encontrar instrucciones detalladas para utilizarlo en [la página “Instalar módulos” del manual de referencia de Puppet](http://docs.puppetlabs.com/puppet/latest/reference/modules_installing.html). Aquí, algunos ejemplos:

	$ sudo puppet module install puppetlabs-mysql

Listar todos los módulos instalados:

$ sudo puppet module list

**Prefijos de nombres de usuario**

Los módulos de Puppet Forge tienen un prefijo de nombre de usuario en sus nombres; esto es para evitar conflictos de nombres entre, por ejemplo, todos los de Apache.

El subcomando **puppet module** maneja estos prefijos de nombre de usuario automáticamente, esto los preserva como metadatos, pero instala el módulo con su nombre común. Esto significa que tus manifiestos de Puppet deberían hacer referencia al módulo **mysql** y no a **puppetlabs-mysql**.

#Ejercicios
###Ejercicio: Otra vez Apache
Construyendo sobre el trabajo que has hecho dos capítulos atrás, crea un módulo Apache y una clase que asegure que Apache está instalado, en ejecución y manejando su archivo de configuración. 

**Trabajo extra**: Haz que Puppet maneje la carpeta DocumentRoot, coloque una página 404 customizada y un index.html por defecto en ese lugar. También puedes utilizar declaraciones condicionales para establecer cualquier archivo o nombres paquete/servicio que puedan variar según el sistema operativo. Si no quieres investigar los nombres utilizados por otros sistemas operativos, puedes hacer que la clase falle si no se utiliza en CentOS.

#Siguiente paso
**Próxima clase**

¿Qué pasa con esa carpeta **templates/** en la estructura del módulo? ¿Podemos hacer algo más interesante con los archivos de configuración que reemplazarlos con contenido estático? [Averígualo en el capítulo de Templates](http://docs.puppetlabs.com/learning/templates.html).

**Nota aparte:**

Como ya sabes instalar módulos gratis de Puppet Forge, y cómo declarar las clases dentro de esos módulos, investiga e intenta encontrar módulos que puedan ser útiles en tu infraestructura; luego, [descarga gratis Puppet Enterprise](http://info.puppetlabs.com/download-pe.html), sigue [la guía de comienzo rápido](http://docs.puppetlabs.com/pe/latest/quick_start.html) para obtener un pequeño entorno instalado y luego intenta manejar servicios complejos en alguno de tus nodos de prueba.

