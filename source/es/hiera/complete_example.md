---
layout: default
title: "Hiera 1: Ejemplo completo"
canonical: "/es/hiera/complete_example.html"
---

En este ejemplo, usaremos el popular [Módulo NTP de Puppet Labs](http://forge.puppetlabs.com/puppetlabs/ntp) un ejemplo del patrón de diseño *paquete/archivo/servicio*, de uso común en la comunidad de usuarios de Puppet. Comenzaremos de manera simple, usando Hiera para proveer el módulo ntp con datos de parámetros basados en nodos particulares de tu organización.  Luego, usaremos Hiera para asignar la clase *ntp* proporcionada por el módulo a nodos específicos.

## ¿Qué podemos hacer con Hiera?
Comencemos observando el módulo de ntp.  Realiza todo su trabajo en una sola clase **ntp**, la cual vive en [el manifiesto **init.pp**](https://github.com/puppetlabs/puppetlabs-ntp/blob/master/manifests/init.pp). La clase **ntp** también evalúa algunos templates ERB almacenados en el [directorio de templates](https://github.com/puppetlabs/puppetlabs-ntp/tree/master/templates). Entonces, ¿qué podemos hacer con Hiera?

### Expresar Información organizacional
La clase **NTP** toma cinco parámetros:

+ servers
+ restrict
+ autoupdate
+ enable
+ template

La mayoría de estos parámetros reflejan decisiones que tenemos que tomar sobre cada uno de los nodos a los que debemos aplicar la clase **ntp**: ¿Puede actuar como servidor NTP para otros hosts? (**restrict**);  ¿Qué servidor debería consultar? (**servers**); ¿D eberíamos permitir  que Puppet actualice automáticamente el paquete ntp o no? (**autoupdate**).
Sin Hiera, nos encontraríamos agregando datos organizacionales al código de nuestro módulo como valores de los parámetros por defecto, reduciendo la portabilidad del módulo.  Nos encontraríamos repitiendo los datos de configuración en nuestros manifiestos para cubrir las diferencias menores en la configuración entre nodos.
Con Hiera, podemos mudar estas decisiones a una jerarquía construida en base a los facts que conducen estas decisiones, incrementar la portabilidad y reducir la repetición de código.

### Clasificar nodos con Hiera
También podemos usar Hiera para asignar clases a los nodos, usando la función [hiera_include](http://docs.puppetlabs.com/es/hiera/puppet.html#assigning-classes-to-nodes-with-hiera-hierainclude), agregando una sóla línea a nuestro manifiesto **site.pp**, luego asignando clases a los nodos dentro de Hiera, en lugar de hacerlo dentro de nuestro manifiesto site.pp. Esto puede ser un atajo muy útil cuando asignamos explícitamente clases a nodos específicos dentro de Hiera, pero se vuelve muy poderoso cuando asignamos clases implícitamente basadas en una característica del nodo. En otras palabras, te mostraremos cómo no tienes que saber el nombre de cada huésped de VMWare  en tu organización para asegurarte que todos tengan instalada la versión actual de las herramientas de VMWare.

## Descripción de nuestro entorno
A los efectos de este tutorial, vamos a asumir esta situación:

+ Tenemos dos servidores ntp en la organización que tienen permiso para conectarse con servidores ntp externos. Otro servidor ntp obtiene sus datos de tiempo de estos dos servidores.
+Uno de nuestros servidores ntp primarios está configurado muy cautelosamente (no nos podemos permitir testeo previo, así que no está permitida la actualización automática del paquete de este servidor ntp sin pruebas). El otro servidor está configurado con más permisos.
+ Tenemos un número de otros servidores ntp que usarán nuestros dos servidores primarios.
+ Tenemos un número de  Sistemas operativos hospedados en VMWare que necesitan tener las herramientas VMWare instaladas.

### Nuestro entorno antes de Hiera

¿Cómo se veían las cosas antes de que decidiéramos utilizar Hiera? Las clases eran asignadas a los nodos vía el manifiesto del sitio (**/etc/puppet/manifests/sites.pp** para Puppet open source); así que aquí está cómo nuestro site.pp podría haber sido:

	node "kermit.example.com" {
	  class { "ntp":
		servers    => [ '0.us.pool.ntp.org iburst','1.us.pool.ntp.org iburst','2.us.pool.ntp.org iburst','3.us.pool.ntp.org iburst'],
		autoupdate => false,
		restrict => false,
		enable => true,
	  }
	}

	node "grover.example.com" {
	  class { "ntp":
		servers    => [ 'kermit.example.com','0.us.pool.ntp.org iburst','1.us.pool.ntp.org iburst','2.us.pool.ntp.org iburst'],
		autoupdate => true,
		restrict => false,
		enable => true,
	  }
	}

	node "snuffie.example.com", "bigbird.example.com", "hooper.example.com" {
	  class { "ntp":
		servers    => [ 'grover.example.com', 'kermit.example.com'],
		autoupdate => true,
		restrict => true,
		enable => true,
	  }
	}

## Configuración de Hiera y armado de la jerarquía

Toda la configuración de Hiera comienza con el archivo**hiera.yaml**. Puedes leer [una discusión completa sobre este archivo](http://docs.puppetlabs.com/es/hiera/configuring.html), incluido dónde deberías colocarlo dependiendo de la versión de Puppet que estés usando.  Aquí está la que usaremos en este tutorial:

	---
	:backends:
	  - json
	:json:
	  :datadir: /etc/puppet/hiera
	:hierarchy:
	  - node/%{::fqdn}
	  - common

Paso a paso:

**:backends:** le dice a Hiera qué tipo de Fuentes de datos debe procesar. En este caso usaremos archivos JSON.

**:json:** configura el *backend* de datos JSON, indicando a Hiera que busque las fuentes de datos JSON en **/etc/puppet/hiera**.

**:hierarchy:**  configura las Fuentes de datos que Hiera debe consultar. Los usuarios de Puppet normalmente separan sus jerarquías en directorios para obtener fácilmente un panorama de cómo está armada la jerarquía. En este caso, nosotros lo hacemos más simple:

+ Un solo directorio (**node/**) contendrá todos los archivos nombrados según el fact *fqdn* (fully qualified domain name) de algún nodo.  (Ej: **/etc/puppet/hiera/node/grover.example.com.json**) Esto nos permite configurar específicamente cualquier nodo determinado con Hiera. No es necesario que todos los nodos tengan un archivo en el directorio **node/**  (Si no está allí, Hiera pasará al siguiente nivel de la jerarquía).
+ Luego, la fuente de datos **común** (el archivo **/etc/puppet/hiera/common.json**) proveerá de valores comunes o por defecto que querramos usar cuando Hiera no pueda encontrar una coincidencia para una clave determinada en otra parte de nuestra jerarquía. En este caso, vamos a usar estos valores para configurar servidores ntp comunes y las opciones de configuración por defecto para el módulo ntp.

**Nota de Jerarquías y facts**: Cuando construyas una jerarquía, ten en cuenta que la mayoría de las variables útiles de Puppet, son **facts**; y por ser los facts presentados por el propio nodo agente, no son *necesariamente confiables*. No recomendamos usar facts como único factor decisivo para la distribución de credenciales secretas.
En este ejemplo, usamos el fact **fqdn** para identificar nodos específicos; la variable especial *clientcert* es otra opción, a la cual el agente asigna el valor de su *certname* (nombre del certificado); Esto generalmente es lo mismo que fqdm, pero no siempre. Actualmente, Puppet no provee variables con datos confiables acerca del nodo dado, estamos [investigando la posibilidad de agregar algunas](http://projects.puppetlabs.com/issues/19514)

**Nota de Puppet Master**: Si modificas **hiera.yaml** entre ejecuciones de agentes, tendrás que reiniciar tu Puppet master para que los cambios tengan efecto.

### Configuración de la línea de comando
La [Herramienta de línea de comando de Hiera](http://docs.puppetlabs.com/es/hiera/command_line.html) es útil cuando estás en proceso de diseñar y testear tu jerarquía. Puedes usarla para imitar facts para que Hiera busque sin tener que pasar por engorrosas acciones de prueba y error de Puppet. Como el comando **hiera** espera encontrar **hiera.yaml** en **/etc/hiera.yaml**,  debes configurar un link simbólico desde tu  archivo **hieral.yaml** a **/etc/hiera.yaml**:

	$ ln -s /etc/puppet/hiera.yaml /etc/hiera.yaml	

## Escribir Fuentes de información 
Ahora que tenemos Hiera configurado, estamos listos para volver al módulo ntp y mirar los parámetros de la clase **ntp**. 
**Aprende acerca de las fuentes de información de Hiera**: Este ejemplo no cubrirá todos los tipos de información que quizás quieras usar, y nosotros  estamos usando sólo uno de los dos backends integrados (JSON). Para una mirada completa de las fuentes de información, por favor mira nuestra guía para [escribir fuentes de información de Hiera](http://docs.puppetlabs.com/es/hiera/data_sources.html) que incluye ejemplos más completos, escritos en JSON y YAML.

### Identificar parámetros
Tenemos que empezar por averiguar los parámetros requeridos por la clase ntp; Observemos [el manifiesto **init.pp** del módulo ntp]( https://github.com/puppetlabs/puppetlabs-ntp/blob/master/manifests/init.pp) dónde encontramos cinco de ellos:

*Servers*:
Un conjunto de servidores de tiempo, **UNSET** por defecto. La lógica condicional en **init.pp** provee una lista de servidores ntp mantenida por los respectivos encargados de mantenimiento de sistemas operativos compatibles con nuestro módulo.

*Restrict*:
Restringe que el daemon de NTP sea usado como servidor por otros; **true** (verdadero) por defecto

*Autoupdate*
Actualiza el paquete NTP automáticamente o no; **false** (falso) por defecto.

*Enable*:
Inicia el daemon NTP en el arranque; **true** por defecto.

*Template*:
El nombre del template que se utiliza en la configuración del servicio NTP. Esto es **undef** (indefinido) por defecto, y está configurado en el manifiesto **init.pp** con una lógica condicional.

+ [Mira las referencias del lenguaje Puppet para más información acerca de los parámetros de clase](http://docs.puppetlabs.com/puppet/latest/reference/lang_classes.html#class-parameters-and-variables)

### Tomar decisiones y expresarlas en Hiera
Ahora que conocemos los parámetros  que la clase NTP espera, podemos comenzar a tomar decisiones acerca de los nodos en nuestro sistema y luego expresarlas como datos Hiera. Comencemos con *Kermit* y *Grover*:  son dos nodos en nuestra organización a los que le permitimos conectarse con el mundo externo a los fines de mantener actualizado el tiempo.

#### `kermit.example.com.yaml`

Queremos que uno de esos dos nodos, **kermit.expample.com**,  actúe como servidor primario de tiempo en la organización. Queremos que consulte servidores de tiempo externos, no vamos a querer que actualice su paquete de servidor NTP por defecto; y definitivamente, queremos inicie  el servicio NTP en el arranque. Entonces, vamos a escribir eso en YAML, asegurándonos de expresar nuestras variables como parte del namespace de NTP para asegurarnos que Hiera los tome como parte de su [búsqueda automática de parámetros](http://docs.puppetlabs.com/es/hiera/puppet.html#automatic-parameter-lookup)

    ---
    ntp::restrict:
      -
    ntp::autoupdate: false
    ntp::enable: true
    ntp::servers:
      - 0.us.pool.ntp.org iburst
      - 1.us.pool.ntp.org iburst
      - 2.us.pool.ntp.org iburst
      - 3.us.pool.ntp.org iburst

Como queremos proveer esta información para un nodo específico, y como usamos el fact **fqdn** para identificar nodos únicos en nuestra jerarquía, necesitamos salvar esta información en el directorio **/etc/puppet/hiera/node** como **kermit.example.com.yaml**.
Una vez salvado, haremos una prueba rápida usando [La herramienta de línea de comando de Hiera](http://docs.puppetlabs.com/es/hiera/command_line.html)

	$ hiera ntp::servers fqdn=kermit.example.com

Y tú debes ver esto:

	["0.us.pool.ntp.org iburst", "1.us.pool.ntp.org iburst", "2.us.pool.ntp.org iburst", "3.us.pool.ntp.org iburst"]

Esto es sólo una *array* (matriz) de servidores NTP externos y sus opciones, que están expresados como un array YAML, y Hiera la convierte en un array de Puppet. El módulo la usará cuando genere archivos de configuración de estos templates.

**¿Algo falló?**: Si por el contrario tienes **nil**, **false**, o algo completamente distinto, debes volver a tu configuración Hiera y asegurarte que:

+ Tu archivo **hiera.yaml** coincide con el ejemplo que te dimos.
+ Has colocado un link simbólico en **hiera.yaml** donde la herramienta de línea de comando pueda encontrarla (**/etc/hiera.yaml**)
+  Has salvado tu archivo de fuente de información **kermit.example.com** con extensión **.yaml**
+ El JSON de tu archivo de fuente de información está bien escrito. Un olvido o mala colocación de una *coma*, causará que el parser de JSON falle.
+ Has reiniciado tu Puppet Master si modificaste **hiera.yaml**

Si todo funciona y obtienes ese array de servidores NTP, estás listo para configurar otro nodo.

#### `grover.example.com.yaml`

Nuestro próximo nodo NTP, **grover.example.com** es un poco menos crítico que kermit en nuestra infraestructura, así que podemos ser un poco más permisivos en esta configuración. Está bien si el paquete NTP de grover se actualiza automáticamente. También queremos que grover use kermit como servidor NTP primario. Expresemos eso en YAML:

    ---
    ntp::restrict:
      -
    ntp::autoupdate: true
    ntp::enable: true
    ntp::servers:
      - kermit.example.com iburst
      - 0.us.pool.ntp.org iburst
      - 1.us.pool.ntp.org iburst
      - 2.us.pool.ntp.org iburst

Como con **kermit.example.com** queremos salvar la fuente de información Hiera de grover en el directorio **/etc/puppet/hiera/nodes** usando el fact **fqdn** para el nombre de archivo **grover.example.com.yaml**. Lo podemos probar una y otra vez con esta herramienta de línea de comando de Hiera:

	$ hiera ntp::servers ::fqdn=grover.example.com
	["kermit.example.com iburst", "0.us.pool.ntp.org iburst", "1.us.pool.ntp.org iburst", "2.us.pool.ntp.org iburst"]

#### `common.yaml`

Así, hemos configurado los dos nodos en nuestra organización que podemos actualizar desde servidores NTP externos. Sin embargo todavía tenemos algunos nodos para tener en cuenta que también proveen servicios NTP. Dependen de kermit y grover para obtener el tiempo correcto, y para nosotros no es importante si se actualizan a sí mismos. Escribamos esto en YAML:

    ---
    ntp::autoupdate: true
    ntp::enable: true
    ntp::servers:
      - grover.example.com iburst
      - kermit.example.com iburst

A diferencia de kermit y grover, para los cuales para los cuales necesitábamos configuraciones ligeramente distintas pero específicas para cada nodo, confiamos en dejar que cualquier otro nodo que use clase NTP use estos datos de configuración genéricos. En lugar de crear una fuente de información específica para cada nodo posible en nuestra red que necesitara usar el módulo NTP, vamos a almacenar esta información en **/etc/puppet/hiera/common.yaml**. Con nuestra jerarquía simple, la cual por ahora sólo busca por el fact **fqdn**; cualquier nodo con un **fqdn** que no coincida con los nodos de los que tenemos fuentes de información, podrán obtenerla en **common.yaml**. Hagamos una prueba con uno de esos nodos:

	$ hiera ntp::servers fqdn=snuffie.example.com
	["kermit.example.com iburst", "grover.example.com iburst"]

#### `Modifica nuestro Manifiesto `site.pp``

Ahora que todo ha sido probado desde la línea de comando, es hora de obtener algún beneficio de este trabajo en producción.
Recordando  nuestra configuración pre-Hiera, verás que declarábamos un número de parámetros para la clase NTP en nuestro manifiesto **site.pp** de esta forma:

	node "kermit.example.com" {
		  class { "ntp":
			servers    => [ '0.us.pool.ntp.org iburst','1.us.pool.ntp.org iburst','2.us.pool.ntp.org iburst','3.us.pool.ntp.org iburst'],
			autoupdate => false,
			restrict => false,
			enable => true,
	  	}
	}

De hecho, teníamos tres estrofas separadas de esa longitud. Pero ahora que hemos pasado toda esa información de parámetros a Hiera, podemos recortar significatvamente el  **site.pp**:

	node "kermit.example.com", "grover.example.com", "snuffie.example.com" {
      include ntp
      # or:
      # class { "ntp": }
	}

Esto es todo.
Como Hiera está proporcionando automáticamente información de parámetros desde las fuentes de información en esta jerarquía, no necesitamos hacer nada más que asignar la clase NTP al nodo y dejar que el parámetro de Hiera busque el resto. En el futuro, cuando modifiquemos o agreguemos nodos que necesiten usar la clase NTP, podremos: 

+ Copiar rápidamente la fuente de información para cubrir casos donde el nodo necesite una configuración específica.
+ Si el nuevo nodo puede funcionar con la configuración genérica en **common.json** podremos decir **include ntp** en nuestro **site.pp** sin escribir ninguna información nueva en Hiera.
+ Desde que Hiera busca cada parámetro individualmente, también podemos escribir un nuevo archivo JSON que, por ejemplo, sólo cambie el parámetro **ntp::autoupdate**. Hiera obtendrá el resto de **common.json**.

Si estás interesado en avanzar, usando las habilidades para la toma de decisiones que has recogido de este ejemplo para elegir qué nodos tienen clase particular, entonces continuemos.

## Asignar una clase a un nodo con Hiera 
En la primera parte de nuestro ejemplo, estuvimos enfocados en cómo usar Hiera para proporcionar información a una clase parametrizada, pero asignando las clases a nodos con el método tradicional de Puppet: Haciendo declaraciones de **clase** para cada nodo en nuestro manifiesto **site.pp**. Gracias a la función **hiera_include**, puedes asignar nodos a las clases de la misma forma que puedes asignar valores para clasificar parámetros: Tomando un *fact* en el cual quieres basar una decisión, agregándolo a la jerarquía en tu archivo **hiera.yaml** y luego escribiendo las fuentes de información.

### Uso de **hiera_include**
Hasta donde vimos, nuestro manifiesto **site.pp**  estaba bastante vacío. Con la función **hiera_include** podemos reducir las cosas aún más eligiendo una clave para utilizar en las clases (recomendamos utilizar la clave **clases**) y luego declarándola en nuestro manifiesto **site.pp**:

	hiera_include('classes')

Desde este punto en adelante, puedes agregar o modificar una fuente de información de Hiera ya existente para agregar una array de clases que quieras asignar a los nodos coincidentes. En el caso más simple, podemos ver cada nodo kermit, grover y snuffie, y agregar esto a sus fuentes de información JSON en **/etc/puppet/hiera/node**:

	"classes" : "ntp",

Modificar la fuente de información de kermit, por ejemplo, para que se vea así:

	{
	"classes" : "ntp",
	"ntp::restrict" : false,
	"ntp::autoupdate" : false,
	"ntp::enable" : true,
	"ntp::servers" : [
		   "0.us.pool.ntp.org iburst",
		   "1.us.pool.ntp.org iburst",
		   "2.us.pool.ntp.org iburst",
		   "3.us.pool.ntp.org iburst"
		   ]
	}

**hiera_include** requiere de un string con una sola clase, o de una array de clases para aplicar a un determinado nodo. Echa un vistazo a la array de “clases” en la parte superior de nuestra fuente de datos kermit para ver cómo debemos agregar tres clases a kermit:

	{
	"classes" : [
		   "ntp",
		   "apache",
		   "postfix"
	],
	"ntp::restrict" : false,
	"ntp::autoupdate" : false,
	"ntp::enable" : true,
	"ntp::servers" : [
		   "0.us.pool.ntp.org iburst",
		   "1.us.pool.ntp.org iburst",
		   "2.us.pool.ntp.org iburst",
		   "3.us.pool.ntp.org iburst"
		   ]
	} 

Podemos testear qué clases hemos asignado a un nodo determinado con la herramienta de línea de comandos de Hiera:

	$ hiera classes fqdn=kermit.example.com
	["ntp", "apache", "postfix"]

Nota: La función **hiera_include** hará una [Busqueda *Array merge*](http://docs.puppetlabs.com/es/hiera/lookup_types.html#array-merge) que permite que las fuentes de datos más específicas se **sumen** a las fuentes comunes en lugar de **reemplazarlas**. Esto te ayuda a evitar repeticiones.

#### Uso de facts para conducir la asignación de clase
Esto demuestra un caso muy simple para **hiera_include**, donde sabemos que queremos asignar una clase particular a un host específico por el nombre. Pero al usar el fact **fqdn** para elegir qué nodo recibirá valores de parámetro específico, podemos usar ese o cualquier otro fact para conducir las asignaciones de clase. En otras palabras, puedes asignar clases a los nodos basándote en características que no son tan obvias como sus nombres, creando la posibilidad de configurar nodos basados en características más complejas.

Algunas organizaciones pordrían elegir asegurarse que todas sus Macs tengan instalado *Homebrew*, o asignar una clase **postfix** a los nodos que tengan el rol de servidores de mail expresados en un fact personalizado, o asignar una clase **vmware_tool** como valor para este fact **virtual**.
De hecho, usemos este último caso para esta parte del tutorial: Instalar las herramientas VMWare en un huésped virtual. Existe el módulo [Herramientas VMWare de Puppet](https://github.com/craigwatson/puppet-vmwaretools) en *Puppet Forge* que contiene todo lo que necesita. Toma dos parámetros:

*Version*
La versión de las herramientas VMWare que queremos instalar

*working_dir*
El directorio en el cual queremos instalar VMWare.

Dos formas con las que podríamos querer usar Hiera para que nos ayude a organizar nuestro uso de las clases que este módulo provee, incluyen el asegurarse que se aplica a todos nuestros host virtuales VMWare; y configurar dónde se instala según el sistema operativo invitado para un host virtual determinado.

Así que echemos un vistazo a nuestro archivo **hiera.yaml** y hagamos provisiones para dos nuevas fuentes de información. Crearemos una basada en el fact **virtual** que devuelve un  **vmware** cuando un nodo es un huésped basado en VMWare. Crearemos otro basado en el fact **osfamily**, que devuelve la familia general a la que pertenece el sistema operativo de un nodo (ej: “Debian” para Ubuntu y sistemas Debian, o “RedHat” para RHEL, CentOS, y Fedora systems):

	---
	:backends:
	  - json
	:json:
	  :datadir: /etc/puppet/hieradata
	:hierarchy:
	  - node/%{::fqdn}
	  - virtual/%{::virtual}
	  - osfamily/%{osfamily}
	  - common

Luego, necesitaremos crear directorios para nuestras dos fuentes de información nuevas:

	`mkdir /etc/puppet/hiera/virtual; mkdir /etc/puppet/hiera/osfamily`

En nuestro directorio **virtual** queremos crear el archivo **vmware.json**. En esta fuente de información, asignaremos la clase **vmwaretools**, por lo que el archivo tendrá que verse así:

	{
	  "classes": "vmwaretools"
	}

Luego, necesitamos proveer la información para los parámetros de clase **vmwaretools**. Asumiremos tener una mezcla de VMs Red Hat y Debian en uso en nuestra organización, y que queremos instalar las herramientas VMWare en **/opt/vmware** en nuestros VMs de Red Hat, y en **/usr/local/vmware** en nuestros VMs de Debian. Necesitaremos los archivos **RedHat.json** y **Debian.json** en el directorio **/etc/puppet/hiera/osfamily**.
**RedHat.json** debe verse así:

	{
	  "vmwaretools::working_dir" : "/opt/vmware"
	}

**Debian.json** debe verse así:

	{
	 "vmwaretools::working_dir" : "/usr/local/vmware"
	}

Esto nos deja un parámetro sin cubrir: el parámetro **version**. Como que no necesitamos variar la versión de las herramientas de VMWare del VMs que estamos usando, podemos colocar eso en **common.json**, lo que entonces se vería así:

	{
	   "vmwaretools::version" : "8.6.5-621624",
	   "ntp::restrict" : true,
	   "ntp::autoupdate" : true,
	   "ntp::enable" : true,
	   "ntp::servers" : [
		   "grover.example.com iburst",
		   "kermit.example.com iburst"
		  ]
	}

Una vez que tienes todo esto configurado, continúa el proceso testeando la herramienta de línea de comando de Hiera:

	$ hiera vmwaretools::working_dir osfamily=RedHat
	/opt/vmware
	
	$ hiera vmwaretools::working_dir osfamily=Debian
	/usr/local/vmware
	
	$ hiera vmwaretools::version
	8.6.5-621624
	
	$ hiera classes virtual=vmware
	Vmwaretools

Si todo funciona, buenísimo; Si no, [consulta la lista de verificación que te dimos antes](http://docs.puppetlabs.com/es/hiera/complete_example.html#something-went-wrong) e intenta nuevamente.

## Explora Hiera más allá
Esperamos que este tutorial te haya dado una buena impresión acerca de las cosas que puedes hacer con Hiera. Pero hay algunas cosas de las que no hablamos:

+ No hemos discutido acerca de cómo usar Hiera en módulos de manifiesto, prefiriendo resaltar esta habilidad de proveer información a clases parametrizadas. Hiera también provee una [colección de funciones](http://docs.puppetlabs.com/es/hiera/puppet.html#hiera-lookup-functions) que te permiten usar Hiera dentro de un módulo. Pero presta mucha atención aquí: Una vez que comiences a usar Hiera para que tu módulo funcione, reducirás su portabilidad y, potencialmente, se la cerrarás a algunos usuarios.
+ Te mostramos cómo llevar a cabo búsquedas importantes con Hiera, es decir, la recuperación de datos de la jerarquía, basada en la primera coincidencia para una clave determinada. Es la única forma de utilizar Hiera con clases parametrizadas, pero las funciones de búsqueda de Hiera incluyen [búsquedas especiales de hashes y arrays](http://docs.puppetlabs.com/es/hiera/lookup_types.html), permitiéndote recolectar información de las fuentes a través de toda tu jerarquía, o anular selectivamente las precedencias normales de tu jerarquía. Esto te permite declarar, por ejemplo, ciertos valores básicos para todos los nodos, y luego aplicar capas de valores adicionales para los nodos que coincidan con diferentes claves, recibiendo toda la información de nuevo en forma de *array* y *hash*.



