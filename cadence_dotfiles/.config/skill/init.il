printf("Loading custom utils\n")
; =======
printf("Loading custom frameworks\n")
;setShellEnvVar("SKILL_SHARP_ROOT", simplifyFilename("$XDG_CONFIG_HOME/skill/skill_sharp", t)) ; don't resolve links
;load(simplifyFilename("$SKILL_SHARP_ROOT/skill/loader.scm", t)) ; don't resolve links

printf("Loading custom functions\n")
; Load custom functions here.
; Really inelegent way but I don't want to play with get_file at the moment
(inScheme
    ( setq utils_to_load '(
                           "misc.scm" ; always load misc helper first.
                           "launch_terminal.scm"
                          ; "bulk_export_csv_results.scm"
                          ; "abDumpWaveform.il"
                           ) )
    (foreach _file utils_to_load
        (loadi ( simplifyFilename ( lsprintf "$XDG_CONFIG_HOME/skill/%s" _file ) ) )
    )
)

printf("Setting custom bindkeys\n")
hiSetBindKeys( "Command Interpreter" list(
    list("Ctrl<Key>T" "launch_terminal()" )
))
