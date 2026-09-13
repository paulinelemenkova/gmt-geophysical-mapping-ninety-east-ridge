# GMT Geophysical Mapping of the Ninety East Ridge, Indian Ocean

GMT (Generic Mapping Tools) shell scripts mapping the topography, geoid and free-air gravity of the Ninety East Ridge, a ~5000 km linear aseismic ridge in the Indian Ocean (region 65-107 E, 35 S-21 N). The three scripts render a shaded-relief bathymetry map from GEBCO, a geoid map from the EGM96/EGM2008 models, and a marine free-air gravity map from the Sandwell & Smith global grid.

## Associated publication

Lemenkova, P. (2021). Geomorphology of the Ninety East Ridge. *Bulletin of Perm University. Geology / Vestnik Permskogo universiteta. Geologia*, 20(3), 195-212. ISSN 1994-3601.

## Links

- Published paper (archived at Zenodo, DOI): https://doi.org/10.5281/zenodo.5577923
- Publisher (Perm University): http://geology-vestnik.psu.ru/index.php/geology/article/view/401
- Preprint (HAL): https://hal.science/hal-03384973
- Preprint (SSRN): https://ssrn.com/abstract=3945470
- LifeScience.net: https://www.lifescience.net/publications/19427/geomorphology-of-the-ninety-east-ridge/
- Author ORCID: https://orcid.org/0000-0002-5759-1089

## Scripts

- `GMT-01-JM-NER_rus.sh`
- `GMT-01-JM-geoid-NEREGM96_rus.sh`
- `GMT-01-JM-gravity-NER_rus.sh`

## Data

The scripts read a GEBCO bathymetry grid (GEBCO_2019.nc), the EGM96/EGM2008 geoid models and the Sandwell & Smith global marine free-air gravity grid (grav_27.1.img). These global source grids are not included in the repository; download them and adjust the paths at the top of each script.

## Requirements

GMT (Generic Mapping Tools) 6 and GDAL (gdalinfo).

## Author

Polina Lemenkova

## License

MIT — see the LICENSE file (Copyright Polina Lemenkova).
