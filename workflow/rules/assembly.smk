rule assembly:
    input:
        fastq1="results/trimmed/{sample}.1.fastq.gz",
        fastq2="results/trimmed/{sample}.2.fastq.gz",
    output:
        "results/assembly/{sample}/final.contigs.fa",
    log:
        "logs/megahit/{sample}.log",
    params:
        outdir=lambda w, output: os.path.dirname(output[0]),
    threads: 8
    conda:
        "../envs/megahit.yaml"
    shell:
        "rm -r {params.outdir}; megahit --min-contig-len 20000 -1 {input.fastq1} -2 {input.fastq2} -o {params.outdir} 2> {log}"

# TODO remove min config len threshold, and rather filter out the largest contig in a subsequent step
# TODO add plot that visualizes assembly quality
# TODO blast smaller contigs to determine contamination?
