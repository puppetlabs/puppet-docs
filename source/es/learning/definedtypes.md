---
layout: default
title: "Aprende Puppet – Tipos de recurso definidos"
canonical: "/es/learning/definedtypes.html"
toc: false
---

#Aprende Puppet
1. [Más allá de los singletons]()
2. [Definir un tipo]()
3. [Las clases: Florcitas especiales]()
4. [Tipos definidos en módulos]()
	+ [Referencias de recursos y tipos con namespaces]()
5. [Ejemplo: Vhosts de Apache]() 
6. [Ejercicios]()
7. [Un último consejo]()
8. [Próxima clase]() 

#Más allá de los singletons

Digamos que escribiste un trozo de código Puppet que toma parámetros y configura un virtual host Apache individual.  Lo colocas en una clase; funciona bien, pero como las clases son singletons, Puppet nunca te dejará declarar más de un vhost.

Lo que quieres es algo más parecido a un *tipo de recurso*: no puedes declarar el mismo recurso dos veces, pero puedes declarar cuantos archivos o usuarios quieras.

	    apache::vhost {'users.example.com':
	      port    => 80,
	      docroot => '/var/www/personal',
	      options => 'Indexes MultiViews',
	    }


Esto resulta ser fácil: Para modelar trozos *repetibles* de configuración, como un repositorio Git o un vhost de Apache, debes utilizar **tipos de recurso definidos**.

Los tipos definidos actúan como tipos de recursos normales y son declarados de la misma forma, pero están compuestos por otros recursos.

#Definir un tipo

**Defines un tipo con la palabra clave _define_**, y la definición es prácticamente igual a una clase con parámetros. Necesitas:

+ La palabra clave **define**
+ Un **nombre**
+ Una lista de **parámetros** (entre paréntesis, después del nombre)
	+ Los tipos definidos también obtienen un parámetro especial **$title** sin tener que declararlo, y su valor siempre se establece como el título de la instancia de recurso. El parámetro **$name** actúa de la misma forma, y generalmente, tiene el mismo valor que **$title**. Las clases también obtienen estos parámetros, pero son menos útiles ya que la clase siempre tendrá un sólo nombre.
+ Un **bloque de código Puppet**

Así:

	define planfile ($user = $title, $content) {
	  file {"/home/${user}/.plan":
	    ensure  => file,
	    content => $content,
	    mode    => 0644,
	    owner   => $user,
	    require => User[$user],
	  }
	}
	
	user {'nick':
	  ensure     => present,
	  managehome => true,
	  uid        => 517,
	}
	planfile {'nick':
	  content => "Trabajar en capítulos nuevos de Aprende Puppet. Mañana: actualizar la máquina virtual de LP.",
	}

Éste es bastante simple. De hecho es, básicamente, una macro. Tiene dos parámetros, uno de los cuales es opcional (asume por defecto el título del recurso), y el grupo de recursos que declara es un solo recurso de archivo.

# Las clases: Florcitas especiales
Entonces, es fácil, no? Igual que definir una clase? **Casi:** hay un requerimiento extra. Como el usuario puede declarar cualquier número de instancias de un tipo definido, tienes que asegurarte que la implementación **nunca declarará el mismo recurso dos veces**.

Veamos una versión algo diferente de aquella primera definición:

	    define planfile ($user = $title, $content) {
	      file {'.plan':
	        path    => "/home/${user}/.plan",
	        ensure  => file,
	        content => $content,
	        mode    => 0644,
	        owner   => $user,
	        require => User[$user],
	      }
	    }

Ves cómo el título del recurso de archivo no está conectado a ninguno de los parámetros de la definición?

	    planfile {'nick':
	      content => " Trabajar en capítulos nuevos de Aprende Puppet. Mañana: actualizar la máquina virtual de LP.",
	    }

	    planfile {'chris':
	      content => "Resucitar una laptop muerta",
	    }

	# puppet apply planfiles.pp
	Duplicate definition: File[.plan] is already defined in file /root/manifests/planfile.pp at line 9; cannot redefine at /root/manifests/planfile.pp:9 on node puppet.localdomain

Caramba. Puedes ver dónde nos equivocamos: cada vez que declaramos una instancia de **planfile**, va a declarar el recurso **File[‘.plan’]**, y Puppet fallará la compilación si intentas declarar el mismo recurso dos veces.

![](img/defined_type_collision.png)

Para evitar esto, tienes que asegurarte de que tanto **el título y el nombre** (o atributo) de **cada recurso** en la definición sean derivados de un **parámetro único** (que suele ser **$title**) del tipo definido. Por ejemplo, no podemos derivar el título del archivo desde el **$content** del recurso **planfile**, porque más de un usuario puede escribir el mismo texto *.plan*.

Si hay un recurso singleton que tiene que existir para que cualquier instancia del tipo definido trabaje, debes:

+ Colocar ese recurso en una clase
+ Dentro de una definición de tipo, utiliza **include** para declarar esa clase.
+ También dentro de la definición de tipo, utiliza algo como lo que veremos a continuación para establecer una orden de dependencias: 

# Asegúrate que la compilación falle si 'myclass' no se declara:
Class['myclass'] -> Apache::Vhost["$title"]

Establecer relaciones de orden en el nivel de clase generalmente es mejor que pedir directamente uno de los recursos dentro de ella.

#Tipos definidos en módulos
Los tipos definidos pueden ser cargados automáticamente como las clases, y en consecuencia, utilizados desde cualquier parte en tus manifiestos. [Como con las clases](http://docs.puppetlabs.com/learning/modules1.html#module-structure), **cada tipo definido debe ir en su propio archivo** en el directorio **manifests/** del módulo. **Se aplican las mismas reglas para el namespace**. Entonces, el tipo **apache::vhost** debe ir en algún lugar como **/etc/puppetlabs/puppet/modules/apache/manifests/vhost.pp**, y si vamos a mantener el tipo **planfile**, debe ir en **/etc/puppetlabs/puppet/modules/planfile/manifests/init.pp**.

##Referencias de recurso y tipos con namespace

Quizás ya sabías esto que hablamos antes, pero: cuando haces una [referencia de recurso](http://docs.puppetlabs.com/puppet/latest/reference/lang_datatypes.html#resource-references) a una instancia de un tipo definido, tienes que **capitalizar cada [segmento de namespace](http://docs.puppetlabs.com/puppet/latest/reference/lang_namespaces.html)** en el nombre de tipo. Es decir que a una instancia del tipo **foo::bar::baz** se debe hacer referencia como ** Foo::Bar::Baz['mybaz']**.

#Ejemplo: Vhosts de Apache 

No es que mi macro *.plan* no sea genial, pero pongámonos serios por un minuto. Recuerdas el [módulo Apache](http://docs.puppetlabs.com/learning/modules1.html#exercises) de hace unos capítulos atrás? Vamos a extenderlo para poder declarar vhosts fácilmente. Este ejemplo de código lo tomamos prestado del [módulo puppetlabs-apache](https://github.com/puppetlabs/puppetlabs-apache).

	    # Definition: apache::vhost
	    #
	    # Esta clase instala vhost de Apache
	    #
	    # Parámetros:
	    # - El $port en que se va a configurar el host
	    # - El $docroot provee la variable DocumentationRoot 
	    # - La opción $template especifica si utilizar el template por defecto o el override
	    # - El $priority del sitio
	    # - El $serveraliases del sitio
	    # - El $options para el vhost dado
	    # - El $vhost_name para un nombre basado en virtualhosting, asumiendo por defecto *
	    #
	    # Acciones:
	    # - Instalar Virtual Hosts de Apache 
	    #
	    # Requiere:
	    # - La clase Apache
	    #
	    # Ejemplos de uso:
	    #  apache::vhost { 'site.name.fqdn':
	    #    priority => '20',
	    #    port => '80',
	    #    docroot => '/path/to/docroot',
	    #  }
	    #
	    define apache::vhost(
	        $port,
	        $docroot,
	        $template      = 'apache/vhost-default.conf.erb',
	        $priority      = '25',
	        $servername    = '',
	        $serveraliases = '',
	        $options       = "Indexes FollowSymLinks MultiViews",
	        $vhost_name    = '*'
	      ) {
	
	      include apache

	      # Debajo hay una expresión pre-2.6.5 para tener un parámetro por defecto para el título,
	      # pero también puedes declarar $servername = "$title" en los parámetros
	      # lista y cambia srvname to servername en el template.

	      if $servername == '' {
	        $srvname = $title
	      } else {
	        $srvname = $servername
	      }
	      case $operatingsystem {
	        'centos', 'redhat', 'fedora': { $vdir   = '/etc/httpd/conf.d'
	                                        $logdir = '/var/log/httpd'}
	        'ubuntu', 'debian':           { $vdir   = '/etc/apache2/sites-enabled'
	                                        $logdir = '/var/log/apache2'}
	        default:                      { $vdir   = '/etc/apache2/sites-enabled'
	                                        $logdir = '/var/log/apache2'}
	      }
	      file {
	        "${vdir}/${priority}-${name}.conf":
	          content => template($template),
	          owner   => 'root',
	          group   => 'root',
	          mode    => '755',
	          require => Package['httpd'],
	          notify  => Service['httpd'],
	      }

	    }
	    # /etc/puppetlabs/modules/apache/templates/vhost-default.conf.erb

	    # ************************************
	    # El template por defecto en el módulo puppetlabs-apache
	    # Manajado por Puppet
	    # ************************************
	
	    Listen <%= port %>
	    NameVirtualHost <%= vhost_name %>:<%= port %>
	    <VirtualHost <%= vhost_name %>:<%= port %>>
	      ServerName <%= srvname %>
	    <% if serveraliases.is_a? Array -%>
	    <% serveraliases.each do |name| -%><%= "  ServerAlias #{name}\n" %><% end -%>
	    <% elsif serveraliases != '' -%>
	    <%= "  ServerAlias #{serveraliases}" -%>
	    <% end -%>
	      DocumentRoot <%= docroot %>
	      <Directory <%= docroot %>>
	        Options <%= options %>
	        AllowOverride None
	        Order allow,deny
	        allow from all
	      </Directory>
	      ErrorLog <%= logdir %>/<%= name %>_error.log
	      LogLevel warn
	      CustomLog <%= logdir %>/<%= name %>_access.log combined
	      ServerSignature Off
	    </VirtualHost>


Esto es más o menos todo. Tú puedes aplicar un manifiesto de esta forma:

	    apache::vhost {'testhost':
	      port => 8081,
	      docroot => '/var/www-testhost',
	      priority => 25,
	      servername => 'puppet',
	    }


Y, siempre y cuando exista el directorio, podrás acceder inmediatamente al vhost nuevo:

	# curl http://puppet:8081

En cierto modo, esto es sólo un poco más sofisticado que el primer ejemplo, pero sigue siendo un solo recurso **file**. El uso de templates lo hace MUCHO más poderoso y ya has visto todo el tiempo que ahorra; puedes hacerlo más práctico mientras más tipos construyas: una vez que tengas un tipo customizado que maneje reglas de firewall, por ejemplo, puedes agregar algo *así* a la definición: 

	firewall {"0100-INPUT ACCEPT $port":
	    jump  => 'ACCEPT',
	    dport => "$port",
	    proto => 'tcp'
	}

#Ejercicios 

Tómate un minuto para hacer algunos tipos definidos más para acostumbrarte a modelar grupos de recursos repetibles.

+ Intenta envolver un recurso **user** en un tipo **human::user** que maneje los archivos .bashrc de esa persona y maneje uno o más recursos **ssh_authorized_key** para su cuenta.

+ Si estás familiarizado con Git, intenta escribir un tipo **git::repo** que pueda clonar un repositorio en la red (y quizás también mantener actualizada la copia  de una rama específica!) Esto será difícil y probablemente tendrás que hacer una clase **git** para asegurar que git esté disponible, y tendrás que utilizar al menos un **file** (**ensure => directory**) y un recurso **exec**. Recuerda que los exec pueden ser tramposos ya que tienes que asegurarte que sólo se ejecuten cuando sea necesario.

#Un último consejo

Los tipos definidos tienen input, y el input puede ser algo “sucio”o inesperado. Puede que quieras chequear los parámetros para asegurarte que son el tipo de dato correcto, y generar un error temprano si no funcionan en lugar de escribir cosas sin definir en el sistema.

Si estás por poner en prácticala validación de tus entradas (hint: hazlo!), puedes ahorrarte mucho esfuerzo si utilizas las funciones de validación en el módulo **stdlib** de Puppet Labs. Con PE 2.0 viene una versión de **stdlib** y también puedes descargarla gratis en [GitHub](https://github.com/puppetlabs/puppetlabs-stdlib/) o en [el Forge](http://forge.puppetlabs.com/puppetlabs/stdlib). Las funciones son:

+ **validate_array**
+ **validate_bool**
+ **validate_hash**
+ **validate_re**
+ **validate_string**

Puedes aprender cómo utilizarlas ejecutando **puppet doc --reference function | less** en un sistema donde **stdlib** esté instalado en su **modulepath**, o puedes leer la documentación directamente en cada archivo de función. Busca en el directorio **lib/puppet/parser/functions** del módulo.

#Siguiente paso
**Próxima clase**

Hay mucho más para decir acerca de módulos; aún no hemos hablado de separación de información, patrones para hacer más legibles a los módulos o la composición de módulos; pero tenemos pendiente un asunto más importante. [Continúa leyendo](http://docs.puppetlabs.com/learning/agentprep.html) para preparar tus VMs (sí, plural) para Puppet master/agente.

**Nota aparte**:

Ya hemos visto varios ejemplos de Apache, y es probable que tengas al menos un servidor web en tu infraestructura. Por qué no utilizas uno de los módulos listos para usar disponibles, y te fijas si puedes reproducir tu propia configuración de forma automatizada?

[Descarga gratis Puppet Enterprise](http://info.puppetlabs.com/download-pe.html) y sigue [la guía de comienzo rápido](http://docs.puppetlabs.com/pe/latest/quick_start.html) para obtener un pequeño entorno instalado en algunas máquinas de prueba. Luego, instala uno de los siguientes módulos:

+ [puppetlabs/apache](http://forge.puppetlabs.com/puppetlabs/apache)
+ [simondean/iis](http://forge.puppetlabs.com/simondean/iis) (para IIS en Windows Server)
+ [Cualquiera de los módulos de Nginx disponibles]( http://forge.puppetlabs.com/modules?utf-8=%E2%9C%93&q=nginx&LeadSource=Web+-+Organic&Lead_Source_Description__c=google+-+%28not+provided%29&utm_source__c=google&utm_medium__c=organic&utm_term__c=%28not+provided%29&utm_content__c=null&utm_campaign__c=%28organic%29&utm_adgroup__c=null&gclid=)

Lee la documentación del módulo para ver cómo funciona, luego intenta manejar el servicio y cualquier servidor virtual relevante para que coincida con tu infraestructura configurada manualmente.
