import os
import sys
import subprocess
sys.path.append(snakemake.config['args']['mcc_path'])
import scripts.mccutils as mccutils
import statistics


def main():
    fq2 = snakemake.params.fq2

    if fq2 != "None":
        print("<PROCESSING> calculating median insert size of reads...")
        insert_sizes = []
        with open(snakemake.input[0],"r") as sam:
            for line in sam:
                split_line = line.split("\t")
                if len(split_line) >= 8:
                    insert_size = int(split_line[8])
                    if insert_size > 0:
                        insert_sizes.append(insert_size)
        
        insert_sizes.sort()
        median = statistics.median(insert_sizes)
        with open(snakemake.output[0],"w") as out:
            out.write("median_insert_size="+str(median)+"\n")
    
    else:
        with open(snakemake.output[0],"w") as out:
            out.write("median_insert_size=500\n")
        

if __name__ == "__main__":                
    main()