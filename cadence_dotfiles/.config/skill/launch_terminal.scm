(defun launch_terminal
  ( @key
    (terminal "st")
    (title_arg "-t")
    (title_str "virtuoso-terminal")
    (cmd_arg "-e")
    (cmd_str "/usr/bin/env fish &")
    @rest _)
  ; ?doc "launch_terminal: Launch a terminal emulator with a specified title and command."
  SPACE = " "
  QUOTECHAR = "\""
  exec_cmd = (buildString
               (list terminal
                     title_arg
                     QUOTECHAR title_str QUOTECHAR
                     cmd_arg
                     cmd_str
                     )
               SPACE ; inserted after every element in the above list
               )
  (info "Opening the terminal using: %s" exec_cmd)
  (system exec_cmd)
  )
; Based on abuchet's tutorial