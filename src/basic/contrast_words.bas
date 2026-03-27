#include once "contrast_words.bi"

'' Constantes
Const kSCORE = 200
Const kWAIT = 2000
Const kMAX_TRIES = 3
Const kMIN_TRIES = 0

'' Variables globales de juego
Const save_game As String = "save_game.txt"
Const wizard_img As String = "wizard.txt"
Const goodbye_img As String = "goodbye.txt"
Const howto_img As String = "howto.txt"
Const gameover_img As String = "gameover.txt"
Const play_img As String = "play.txt"

'' Variables globales de jugadores (maximas)
Dim Shared hiscore As Integer = 0
Dim Shared histreak As Integer = 0
Dim Shared hiusername As String

'' Variables globales de jugadores (actuales)
Dim Shared score As Integer = 0
Dim Shared streak As Integer = 0
Dim Shared username As String

'' Cabeceras
Declare Sub MainMenu
Declare Sub ReadPlayerChoice
Declare Sub ExecPlayerChoice(ByVal choice As Integer)
Declare Sub ShowHowToPlay
Declare Sub ShowScore
Declare Function CheckAntonym(ByVal key As ZString Ptr, ByVal player As String) As Boolean
Declare Sub ReadScore
Declare Sub WriteScore
Declare Sub PrintImage(ByVal img As String)
Declare Sub UpdateScore(ByVal tries_left As Integer)
Declare Sub RestartScore
Declare Sub RestartPlayer
Declare Sub MainLoop
Declare Sub InitGame

'' Funciones
Sub MainMenu
    '' Substring con primera en mayus y el resto con cualquier case
    Dim str_username As String = UCase(Mid(username, 1, 1)) & Mid(username, 2)

    '' Mostrar imagen del mago
    PrintImage(wizard_img)

    '' Titulo
    Print "============================"
    Print str_username & ", welcome to Contrast Words!"
    Print "============================"

    '' Opciones
    Print "[1] HOW TO PLAY"
    Print "[2] PLAY"
    Print "[3] SHOW SCORE AND STREAK"
    Print "[4] EXIT"
End Sub

Sub ReadPlayerChoice
    '' Eleccion del usuario
    Dim choice As Integer

    Do
        '' Limpiar pantalla
        Shell "cls"

        '' Mostrar menu principal
        MainMenu

        '' Leer eleccion del usuario
        Input "Choose an option: ", choice

        '' Ejecutar opciones
        ExecPlayerChoice(choice)
    Loop While choice <> 4

    WriteScore
End Sub

Sub ExecPlayerChoice(ByVal choice As Integer)
    '' Esta variable solo sirve para consumir una tecla y no hacer nada con ella
    Dim tmp As String

    Select Case choice
    Case 1
        ShowHowToPlay
        ''Print ""
        Input "Press any key... ", tmp
    Case 2
        MainLoop
    Case 3
        ShowScore
        ''Print ""
        Input "Press any key... ", tmp
    Case 4
        free_json
        Shell "cls"
        PrintImage(goodbye_img)
        Sleep kWAIT * 2
    Case Else
        Print "Not a valid option."
        Sleep kWAIT
    End Select
End Sub

Sub ShowHowToPlay
    Shell "cls"
    PrintImage(howto_img)
End Sub

Sub ShowScore
    Shell "cls"
    Print "Username: "; UCase(hiusername)
    Print "Highest streak: "; histreak
    Print "High score: "; hiscore
    Print "-----------------------------"
    Print "Current username: "; UCase(username)
    Print "Current streak: "; streak
    Print "Current score: "; score
End Sub

Sub ReadScore
    '' Numero de archivo disponible, evita conflictos con otros archivos abiertos
    Dim F As Integer
    F = FreeFile()

    '' Linea
    Dim a_line As String
    Dim lines() As String
    Dim length As Integer = 0

    '' Abrir archivo y guardar linea en 'lines'
    Open save_game For Input As #F
        While Not Eof(F)
            '' Leer linea
            Line Input #F, a_line

            '' Incrementar el largo
            length += 1

            '' Redimensionar array
            ReDim Preserve lines(length - 1)

            '' Guardar linea en la ultima posicion del array
            lines(length - 1) = a_line
        Wend
    Close #F

    '' Valores obtenidos
    hiusername = lines(0)
    hiscore = Val(lines(1))
    histreak = Val(lines(2))
End Sub

Sub WriteScore
    '' Numero de archivo disponible, evita conflictos con otros archivos abiertos
    Dim F As Integer
    F = FreeFile()

    '' Abrir archivo y escribir
    Open save_game For Output As #F
        Print #F, UCase(hiusername)
        Print #F, hiscore
        Print #F, histreak
    Close #F
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

Sub PrintImage(ByVal img As String)
    '' Numero de archivo disponible, evita conflictos con otros archivos abiertos
    Dim F As Integer
    F = FreeFile()

    '' Linea
    Dim txt As String

    '' Abrir archivo y escribir
    Open img For Input As #F
        While Not Eof(F)
            '' Leer linea
            Line Input #F, txt

            '' Dibujar linea
            Print txt
        Wend
    Close #F
End Sub

Sub UpdateScore(ByVal tries_left As Integer)
    score += kSCORE * tries_left
    streak += 1

    If score > hiscore Then 
        hiscore = score
        hiusername = username
    End If

    If streak > histreak Then
        histreak = streak
        hiusername = username
    End If
End Sub

Sub RestartScore
    score = 0
    streak = 0
End Sub

Sub RestartPlayer
    '' Mostrar por pantalla
    Shell "cls"
    PrintImage(gameover_img)
    ''Print "GAME OVER"
    Sleep kWAIT

    '' Reinicio de propiedades
    RestartScore
End Sub

Sub MainLoop
    '' Variables del bucle
    Dim found As Boolean
    Dim tries_left As Integer = kMAX_TRIES

    '' Variables referentes a los valores
    Dim key As ZString Ptr
    Dim player_antonym As String

    '' Obtener una clave aleatoria a adivinar
    key = get_random_key

    Do
        '' Limpiar pantalla
        Shell "cls"

        '' Dibujo de PLAY
        PrintImage(play_img)

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
            '' Actualizar variables de puntuacion y racha mas alta
            UpdateScore(tries_left)

            '' Sonido
            Beep

            '' Mostrar por pantalla
            Print "Found!"
            Sleep kWAIT
        ElseIf tries_left > 1 Then
            '' Decrementar intentos
            tries_left -= 1

            '' Sonido
            Beep
            Beep

            '' Mostrar por pantalla
            Print "Wrong! Try again..."
            Sleep kWAIT / 2
        ElseIf tries_left = 1 Then
            '' Decrementar intentos
            tries_left -= 1

            '' Sonido
            Beep
            Beep
        End If
    Loop While tries_left > kMIN_TRIES And Not found

    '' Reinicio de propiedades
    If Not found Then RestartPlayer End If
End Sub

Sub InitGame
    '' Tamano de la terminal
    Shell "mode con cols=120 lines=80"

    '' Titulo de la terminal (no va?)
    Shell "title Contrast Words"

    '' Inicializar variables globales del juego
    ReadScore

    '' Inicializar variables globales de jugadores
    Input "How should I address you? ", username
    RestartScore

    '' Inicializar JSON (desde C)
    init_json()

    '' Leer eleccion del usuario
    ReadPlayerChoice
End Sub

'' Inicia el juego
InitGame

'' NOTA: refactorizar un poco algunos bloques que se repiten: MAIN LOOP principalmente lo necesita
'' NOTA: anadir dibujos