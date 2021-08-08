#!/bin/bash

# create folders
function create_folders()
{
	for i in ./*; 
	do 
		if [ -d ./_pro ]; 
		then 
			if [[ ./_pro = *itg* ]]; 
			then 
				echo ./_pro; 
				mkdir -p ./_pro/spc && mkdir -p ./_pro/gnc; 
			fi; 
		fi; 
	done;
}


function erase()
{
	for i in ./*; 
	do 
		if [ -d $i ];
		then 
			cd $i
			find . -iname CMakeLists.*.txt -exec rm {} \;; 
			find . -iname CMake* -exec rm -rf {} \;;
			find . -iname CTest* -exec rm -rf {} \;;
			find . -iname *.a -exec rm -rf {} \;;
			find . -iname *.o -exec rm -rf {} \;;
			cd -
		fi; 
	done;

}

submodules=()

function prepare_module()
{
	echo "function prepapre_module"
	echo ${2}
	echo $1
	echo "all libs"
	echo ${all_submodules_from_submodules[@]}
	tmpfile="CMakeLists.txt"
 	
	sed -r "s|\{user_incdir\}|\".\"|g" ../../CMakeLists.module.txt > $tmpfile	
	for i in ${all_submodules_from_submodules[@]};
	do
		echo "include_directories ( $i )" >> $tmpfile
	done
	sed -ri "s/\{user_srcs\}/${2}/g" $tmpfile
	sed -ri "s/\{user_name\}/$1/g" $tmpfile

	return
}


function work_on_module()
{
	for i in ./*; 
	do 
		if [[ $i = *"mod"* ]]; 
		then
			submodules=(${submodules[@]} $i);
		fi; 
	done;

	echo ${submodules[@]}
	
	for i in ${submodules[@]};
	do
		if [ -d $i ];
		then
			name=${i##*/}_gnc
			mkdir -p $i/gnc
			cd $i/gnc
			sed -r "s/\{project_name\}/$name/g" ../../module.c.tmp > ${i}_gnc.c
			sed -ri "s/\{PROJECT_NAME\}/$name/g" ${i}_gnc.c
			sed -r "s/\{project_name\}/$name/g" ../../module.h.tmp >> ${i}_gnc.h
			sed -ri "s/\{PROJECT_NAME\}/$name/g" ${i}_gnc.h
			cd -
			name=${i##*/}_spc
			mkdir -p $i/spc
			cd $i/spc
			sed -r "s/\{project_name\}/$name/g" ../../module.c.tmp >> ${i}_spc.c
			sed -ri "s/\{PROJECT_NAME\}/$name/g" ${i}_spc.c
			sed -r "s/\{project_name\}/$name/g" ../../module.h.tmp >> ${i}_spc.h
			sed -ri "s/\{PROJECT_NAME\}/$name/g" ${i}_spc.h
			cd -
		fi;
	done

	for i in ${submodules[@]}; 
	do 
		folders=(gnc spc)
		for j in ${folders[@]};
		do
			project_name=${i##*/}$j
			echo $project_name
			
			cd $i/$j
			echo "extract the name, find source and include files"
			tmp_src_files=$(find . -iname "*.[c]")
			src_files=()
			
			for k in ${tmp_src_files[@]};
			do
				src_files=(${src_files[@]} ${k##*/})
			done
			echo ${src_files[@]}
			
			echo "use sed to prepare cmake file (new file)"

			prepare_module $project_name $src_files

			cd -
		done
	done
	return 
}

function prepare()
{
	filename="CMakeLists.txt"
	work_on_module
	return

	echo "include"
	for i in ${all_submodules_from_main_inc[@]};
	do
		echo "include_directories ( $i )" >> $filename
	done
	echo "subdirectory"
	for i in ${all_submodules_from_main[@]};
	do
		echo "add_subdirectory ( $i) " >> $filename
	done
	echo "submodule"
	for i in ${all_submodules[@]};
	do
		echo "list (APPEND EXTRA_LIBS $i) " >> $filename
	done
}

function help_text()
{
	echo "-p	prepare"
	return
}



case $1 in 
	-p)
		prepare
		;;
	-e)
		erase
		;;
	-h | *)
		help_text
		;;
esac
	
