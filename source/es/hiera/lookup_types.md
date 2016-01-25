---
layout: default
title: "Hiera 1: Tipos de búsqueda"
canonical: "/es/hiera/lookup_types.html"
---

Hiera siempre toma una clave de búsqueda y devuelve un valor simple (de algún tipo de información simple o complejo), pero tiene varios métodos de extracción / ensamble de ese valor a partir de la jerarquía. Nos referimos a eso como “métodos de búsqueda”.

Todos estos métodos de búsqueda están disponibles vía las funciones Puppet de Hiera, interfaces de líneas de comando, y las API de Ruby.

## Prioridad (por defecto)

Una **búsqueda prioritaria** obtiene un valor del nivel de coincidencia más específico de la jerarquía (el primero en coincidir) que sea consultado.

Las búsquedas prioritarias pueden recuperar valores de cualquier tipo de información (strings, arrays, hashes), pero el valor completo provendrá de sólo un nivel de jerarquía.

Esto es el método de búsqueda por defecto de Hiera.

## Merge de array

Una **búsqueda de merge de arrays**  ensambla un valor de **todos** los niveles de coincidencia de la jerarquía.  Recupera **todos** los valores (string o array) para una clave determinada, luego los aplana en un array de valores únicos. Si la búsqueda prioritaria puede ser pensada como un patrón “por defecto con overrides”, la búsqueda de merge de arrays puede ser pensada como “por defecto con adiciones”.

Por ejemplo, una jerarquía determinada de: 

	- web01.example.com
	- common

… y la siguiente información:

	# web01.example.com.yaml
	mykey: one
	
	# common.yaml
	mykey:
		-	 two
		- 	three

Una búsqueda de merge de arrays devolvería un valor de **[uno, dos, tres]**.

En esta versión de Hiera, la búsqueda de merge de arrays fallará si alguno de los valores encontrados en las fuentes de información es un hash. Sólo funciona con strings, valores escalares similares a strings (booleanos y números) y arrays.

## Merge de hash

Una búsqueda de merge de hash ensambla un valor usando **todos** los niveles de coincidencia de la jerarquía. Recupera **todos** los valores (del hash) de una clave determinada, luego **fusiona** los hashes en un solo hash.

En Hiera 1.x, la búsqueda de merge de hash fallará si alguno de los valores encontrados en las fuentes de información es un string o un array. Sólo funciona cuando todos los valores encontrados son hashes.

### Merge nativo

En Hiera 1.0 y 1.1, ésta es la única clase disponible de merge de hash. En Hiera ≥ 1.2, también están disponibles el merge en profunidad (mira la explicación debajo).

En un merge de hash nativo, Hiera fusiona sólo los **valores y claves de nivel superior** en cada hash de la fuente. Si existe la misma clave en una fuente de mayor prioridad en la jerarquía y una de menor prioridad, la de mayor prioridad será usada.

Por ejemplo una jerarquía determinada de:

	- web01.example.com
	- common

… y la siguiente información:

	# web01.example.com.yaml
	mykey:
	    z: 	"local value"

	# common.yaml
	mykey:
	    a: 	"common value"
	    b: 	"other common value"
	    z: 	"default local value"

... una búsqueda de merge de hash nativo devolvería un valor **{z => "local value", a => "common value", b => "other common value"}**. Ten en cuenta que en casos donde dos o más hashes fuente compartan algunas claves, la fuente de información de mayor prioridad en la jerarquía sustituirá a la de menor.

### Merge en profundidad en Hiera ≥ 1.2.0

En Hiera 1.2.0 y superiores, también es posible configurar las búsquedas de merge de hashes para combinar de forma recursiva las claves de los hashes, implementado como [Issue 16107](https://projects.puppetlabs.com/issues/16107). Esto está pensado para los usuarios que han trasladado estructuras complejas de datos (por ejemplo [hashes para *create_resources*](http://docs.puppetlabs.com/puppet/latest/reference/function.html#createresources) a Hiera.

Para configurar el merge en profunidad, utiliza la [opción de configuración **:merge_behavior**](http://docs.puppetlabs.com/es/hiera/configuring.html#mergebehavior), el cual puede ser configurado para que sea **native, deep** o **deeper**.

Limitaciones:

+ Actualmente funciona sólo con los backends yaml y json.
+ Debes instalar el gem de Ruby **deep_merge** para que funcionen los merge en profundidad. Si esta opción no está disponible, Hiera recurrirá al comportamiento por defecto del merge nativo.
+ Esta configuración es global, no para cada búsqueda.

#### Comportamientos del merge 

Hay tres comportamientos disponibles para el merge.

+ El tipo por defecto, **native**, está descrito más arriba en “Merge nativo” y coincide con lo que hace Hiera 1.0 y 1.1
+ El tipo **deep** es en gran parte inútil y debe ser evitado
+ El tipo **deeper** realiza un merge recursivo, y se comporta como la mayoría de los usuarios espera.

En un merge de hash **deeper**, Hiera fusiona claves y valores en cada hash de origen. **Para cada clave**, si el valor:

+ **Está presente en sólo un** hash de origen, entra en el hash final.
+ **Es un string/número/booleano** y existe en dos o más hashes de origen, la el valor de **prioridad más elevada** entra en el hash final.
+ **Es un array** y existe en dos o más hashes de origen, los valores de cada fuente son fusionados en un array y de-duplicado, pero no aplanado automáticamente como en las búsquedas de merge de array.
+ **Es un hash** y existe en dos o más hashes de origen, los valores de cada fuente **se fusionan recursivamente** como si fueran hashes de origen.
+ **No es coincidente** entre dos o más hashes de origen, no hemos validado el comportamiento. Debería actuar como se describe en [la documentación del gem **deep_merge**](https://github.com/peritor/deep_merge).

En un merge de hash **deep**, Hiera se comporta como lo descrito arriba, excepto cuando existe un string/número/booleano en dos o más hashes de origen, que el valor de **prioridad más baja** entra en el hash final. Como ya hemos mencionado, esto suele ser inútil.

#### Ejemplo

Un caso típico de uso de hashes en Hiera es la construcción de una estructura de datos que se le pasa a la función **create_resources**. Este ejemplo implementa las siguientes reglas de negocio que dicen:

1. El usuario ‘jen’ está definido sólo en el servidor ‘deglitch’
2. El usuario ‘bob’ está definido en todos lados, pero tiene un *uid* diferente en ‘deglitch’ respecto de lo que recibe en otros servidores. 
3. El usuario ‘ash’ está definido en todos lados con un ‘uid’ y un ‘shell’ consistentes.

En hiera.yaml, enviamos una jerarquía de dos niveles:

    # /etc/puppet/hiera.yaml
    ---
    :backends:
      - yaml
    :logger: puppet
    :hierarchy:
      - "%{hostname}"
      - common
    :yaml:
      :datadir: /etc/puppet/hieradata
    # Las opciones son native, deep, deeper
	:merge_behavior: deeper

En common.yaml, configuramos usuarios por defecto para todos los nodos:

	---
    site_users:
      bob:
        uid: 501
        shell: /bin/bash
      ash:
        uid: 502
        shell: /bin/zsh
	  group: common

En deglitch.yaml, configuramos los detalles de un usuario de nodo específico para *deglitch.example.com*:

	---
    site_users:
      jen:
        uid: 503
        shell: /bin/zsh
        group: deglitch
      bob:
        uid: 1000
        group: deglitch

En un merge de hash **nativo**, quisiéramos terminar con un hash como el siguiente:

	{
      "bob"=>{
        group=>"deglitch",
        uid=>1000,
      },
      "jen"=>{
        group=>"deglitch",
        uid=>503
        shell=>"/bin/zsh",
      },
      "ash"=>{
        group=>"common",
        uid=>502,
        shell=>"/bin/zsh"
      }
    }

Ten en cuenta que Bob pierde su *shell*, y esto sucede porque el valor de nivel superior de la clave **bob** de common.yaml fue remplazada por completo.

Con un merge de hash **deeper**, obtendríamos un comportamiento más intuitivo:

	{
      "bob"=>{
        group=>"deglitch",
        uid=>1000,
        shell=>"/bin/bash"
      },
      "jen"=>{
        group=>"deglitch",
        uid=>503
        shell=>"/bin/zsh",
      },
      "ash"=>{
        group=>"common",
        uid=>502,
        shell=>"/bin/zsh"
      }
    }

En este caso, el *shell* de Bob persiste a common.yaml, pero deglitch.yaml tiene permiso para sustituir su *uid* y su grupo, reduciendo la cantidad de información que tienes que duplicar entre archivos.

Con un merge en **profundidad**, obtendríamos esto:

	{
      "bob"=>{
        group=>"deglitch",
        uid=>501,
        shell=>"/bin/bash"
      },
      "jen"=>{
        group=>"deglitch",
        shell=>"/bin/zsh",
        uid=>503
      },
      "ash"=>{
        group=>"common",
        uid=>502,
        shell=>"/bin/zsh"
      }
    }

En este caso, deglitch.yaml pudo configurar el grupo porque common.yaml no tenía un valor para él, pero donde hubo conflicto, por ejemplo en uid, ganó *common*. Generalmente los usuarios no quieren esto.

Desafortunadamente ninguno de estos comportamientos de merge funciona con *data bindings* para la búsqueda automática de parámetros, porque no hay posibilidad de especificar el tipo de búsqueda. Entonces, en lugar de ver cualquiera de los resultados antes mostrados, las búsquedas automáticas de data binding sólo verán los resultados de **deglitch.yaml**. Mira [Bug#20199](https://projects.puppetlabs.com/issues/20199) para seguir este proceso.
