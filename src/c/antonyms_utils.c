#include "antonyms_utils.h"
#include "../../libs/cJSON.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// Constante con el nombre del archivo de antonimos
const char kANTONYMS[] = "antonyms_formatted.json";

// Variable global que contiene todo el JSON para todo el archivo
static cJSON *json_file = NULL;

// Inicializar y guardar el JSON en la variable global
void init_json(void) {
    // Abrir archivo
    FILE *fp = open_file(kANTONYMS);

    // Leer archivo
    char *buffer = read_file(fp);

    // Parsear JSON y guardar en variable global
    json_file = parse_json(buffer);

    // Liberar buffer
    free(buffer);
}

// Cerrar json
void free_json(void) {
    if (json_file) {
        // Liberar puntero del JSON
        cJSON_Delete(json_file);

        // Volver a poner a nulo
        json_file = NULL;
    }
}

// Abre el archivo
FILE *open_file(const char *filename) {
    // Abrir archivo en modo lectura
    FILE *fp = fopen(filename, "r");

    // Si el archivo es nulo (no lo encuentra o lo que sea)
    if (fp == NULL) {
        printf("Error: Unable to open the file.\n");
    }

    return fp;
}

// Obtiene tamano del archivo
int file_size(FILE *input_file) {
    // Declarar tamano
    int size;

    // Buscar hasta el final de archivo
    fseek(input_file, 0, SEEK_END);

    // Devuelve tamano en bytes
    size = ftell(input_file);

    // 'Vuelve atras' al principio del archivo
    fseek(input_file, 0, SEEK_SET);

    return size;
}

// Lee archivo
char *read_file(FILE *input_file) {
    // Obtener tamano del archivo
    int len = file_size(input_file);

    // Reservar memoria
    char *buffer = malloc(len + 1);

    // Leer archivo
    fread(buffer, 1, len, input_file);

    // Coloca un caracter nulo al final (terminador)
    buffer[len] = '\0';

    // Cierra el archivo
    fclose(input_file);

    return buffer;
}

// Parsea archivo
cJSON *parse_json(char *buffer) {
    cJSON *json = cJSON_Parse(buffer);

    // Si fallara por alguna razon
    if (json == NULL) {
        const char *error_ptr = cJSON_GetErrorPtr();

        if (error_ptr != NULL) {
            printf("Error: %s\n", error_ptr);
        }

        // Liberar puntero
        cJSON_Delete(json);
    }

    return json;
}

// Cuenta el numero de claves existentes en el archivo
int get_number_keys(void) {
    // Apunta al primer elemento del JSON
    cJSON *child = json_file->child;

    // Contar numero de claves que contiene todo el JSON
    int total_keys = 0;

    // Mientras no sea NULL
    while (child) {
        // El nuevo hijo es el proximo elemento
        child = child->next;

        // Incrementar numero de claves
        total_keys++;
    }

    return total_keys;
}

// Obtiene una clave aleatoria para que el usuario diga un antonimo de esta
char *get_random_key(void) {
    // Generar semilla
    srand(time(NULL));

    // Obtener un indice
    int index = rand() % get_number_keys();

    // Apunta al primer elemento del JSON
    cJSON *child = json_file->child;

    // Variable de cuenta
    int i = 0;

    // Mientras no sea NULL
    while (child) {
        // Comprobar clave que coincida
        if (i == index) {
            return child->string;
        }

        // El nuevo hijo es el proximo elemento
        child = child->next;

        // Incrementar numero de claves
        i++;
    }

    // Si no encuentra ninguna clave (esto seria raro), devolver nulo
    return NULL;
}

// Obtiene valores del diccionario en base a su clave
char **get_values(char *word, int *count) {
    // Inicializar variable de cuenta a 0, es para que Basic sea capaz de 
    // saber cuantos elementos tiene el array de valores y recorrerlo
    *count = 0;

    // Clave a buscar
    cJSON *key = cJSON_GetObjectItemCaseSensitive(json_file, word);

    // Numero de valores de la clave
    int n = cJSON_GetArraySize(key);

    // Array donde guardar los valores
    char **values = malloc(sizeof(char*) * n);

    // Comprobar si es un Array
    if (key && cJSON_IsArray(key)) {
        // Inicializar puntero a nulo
        cJSON *item = NULL;

        // Recorrer JSON
        cJSON_ArrayForEach(item, key) {
            // Mostrar valores
            if (cJSON_IsString(item) && (item->valuestring != NULL)) {
                // Guardar valores en el array
                values[*count] = strdup(item->valuestring);
                //printf("%s\n", item->valuestring);

                // Incrementar indice
                (*count)++;
            }
        }
    }

    // TODO: Liberar array de valores desde Basic!!
    //free(values);

    return values;
}
