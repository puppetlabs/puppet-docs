---
layout: frontpage
title: Documentación de Puppet Labs
canonical: "/es/index.html"
toc: false
---

1. [Contribuir](http://docs.puppetlabs.com/#contributing)
2. [Puppet](http://docs.puppetlabs.com/#puppetpuppet)
3. [Puppet Enterprise](http://docs.puppetlabs.com/#puppet-enterprisepelatest)
4. [MCollective](http://docs.puppetlabs.com/#mcollectivemcollective)
5. [Puppet Dashboard](http://docs.puppetlabs.com/#puppet-dashboarddashboardmanual12)
6. [PuppetDB](http://docs.puppetlabs.com/#puppetdbpuppetdblatest)
7. [Hiera](http://docs.puppetlabs.com/#hierahiera1)
8. [Facter](http://docs.puppetlabs.com/#facterfacter16corefactshtml)
9. [Geppetto](http://docs.puppetlabs.com/#geppetto)
10. [Puppet Forge](http://docs.puppetlabs.com/#forge)
11. [Razor](http://docs.puppetlabs.com/#razor)
12. [Comunidad](http://docs.puppetlabs.com/#community)
13. [Ayúdanos a mejorar este sitio](http://docs.puppetlabs.com/#help-improve-this-site)
14. [Versiones de la documentación](http://docs.puppetlabs.com/#documentation-version)

Bienvenidos al sitio de documentación de Puppet Labs. Es posible [bajar la versión actual de todo este sitio](https://docs.puppetlabs.com/puppetdocs-latest.tar.gz) como archivo zipeado; descomprímelo y sigue las instrucciones del archivo README.txt para ver el sitio offline.

##Contribuir
Este documento ha sido contribuido amablemente por la comunidad de usuarios de Puppet. En particular nos gustaría agradecer especialente a [Edrans](www.edrans.com), partner de Puppet basado en Argentina, por su generosa contribución a la traducción de la documentación de Puppet Labs al Español.

Puppet Labs está comprometido a dar soporte a nuestros usuarios hispanoparlantes. Estamos planeando agregar más recursos en Español para ayudarles a aprender e implementar Puppet y Puppet Enterprise.

Siempre estamos buscando más ayuda en la traducción de nuestra documentación al Español. Si te interesa contribuir a la traducción de documentación de Puppet, por favor envíanos un [email](localization@puppetlabs.com).

##Puppet
Puppet maneja tus servidores: Describes la configuración en un lenguaje declarativo de fácil lectura, y Puppet llevará tus sistemas al estado deseado y los mantendrá allí.

[Mira el índice de la documentación Puppet aquí](http://docs.puppetlabs.com/puppet/), o ve directamente a una de las páginas más populares:

+ [La serie de aprendizaje de Puppet](http://docs.puppetlabs.com/learning/) es un tutorial guiado para usuarios nuevos, el cual incluye una VM gratuita para hacer ejercicios y experimentar, y puedas ir desde  *“¿Qué es esto?”* a un *“¡Puedo hacerlo!”* en sólo un par de horas. 
+ [La guía de instalación](http://docs.puppetlabs.com/guides/installation.html) te ayudará a instalar y configurar la versión actual de Puppet Open Source.
+ [El manual de referencia para Puppet 3.7](http://docs.puppetlabs.com/puppet/3.7/reference/)
+ [El manual de referencia para Puppet 3.6](http://docs.puppetlabs.com/puppet/3.6/reference/), [Puppet 3.5](http://docs.puppetlabs.com/puppet/3.5/reference/), [Puppet 3.0-3.4](http://docs.puppetlabs.com/puppet/3/reference/) y [Puppet 2.7](http://docs.puppetlabs.com/puppet/2.7/reference/).
+ [Referencia de tipos](http://docs.puppetlabs.com/references/latest/type.html) cubre todos los tipos de recursos integrados y sus atributos disponibles. Los usuarios nuevos deberían empezar por otra parte, pero los experimentados pasarán la mayoría del tiempo en esta página.
+ [El glosario](http://docs.puppetlabs.com/references/glossary.html) explica la terminología que encontrarás leyendo sobre Puppet.

##Puppet Enterprise
Puppet Enterprise es Puppet y más; incluye soporte profesional, un stack de Puppet listo para producción, una consola web para analizar reportes y controlar tu infraestructura, poderosas features de orquestación, y herramientas para provisionar en la nube.

Casi toda la documentación de Puppet también se aplica para Puppet Enterprise. Para más detalles sobre otras características de PE y su entorno de ejecución ligeramente distinto, mira a [la *Guía para el usuario* actual de PE](http://docs.puppetlabs.com/pe/latest/), o ve directamente a: 

+ [Requerimientos del sistema](http://docs.puppetlabs.com/pe/latest/install_system_requirements.html)
+ [Instrucciones para la instalación](http://docs.puppetlabs.com/pe/latest/install_basic.html) o [Instrucciones de actualización](http://docs.puppetlabs.com/pe/latest/install_upgrading.html)
+ [La guía para comenzar rápido](http://docs.puppetlabs.com/pe/latest/quick_start.html), la cual te llevará a través de la construcción y gestión de una pequeña prueba de concepto para comenzar a usar PE.
+ [La guía de utilización](http://docs.puppetlabs.com/guides/deployment_guide/dg_intro_install.html) tiene mucha información para ayudarte a preparar y hacer uso de PE de acuerdo con las mejores prácticas y métodos usados por los Ingenieros de Servicios Profesionales en Puppet Labs.
+ [El sitio de downloads de PE](http://info.puppetlabs.com/download-pe.html) La versión actual de PE es 3.7; la documentación para versiones anteriores puedes encontrarla [aquí](http://docs.puppetlabs.com/pe/index.html).

##MCollective
MCollective es un poderoso framework de orquestación. Puedes ejecutar acciones en miles de servidores simultáneamente, usando plugins existentes o escribiendo plugins propios.
[Mira el índice de documentación de MCollective](http://docs.puppetlabs.com/mcollective/), o ve directo a:

+ [Glosario de terminología](http://docs.puppetlabs.com/mcollective/terminology.html)
+ [Instrucciones de instalación](http://docs.puppetlabs.com/mcollective/reference/basic/gettingstarted.html)
+ [Guía de configuración](http://docs.puppetlabs.com/mcollective/reference/basic/configuration.html)
+ [Guía para escribir nuevos plugins para el agente](http://docs.puppetlabs.com/mcollective/simplerpc/)
+ [Notas acerca de la versión](http://docs.puppetlabs.com/mcollective/releasenotes.html)
Nota: MCollective está incluído en PE, y nuevos plugins para los agentes aparecerán en el control de gestiones de la consola.

##Puppet Dashboard
Puppet Dashboard es una consola web de código abierto para Puppet, la cual puede analizar reportes, chequear datos de inventario y clasificar nodos. 
[Mira el manual 1.2 de Dashboard](http://docs.puppetlabs.com/dashboard/manual/1.2/), o ve directo a:

+ [Instrucciones de instalación](http://docs.puppetlabs.com/dashboard/manual/1.2/bootstrapping.html)
+ [Guía de configuración](http://docs.puppetlabs.com/dashboard/manual/1.2/configuring.html)
+ [Guía de mantenimiento](http://docs.puppetlabs.com/dashboard/manual/1.2/maintaining.html)
Nota: La consola PE está basada en el Puppet Dashboard, extendiéndose en otras características. Los usuarios de PE deben ver la documentación de PE en lugar de la documentación del Dashboard.

##PuppetDB
PuppetDB es el depósito de datos de Puppet: rápido, explandible y confiable. Cachea los datos generados por Puppet, y te devuelve información a gran velocidad con una poderosa API.
[Mira el manual de la última versión de PuppetDB](http://docs.puppetlabs.com/puppetdb/latest/), o ve directamente a:

+ [Instalación vía módulo de Puppet](http://docs.puppetlabs.com/puppetdb/latest/install_via_module.html)
+ [Instalación manual](http://docs.puppetlabs.com/puppetdb/latest/install_from_packages.html)
+ [Requerimientos del sistema](http://docs.puppetlabs.com/puppetdb/latest/index.html#system-requirements)
+ [Identificación y corrección de problemas frecuentes](http://docs.puppetlabs.com/puppetdb/latest/puppetdb-faq.html)
La documentación de otras versones de PuppetDB la encuentras [aquí](http://docs.puppetlabs.com/puppetdb/).

##Hiera
Hiera es una herramienta de búsqueda de pares clave/valor para configurar datos, hecha para mejorar Puppet. Te permite definir datos específicos de cada nodo sin repeticiones. El soporte de Hiera está integrado en Puppet 3, y está disponible como un complemento para Puppet 2.7.
[Mira el manual Hiera 1](http://docs.puppetlabs.com/hiera/1/), o ve directamente a:

+ [Instrucciones de instalación](http://docs.puppetlabs.com/hiera/1/installing.html)
+ [Referencias de Archivos de configuración](http://docs.puppetlabs.com/hiera/1/configuring.html)
+ [Información sobre jerarquías](http://docs.puppetlabs.com/hiera/1/hierarchy.html)
+ [Cómo escribir fuetes de datos](http://docs.puppetlabs.com/hiera/1/data_sources.html)
+ [Usar Hiera con Puppet](http://docs.puppetlabs.com/hiera/1/puppet.html)
+ [Usar Hiera desde la línea de comandos](http://docs.puppetlabs.com/hiera/1/command_line.html)

##Facter
Facter es la biblioteca multiplataforma de perfilado de sistemas utilizado por Puppet. Descubre y reporta *datos particulares de cada nodo* (facts), los cuales están disponibles en tus manifiestos de Puppet como variables.

+ [La lista de facts fundamentales](http://docs.puppetlabs.com/facter/latest/core_facts.html) enumera y describe cada fact que se incluye por defecto en Facter.
+ [La guía de facts customizados](http://docs.puppetlabs.com/guides/custom_facts.html), explica cómo escribir y distribuir tus propios facts.

##[Geppetto](/geppetto/latest/index.html)

Geppetto es un entorno integrado de desarrollo (IDE) para Puppet. Provee herramientas para el desarrollo de módulos y manifiestos de Puppet incluyendo resaltado de sintaxis, debugging de errores y autocompletado de código. Geppetto también incorpora integración con PE parseando los reportes de errores de PuppetDB. Esto permite encontrar rapidamente las fallas de configuración causadas por errores en el código de Puppet.

* [El manual de Geppetto](/geppetto/latest/index.html) tiene instrucciones para la instalación y uso.

##[Puppet Forge](/forge/index.html)

El [Puppet Forge](https://forge.puppetlabs.com) es donde puedes conseguir módulos pre-hechos, creados por Puppet Labs y la comunidad de Puppet. Los módulos del Forge abarcan desde NTP y Registry hasta Apache y PostgreSQL, haciendo fácil la instalación, configuración y manejo de todo tipo de tecnologías con Puppet. Puedes acceder al Forge online o desde la herramienta Puppet module, la cual permite interactuar con el Forge desde la línea de comandos.

* [Módulos de Puppet Enterprise](/forge/puppetenterprisemodules/index.html) te dirá todo lo que necesitas saber para trabajar con módulos específicos de PE en el Forge.

##Razor

Razor es una aplicación avanzada de provisionamiento que puede desplegar sistemas bare metal y virtuales. Para más información acerca de la integración de Razor con PE, ver [Provisionamiento Bare Metal con Razor](/pe/latest/razor_intro.html).

[Razor también está disponible como un proyecto open source](https://github.com/puppetlabs/razor-server). Ver la [wiki de Razor](https://github.com/puppetlabs/razor-server/wiki) para más información.

#Comunidad
Puppet tiene una gran comunidad y muchos recursos para usuarios.

+ [Pautas y código de conducta de la comunidad](http://docs.puppetlabs.com/community/community_guidelines.html) Información general sobre cómo navegar por nuestra comunidad y obtener ayuda.
+ [Repositorios Yum/Apt](http://docs.puppetlabs.com/guides/puppetlabs_package_repositories.html) Instala de forma fácil el software de Puppet Labs en las distribuciones más populares de Linux.
+ [Puppet Forge](http://forge.puppetlabs.com/) Un bazar de módulos hecho por la comunidad, para gestionar desde repositorios Apt hasta ZFT.
+ [Flujo de trabajo de Redmine para proyectos Puppet open source](http://docs.puppetlabs.com/community/puppet_projects_redmine_workflow.html) Información acerca de cómo los proyectos de Puppet utilizan sus propias herramientas de seguimiento de errores, y cómo puedes ayudar.
+ [Políticas de exención para parches triviales](http://docs.puppetlabs.com/community/trivial_patch_exemption.html) Detalles acerca de qué contribuciones están exentas del acuerdo para contribuyentes.

#Ayúdanos a mejorar este sitio
Los documentos debajo pertenecen a la comunidad y están bajo licencia de *Creative Commons*. Tú puedes ayudarnos a mejoralos!
Este trabajo está bajo licencia de [Creative Commons Attribution-Share Alike 3.0 United States License]( (http://creativecommons.org/licenses/by-sa/3.0/us/).
Para sugerencias o correcciones menores, puedes enviar un correo a: faq@puppetlabs.com. Para aportar texto o sugerencias mayores, mira las [instrucciones para contribuciones](http://docs.puppetlabs.com/contribute.html). Si quisieras presentar tu propio material, puedes crear un *fork* del proyecto en github, haz cambios, y envíanos un *pull request*. Mira los archivos README del proyecto para más información acerca de cómo generar y visualizar una copia del sitio web.
