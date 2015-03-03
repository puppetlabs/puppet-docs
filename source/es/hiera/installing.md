---
layout: default
title: "Hiera 1: Instalación"
canonical: "/es/hiera/installing.html"
toc: false
---

#Hiera 1: Instalación

1. Prerrequisitos
2. Instalar Hiera
	+ Paso 1: Instalar hiera como paquete o como Gem
	+ Paso 2: Instalar las funciones de Puppet
3. A continuación

Nota: Si estás usando Puppet 3 o superior, probablemente ya tengas instalado Hiera. Puedes saltearte estos pasos, e ir directamente a [configurar Hiera](http://docs.puppetlabs.com/hiera/1/configuring.html)

#Prerrequisitos

+ Hiera trabaja en sistemas \*nix y Windows.
+ Requiere Ruby 1.8.5 o superior.
+ Para trabajar con Puppet, requiere Puppet 2.7.x o superior.
+ Si es usado con Puppet 2.7.x, también necesita el paquete adicional **hiera-puppet**;  mira más abajo.

#Instalar Hiera
Si estás usando Hiera para Puppet, debes instalarlo **en tus servidores puppet master**; esto es opcional e innecesario en los nodos agentes. Si estás usando una implementación sin un puppetmaster con puppet apply, cada nodo debe tener Hiera.

## Paso 1: Instalar hiera como paquete o como Gem
Instala el paquete **hiera** usando Puppet, o el gestor de paquetes estandar del sistema.

**Nota**: Quizás primero necesites [habilitar los repositorios de paquetes de Puppet Labs](http://docs.puppetlabs.com/guides/puppetlabs_package_repositories.html)
	
	$ sudo puppet resource package hiera ensure=installed

Si tu sistema no tiene paquetes nativos de Hiera disponibles, quizás necesites instalarlos como un Gem de Ruby.

	$ sudo gem install hiera

##Paso 2: Instala las funciones de Puppet
SI estás usando Hiera con Puppet 2.7.x, debes instalar el paquete **hiera-puppet** en cada puppet master.

	$ sudo puppet resource package hiera-puppet ensure=installed

O, en sistemas sin paquetes nativos:

	$ sudo gem install hiera-puppet

**Nota:** Puppet 3 no necesita el paquete **hiera-puppet**,  y quizás su presencia impida la instalación. Lo puedes borrar sin problemas en el proceso de actualización de Puppet 3.

#A continuación
Esto es todo: Hiera está instalado. Ahora, [configura Hiera con el archivo de configuración **hiera.yaml**](http://docs.puppetlabs.com/hiera/1/configuring.html)
