---
layout: default
title: "PE 3.8 » Inicio Rápido » Firewall"
subtitle: "Guía de Inicio Rápido sobre Firewall"
canonical: "/pe/latest/quick_start_firewall.html"
---

[downloads]: http://info.puppetlabs.com/download-pe.html
[sys_req]: ./install_system_requirements.html
[agent_install]: ./install_agents.html
[install_overview]: ./install_basic.html

Bienvenido a la Guía de Inicio Rápido sobre Firewall. Este documento provee instrucciones para dar los primeros pasos administrando reglas de firewall con PE.

En un firewall, los administradores de sistema definen un conjunto de políticas (es decir, reglas de firewall) que consisten en puertos de red (tcp/udp), interfaces (dispositivos físicos con un puerto de red), direcciones IP, y una acción, en forma de un verbo como permitir o denegar. Estas reglas se aplican de "arriba-para-abajo". Por ejemplo, cuando un servicio, como SSH, intenta acceder a recursos del otro lado de un firewall, este aplica una lista de reglas para determinar si o como las comunicaciones via SSH deben administrarse. De no existir una regla que regule el acceso, se utilizará la política por defecto (permitir o denegar).  

Para administrar de forma mas eficaz estas reglas con PE, deberás dividirlas en grupos `pre` y `post`.

Siguiendo los ejemplos, esta guía te permitirá:

* [escribir un módulo simple que contenga una clase llamada `my_firewall` para definir las reglas de firewall para tu infraestructura administrada por PE](#write-the-my-firewall-class).
* [utilizar la consola de PE para agregar la clase `my_firewall` a tus nodos agente](#use-the-pe-console-to-add-the-my-firewall-class).
* [escribir una clase adicional para abrir los puertos del Puppet master](#open-ports-for-the-puppet-master).
* [asegurar el estado deseado de la clase `my_firewall`](#enforce-the-desired-state-of-the-my-firewall-class).

### Instalar Puppet Enterprise y el Agente de Puppet Enterprise

Si aún no lo has hecho, previo a esta guía debes tener PE instalado. Refiere a la página de [requerimientos del sistema][sys_req] para ver que plataformas están soportadas.

1. [Descarga y verifica el archivo comprimido][downloads].
2. Refiere al [resúmen de instalación][install_overview] para asistirte con la instalación de PE, luego sigue las instrucciones.
3. Refiere a las [instrucciones de instalación de agentes][agent_install] para asistirte con la instalación de nodo(s) agente(s), luego sigue las instrucciones.

>**Sugerencia**: Sigue las instrucciones en la [Guía de Inicio Rápido sobre NTP](./quick_start_ntp.html) para configurar PE de forma que asegures que la hora este sincronizada en todo los equipos de tu entorno.

## Escribir el modulo `my_firewall`

Algunos modulos pueden ser grandes, complejos, y requieren una significativa cantidad de prueba y error. Este módulo, sin embargo, sera muy simple de escribir, solo contiene tres clases.

> #### Un breve comentario sobre módulos
>
>Lo primero que debes saber es que, por defecto, los módulos que utilizarás para administrar sistemas (incluyendo los que instala PE, los que descargas del Forge, y aquellos que desarrolles tu mismo) estan ubicados en el directorio `/etc/puppetlabs/puppet/environments/production/modules`.
>
>**Nota**: PE también instala módulos en  `/opt/puppet/share/puppet/modules`, pero no modifiques ni agregues nada en este directorio.
>
>Existe una abundante cantidad de recursos sobre desarrollo de módulos que puedes utilizar como referencia. Refiere a [Módulos y Manifiestos](./puppet_modules_manifests.html), o la [Guía para Principiantes sobre Módulos](/guides/module_guides/bgtm.html), y el [Puppet Forge](https://forge.puppetlabs.com/).

 Los Módulos son simplemente estructuras de directorios. Para esta tarea, crearás los siguientes archivos:

 - `my_firewall` (the module name)
   - `manifests/`
     - `pre.pp`
     - `post.pp`
      - `init.pp`

**Escribir el modulo `my_firewall`**:

1. Desde la línea de comandos del Puppet Master, ve al directorio de modulos (`cd /etc/puppetlabs/puppet/modules`)
2. Ejecuta `mkdir -p my_fw/manifests` para crear el nuevo directorio del modulo y su directorio de manifiestos.
3. Desde el directorio `manifests`, utiliza un editor de texto para crear el archivo `pre.pp`.
4. Edita el archivo `pre.pp` de forma de que tenga el siguiente contenido:

       class my_firewall::pre {

         # Default firewall rules
         firewall { '000 accept all icmp':
           proto   => 'icmp',
           action  => 'accept',
         }

         firewall { '001 accept all to lo interface':
           proto   => 'all',
           iniface => 'lo',
           action  => 'accept',
         }

         firewall { '002 accept related established rules':
           proto   => 'all',
           state   => ['RELATED', 'ESTABLISHED'],
           action  => 'accept',
         }

         # Allow SSH
         firewall { '100 allow ssh access':
           port   => '22',
           proto  => tcp,
           action => accept,
         }

       }

5. Guarda el archivo y sal del editor de texto.
6. Desde el directorio `manifests` utiliza el edito de texto para crear el archivo `post.pp`.
7. Edita el archivo `post.pp` de forma de que tenga el siguiente contenido:

        class my_firewall::post {

          firewall { "999 drop all other requests":
            action => "drop",
          }

        }

8. Guarda el archivo y sal del editor de texto.
9. Desde el directorio `manifests`, utiliza el editor de texto para crear el archivo `init.pp`:
10. Edita el archivo `init.pp` de forma de que tenga el siguiente contenido:

         class my_firewall {

           stage { 'fw_pre':  before  => Stage['main']; }
           stage { 'fw_post': require => Stage['main']; }

           class { 'firewall':
             stage => 'fw_pre',
           }

           class { 'my_fw::pre':
             stage => 'fw_pre',
           }

           class { 'my_fw::post':
             stage => 'fw_post',
           }

          resources { "firewall":
             purge => true
          }

        }

11. Guarda el archivo y sal del editor de texto.

> Listo! Haz escrito un modulo que contiene una clase que, una vez aplicada, se asegura que el firewall tenga reglas que seran administradas por PE. Debes esperar un tiempo hasta que las clases se carguen, de forma de que esten disponibles para agregarlas a los nodos agente.
>
> Nota lo siguiente sobre tu nueva clase:
>
> * `pre.pp` define el grupo de reglas que se ejecutan al principio cuando se requiere acceso a un servicio.
> * `post.pp` definen las reglas que se ejecutan al final, para descartar paquetes cuyo acceso no se ha permitido de forma explicita en `pre.pp`.
> * `init.pp` aplica las dos clases previamente definidas, ademas de informarle a Puppet cuando aplicar las reglas en relación a las dos clases previas, asimismo le informa a Puppet cuando aplicar las clases en relación a la etapa principal `main` (que asegura que todas las clases se apliquen en el orden correcto).

## Crear el Grupo firewall_example

Los Grupos permiten asignar clases y variables a varios nodos a la vez. Los Nodos pueden pertenecer a múltiples grupos y heredan clases y variables de los mismos. Los Grupos, también pueden ser miembros de otros grupos y heredar la configuración desde su grupo padre de la misma manera que lo hacen los nodos. PE automáticamente crea varias grupos en la consola, puedes obtener mas información en la [documentación de PE](https://docs.puppetlabs.com/pe/latest/console_classes_groups_preconfigured_groups.html).

En este procedimiento, crearás un grupo simple, llamado __firewall_example__, que contendrá todos tus nodos. Dependiendo de las necesidades de la infraestructura, es posible que se necesite asignar la clase firewall a un grupo diferente.

[firewall_add_node]: ./images/quick/firewall_add_node.png

**Para crear el grupo firewall_example**:

1. Desde la consola, haz clic en __Classification__, en la barra de navegación.
2. En el campo __Node group name__, asígnale un nombre al grupo (por ej., **firewall_example**).
3. Haz clic en __Add group__.
4. Elije el grupo __firewall_example__.
5. Desde la pestaña __Rules__, en el campo __Node name__, ingresa el nombre del nodo administrado por PE para agregarlo al grupo.

   >**Advertencia**: Se recomienda no agregar al Puppet Master a este grupo. La clase firewall no contiene las reglas requeridas para permitir acceso al Puppet Master. Agregarás estas reglas mas tarde cuando escribas una clase para [abrir los puertos para el Puppet Master](#open-ports-for-the-puppet-master).

6. Haz clic __Pin node__.
7. Haz clic __Commit 1 change__.

   ![adding node to firewall group][firewall_add_node]

8. Repite los pasos 5-7 para cada nodo que desees agregar.

## Utilizando la consola de PE para agregar la clase `my_firewall`

[classbutton]: ./images/quick/add_class_button.png
[add_firewall]: ./images/quick/firewall_add_firewall.png
[assign_firewall_group]: ./images/quick/assign_my_fw_group.png

El módulo puppetlabs-firewall se instala automáticamente como parte de la instalación de PE en `/opt/puppet/share/puppet/modules` y se distribuye a los nodos cuando se agrega la clase `my_firewall`

**Para agregar la clase** `my_firewall` **al grupo firewall_example**:

1. Desde la consola, haz clic en __Classification__ en la barra de navegación superior.

   ![classification selection][classification_selector]

2. Desde la página de __Classification__, elije el grupo __firewall_example__.

3. Haz clic en la pestaña de __Classes__.

4. En el campo __Class name__, comienza a escribir `my_firewall`, y elije la opción de la lista de autocompleción.

   ![adding the firewall class][firewall_add_firewall]

   **Sugerencia**: Solo necesitas agregar la clase principal `my_firewall`; ya que contiene las otras clases presentes en el módulo.

5. Haz clic en __Add class__.

6. Haz clic en __Commit 1 change__.

   ![committing class change][firewall_commit_change]

   **Nota**: La clase `my_firewall` ahora aparace en la lista de clases para el grupo __firewall_example__, pero aún no ha sido configurada en los nodos, para que esto suceda de inmediato, deberás forzar la ejecución del agente de Puppet en los nodos.

7. En el nodo agente, ejecuta `puppet agent -t` para forzar la ejecución.

> Felicitaciones! Acabas de crear una clase firewall que puedes utilizar para definir y aplicar reglas de firewall en tu infraestructura administrada por PE.

## Abrir puertos para el Puppet Master

[master_run_report]: ./images/quick/master_log.png
[select_master_log]: ./images/quick/select_master_log.png

El Puppet Master, como cualquier otra aplicación en la infraestructura, requiere que cierta configuración especifica en el firewall para funcionar correctamente.

1. Desde la línea de comándos en el Puppet Master, ve al directorio donde están alojados los modulos (`cd /etc/puppetlabs/puppet/modules`).
2. Ejecuta `mkdir -p my_master/manifests` para crear un nuevo directorio para el módulo y su correspondiente directorio de manifiestos.
3. Desde el directorio `manifests`, utiliza un editor de texto para crear el archivo `init.pp`.
4. Edita el archivo `init.pp` de forma de que contenga el siguiente código de Puppet:

       class my_master {
         include my_firewall

         firewall { '100 allow PE Console access':
           port   => '443',
           proto  => tcp,
           action => accept,
         }

         firewall { '100 allow Puppet master access':
           port   => '8140',
           proto  => tcp,
           action => accept,
         }

         firewall { '100 allow ActiveMQ MCollective access':
           port   => '61613',
           proto  => tcp,
           action => accept,
         }

       }

5. Utilizando la consola, agrega la clase `my_master` al Puppet Master.
6. Agrega el Puppet master al grupo __firewall_example__.
7. En la línea de comandos del Puppet Master, ejecuta `puppet agent -t` para forzar la ejecución.
8. Una vez finalizada la ejecución del agente, en la consola, ve a la página del nodo en donde se aloja el Puppet Master, y elije el último reporte.

   ![selecting the latest run report][select_master_log]

9. Elije la pestaña __Events__.

   Encontraras tres eventos en este nodo, indicando que el firewall permite acceso a MCollective, la consola de PE, y el Puppet master.

   >**Sugerencia**: Para obtener información relacionada a reglas de firewall requeridas para la instalación de PE, revisa la documentación sobre [requisitos del sistema](./install_system_requirements.html#firewall-configuration).

   ![viewing the latest run report][master_run_report]

> A continuación, veamos como actúa PE cuando existen diferencias en la configuración, asegurando el estado deseado de la clase `my_firewall`.

## Asegurando el Estado Deseado de la Clase `my_firewall`

Finalmente, veamos como PE asegura el estado deseado de la clase `my_firewall` en los nodos agente. En la tarea previa, se aplico una clase firewall. Ahora imagina un eschenario en el que un miembro de tu equipo cambia el contenido de `iptables` para permitir las conecciones a un puerto al azar que no esta especificado en `my_firewall`.

1. Elije un nodo agente en el que este la clase `my_firewall` aplicada, y ejecuta `iptables --list`.
2. Nota que las reglas de la clase `my_firewall` están aplicadas.
3. Desde la línea de comandos, inserta una nueve regla para permitir conexiones al puerto **8449**, y luego ejecuta `iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8449 -j ACCEPT`.
4. Ejecuta `iptables --list` nuevamente y nota que esta nueva regla ahora esta listada.
6. Desde el nodo agente, ejecuta `puppet agent -t`
7. Ejecuta `iptables --list` en el nodo una vez mas, y nota que PE ha asegurado el estado deseado que fue especificado previamente para las reglas de firewall.

> Listo---PE ha asegurado el estado deseado de tu nodo agente!

## Otros recursos

El módulo de firewall de Puppet Labs (`puppetlabs-firewall`), es parte del programa [modulos soportados](http://forge.puppetlabs.com/supported) por PE; que incluye modulos soportados, probados y mantenidos por Puppet Labs. Puedes obtener mas información sobre el modulo de Firewall de Puppet Labs visitando el [Puppet Forge](http://forge.puppetlabs.com/puppetlabs/firewall).

Revisa otras guías de inicio rápido en la serie de GIR de PE:

- [Guía de inicio rápido sobre NTP](./quick_start_ntp.html)
- [Guía de inicio rápido sobre SSH](./quick_start_ssh.html)
- [Guía de inicio rápido sobre DNS](./quick_start_dns.html)
- [Guía de inicio rápido sobre Sudo](./quick_start_firewall.html)

Puppet Labs tiene una amplia oferta de herramientas para aprendizaje, desde certificaciones y cursos formales a lecciones online. Sigue los vinculos debajo, o ve a [las páginas de aprendizaje de Puppet (en inglés)](https://puppetlabs.com/learn)

* [Aprendiendo Puppet](http://docs.puppetlabs.com/learning/) es una serie de ejercicios sobre varios temas esenciales relacionados al uso y el despliegue de PE.
* Los seminarios de Puppet Labs contienen lecciones que puedes seguir a tu propio paso sobre una variedad de temas. Puedes crear una cuenta para acceder a los contenidos en [las páginas de aprendizaje de Puppet (en inglés)](https://puppetlabs.com/learn).
