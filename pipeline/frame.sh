# get width
echo $7
width=$(identify -format "%w" $1)
convert mad_memes_top_logo.png -resize $width tmp_logo.png
height=$(identify -format "%h" tmp_logo.png)
convert badge_transparent.png -font Creepster -fill White -pointsize 52 \
        -annotate +60+150 '#'${8}'' -pointsize 35 -annotate +40+100 'Season 1' tmp_badge.png
convert tmp_badge.png -resize $height tmp_badge.png
convert tmp_logo.png tmp_badge.png -gravity East   \
        -alpha On \
        -composite  tmp_logo.png
convert tmp_logo.png $1 -append tmp_output.png
convert ${7}.png -resize ${width} tmp_rarity.png
convert tmp_output.png tmp_rarity.png -append tmp_output.png
convert mad_memes_footer.png -resize $width tmp_footer.png
convert tmp_output.png tmp_footer.png -append tmp_output.png
# e.g. ./frame.sh meme.jpg DejaVu-Sans 24 "Mad Meme #666: Legendary" frame.png output.png


magick tmp_output.png -resize 550x550\> \
       -gravity South -append \
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