; Caution: This isn't good code and might crap out on edge cases.
(defun bulk_export_csv_results
  (@key
    ( axl_sess (axlGetWindowSession) )
    ( hists nil )
    ( export_dir (simplifyFilename "$HOME/Documents") )
    ( view_type "Detail-Transpose" )
    ( list_histories_mode nil )
    @rest _ )
    ; doc "export_csv_results: Export simulation results to CSV files for specified histories."

    ; get Library, Cell, and View names from the session for metadata
    ( setq lib_name  ( axlGetSessionLibName  axl_sess  ) )
    ( setq cell_name ( axlGetSessionCellName axl_sess  ) )
    ( setq view_name ( axlGetSessionViewName axl_sess  ) )
    ( printf "Info: Library: %s, Cell: %s, View: %s\n" lib_name cell_name view_name )

    ( setq sdb ( axlGetMainSetupDB axl_sess ) )
    ( setq all_histories (nth 1 ( axlGetHistory sdb ) ) )

    (cond
      ( list_histories_mode
        ( printf "Info: Listing all the histories\n" )
        ( pprint all_histories )
        ( setq hists_to_export nil )
       )

      ( hists
        ( setq hists_to_export ( setof _i hists ( member _i all_histories ) ) )
        ; ( assert ( hists_to_export "No matching history %s found within %s" hists all_histories ) )
      )

      ( not( and( hists list_histories_mode ) )
        ( printf "Info: No specific histories provided, exporting all histories\n" )
        ( setq hists_to_export all_histories )
        )
    )
    (when hists_to_export
    ( printf "Info: Exporting CSV files\n" )
    ( foreach _hist hists_to_export
      ( printf "Info: History Name: %s\n" _hist )
      ( setq _hist_slug ( sluggify ?input_str _hist ) )
      ( setq csv_file_path ( strcat export_dir
                                    "/"
                                    lib_name
                                    "_" cell_name
                                    "_" view_name
                                    "_" view_type
                                    "_" _hist_slug
                                    ".csv" )
                                    )
      ( axlExportOutputView axl_sess csv_file_path view_type
                            ?history _hist
                            ?clearAllFilters t
                            )
      ( printf "Info: Export completed\n" )
    )
    )
)
; sources: https://community.cadence.com/cadence_technology_forums/f/38/p/33480/1342368#1342368
