#!/bin/bash

filename="./filtered_gene_pairs_SingleL"
output_file="ka_ks_SL.txt"

touch output.txt
while IFS= read -r line; do

	gene1=$(echo "$line" | cut -d' ' -f1)
	gene2=$(echo "$line" | cut -d' ' -f2)

	cat ALL_Prot/"${gene1}.fasta" > prot.fst
	cat ALL_Prot/"${gene2}.fasta" >> prot.fst
	cat ALL_CDS/"${gene1}.fasta" > cds.fst
	cat ALL_CDS/"${gene2}.fasta" >> cds.fst

	clustalw -quiet -align -infile=prot.fst -outfile=prot.ali.aln

	./pal2nal.pl prot.ali.aln cds.fst -output paml > cds.ali.phy

	paml-4.10.7/bin/yn00

	dN=$(awk 'NR==3' 2YN.dN | tr -s ' ' | cut -d ' ' -f2)
	dS=$(awk 'NR==3' 2YN.dS | tr -s ' ' | cut -d ' ' -f2)

	printf "%s %s %s %s\n" "$gene1" "$gene2" "$dN" "$dS" >> "$output_file"

done < "$filename"