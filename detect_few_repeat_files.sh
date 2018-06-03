#!/bin/bash
# Powered by ChangeGene LLC.
# A Bioinformatics Solution Provider from Harvard.
# Created by skywalker@changegene.com at 20170731.
# License: Peaceful Open Source License (PeaceOSL)
# The follow is modify log:

#1. readme.
if [ ! $1 ]; then 
echo "
the detect_few_repeat_files.sh is a shell script to detect repeat files in the path you input by MD5 value.
Useage:  
	sudo sh detect_few_repeat_files.sh /the_path_you_want_to_check_repeat_files
example:
	sudo sh detect_few_repeat_files.sh /8T1/Freya/P#129_Freya_s3/absolute/vcf2maf-1.6.12/docs

There are there output files:
	1. uniq files: all.uniq_files_everylines.md5value.size.list
	2. repeat files: all.repeat_files_everylines.md5value.size.list
	3. repeat times of MD5 value: all.repeat_md5.macthed_times.check.list
	" 
exit 0
fi 

#2. calculate MD5 value and size of these files in the path you input.
find $1 -type f -print0|xargs -0 md5sum|awk '{cmd="du -b "$2;cmd|getline var; print $1 "\t" var;}'|awk '{print $3 "\t" $2 "\t" $1}'|sort -k2,2nr -k1,1 >all.md5value.size.list

#3. Get the repeat MD5 value and files.
uniq -f 1 -d  *all.md5value.size.list >all.repeat_files.md5value.size.list

#4. Use the repeat MD5 value get the uniq files and repeat files.
awk -F'\t' 'NR==FNR{a[$3]=0} NR>FNR {if($3 in a){print $0 "\t" FILENAME >"all.repeat_files_everylines.md5value.size.list";a[$3]++;}else{print $0 "\t" FILENAME >"all.uniq_files_everylines.md5value.size.list"}}END{for(i in a){print a[i] "\t" i >"all.repeat_md5.macthed_times.check.list"}}' all.repeat_files.md5value.size.list *all.md5value.size.list

#5. resort all.repeat_files_everylines.md5value.size.list
sort -k2,2nr -k1,1 all.repeat_files_everylines.md5value.size.list >all.repeat_files_everylines.md5value.size.sort

echo "
There are there output files:
	1. uniq files: all.uniq_files_everylines.md5value.size.list
	2. repeat files: all.repeat_files_everylines.md5value.size.list
	3. repeat times of MD5 value: all.repeat_md5.macthed_times.check.list
"
