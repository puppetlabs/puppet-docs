---
layout: default
title: "PE 3.8 » Inicio Rápido » Introducción para usuarios *Nix"
subtitle: "Guías de inicio rápido para Puppet Enterprise: 3.8.0"
canonical: "/es/pe/latest/quick_start.html"
---

Bienvenido a la Guía de Inicio Rápido para Puppet Enterprise. Ya sea que estes configurando PE para un despliegue en producción o que desees aprended algunos conceptos fundamentales sobre manejo de confifuración con Puppet Enterprise, esta serie de guías te proveeran la información necesaria para ponerte en marcha. Te guiaremos a través de la configuración de un despliegue monolítico (todo en un nodo) y te demostraremos como automatizar algunas de las tareas básicas que los administradores de sistemas performan regularmente.

Las siguientes guías presentan las tareas en el orden el cual probablemente las realizarías. Por favor, revisa la seccion de prerequisitos de cada guía para asegurarte que tu entorno esta configurado como se espera para realizar los pasos como estan definidos:

### 1. Instalar un despliegue Monolítico de Puppet Enterprise
Sigue las siguientes [instrucciones](./quick_start_install_mono.html) para instalar de forma rápida un un despliegue de PE en un equipo con Linux. El mismo incluye un Puppet Master, la consola de PE, y PuppetDB en un único nodo. Nota que debes revisar algunos de los prerequisitos antes de proseguir con la guía.

### 2. Instalar el Agente de Puppet
Sigue las siguientes instrucciones para instalar de forma rápida un Agente de Puppet. Un equipo corriendo el agente de Puppet es usualmente conocido como un "nodo agente". El agente de Puppet se conecta regularmente con un Puppet Master para obtener un catálogo de configuración para ser aplicado en el sistema local.

Hay instrucciones disponibles para usuarios de [Windows](./quick_start_install_agents_windows.html) y [*nix](./quick_start_install_agents_nix.html). Estas instrucciones incluyen los pasos para firmar el certificado de cada agente en la consola.

### 3. Hola, Mundo!
Las instrucciones en [esta guía](./quick_start_helloworld.html) describen los pasos fundamentales requeridos para escribir módulos de Puppet. Su objetivo es crear un módulo muy simple que contenga las clases para administrar tu MOTD (message of the day, o mensaje del día) y crear una notificación de "Hola, Mundo!" en la linea de comandos.

### 4. Instalar un Módulo
Sigue las siguientes instrucciones para instalar un módulo de Puppet Labs. Los módulos contienen [clases](/puppet/3.8/reference/lang_classes.html), que son las unidades mínimas de código de Puppet mediante las cuales Puppet Enterprise configura y administra nodos.


### 5. Añadir clases desde la consola
Sigue las siguientes instrucciones para añadir una clase a tu agente de Puppet de forma rápida. La clase que instalarás esta derivada del módulo que instalaste en la GIR sobre instalación de módulos.

Hay instrucciones disponibles para usuarios de [Windows](./quick_start_adding_class_windows.html) y [*nix](./quick_start_adding_class_nix.html).

### 6. Clasificando nodos y Administrando usuarios.
Estas instrucciones te introducen al concepto de clasificación de nodos y control de acceso basado en roles (RBAC). Deberás crear un nuevo grupo de nodos y agregar nodos al mismo. Asimisimo, agregarás clases a un nodo, un proceso también conocido como clasificar un nodo. Luego crearás un nuevo rol de usuario, y permitirás a ese rol el control del grupo de nodos que creaste previamente.

Refiere a [esta guía](./quick_start_nc_rbac.html) para más información.

### 7. Guía de Inicio Rápido sobre Desarrollo de Módulos
Sigue las instrucciones de esta guía para escribir módulos para familiarizarte con los módulos de Puppet y el desarrollo de módulos.

Hay instrucciones disponibles para usuarios de [Windows](./quick_writing_windows.html) y [*nix](./quick_writing_nix.html).



