#!/bin/sh
# Purpose: shaded relief grid raster map from the GEBCO dataset (here: Ninety East Ridge, Indian Ocean)
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

# GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TITLE_OFFSET=1c \
    MAP_ANNOT_OFFSET=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thin,white \
    MAP_GRID_PEN_SECONDARY=thinnest,white \
    FONT_TITLE=12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=7p,Helvetica,dimgray \
    FONT_LABEL=7p,Helvetica,dimgray
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

# 'cent2_geoid/' - папка с ESRI GRDI файлами
grdconvert n00e45/ EGM2008ner1.grd
grdconvert n00e90/ EGM2008ner2.grd
grdconvert s45e45/ EGM2008ner3.grd
grdconvert s45e90/ EGM2008ner4.grd

gdalinfo geoid.egm96.grd -stats
# Minimum=-47.681 Maximum=4.883
gdalinfo EGM2008ner2.grd -stats
# Minimum=-66.313, Maximum=76.565
gdalinfo EGM2008ner3.grd -stats
# Minimum=-102.829, Maximum=46.450
gdalinfo EGM2008ner4.grd -stats
# Minimum=-64.559, Maximum=80.817
# Make color palette
# makecpt --help
gmt makecpt -Chaxby.cpt -V -T-110/81/10 > colors.cpt
#gmt makecpt -Chaxby.cpt -V -T-85/81/5 > colors1.cpt
#gmt makecpt -Chaxby.cpt -V -T-100/100/5 > colors2.cpt
#gmt makecpt -Chaxby.cpt -V -T-100/100/5 > colors3.cpt
#gmt makecpt -Chaxby.cpt -V -T-100/100/5 > colors4.cpt

# Generate a file
ps=Geoid_NER.ps

# Make raster image
#gmt grdimage geoid.egm96.grd -Ccolors.cpt -R65/107/-35/21 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps
gmt grdimage geoid.egm96.grd -Gb -R65/107/-35/21 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx10f5a5 -Bpyg10f5a5 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_TITLE=14p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    -O -K >> $ps
    
# Add isolines
#gmt grdcontour geoid.egm96.grd -R -J -C5 -A10 -Wthin,dimgray -O -K >> $ps
gmt grdcontour EGM2008ner1.grd -R -J -C5 -A10 -Wthin,dimgray -O -K >> $ps
gmt grdcontour EGM2008ner2.grd -R -J -C5 -A10 -Wthin,dimgray -O -K >> $ps
gmt grdcontour EGM2008ner3.grd -R -J -C5 -A10 -Wthin,dimgray -O -K >> $ps
gmt grdcontour EGM2008ner4.grd -R -J -C5 -A10 -Wthin,dimgray -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT_LABEL=8p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=8p,Helvetica,black \
    --MAP_LABEL_OFFSET=0.1c \
    -Lx12.7c/-2.5c+c50+w1000k+f \
    -UBL/-5p/-75p -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P \
    -Ia/thinnest,blue -Na -N1/thinner,red -Wthin -Df -O -K >> $ps
#
# tectonic plates
#gmt psxy -R -J TP_Indian.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_African.txt -L -Wthickest,red -O -K >> $ps
#gmt psxy -R -J TP_Australian.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_Eurasian.txt -L -Wthickest,red -O -K >> $ps

# Add legend
gmt psscale -Dg65/-37.5+w15.2c/0.4c+h+o0.0/0i+ml -R -J -Ccolors.cpt \
    --FONT_LABEL=7p,Helvetica,black \
    --MAP_LABEL_OFFSET=0.1c \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Bg5f2a10 \
    -I0.2 -By+lm -O -K >> $ps

# Add GMT logo
gmt logo -Dx6.2/-3.3+o0.1i/0.1i+w2c -O >> $ps

# Convert to image file using GhostScript
gmt psconvert Geoid_NER.ps -A1.0c -E720 -Tj -Z
