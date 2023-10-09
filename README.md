# NFC Health

Proyecto de NFC, Blockchain enfocado a la eficaz identificación de pacientes en centros hospitalariosa

## Prerrequisitos

### Dependencias

- `Node.JS`
- `Npm`
- `Flutter/Dart`
- `Truffle`
- `Ganache UI Truffle`
- `Java`

### Instalación de Flutter

La instalación es sencilla y bien explicada en el sitio oficial de [Flutter](https://esflutter.dev/docs/get-started/install)

### Instalacion de Truffle

Para una instalación global de Truffle usamos:

> `npm install -g truffle`

### Instalación de Ganache

Es recomendada la version "2.5.4". El link del release oficial de [Ganache](https://github.com/trufflesuite/ganache-ui/releases/tag/v2.5.4)

## Instalacion y configuración

Antes de instalar las dependencias propias de Flutter y Node es necesario editar el fichero `truffle-config.js`
```js
development: {
    host: "(Your Ganache IP)",
    port: 7545,
    network_id: '*',
}
```

Una vez configurado la IP de Ganache se procede a ejecutar el comando para la instalación de dependencias del proyecto mismo:

`npm run initAll`

Este está especificado en el fichero `package.json`:

``` json
"scripts": {
    ...,
    "initAll": "npm i && truffle compile && truffle migrate && flutter pub get"
  }
```

Esto instalará los paquetes, compilará los contratos inteligentes y permitirá la instalación de paquetes de Flutter.

### Ejecutar el proyecto

Se procede a tener ejecutado el programa `Ganache` y se procede a conectar un emulador o un dispositivo permitido por Flutter a la maquina. 

Ejecutamos `flutter run` y esperamos el proceso de build.