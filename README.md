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

`npm install -g truffle`

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
    "otherScripts": "...",
    "initAll": "npm i && truffle compile && truffle migrate && flutter pub get"
  }
```

Esto instalará los paquetes, compilará los contratos inteligentes y permitirá la instalación de paquetes de Flutter.

### Ejecutar el proyecto

Se procede a tener ejecutado el programa `Ganache` y se procede a conectar un emulador o un dispositivo permitido por Flutter a la maquina. 

Ejecutamos `flutter run` y esperamos el proceso de build.

## Contacto

- Sebastián Ricardo: sricardocardenas26@correo.unicordoba.edu.co
- Fabián Sánchez: fsanchezruiz99@correo.unicordoba.edu.co

## Licencia

MIT License

Copyright (c) 2023. Sebastián Ricardo, Fabián Sánchez

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
