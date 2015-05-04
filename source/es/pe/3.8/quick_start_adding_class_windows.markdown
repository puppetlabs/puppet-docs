---
layout: default
title: "PE 3.8 » Inicio Rápido » Clasificando Agentes (Windows)"
subtitle: "Guía de Inicio Rápido sobre Agregar Clases"
canonical: "/es/pe/latest/quick_start_adding_class_windows.html"
---

### Resúmen

[classification_selector]: ./images/quick/classification_selector.png
[windows_add_group]: ./images/quick/windows_add_group.png

Cada módulo contiene una o más **clases**. Las [clases](/puppet/3.8/reference/lang_classes.html) son la unidad mínima de código de Puppet que usa Puppet Enterprise para configurar nodos. El módulo de Registro que instalaste previamente en la [GIR sobre Instalación de Módulos](./quick_start_module_install_windows.html) contiene una clase llamada `registry`. En este ejemplo, utilizarás la clase `registry` para proveer los tipos y proveedores necesarios para crear y administrar claves y valones del Registro de Windows con Puppet.

En este ejemplo crearás un grupo llamado __ejemplo_windows_ y agregarás la clase `registry` a este grupo.

>**Prerequisitos**: Esta guía asume que ya existe en funcionamiento un [entorno de PE monolítico](./quick_start_install_mono.html), al menos un [nodo agente Windows](./quick_start_install_agents_windows.html) y el módulo [puppetlabs-registry](./quick_start_module_install_windows.html).

>**Nota**: El proceso para agregar clases a nodos agente en la consola es el mismo tanto en sistemas operativos Windows como *nix.

### Creando el Grupo ejemplo_windows

**Para crear el grupo ejemplo_windows**:

1. Desde la consola, haz clic en __Classification__ en la barra de navegación.
2. En el campo __Node group name__, asígnale un nombre a tu grupo (ej., **ejemplo_windows**).
3. Haz clic __Add group__.
4. Haz clic en el grupo __ejemplo_windows__.
5. Desde la pestaña __Rules__, en el campo __Node name__, ingresa el nombre del nodo administrado por PE que deseas agregar al grupo.
6. Haz clic en __Pin node__.
7. Haz clic en __Commit 1 change__.

   ![adding node to windows group][windows_add_group]

8. Repite los pasos 5-7 para cualquier nodo adicional que desees agregar.



### Añadiendo la clase `registry` al Grupo Ejemplo

**Para agregar la clase** `registry` **al grupo ejemplo**:

1. Desde la consola, haz clic en __Classification__ en la barra de navegación.

   ![classification selection][classification_selector]

2. Desde __la página de Classification__, elige el grupo __windows_example__.

3. Haz clic en la pestaña __Classes__.

4. En el campo __Class name__, comienza a escribir `registry`, y haz clic sobre la opción cuando aparezca en la lista de auto-compleción.

5. Haz clic en __Add class__.

6. Haz clic __Commit 1 change__.

   Nota que la clase `registry` ahora aparece entre las clases de tu nodo agente.
7. En el nodo agente, ve a `Inicio`, `Todos los programas`, `Puppet Enterprise`, `Run Puppet Enterprise`. Aguarda uno o dos minutos.

-------

Siguiente: [Inicio Rápido: Clasificando Nodos y Asignando Permisos a Usuarios](./quick_start_nc_rbac.html)

