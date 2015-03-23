---
title: "Hiera 1: Vista general"
layout: default
canonical: "/es/hiera/index.html"
---

Hiera es una herramienta de búsqueda de pares clave/valor para configurar información, hecha para **mejorar [Puppet](http://docs.puppetlabs.com/puppet/)** y permitirte establecer los datos específicos del nodo sin repeticiones. Mira [¿Por qué Hiera? en el punto 2](http://docs.puppetlabs.com/hiera/1/index.html#why-hiera) para más información, o comienza a usarlo directamente:

## Comenzar a usar Hiera
Para comenzar con Hiera, necesitarás hacer lo siguiente:

+ [Instalar Hiera](http://docs.puppetlabs.com/es/hiera/installing.html) si todavía no lo hiciste.
+ [Hacer un archivo de configuración hiera.yaml](http://docs.puppetlabs.com/es/hiera/configuring.html) 
+ [Organizar una jerarquía](http://docs.puppetlabs.com/es/hiera/hierarchy.html) que se adapte a tu sitio y tus datos.
+ [Escribir fuentes de información](http://docs.puppetlabs.com/es/hiera/data_sources.html)
+ [Usar tus datos de Hiera en Puppet](http://docs.puppetlabs.com/es/hiera/puppet.html) (o en cualquier otra herramienta)

Luego de tener Hiera funcionando, puedes ajustar tu información y tus jerarquías cuando necesites hacerlo. También puedes [probar Hiera desde la línea de comando](http://docs.puppetlabs.com/es/hiera/command_line.html) para asegurarte que está trayendo la información correcta para cada nodo. 

### Aprender con el ejemplo
Si aprendes mejor con un ejemplo, comienza con [este tutorial Hiera y Puppet simple de principio a fin](http://docs.puppetlabs.com/es/hiera/complete_example.html). Para aprender más, poder volver y leer las secciones enlazadas antes.

## ¿Por qué Hiera?

### Mejorar Puppet
Hiera mejora Puppet al **mantener la información específica fuera de tus manifiestos**. Las clases de Puppet pueden solicitar toda la información que necesiten, y tus datos de Hiera actuarán como un archivo de configuración que abarca todo el sitio.

Esto tiene muchas ventajas:

+ Facilita la configuración de tus propios nodos: al fin es fácil configurar datos por defecto con múltiples niveles de override.
+ Facilita la reutilización de los módulos públicos de Puppet: No edites el código, sólo coloca la información necesaria en Hiera.
+ Facilita la publicación de tus propios módulos para colaboración: No necesitas preocuparte de limpiar tu información antes de mostrar el módulo. No más choques entre nombres de variables.

### Evitar repeticiones
Con Hiera, puedes:

+ Escribir información común para la *mayoría* de los nodos.
+ Sustituir *algunos* valores para máquinas ubicadas en locaciones particulares…
+ … y sustituir algunos de *esos* valores para uno o dos nodos únicos.

De esta forma, sólo tienes que escribir las *diferencias* entre nodos. Cuando cada nodo pregunte por una pieza de información, éste recibirá el valor específico que necesita.

Para decidir qué fuente de información pueden sustituir a otras, Hiera usa una **jerarquía configurable**. Esta lista ordenada puede incluir tanto fuentes de información **estáticas** (con nombres como por ejemplo “common”) como las **dinámicas** (las cuales pueden elegir distintas fuentes de información basandose en el nombre del nodo, sistema operativo, y más).
