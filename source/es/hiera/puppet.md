---
layout: default
title: "Hiera 1: Usar Hiera con Puppet"
canonical: "/es/hiera/puppet.html"
---

Puppet puede utilizar Hiera para  buscar información. Esto te ayuda a separar información específica del sitio, del código Puppet; para reutilizar más fácilmente un código y facilitar la gestión de información que hay que diferir a través de tu población de nodos.

## Habilitar y configurar Hiera para Puppet

### Puppet 3 y superior

Puppet 3.x y versiones superiores vienen con soporte para Hiera ya habilitado. No necesitas hacer nada extra. La información de Hiera debería existir en el o los puppet master(s).

+ Puppet espera encontrar el [archivo hiera.yaml](http://docs.puppetlabs.com/es/hiera/configuring.html) en **$confdir/hiera.yaml** (normalmente **/etc/puppet/hiera.yaml**); puedes modificar esto con las opciones de configuración **hiera_config**.
+ Recuerda configurar los valores de **:datadir** para todos los backends que uses. Generalmente lo mejor es utilizar algo dentro del directorio **/etc/puppet/** ya que es en el primer lugar que tus colegas administradores esperan encontrar la información.

### Puppet 2.7

Debes instalar Hiera y el paquete **hiera-puppet** en tus puppet master(s) antes de usar Hiera con Puppet. La información de Hiera debería existir en el o los puppet master(s).

+ Puppet espera encontrar el [archivo hiera.yaml](http://docs.puppetlabs.com/es/hiera/configuring.html) en **$confdir/hiera.yaml** (normalmente **/etc/puppet/hiera.yaml**); Esto no es configurable en 2.7.
+ Recuerda configurar los valores de **:datadir** para todos los backends que uses. Generalmente lo mejor es utilizar algo dentro del directorio **/etc/puppet/** ya que es en el primer lugar que tus colegas administradores esperan encontrar información. 

### Versiones anteriores

Hiera no es compatible con versiones anteriores, pero podría ser posible hacerlo funcionar de forma similar a Puppet 2.7.

## Variables de Puppet pasadas a Hiera

En el momento que una búsqueda de Hiera se dispara desde Puppet, Hiera recibe una copia de **todas** las variables actualmente disponibles para Puppet, incluyendo variables locales y de top scope (top scope, ver [Referencia del lenguaje](http://docs.puppetlabs.com/puppet/3/reference/lang_scope.html) .

Entonces Hiera puede usar cualquiera de estas variables en los [símbolos de interpolación de variables](http://docs.puppetlabs.com/es/hiera/variables.html) desperdigados por toda la [jerarquía](http://docs.puppetlabs.com/es/hiera/hierarchy.html) y [fuentes de información](http://docs.puppetlabs.com/es/hiera/data_sources.html). Puedes habilitar jerarquías más flexibles creando [facts personalizados](http://docs.puppetlabs.com/guides/custom_facts.html) para cosas como la ubicación de datacenters y el propósito de los servidores. 

### Pseudo-variables especiales

Cuando realizas cualquier búsqueda de Hiera, sea con la búsqueda automática de parámetros o con las funciones de Hiera, Puppet configura dos variables que no están disponibles en manifiestos normales:

+ **calling_module**, el módulo en el que se escribe la búsqueda. Tiene el mismo valor que la [la variable Puppet **$module_name**.](http://docs.puppetlabs.com/puppet/latest/reference/lang_variables.html#parser-set-variables)
+ **calling_class**, la clase en la que la búsqueda es evaluada. Si la búsqueda está escrita en un tipo definido, esta variable es la clase en que se declara la instancia actual del tipo definido.

**Nota:** Estas variables estaban rotas en algunas versiones de Puppet.

+ Puppet 2.7.x: **Funcionan**
+ Puppet 3.0.x and 3.1.x: **Rotas**
+ Puppet 3.2.x y superiores: **Funcionan**

### Buenas prácticas
**No uses variables locales de Puppet** en jerarquías de Hiera o fuentes de información. Sólo usa [facts](http://docs.puppetlabs.com/puppet/latest/reference/lang_variables.html#facts-and-built-in-variables) y **variables top-scope definidas por un ENC**. Usa [notación de top-scope absoluta](http://docs.puppetlabs.com/puppet/latest/reference/lang_variables.html#accessing-out-of-scope-variables) (por ejemplo: **%{::clientcert}** en lugar de **%{clientcert}**) en la configuración de archivos de Hiera para evitar usar accidentalmente una variable local en lugar de una *top-scope*.

Esta no es una regla estricta, existen excepciones; pero casi siempre te arrepentirás si la rompes, y eso sucede porque la función de Hiera es separar la información del código, y establecer información jerárquica específica de cada nodo que no depende del orden de análisis de Puppet.

Si Hiera sólo depende de variables que están configuradas **antes que Puppet comience a analizar sus manifiestos**, esta información será específica de cada nodo pero estática y confiable. ¡Esto es bueno! Te libera de bugs dependientes del orden de análisis, facilita probar tu información y también saber qué es lo que sucede exactamente con sólo mirar una sección determinada del código Puppet.

Por otro lado, hacer depender a Hiera de variables locales establecidas por el parser de Puppet significa que aún estás, básicamente, incorporando datos en el código y todavía tienes todos los problemas que Hiera pretende resolver.

## Búsqueda automática de parámetros

Puppet recuperará automáticamente los parámetros de clase desde Hiera, usando claves de búsqueda como **myclass::parameter_one**.

**Nota**: Esta función está disponible sólo en Puppet 3 y superiores.

Las [clases](http://docs.puppetlabs.com/puppet/latest/reference/lang_classes.html) pueden incluir opcionalmente [parámetros](http://docs.puppetlabs.com/puppet/latest/reference/lang_classes.html#class-parameters-and-variables) en sus definiciones. Esto le permite a la clase pedir que se pase información en el momento que sea declarada, y pueda usar esos datos como variables normales a lo largo de su definición. 

		# En este ejemplo, el valor de $parameter se define cuando `myclass` es declarada. 
    	# Definición de la clase:
    	class myclass ($parameter_one = "default text") {
      	    file {'/tmp/foo':
            ensure  => file,
            content => $parameter_one,
      		}
    	}

Los parámetros se pueden establecer de diferentes formas, y Puppet probará a cada una de ellas en orden para cuando la clase sea [declarada](http://docs.puppetlabs.com/puppet/latest/reference/lang_classes.html#declaring-classes) o [asignada por un ENC](http://docs.puppetlabs.com/puppet/latest/reference/lang_classes.html#assigning-classes-from-an-enc):

+ Si fue una [declaración o asignación como recurso](http://docs.puppetlabs.com/puppet/latest/reference/lang_classes.html#using-resource-like-declarations), Puppet usará cada parámetro que haya sido configurado explícitamente. De existir, estos son los que siempre ganan.
+ **Puppet buscará parámetros en Hiera automáticamente**, usando ** <NOMBRE DE CLASE>::<NOMBRE DE PARÁMETRO>** como clave de búsqueda. (**myclass::parameter_one** en el ejemplo anterior) 
+ Si 1 y 2 no devuelven un valor, Puppet usará el valor por defecto de la [definición](http://docs.puppetlabs.com/puppet/latest/reference/lang_classes.html#defining-classes) de la clase. (**”default text”** en el ejemplo anterior)
+ Si de 1 a 3 no devuelven un valor, la compilación fallará.

El paso 2 es el que más nos interesa aquí. Como Puppet siempre buscará parámetros en Hiera, puedes declarar de forma segura cualquier **clase** con **include**, incluso clases con parámetros. (No es el caso en las primeras versiones de Puppet) Si usas el ejemplo anterior, puedes obtener algo como lo siguiente en tu información de Hiera:

	# /etc/puppet/hieradata/web01.example.com.yaml
	---
	myclass::parameter_one: "This node is special, so we're overriding the common configuration that the other nodes use."

	# /etc/puppet/hieradata/common.yaml
	---
	myclass::parameter_one: "This node can use the standard configuration."

Podrías entonces declarar **include myclass** para cada nodo, y cada nodo obtendría su propia información adecuada para la clase.

### ¿Por qué?
La búsqueda automática de parámetros es buena para escribir código reutilizable porque es **normal y predecible**. Cualquiera que baje tu módulo podrá ver la primera línea de cada manifiesto y ver fácilmente qué claves necesitan establecer en sus propios datos Hiera.

Si por el contrario, utilizas las funciones de Hiera en el cuerpo de una clase, necesitarás documentar claramente qué claves necesita establecer el usuario.

### Limitaciones

#### Sólo prioridad
La búsqueda automática de parámetros sólo puede usar el método de búsqueda de [prioridad](http://docs.puppetlabs.com/es/hiera/lookup_types.html#priority-default). Esto significa que, si bien **puede** recibir cualquier tipo de información desde Hiera (strings, arrays, hashes) **no puede** combinar valores desde múltiples niveles de jerarquía. Sólo obtendrás el valor del nivel de jerarquía más específico.

Si necesitas combinar arrays o hashes de niveles de jerarquía múltiples, deberás usar las funciones **hiera_array** o **hiera_hash** en el cuerpo de las clases.

#### No soportado en Puppet 2.7
Basarse en la búsqueda automática de parámetros significa escribir código solamente para Puppet 3 y superiores. De todos modos puedes imitar el comportamiento de Puppet 3 en 2.7 combinando parámetros por defecto y funciones de llamadas de Hiera.

	class myclass (
      	$parameter_one = hiera('myclass::parameter_one', 'default text')
    	) {
      	# ...
    	}

+ Este patrón requiere que los usuarios de 2.7 tengan Hiera instalado. Fallará la compilación si las funciones de Hiera no están.
+ Como todos los parámetros tienen opciones predeterminadas, tu clase será declarable con seguridad con **include** incluso en 2.7.
+ Puppet 2.7 hará las búsquedas de Hiera para las mismas claves que puppet 3 busca automáticamente.
+ Ten en cuenta que esto acarrea una disminución de la performance, porque Puppet 3 terminará haciendo dos llamadas a Hiera para cada parámetro en lugar de sólo una.

## Funciones de búsqueda de Hiera
Puppet tiene tres funciones de búsqueda para recuperar datos desde Hiera. Todas esas funciones devuelven un sólo valor (pero ten en cuenta que este valor puede ser una estructura compuesta de información de forma arbitraria y compleja) y puede usarse en cualquier lugar en que Puppet acepte valores de ese tipo (atributos de recursos, títulos de recursos, los valores de las variables, etc.).

**hiera**
Búsqueda estándar de prioridad. Obtiene el valor más específico para una clave determinada. Esto puede devolver valores de cualquier tipo (strings, arrays, hashes) desde Hiera.

**hiera_array**
Utiliza una [búsqueda de merge de array](http://docs.puppetlabs.com/es/hiera/lookup_types.html#array-merge). Obtiene todo de los valores de strings o arrays en la jerarquía para una clave determinada, y luego las aplana en un array simple de valores únicos.

**hiera_hash**
Utiliza una [búsqueda de merge de hash](http://docs.puppetlabs.com/es/hiera/lookup_types.html#hash-merge). Espera que cada valor en la jerarquía de una clave determinada sea un hash y combina las claves de valor superior en cada hash, en un único hash. Ten en cuenta que esto no realiza un merge en profundidad en estructuras compuestas.

Cada una de estas funciones toma tres argumentos en el siguiente orden:

1. Clave (requerido): La clave de búsqueda en Hiera.
2. Default (opcional): Valor para usar si Hiera no encuentra nada para esa clave. Si no se provee este valor, se producirá una falla en la búsqueda que causará una falla en la compilación.
3. Sustitución (opcional): El nombre de un [nivel de jerarquía](http://docs.puppetlabs.com/es/hiera/hierarchy.html) arbitrario para insertar al tope de la jerarquía. Esto te permite usar una jerarquía modificada temporalmente para una búsqueda particular (por ejemplo: en lugar de una jerarquía de **$clientcert -> $osfamily -> common**, la búsqueda usaría **specialvalues -> $clientcert -> $osfamily -> common**; necesitarías estar seguro de tener **specialvalues.yaml** o similar en tus datos de Hiera).

### Usar las funciones de búsqueda desde Templates
En general, no utilices las funciones de Hiera desde templates. Ese patrón es poco legible y *lastimará* el mantenimiento de tu código. Si un coautor de tu código necesita cambiar las invocaciones de Hiera y busca archivos **.pp** para esto, podrían perderse invocaciones extra en este template. Incluso si sólo una persona hace el mantenimiento de este código, es probable que cometa errores similares luego de algunos meses.

Es mucho mejor usar las funciones de búsqueda en manifiestos puppet, asignar su valor a una variable local y luego hacer la referencia de la variable desde el template. Esto mantiene las llamadas a funciones  aisladas en una capa de tu código, donde serán fáciles de encontrar si necesitas modificarlas o documentarlas para otros usuarios.

Sin embargo puedes, por supuesto, [usar el prefijo **scope.function**](http://docs.puppetlabs.com/guides/templating.html#using-functions-within-templates) para llamar a cualquiera de las funciones Hiera desde un template.

## Interactuar con información estructurada desde Hiera

Las funciones de búsqueda y la búsqueda automática de parámetros siempre devuelve valores de **claves de nivel superior** en tus datos de Hiera, no pueden descender a estructuras de información profundamente compuestas y devolver sólo una porción de ello. Para realizar esto, necesitas en primer lugar, almacenar la estructura completa como una variable, luego indexarla dentro de la estructura desde tu código Puppet o template:

Ejemplo:

	# /etc/puppet/hieradata/appservers.yaml
   	---
    	proxies:
      - hostname: lb01.example.com
        ipaddress: 192.168.22.21
      - hostname: lb02.example.com
        ipaddress: 192.168.22.28

Bueno:

    # Busca la información estructurada:
    $proxies = hiera('proxies')
    # Indexa dentro de la estructura:
    $use_ip = $proxies[1]['ipaddress'] # will be 192.168.22.28

Malo:

    # Trata de saltearse un paso, y le da a Hiera algo que no entiende:
    $use_ip = hiera( 'proxies'[1]['ipaddress'] ) # esto va a explotar


## Asignar clases a los nodos con Hiera (**hiera_include**)
Puedes usar Hiera para asignar clases a nodos con la función especial **hiera_include**. Esto te permite asignar clases en gran detalle sin repeticiones. Esto es esencialmente lo que la gente intentó hacer, sin éxito, al usar herencia de nodos.  Puede darte los beneficios de un [clasificador de nodos externo](http://docs.puppetlabs.com/guides/external_nodes.html) rudimentario sin tener que escribir en el ENC real.

1. Elige un nombre de clave para usar para las clases. Debajo, asumiremos que estás utilizando **classes**.
2. En tu archivo **/etc/puppet/manifests/site.pp**, escribe la línea ** hiera_include ('classes')**. Coloca esto **fuera de cualquier otra [definición de nodo**](http://docs.puppetlabs.com/puppet/latest/reference/lang_node_definitions.html) y debajo de cualquier variable top-scope de la que dependan tus búsquedas de Hiera.
3. Crea claves de **classes** a través de tu jerarquía Hiera

+ El valor de cada clave de **classes** debe ser un **array**

+ Cada valor en el array debe ser **el nombre de una clase**
Una vez que hayas hecho estos pasos, Puppet asignará automáticamente clases desde Hiera a todos los nodos. Ten en cuenta que la función **hiera_include** usa una búsqueda de merge de array para recuperar el array **classes**, esto significa que cada nodo tendrá cada clase desde esta jerarquía.

Ejemplo:

Asumiendo una jerarquía de:
	
	:hierarchy:
     	 - %{::clientcert}
  	    - %{::osfamily}
 	     - common

E información de Hiera como la siguiente:

	# common.yaml
    	---
   	 classes:
     	 - base	
     	 - security
    	  - mcollective

	# Debian.yaml
  	  ---
  	  classes:
      	- base::linux
   	   - localrepos::apt

  	  # web01.example.com
 	   ---
 	   classes:
 	     - apache
 	     - apache::passenger

El nodo Ubuntu **web01.example.com** obtendría las siguientes clases:

+ apache
+ apache::passenger
+ base::linux
+ localrepos::apt
+ base
+ security
+ mcollective

En Puppet 3, cada una de estas clases buscará automáticamente cualquier parámetro requerido en Hiera.
