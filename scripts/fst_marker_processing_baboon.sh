REGION_SIZE=100000
MAX_POS=$(awk '$1 == "20" { print $3 }' FSTMarkersOver80.txt | sort -n | tail -n 1)

for chr in $(seq 1 20); do
  mkdir -p "Chrom${chr}"

  for ((start=1; start<=$MAX_POS; start+=REGION_SIZE)); do
    end=$((start+REGION_SIZE-1))

    if [[ $end -gt $MAX_POS ]]; then
      end=$MAX_POS
    fi

    # Extract markers within the 100,000 bp window
    awk -v chr="$chr" -v start="$start" -v end="$end" 'BEGIN {OFS = "\t"} $1 == chr && $3 >= start && $3 <= end { print $0 }' FSTMarkersOver80.txt > "Chrom${chr}/Chr${chr}_${start}-${end}.txt"

    # Find the maximum FST value in the window
    max_fst=$(awk 'NR==1{max=$5} $5>max{max=$5} END{print max}' "Chrom${chr}/Chr${chr}_${start}-${end}.txt")

    # Extract the row corresponding to the maximum FST value
    grep -w "$max_fst" "Chrom${chr}/Chr${chr}_${start}-${end}.txt" > "Chrom${chr}/Chr${chr}_${start}-${end}_maxFST.txt"
  done
done

