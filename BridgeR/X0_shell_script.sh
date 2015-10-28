#!/bin/sh
for file in htseq_count_result_siStealth_0h htseq_count_result_siStealth_1h htseq_count_result_siStealth_2h htseq_count_result_siStealth_4h htseq_count_result_siStealth_8h htseq_count_result_siStealth_12h htseq_count_result_siPUM1_0h htseq_count_result_siPUM1_1h htseq_count_result_siPUM1_2h htseq_count_result_siPUM1_4h htseq_count_result_siPUM1_8h htseq_count_result_siPUM1_12h
do
    python3 X1_define_rpm_from_htseq_count_result.py ${file}.txt ${file}_rpm.txt
    python3 X5_calc_rpkm.py ${file}_rpm.txt PUM1KD_gene_exp_RefSeq_rep_isoform_seq_length.result ${file}_rpkm.txt
done
###python3 X4_define_rep_transcript_length.py Refseq_gene_hg19_June_02_2014.seq PUM1KD_gene_exp_RefSeq_rep_isoform.result PUM1KD_gene_exp_RefSeq_rep_isoform_seq_length.result

cut -f 1,2,3,4,6 htseq_count_result_siStealth_0h_rpkm.txt > htseq_count_result_siStealth_0h_rpkm_cut_12346.txt
cut -f 6 htseq_count_result_siStealth_1h_rpkm.txt > htseq_count_result_siStealth_1h_rpkm_cut6.txt
cut -f 6 htseq_count_result_siStealth_2h_rpkm.txt > htseq_count_result_siStealth_2h_rpkm_cut6.txt
cut -f 6 htseq_count_result_siStealth_4h_rpkm.txt > htseq_count_result_siStealth_4h_rpkm_cut6.txt
cut -f 6 htseq_count_result_siStealth_8h_rpkm.txt > htseq_count_result_siStealth_8h_rpkm_cut6.txt
cut -f 6 htseq_count_result_siStealth_12h_rpkm.txt > htseq_count_result_siStealth_12h_rpkm_cut6.txt
paste htseq_count_result_siStealth_0h_rpkm_cut_12346.txt htseq_count_result_siStealth_1h_rpkm_cut6.txt htseq_count_result_siStealth_2h_rpkm_cut6.txt htseq_count_result_siStealth_4h_rpkm_cut6.txt htseq_count_result_siStealth_8h_rpkm_cut6.txt htseq_count_result_siStealth_12h_rpkm_cut6.txt > htseq_count_result_siStealth_rpkm.txt

cut -f 1,2,3,4,6 htseq_count_result_siPUM1_0h_rpkm.txt > htseq_count_result_siPUM1_0h_rpkm_cut_12346.txt
cut -f 6 htseq_count_result_siPUM1_1h_rpkm.txt > htseq_count_result_siPUM1_1h_rpkm_cut6.txt
cut -f 6 htseq_count_result_siPUM1_2h_rpkm.txt > htseq_count_result_siPUM1_2h_rpkm_cut6.txt
cut -f 6 htseq_count_result_siPUM1_4h_rpkm.txt > htseq_count_result_siPUM1_4h_rpkm_cut6.txt
cut -f 6 htseq_count_result_siPUM1_8h_rpkm.txt > htseq_count_result_siPUM1_8h_rpkm_cut6.txt
cut -f 6 htseq_count_result_siPUM1_12h_rpkm.txt > htseq_count_result_siPUM1_12h_rpkm_cut6.txt
paste htseq_count_result_siPUM1_0h_rpkm_cut_12346.txt htseq_count_result_siPUM1_1h_rpkm_cut6.txt htseq_count_result_siPUM1_2h_rpkm_cut6.txt htseq_count_result_siPUM1_4h_rpkm_cut6.txt htseq_count_result_siPUM1_8h_rpkm_cut6.txt htseq_count_result_siPUM1_12h_rpkm_cut6.txt > htseq_count_result_siPUM1_rpkm.txt
