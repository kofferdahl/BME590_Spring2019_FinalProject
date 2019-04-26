To generate images:
1. Download Field_II at https://field-ii.dk/
2. Add field_ii to path, type field_init in command window
3. Run make_PSF with desired parameters.
4. Make directory structure for saving images specified in gen_images.m
5. Modify gen_images.sh to have the desired image parameters (e.g. lesion 
contrast, number of images in each set, etc.). 
6. Modify launch.sh to the desired number of sets to be created in parallel
(currently set to 10)
7. ssh in to DCC (ssh durmstrang.egr.duke.edu)
8. Make an output folder for logs (folder must be called output)
9. run ./launch.sh
10. Convert sets of .mat files to one compressed numpy file using SavePythonData.ipynb

