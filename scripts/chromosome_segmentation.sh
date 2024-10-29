while read i; do 
  for chrom in {1..22}; do 
    for segment in {0..500}; do 
      awk -v chrom="$chrom" -v segment="$segment" '$1 == "chr"chrom && $6 == segment {print}' \
      "${i}.Alt.FullData.filtered.txt" > Chrom${chrom}/${i}.${segment}.segment
    done 
  done 
done < Pops.txt
