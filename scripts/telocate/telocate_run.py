import os
import sys
import subprocess
sys.path.append(snakemake.config['args']['mcc_path'])
import scripts.mccutils as mccutils
import config.telocate.telocate_run as config


def main():
    te_gff = snakemake.input.te_gff
    sam = snakemake.input.sam
    ref_fasta = snakemake.input.ref
    median_insert_size_file = snakemake.input.median_insert_size

    telocate = snakemake.params.run_script
    max_mem = snakemake.params.max_mem
    out_dir = snakemake.params.out_dir


    sam_dir = os.path.dirname(sam)

    os.chdir(os.path.dirname(telocate))

    median_insert_size = mccutils.get_median_insert_size(median_insert_size_file)

    distance = (median_insert_size * config.MIN_DISTANCE)

    command = ["perl", telocate, str(max_mem), sam_dir, te_gff, ref_fasta, out_dir, str(distance), str(config.MIN_SUPPORT_READS), str(config.MIN_SUPPORT_INDIVIDUALS)]

    mccutils.run_command(command)


    mccutils.run_command(["cp", out_dir+"_"+str(distance)+"_reads3_acc1.info", out_dir+"te-locate-raw.info"])








if __name__ == "__main__":                
    main()

