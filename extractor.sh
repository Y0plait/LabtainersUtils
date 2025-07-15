#!/bin/bash
echo "Labtainer command history extractor ..."
echo "Working in: "
pwd
echo "\n\n"
cat > ./results.txt<< EOF
Commands to execute in each labtainers present in this direcotry.
Each labtainer is delimited with a line full of =.
If a labtainer has multiple instances in which you have to run commands, these instances are indicated by
a line full of - followed by the name of the instance (e.g: server, client ...)
Script made by y0plait ©.
https://github.com/Y0plait/
EOF
echo "Extraction of repaired archive: done"
echo "Extracting .bashrc and .bash_history for each labtainer"
for labs in */; do
	# Removing trailing /
	labs=${labs%*/}
	#Extracting .lab to .zip
	echo "Repairing archive in "$labs
	zip -F $labs/*.lab --out $labs/cleaned.zip
	echo "Extracting repaired archive in "$labs"/cleaned"
	mkdir $labs/cleaned
	unzip $labs/cleaned.zip -d $labs/cleaned

	# Formating results.txt
	echo "====================="$labs"=====================" >> ./results.txt
	# Extracting all zips
	for file in $labs/cleaned/*; do
		if [[ $file == *".zip"* ]]; then
			out_folder="${file}-cleaned"
			mkdir $out_folder
			unzip $file -d $out_folder
		else
			echo "Skipping "$file" .Not .zip"
		fi
	done
	# Extracting content of .bash_history for each deflated zip if it exists
	for cleaned_zips in  $labs/cleaned/*/; do
		# Working again with direcotries, removinf trailing /
		cleaned_zips=${cleaned_zips%*/}
		# Searching for bash_history
		if [ -f $cleaned_zips/.bash_history ]; then
			if echo "$cleaned_zips" | grep client; then
				echo "-------------Client-------------" >> ./results.txt
			fi
			if echo "$cleaned_zips" | grep server; then
				echo "-------------Server-------------" >> ./results.txt
			else
				echo "-------------"$cleaned_zips"-------------" >> ./results.txt
			fi

			cat $cleaned_zips/.bash_history >> ./results.txt
		fi
	done
done

#tree
