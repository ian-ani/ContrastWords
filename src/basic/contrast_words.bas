#include once "contrast_words.bi"

'' Constantes
Const kSCORE = 200

'' Variables globales
Dim Shared score As Integer = 0
Dim Shared streak As Integer = 0

'' Cabeceras
Declare Sub MainMenu
Declare Sub ReadPlayerChoice
Declare Sub ShowHowToPlay
Declare Sub ShowScore
Declare Sub MainLoop
Declare Sub InitGame
Declare Function CheckAntonym(ByVal key As ZString Ptr, ByVal player As String) As Boolean

'' Funciones
Sub MainMenu
    Print "============================"
    Print "Welcome to Contrast Words!"
    Print "============================"

    Print "[1] HOW TO PLAY"
    Print "[2] PLAY"
    Print "[3] SHOW HIGHEST SCORE AND STREAK"
    Print "[4] EXIT"
End Sub

Sub ReadPlayerChoice
    '' Esta variable no sirve para nada
    Dim tmp As String

    '' Eleccion del usuario
    Dim choice As Integer

    Do
        Cls
        MainMenu
        Input "Choose an option: ", choice

        Select Case choice
        Case 1
            ShowHowToPlay
            Print ""
            Input "Press any key... ", tmp
        Case 2
            MainLoop
        Case 3
            ShowScore
            Print ""
            Input "Press any key... ", tmp
        Case 4
            free_json
            Print "Goodbye! :)"
        Case Else
            Print "Not a valid option."
        End Select
    Loop While choice <> 4
End Sub

Sub ShowHowToPlay
    Cls
    Print "============="
    Print "HOW TO PLAY"
    Print "============="

    Print "Words will be displayed, and you must say at least one antonym for each one."
    Print "Don't lose your streak!"
End Sub

Sub ShowScore
    Cls
    Print "Current streak: "; streak
    Print "Current score: "; score
End Sub

Function CheckAntonym(ByVal key As ZString Ptr, ByVal player As String) As Boolean
    '' Guarda si se ha encontrado o no, de base no
    Dim found As Boolean = False

    '' Array de strings
    Dim values As ZString Ptr Ptr

    '' Variable para guardar el tamano del array de valores
    Dim length As Integer

    '' Obtener todos los valores de una clave
    values = get_values(key, length)

    ''Bucle que itera sobre los valores de una clave y comprueba si el del usuario coincide con alguno
    For i As Integer = 0 To length - 1 Step 1
        If LCase(*values[i]) = LCase(player) Then
            found = True
        End If

        '' Liberar memoria
        Deallocate(values[i])
    Next i

    '' Liberar memoria
    Deallocate(values)

    Return found
End Function

Sub MainLoop
    '' Variables del bucle
    Dim found As Boolean
    Dim tries_left As Integer = 3

    '' Variables referentes a los valores
    Dim key As ZString Ptr
    Dim player_antonym As String

    '' Obtener una clave aleatoria a adivinar
    key = get_random_key

    Do
        '' Limpiar pantalla
        Cls

        '' Mostrar la clave al usuario
        Print "The word is:", UCase(*key)
        Print "----------------------"
        Print "Tries left: ", tries_left

        '' Pedir al usuario que escriba un antonimo
        Input "Write an antonym: ", player_antonym

        ''Asignar valor de retorno
        found = CheckAntonym(key, player_antonym)

        '' Comprobar si el usuario ha escrito un antonimo correcto
        If found Then
            score += kSCORE * tries_left
            streak += 1
            Print "Found!"
            Sleep 2000
        ElseIf tries_left > 1 Then
            tries_left -= 1
            Print "Wrong! Try again..."
            Sleep 1000
        ElseIf tries_left = 1 Then
            tries_left -= 1
        End If
    Loop While tries_left > 0 And Not found

    '' Reinicio de propiedades
    If Not found Then
        Cls
        Print "GAME OVER"
        Sleep 2000
        score = 0
        streak = 0
    End If
End Sub

Sub InitGame
    init_json()
    ''Cls
    ''MainMenu
    ReadPlayerChoice
End Sub

'' Inicia el juego
InitGame

'' NOTA: mostrar tambien el hiscore, no solo el current
'' NOTA: refactorizar un poco algunos bloques que se repiten
'' NOTA: ver si puedo guardar en archivo
'' NOTA: ver si puedo anadir un diccionario en castellano