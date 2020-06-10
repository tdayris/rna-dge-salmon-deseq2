"""
This rule plots a Volano plot from a DESeq2 result file
See: https://github.com/tdayris/snakemake-wrappers/tree/Unofficial/bio/enhancedVolcano/volcano-deseq2
"""
rule volcanoplot:
    input:
        deseq2_tsv = "deseq2/{design}/TSV/Deseq2_{name}.tsv"
    output:
        png = "figures/{design}/Volcano_{name}.png"
    message:
        "Building volcano plot ({wildcards.design}, {wildcards.name})"
    threads:
        1
    resources:
        mem_mb = (
            lambda wildcards, attempt: min(attempt * 1024, 10240)
        ),
        time_min = (
            lambda wildcards, attempt: min(attempt * 20, 200)
        )
    params:
        alpha_threshold = config["thresholds"].get("alpha_threshold", 0.05),
        fc_threshold = config["thresholds"].get("fc_threshold", 1)
    log:
        "logs/volcanoplot/volcano_{design}_{name}.log"
    wrapper:
        f"{git}/bio/enhancedVolcano/volcano-deseq2"