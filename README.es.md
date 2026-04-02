[![Lang en](https://img.shields.io/badge/lang-en-blue?style=flat)](https://github.com/ian-ani/ContrastWords/blob/main/README.md)
[![Lang es](https://img.shields.io/badge/lang-es-red?style=flat)](https://github.com/ian-ani/ContrastWords/blob/main/README.es.md)

# Contrast Words

Juego de línea de comandos para la [Jam for All BASIC Dialects (#7)](https://itch.io/jam/jam-for-all-basic-dialects-7).  
Desarrollado con **FreeBASIC** y **C**.

## Sobre el juego

Una palabra aleatoria aparecerá en pantalla, debes escribir al menos un antónimo de ésta. ¡Intenta no perder tu racha!  
**Juego solo en inglés.** ❗❗❗

## Tabla de contenidos

- [Desarrollo y recursos](#Desarrollo-y-recursos)
- [Cómo jugar](#Cómo-jugar)
- [Requisitos](#Requisitos)
- [Probado en](#Probado-en)
- [Problemas conocidos ❗❗❗](#Problemas-conocidos)
- [Notas adicionales](#Notas-adicionales)

## Desarrollo y recursos

- [FreeBASIC](https://freebasic.net)
- [C](https://www.mingw-w64.org)
- [cJSON](https://github.com/davegamble/cjson)
- [Python para el formato del dataset (Jupyter Notebook)](https://jupyter.org)
- [Dataset de antónimos](https://www.kaggle.com/datasets/duketemon/antonyms-wordnet)
- [Aseprite](https://www.aseprite.org)
- [Imagen a ASCII](https://www.asciiart.eu)

## Cómo jugar

1. Descarga el juego desde [itch.io](https://ianani.itch.io/contrast-words).
2. Haz doble clic o arranca el juego desde la **línea de comandos** o desde **PowerShell**.

```PowerShell
./contrast_words
```

### Ejemplo

```PowerShell
The word is:  ANALYSIS
----------------------
Tries left:    3
Write an antonym: synthesis
```

## Requisitos

- Windows x64

## Probado en

- Windows 10, funcionó en (2/2) ordenadores.
- Windows 11, funcionó en (1/2) ordenadores.
- Windows XP (32-bit) - sin soporte.

Funciona tanto en **cmd** como en **PowerShell**.

## Problemas conocidos

Puede que algunos sistemas Windows 11 muestren texto corrupto como *"Choose an option: STREAK===ds!"* o tengan problemas para pintar apropiadamente las imágenes ASCII. Estoy investigándolo.

## Notas adicionales

Al compilar, necesitarás los archivos de cJSON (ver [Desarrollo y recursos](#Desarrollo-y-recursos)). Además, la estructura del proyecto está un poco regular, así que cada vez que se vaya a compilar el código de C, se necesitará mover cualquier archivo .a generado en el directorio de Basic. Lo mismo se aplica con cualquier .exe resultante y los archivos ASCII.

Compilación de C:

```bash
# Situarse en la carpeta de C
cd src/c

# Crear archivo .o
gcc -c antonyms_utils.c -o antonyms_utils.o
gcc -c ../../libs/cJSON.c -o ../../libs/cJSON.o

# Crear archivo .a
ar r libantonyms_utils.a antonyms_utils.o ../../libs/cJSON.o
```

Compilación de Basic:

```powershell
# Situarse en la carpeta de Basic
cd src/basic

# Crear .exe
fbc64 contrast_words.bas
```
