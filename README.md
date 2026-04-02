[![Lang en](https://img.shields.io/badge/lang-en-blue?style=flat)](https://github.com/ian-ani/ContrastWords/blob/main/README.md)
[![Lang es](https://img.shields.io/badge/lang-es-red?style=flat)](https://github.com/ian-ani/ContrastWords/blob/main/README.es.md)

# Contrast Words

Command-line game made for the [Jam for All BASIC Dialects (#7)](https://itch.io/jam/jam-for-all-basic-dialects-7).  
Developed using **FreeBASIC** and **C**.

## About the game

A random word will appear, you must write at least one antonym. Try to keep your streak!

## Table of contents

- [Development and resources](#Development-and-resources)
- [How to play](#How-to-play)
- [Requirements](#Requirements)
- [Tested on](#Tested-on)
- [Known issues ❗❗❗](#Known-issues)

## Development and resources

- [FreeBASIC](https://freebasic.net)
- [C](https://www.mingw-w64.org)
- [cJSON](https://github.com/davegamble/cjson)
- [Python for dataset formatting (Jupyter Notebook)](https://jupyter.org)
- [Antonyms dataset](https://www.kaggle.com/datasets/duketemon/antonyms-wordnet)
- [Aseprite](https://www.aseprite.org)
- [Image to ASCII](https://www.asciiart.eu)

## How to play

1. Download the game from [itch.io](https://ianani.itch.io/contrast-words).
2. Double-click or run the game from the **command line** or **PowerShell**.

```PowerShell
./contrast_words
```

### Example

```PowerShell
The word is:  ANALYSIS
----------------------
Tries left:    3
Write an antonym: synthesis
```

## Requirements

- Windows x64

## Tested on

- Windows 10, worked on (2/2) computers.
- Windows 11, worked on (1/2) computers.
- Windows XP (32-bit) - not supported.

Works on both **cmd** and **PowerShell**.

## Known issues

Some Windows 11 systems may display corrupted text such as *"Choose an option: STREAK===ds!"* or have issues printing ASCII images. I'm investigating it.
