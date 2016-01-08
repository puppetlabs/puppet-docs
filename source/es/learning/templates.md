---
layout: default
title: "Aprende Puppet – Templates"
canonical: "/es/learning/templates.html"
---

## Comienzo
Hagamos un pequeño ajuste al módulo NTP del capítulo anterior: quita el atributo **source** del recurso de archivo, y reemplázalo con un atributo **content** utilizando una nueva función. Recuerda que **source** especifica el contenido del archivo como un archivo, y **content** especifica el contenido del archivo como un *string*.

	    # /etc/puppetlabs/puppet/modules/ntp/manifests/init.pp

	    class ntp {
	      #...
	      #...
	      #...
	      file { 'ntp.conf':
	        path    => '/etc/ntp.conf',
	        ensure  => file,
	        require => Package['ntp'],
	        content => template("ntp/${conf_file}.erb"),
	      }
	    }


Luego, copia los archivos de configuración en el directorio de templates:

	# cd /etc/puppetlabs/puppet/modules/ntp
	# mkdir templates
	# cp files/ntp.conf.el templates/ntp.conf.el.erb
	# cp files/ntp.conf.debian templates/ntp.conf.debian.erb

El módulo debe funcionar de la misma manera que ha estado funcionando, pero los archivos de configuración ya no son archivos estáticos, ahora son templates.

## Frena la explosión de contenido estático

Considera el módulo NTP.

Ahora, incluimos 2 archivos de configuración diferentes que se parecen a los defaults para los sistemas operativos tipo Red Hat y Debian. ¿Y si queríamos hacer algunos cambios pequeños y razonables? Por ejemplo:

+ Utilizar servidores NTP diferentes para un pequeño grupo de máquinas
+ Ajustar las opciones de configuración en máquinas virtuales para que NTP no entre en pánico si la hora del reloj del sistema cambia repentinamente.

¡Hubiéramos terminado manteniendo ocho o más archivos de configuración diferentes! No lo hagamos; en lugar de eso,  podemos manejar unas cuantas pequeñas diferencias en uno o dos archivos de **Template**.

Los templates son documentos que contienen una mezcla de contenido *estático* y *dinámico*. Utilizando una pequeña cantidad de lógica condicional e interpolación de variables, te permiten mantener un documento fuente que puede ser renderizado en cualquier cantidad de documentos finales.

Para más detalles acerca del comportamiento de los templates de Puppet, mira [la guía para utilizar templates de Puppet](http://docs.puppetlabs.com/guides/templating.html), donde encontrarás una explicación básica.

## Archivos de templates
Los templates son salvados como archivos con extensión .erb, y se deben guardar en el directorio **templates/** de cualquier módulo. Puede haber cualquier cantidad de subdirectorios dentro de **templates/**.

## Rendering de templates

Para utilizar un template, lo tienes que renderizar para producir un string de salida. Para hacer esto, utiliza la [función de **template**](http://docs.puppetlabs.com/references/stable/function.html#template) integrada. Esta función toma un path a uno o más archivos de templates y devuelve un string de salida.

	    file {'/etc/foo.conf':
	      ensure  => file,
	      require => Package['foo'],
	      content => template('foo/foo.conf.erb'),
	    }


Ten en cuenta que estamos utilizando el string de salida como el valor del atributo **content**. No funcionaría con el atributo **source**, el cual espera una URL en lugar del contenido real para un archivo.

### Hacer referencia a archivos de templates en módulos

La función **template** espera que las rutas de archivos tengan un formato específico:

	<NOMBRE DEL MÓDULO>/<NOMBRE DEL ARCHIVO DENTRO DE DIRECTORIOS DE TEMPLATES>

Esto significa que **template(‘foo/foo.conf.erb’)** apuntaría al archivo **/etc/puppetlabs/puppet/modules/foo/templates/foo.conf.erb**.
Ten en cuenta que la ruta al template no utiliza la misma semántica que la ruta en la URL **puppet:///**. Disculpas por la inconsistencia.

### Templates inline

Otra alternativa es utilizar la [función **inline_template**](http://docs.puppetlabs.com/references/stable/function.html#inlinetemplate), que toma un string que contiene un template y devuelve un string de salida.
Esto no es útil tan frecuentemente, pero si tienes un template muy pequeño lo puedes insertar en el manifiesto en lugar de hacer un archivo nuevo para esto.

### Nota aparte: Funciones en general
Ya hemos visto varias funciones, incluyendo **include**, **template**, **fail**, y **str2bool**; así que este es un buen momento para explicar qué son.

Puppet tiene dos tipos de funciones:

+ Funciones que devuelven un valor
+ Funciones que hacen otra cosa y no devuelven un valor.

Las funciones **template** y **str2bool** devuelven valores que puedes utilizar en cualquier lugar que necesite un valor, siempre que el valor de retorno sea el correcto. Las funciones **include** y **fail** hacen algo diferente a devolver un valor: declaran una clase y paran la compilación de un catálogo respectivamente. 

Todas las funciones se ejecutan durante la compilación de catálogo, esto significa que se ejecutan en el puppet master y no necesitan acceder a ningún archivo u opciones de configuración en el nodo agente.

Las funciones pueden tomar cualquier cantidad de argumentos, los cuales están separados por comas y pueden opcionalmente estar entre paréntesis.

	function(argument, argument, argument)

Las funciones son plugins, por lo que muchos plugins customizados están disponibles en módulos.

La documentación completa acerca de las funciones está disponible en [la página de funciones en el manual de referencia de Puppet](http://docs.puppetlabs.com/puppet/latest/reference/lang_functions.html) y en [la lista de funciones integradas](http://docs.puppetlabs.com/references/stable/function.html).

# Variables en templates

Los templates son poderosos porque tienen acceso a todas las variables de Puppet que están presentes cuando se renderiza el template.

+ Los **facts, variables globales**, y **variables locales del scope actual** están disponibles para un template como *variables de instancia de Ruby*; en lugar de los prefijos de Puppet **$**, tienen el prefijo **@**, por ejemplo, **@fqdn, @memoryfree, @operatingsystem**, etc.
+ Se puede acceder a las variables de otros scopes con el método **scope.lookupvar**, que toma un nombre de variable completo sin el prefijo **$**, por ejemplo, **scope.lookupvar(‘apache::user’)**.

## El lenguaje de templating ERB

Puppet no tiene lenguaje de templating propio sino que utiliza ERB, un lenguaje común de template basado en Ruby. El framework de Rails utiliza ERB al igual que otros projectos.

Los templates ERB parecen archivos de configuración normales, con el ocasional **<% tag conteniendo código Ruby %>**.  [La sintaxis de ERB está documentada aquí](http://docs.puppetlabs.com/guides/templating.html#erb-template-syntax), pero como los tags pueden contener *cualquier* código Ruby, es posible que los templates se vuelvan un poco complicados. En general, recomendamos mantener simples a los templates: te mostraremos cómo imprimir variables, hacer declaraciones condicionales e iterar en arrays, lo que debería ser suficiente para la mayoría de las tareas.

## Tags no imprimibles
Los tags de ERB están delimitados por símbolos menor y mayor con signos de porcentaje dentro. No existe ningún concepto del tipo HTML para abrir o cerrar tags.
 
	   <% document = "" %>

Los tags contienen una o más líneas de código Ruby, que pueden establecer variables, manipular información, implementar control de flujo, o, de hecho, prácticamente cualquier cosa excepto imprimir texto en el output renderizado.

### Imprimir una expresión 

Para eso, necesitas utilizar un tag de impresión que parece un tag normal con un signo igual después del separador de apertura:


	    <%= sectionheader %>
	      environment = <%= gitrevision[0,5] %>


### Comentarios

Un tag con una marca de hash después del separador de apertura puede contener comentarios que no son interpretados como código y no se muestran en el output renderizado.

	    <%# Este comentario será ignorado. %>



### Suprimir saltos de línea y espacios al comienzo de una línea

Los tags comunes no imprimen nada, pero si mantienes a cada tag de lógica en su propia línea, el salto de línea que utilizas aparecerá como un grupo de espacios en blanco en el archivo final.

De forma similar, si estas utilizando indentación para mayor legibilidad, el espacio en blanco en la hilera puede desordenar el formato del output renderizado.

Si esto no te gusta, también puedes:

+ Recortar los saltos de línea colocando un guión justo antes del separador de cierre.
+ Recortar espacios al comienzo colocando un guión justo después del separador de apertura.


	    <%- documento += estalínea -%>

## Un Ejemplo: NTP otra vez

Hagamos más inteligentes a los templates de tu módulo NTP.

Primero, asegúrate de haber cambiado el recurso de archivo para utilizar un template, como vimos al principio de esta clase. También debes asegurarte de haber copiado los archivos de configuración al directorio **templates/** y de haberles dado la extensión .erb.

### Ajustar el manifiesto

Luego, moveremos a los servidores NTP por defecto fuera del archivo de configuración y dentro del manifiesto:


	    # /etc/puppetlabs/puppet/modules/ntp/manifests/init.pp

	    class ntp {
	      case $operatingsystem {
	        centos, redhat: {
	          $service_name    = 'ntpd'
	          $conf_file   = 'ntp.conf.el'
	          $default_servers = [ "0.centos.pool.ntp.org",
	                               "1.centos.pool.ntp.org",
	                               "2.centos.pool.ntp.org", ]
	        }
	        debian, ubuntu: {
	          $service_name    = 'ntp'
	          $conf_file   = 'ntp.conf.debian'
	          $default_servers = [ "0.debian.pool.ntp.org iburst",
	                               "1.debian.pool.ntp.org iburst",
	                               "2.debian.pool.ntp.org iburst",
	                               "3.debian.pool.ntp.org iburst", ]
	        }
	      }

	      $servers_real = $default_servers

	      package { 'ntp':
	        ensure => installed,
	      }

	      service { 'ntp':
	        name      => $service_name,
	        ensure    => running,
	        enable    => true,
	        subscribe => File['ntp.conf'],
	      }

	      file { 'ntp.conf':
	        path    => '/etc/ntp.conf',
	        ensure  => file,
	        require => Package['ntp'],
	        content => template("ntp/${conf_file}.erb"),
	      }
	    }


Tenemos los servidores almacenados en un array, así que podemos mostrar cómo iterar dentro de un template. En este momento, no le estamos dando la capacidad de cambiar la lista de servidores, pero estamos preparando el camino para hacerlo en el próximo capítulo.

### Editar los templates

Primero, haz que cada template utilice la variable **$servers_real** para crear una lista de declaraciones de **server**.


	    <%# /etc/puppetlabs/puppet/modules/ntp/templates/ntp %>

	    # Managed by Class['ntp']
	    <% @servers_real.each do |this_server| -%>
	    server <%= this_server %>
	    <% end -%>

	    # ...


Qué está haciendo?

+ Está utilizando un tag no imprimible de Ruby para comenzar un ciclo. Hacemos referencia a la variable de Puppet **$servers_real** con el nombre **@servers_real**, luego llamamos al método **each** de Ruby en él. Todo lo que está entre **do |server| -%>**  y el tag **<% end -%>**  será repetido por cada elemento en el array **servers_real** con el valor de ese elemento de array asignado a la variable temporal **this_server**.
+ Dentro del ciclo, imprimimos literalmente la palabra **server** seguida del valor del elemento del array actual.

Este fragmento producirá algo como lo siguiente:


	# Managed by Class['ntp']
	server 0.centos.pool.ntp.org
	server 1.centos.pool.ntp.org
	server 2.centos.pool.ntp.org


Luego, utilicemos el fact **$is_virtual** para mejorar la performance de NTP si esto es una máquina virtual. Al principio del archivo, agrega esto:


	    <% if @is_virtual == "true" -%>
	    # Evita que ntpd entre en pánico si hay una diferencia importante
	    # en la hora cuando una VM es suspendida y reanudada.
	    tinker panic 0

	    <% end -%>


Luego, **debajo** del ciclo que hicimos para las declaraciones de servidor, agrega esto y asegúrate de remplazar la sección similar del template tipo Red Hat:


	    <% if @is_virtual == "false" -%>
	    # Reloj local indisciplinado. Esto es un driver falso para uso como backup
	    # cuando no hay una fuente externa de tiempo disponible.
	    server 127.127.1.0 # local clock
	    fudge 127.127.1.0 stratum 10

	    <% end -%>


Utilizando facts para encender o apagar de forma condicional partes del archivo de configuración, podemos reaccionar fácilmente de acuerdo al tipo de máquina que estamos manejando.


## Siguiente paso

**Próxima clase**:

Ya hemos visto que las clases se comportan de forma diferente para diferentes tipos de sistemas, y hemos utilizado facts para hacer cambios condicionales para manifiestos y templates.

Pero a veces, no es suficiente con los facts; hay momentos en los que un humano tiene que decidir que diferencia a una máquina, porque esa diferencia es una cuestión de *póliza*; por ejemplo, la diferencia entre un servidor de prueba y uno de producción.

En estos casos necesitamos tener una forma de cambiar manualmente nosotros mismos la forma en que funciona una clase. Podemos hacer esto pasando información con [parámetros de clase](http://docs.puppetlabs.com/es/learning/modules2.html).

**Nota aparte:**
Todavía estás manejando alguna configuración en tu infraestructura real? Ya has aprendido mucho, así que por qué no [descargas gratis Puppet Enterprise](http://info.puppetlabs.com/download-pe.html), sigues [la guía de comienzo rápido](http://docs.puppetlabs.com/pe/latest/quick_start.html) para obtener un pequeño entorno instalado y comienzas a automatizar?
