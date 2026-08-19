# Fundamentos de MongoDB

## ¿Qué es una base de datos no relacional y qué es MongoDB? 

Una base de datos no relacional es un tipo de base de datos que no utiliza necesariamente tablas relacionadas entre sí para organizar la información. En lugar de trabajar únicamente con filas y columnas, puede utilizar diferentes estructuras para almacenar los datos, dependiendo de las necesidades del sistema.

MongoDB es un sistema de base de datos no relacional orientado a documentos. Su información se almacena principalmente en documentos con una estructura similar a JSON. Esto permite trabajar con información de una forma más flexible que en una base de datos relacional.

## ¿Qué son una colección, un documento y un campo?

Una colección es un conjunto de documentos relacionados entre sí. Puede compararse de manera general con una tabla de una base de datos relacional, aunque su funcionamiento es diferente.

Un documento es un registro almacenado dentro de una colección. Contiene la información de un elemento y puede tener diferentes tipos de datos.

Un campo es una propiedad dentro de un documento. Por ejemplo, un documento puede tener campos como nombre, edad, correo, teléfono o fecha.

## ¿Cuáles son las diferencias principales entre una tabla relacional y una colección de documentos? 

En una base de datos relacional, la información se organiza mediante tablas. Cada tabla tiene columnas definidas y los registros siguen una estructura establecida. También es común utilizar llaves primarias y llaves foráneas para establecer relaciones entre diferentes tablas.

En MongoDB, la información se organiza mediante colecciones y documentos. Los documentos de una misma colección pueden tener estructuras diferentes, por lo que existe mayor flexibilidad al momento de almacenar información.

Otra diferencia importante es la forma de manejar las relaciones. En una base de datos relacional las relaciones entre tablas son una parte fundamental del diseño y se pueden realizar consultas utilizando JOIN. En MongoDB se puede guardar información relacionada dentro de un mismo documento o manejar referencias entre documentos, dependiendo de la necesidad del sistema.

## ¿Cuáles son dos ventajas y dos limitaciones de MongoDB? 

## Dos ventajas de MongoDB

Una de sus principales ventajas es la flexibilidad de su estructura. Es posible agregar nuevos campos a los documentos sin tener que modificar una estructura fija de tablas.

Otra ventaja es que puede adaptarse bien a información que cambia con frecuencia o que puede tener diferentes estructuras entre un registro y otro.

## Dos limitaciones de MongoDB

Una limitación es que cuando un sistema depende de muchas relaciones entre diferentes datos, una base de datos relacional puede ser más conveniente para mantener esas relaciones de forma estructurada.

Otra limitación es que la flexibilidad puede provocar diferencias entre los documentos si no se establecen reglas adecuadas para controlar la información almacenada.

## ¿En qué situaciones conviene utilizar PostgreSQL y en cuáles podría convenir MongoDB?

PostgreSQL puede ser una buena opción cuando los datos tienen una estructura definida, cuando existen muchas relaciones entre ellos y cuando es importante mantener reglas de integridad y consistencia.

MongoDB puede ser conveniente cuando los datos necesitan una estructura más flexible, cuando los registros pueden cambiar con frecuencia o cuando se necesita almacenar información que no siempre tiene los mismos campos.

La elección depende de las características del sistema y de la forma en que se necesita manejar la información.

## Dentro del caso elegido, ¿qué información podría almacenarse en MongoDB y por qué? 

En el caso específico de este proyecto, MongoDB podría utilizarse como complemento de PostgreSQL para almacenar información más flexible relacionada con el gimnasio.

Por ejemplo, se podrían guardar bitácoras de eventos, observaciones de las clases, registros adicionales de acceso o información generada durante las actividades del gimnasio.

PostgreSQL seguiría siendo la base principal para almacenar la información estructurada del proyecto, como atletas, instructores, clases, membresías y asistencias.

## Mostrar un ejemplo sencillo de cómo se vería un registro del proyecto como documento JSON. 

Un ejemplo sencillo de cómo podría almacenarse información relacionada con un atleta en MongoDB sería:

```json id="76491"
{
  "id_atleta": 1,
  "nombre": "Luis Garcia",
  "alias": "Shadow",
  "evento": {
    "tipo": "asistencia",
    "clase": "Parkour Kids",
    "fecha": "2026-08-10",
    "hora_entrada": "16:05:00"
  },
  "observaciones": "Ingreso registrado correctamente"
}
```

Este documento representa un ejemplo aplicado al proyecto del gimnasio. La información relacionada con el atleta podría mantenerse junto con datos adicionales del evento, sin necesidad de utilizar varias tablas para ese registro específico.

## Conclusión

Las bases de datos relacionales y no relacionales tienen diferentes características y pueden utilizarse dependiendo de las necesidades del sistema.

PostgreSQL es adecuado cuando se requiere una estructura definida, relaciones entre datos e integridad referencial. MongoDB puede ser una buena alternativa cuando se necesita una estructura más flexible y documentos que puedan adaptarse a diferentes tipos de información.

En el proyecto desarrollado, PostgreSQL se utiliza como la base principal porque permite mantener de forma organizada las relaciones entre los elementos del gimnasio. MongoDB podría utilizarse como complemento para información más flexible, como eventos, bitácoras u observaciones.
