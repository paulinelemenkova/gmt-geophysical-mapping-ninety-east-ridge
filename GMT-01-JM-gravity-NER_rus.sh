#!/bin/sh
# -----------------------------------------------------------------------------
# GMT Geophysical Mapping of the Ninety East Ridge, Indian Ocean
#
# Author:  Polina Lemenkova
# ORCID:   https://orcid.org/0000-0002-5759-1089
# Paper:   Lemenkova, P. (2021). Geomorphology of the Ninety East Ridge. Bulletin of Perm University. Geology / Vestnik Permskogo universiteta. Geologia, 20(3), 195-212. ISSN 1994-3601.
# DOI:     https://doi.org/10.5281/zenodo.5577923
# License: MIT (see LICENSE)
# -----------------------------------------------------------------------------
# Purpose: shaded relief grid raster map from the GEBCO dataset (here: Ninety East Ridge, Indian Ocean)
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

# GMT set up
gmt set MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TITLE_OFFSET=1c \
    MAP_ANNOT_OFFSET=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thin,white \
    MAP_GRID_PEN_SECONDARY=thinnest,white
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

gmt img2grd grav_27.1.img -R65/107/-35/21 -GgravNER.grd -T1 -I1 -E -S0.1 -V

gdalinfo gravNER.grd -stats
# Minimum=-200.998, Maximum=353.447
# Make color palette
# makecpt --help
gmt makecpt -Chaxby.cpt -V -T-100/100/5 > colors.cpt

# Generate a file
ps=Grav_NER.ps
# Make raster image
gmt grdimage gravNER.grd -Ccolors.cpt -R65/107/-35/21 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx10f5a5 -Bpyg10f5a5 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_TITLE=14p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    -O -K >> $ps
    
# Add shorelines
gmt grdcontour gravNER.grd -R -J -C30 -W0.1p -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT_LABEL=9p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=8p,Helvetica,black \
    --MAP_LABEL_OFFSET=0.1c \
    -Lx12.7c/-2.5c+c50+w1000k+f \
    -UBL/-5p/-75p -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P \
    -Ia/thinnest,blue -Na -N1/thinner,red -W0.1p -Df -O -K >> $ps

# Add legend
gmt psscale -Dg65/-38+w15.2c/0.4c+h+o0.0/0i+ml -R -J -Ccolors.cpt \
    --FONT_LABEL=9p,Helvetica,black \
    --MAP_LABEL_OFFSET=0.1c \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Bg5f2a10 \
    -I0.2 -By+lmGal -O -K >> $ps

# Add GMT logo
gmt logo -Dx6.2/-3.3+o0.1i/0.1i+w2c -O >> $ps

# Convert to image file using GhostScript
gmt psconvert Grav_NER.ps -A1.0c -E720 -Tj -Z
