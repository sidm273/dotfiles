function hex2png --description 'Convert hex color codes to a swatch PNG'
    # Usage: cat "#ff0000\n#00ff00\n#0000ff\n" | hex2png output.png
    # This script reads hex color codes from standard input and runs
    # magick convert (previously convert) to create a PNG image with swatches of
    # those colors. Each color code should be in the format #RRGGBB, and they
    # should be separated by newlines. This will usually be an output of either
    # grep from a file or output of `pastel format`.
    if set --query argv[1]
        set --function output $argv[1]
    else
        echo "Using default output filname hex2png_output.png"
        set --function output "hex2png_output.png"
    end
    set --function bar_width 500
    set --function bar_height 100
    set --function xc_colors
    read --null --array colors
    # convert $colors to a "xc" string to pass to convert.
    for i in (seq (count $colors))
        set --append xc_colors "xc:$colors[$i]"
    end
    set --function size (string join '' $bar_width x $bar_height)
    set --function cmd magick -size $size $xc_colors -append $output
    $cmd
    echo "Created $output with "(count $colors)" colors"
end
