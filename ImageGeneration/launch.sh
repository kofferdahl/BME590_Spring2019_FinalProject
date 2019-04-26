#Then launch the batch process using the --array option to specify the indices.

sbatch --array=1-10 gen_images.sh
