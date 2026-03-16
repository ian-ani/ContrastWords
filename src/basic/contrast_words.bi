#IfNDef __contrast_words_bi__
#Define __contrast_words_bi__
#inclib "antonyms_utils"

''void init_json(char *filename)
Declare Sub init_json CDecl Alias "init_json" (ByVal filename As Any Ptr)

''void free_json()
Declare Sub free_json CDecl Alias "free_json" ()

''char *get_random_key()
Declare Function get_random_key CDecl Alias "get_random_key" () As Any Ptr

''char **get_values(char *word, int *count)
Declare Function get_values CDecl Alias "get_values" (ByVal word As ZString Ptr, ByRef count As Integer) As Any Ptr

#endif