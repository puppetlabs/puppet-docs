---
layout: default
title: "Hiera 1: Escribir fuentes de información"
canonical: "/es/hiera/data_sources.html"
toc: false
---

Hiera puede usar diferentes backends de información, incluyendo dos backends integrados y otros opcionales. Cada backend usa un formato diferente para sus fuentes de información.

Esta página describe los backends integrados **yaml** y **json**, que al igual que el backend de **puppet**, incluido con la integración de Hiera en Puppet. Para backends opcionales, mira la documentación de backends.

#YAML

##Sumario

El backend **yaml** busca fuentes de información en disco, en el directorio especificado en su [opción de configuración  **:datadir**](http://docs.puppetlabs.com/es/hiera/configuring.html#datadir)). Espera que cada fuente de información sea un archivo de texto que contenga información en formato YAML válido, con extensión **.yaml**. No está permitida ninguna otra extensión de nombre de archivo, por ejemplo: **.yml**.

##Formato de la información

Mira [yaml.org](http://www.yaml.org/) y [El manual básico de “YAML para Ruby”]( http://www.yaml.org/YAML_for_ruby.html) para una descripción completa del formato YAML válido.

El objeto raíz (de nivel superior) de cada fuente de información YAML debe ser un *mapeo YAML (hash)*. Hiera tratará sus claves de nivel superior como piezas de información disponible en la fuente de información. El valor para cada clave puede ser cualquiera de los tipos de información descritos a continuación:

Los tipos de información de Hiera se asignan a los tipos de datos YAML nativos de la siguiente manera:

<table>
 <thead>
   <tr>
	<th>Hiera</th>
	<th>YAML</th>
   </tr>
 </thead>
 <tbody>
  <tr>
	<td>Hash</td>
	<td>Mapeo (Mapping)</td>
  </tr>
  <tr>
	<td>Array</td>
	<td>Secuencia (Sequence)</td>
  </tr>
  <tr>
	<td>String</td>
	<td>Escalar citado o Escalar no citado no-booleano</td>
  </tr>
  <tr>
	<td>Número</td>
	<td>Entero o flotante</td>
  </tr>
  <tr>
	<td>Booleano</td>
	<td>Booleano (nota: incluye <strong>on</strong> y <strong>off</strong>, <strong>yes</strong> y <strong>no</strong>,  además de <strong>true</strong> y  <strong>false</strong>)</td>
  </tr>
 </tbody>
</table>

Cualquier string puede incluir cualquier número de [símbolo de interpolación variable](http://docs.puppetlabs.com/es/hiera/variables.html)

##Ejemplo

	---
	# array
	apache-packages:
	    - apache2
	    - apache2-common
	    - apache2-utils
	
	# string
	apache-service: apache2
	
	# variable de facter interpolada
	hosts_entry: sandbox.%{fqdn}
	
	# hash
	sshd_settings: 
	    root_allowed: "no"
	    password_allowed: "yes"
	
	# notación alternativa de hash
	sshd_settings: {root_allowed: "no", password_allowed: "yes"}
	
	# para devolver "true" o "false"
	sshd_settings: {root_allowed: no, password_allowed: yes}

#JSON

##Sumario

El backend **json** busca fuentes de información en disco, en el directorio especificado en su [opción de configuración  **:datadir**](http://docs.puppetlabs.com/es/hiera/configuring.html#datadir). Espera que cada fuente de información sea un archivo de texto que contenga información en JSON válida, con extensión **.json**. No está permitida ninguna otra extensión de nombre de archivo.

##Formato de información

[Mira las la guía de especificaciones para una descripción completa del formato JSON válido]( http://www.json.org/)

El objetivo principal de cada fuente de información JSON debe ser un *objeto JSON (hash)*. Hiera tratará estas claves de nivel superior como piezas de información disponible en la fuente de información. El valor para cada clave puede ser cualquiera de los tipos de información descritos a continuación:

<table>
 <thead>
   <tr>
	<th>Hiera</th>
	<th>JSON</th>
   </tr>
 </thead>
 <tbody>
  <tr>
	<td>Hash</td>
	<td>Objeto</td>
  </tr>
  <tr>
	<td>Array</td>
	<td>Array</td>
  </tr>
  <tr>
	<td>String</td>
	<td>String</td>
  </tr>
  <tr>
	<td>Número</td>
	<td>Número</td>
  </tr>
  <tr>
	<td>Booleano</td>
	<td><strong>verdadero</strong> / <strong>falso</strong></td>
  </tr>
 </tbody>
</table>

Cualquier string puede incluir cualquier número de [símbolos de interpolación variables](http://docs.puppetlabs.com/es/hiera/variables.html).

##Ejemplo

	{   
    "apache-packages" : [
    "apache2",
    "apache2-common",
    "apache2-utils"
    ],

    "hosts_entry" :  "sandbox.%{fqdn}",

    "sshd_settings" : {
                        "root_allowed" : "no", 
                        "password_allowed" : "no"
                      }
	}

#Puppet
Próximamente. 
