; This file contains miscellaneous scheme functions that are useful for certain repetative tasks.

;;;; Sluggify a string.
(defun sluggify
  (@key
    ( input_str nil )
    ( replace  "[^a-zA-Z0-9]" ) ; PCRE pattern: (setq RE_NOALPHANUMS "[^a-zA-Z0-9]")
    ( replace_with "_" )
    @rest _ )
  ( setq re_replace (pcreCompile replace) )
  ( pcreReplace re_replace input_str replace_with 0 ) ; 0 -> replace all substrings.
  )

(defun libman_selection_to_clipboard
  (@key
    ( debug_mode nil )
    @rest _ )
  ; ?doc "Copies Lib/Cell/View name of the currently selected entry in library manager to the clipboard"
  ( destructuringBind
    ( lib cell view ) (ddsGetLibManLCV)
    ( printf "Lib name: %s\n" lib )
    ( printf "Cell name: %s\n" cell )
    ( printf "View name: %s\n" view )
    )

  SPACE = " "
  exec_cmd = (buildString
               (list "echo -n"
                     "Lib:" lib ","
                     "Cell:" cell ","
                     "View:" view
                     "|"
                     "xclip" "-in"
                     "-selection" "clipboard"
                     )
               SPACE ; inserted after every element in the above list
               )
  ( printf "Copied to clipboard\n" )
  ( system exec_cmd )
  )
