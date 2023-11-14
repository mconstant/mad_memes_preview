# get width
echo $7
convert $1 -resize 1200 tmp_wide.png
width=$(identify -format "%w" tmp_wide.png)
convert mad_memes_top_logo.png -resize $width tmp_logo_qr.png
height=$(identify -format "%h" tmp_logo_qr.png)
convert badge_transparent.png -font Creepster -fill White -pointsize 52 \
        -annotate +60+150 '#'${8}'' -pointsize 35 -annotate +40+100 'Season 1' tmp_badge_qr.png
convert tmp_badge_qr.png -resize $height tmp_badge_qr.png
convert tmp_logo_qr.png tmp_badge_qr.png -gravity East   \
        -alpha On \
        -composite  tmp_logo_qr.png
convert tmp_logo_qr.png tmp_wide.png -append tmp_output_qr.png
convert ${7}.png -resize ${width} tmp_rarity_qr.png
convert tmp_output_qr.png tmp_rarity_qr.png -append tmp_output_qr.png
convert mad_memes_qr_claim_template.png \( qrs/paper_wallet_seed_for_meme_${8}.png -resize 160% \) -gravity Center +append mad_memes_footer_qr.png
convert mad_memes_footer_qr.png -resize $width tmp_footer_qr.png
convert tmp_output_qr.png tmp_footer_qr.png -append tmp_output_qr.png
# e.g. ./frame.sh meme.jpg DejaVu-Sans 24 "Mad Meme #666: Legendary" frame.png output.png


magick tmp_output_qr.png \
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