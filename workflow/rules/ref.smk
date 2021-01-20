rule get_genome:
    output:
        "resources/genome.fasta",
    log:
        "logs/get-genome.log",
    conda:
        "../envs/entrez.yaml"
    shell:
        "(esearch -db nucleotide -query 'NC_045512.2' |"
        "efetch -format fasta > {output}) 2> {log}"


rule genome_faidx:
    input:
        "resources/genome.fasta",
    output:
        "resources/genome.fasta.fai",
    log:
        "logs/genome-faidx.log",
    wrapper:
        "0.59.2/bio/samtools/faidx"


rule get_genome_annotation:
    output:
        "resources/annotation.gff.gz",
    log:
        "logs/get-annotation.log",
    conda:
        "../envs/tabix.yaml"
    shell:
        # download, sort and bgzip gff (see https://www.ensembl.org/info/docs/tools/vep/script/vep_custom.html)
        "(curl -sSL https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/009/858/895/"
        "GCF_009858895.2_ASM985889v3/GCF_009858895.2_ASM985889v3_genomic.gff.gz | "
        "zcat | grep -v '#' | sort -k1,1 -k4,4n -k5,5n -t$'\t' | bgzip -c > {output}) 2> {log}"


rule get_problematic_sites:
    output:
        temp("resources/problematic-sites.vcf.gz"),  # always retrieve the latest VCF
    log:
        "logs/get-problematic-sites.log",
    conda:
        "../envs/tabix.yaml"
    shell:
        "curl -sSL https://raw.githubusercontent.com/W-L/ProblematicSites_SARS-CoV2/"
        "master/problematic_sites_sarsCov2.vcf | bgzip -c > {output} 2> {log}"


# TODO Alexander + Thomas add rules to retrieve strain sequences (I currently don't yet know from where)
