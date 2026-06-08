# ONT basecalling pipeline
ONT basecalling pipeline is a simple nextflow pipeline for basecalling nanopore data on the S3IT UZH cluster.
## Parameters
| **Parameter** | **Type** | **Description**                              |
|---------------|----------|----------------------------------------------|
| `name`        | String   | Name of your sequencing experiment.          |
| `gigabases`   | Integer  | Number of gigabases sequenced.               |
| `kit`         | String   | Barcoding kit name.                          |
| `datadir`     | String   | Directory of the raw sequencing data (POD5). |
| `outdir`      | String   | Directory for the basecalled data.           |
## Running the pipeline
```
sbatch run_basecalling.slurm params.json
```