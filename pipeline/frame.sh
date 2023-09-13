

# e.g. ./frame.sh meme.jpg DejaVu-Sans 24 "Mad Meme #666: Legendary" frame.png output.png


magick $1 -resize 550x550\> -background Lavender -fill black -font $2 -pointsize $3 \
          label:"$4"   -gravity South -append \
                  -write mpr:image    +delete \
          $5             -write mpr:edge_top +delete \
          $5 -rotate 180 -write mpr:edge_btm +delete \
          \
          mpr:image -alpha set -bordercolor none \
          -compose Dst -frame 25x25+25  -compose over \
          \
          -tile mpr:edge_btm \
          -transverse -draw 'color 1,0 floodfill' \
          -transpose  -draw 'color 1,0 floodfill' \
          -tile mpr:edge_top \
          -transverse -draw 'color 1,0 floodfill' \
          -transpose  -draw 'color 1,0 floodfill' \
          \
          mpr:image -gravity center -composite    $6