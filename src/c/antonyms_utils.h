#ifndef ANTONYMS_UTILS_H
#define ANTONYMS_UTILS_H

#include "cJSON.h"
#include <stdio.h>
#include <string.h>

// Inicializar y guardar el JSON en la variable global
void init_json(const char *filename);

// Cerrar json
void free_json();

// Abre el archivo
FILE *open_file(const char *filename);

// Obtiene tamano del archivo
int file_size(FILE *input_file);

// Lee archivo
char *read_file(FILE *input_file);

// Parsea archivo
cJSON *parse_json(char *buffer);

// Cuenta el numero de claves existentes en el archivo
int get_number_keys();

// Obtiene una clave aleatoria para que el usuario diga un antonimo de esta
char *get_random_key();

// Obtiene valores del diccionario en base a su clave
char **get_values(char *word, int *count);

#endif