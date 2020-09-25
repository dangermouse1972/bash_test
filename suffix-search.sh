#/bin/bash/
search_path=$1
filename=$2
start_date=$3
end_date=$4
echo $search_path
echo $filename

##test git



function help
{
    echo "suffix-search.sh <path> <fileNames> <from_date> <to_date>"
    echo "args:"
    echo "      path:        Root folder of search"
    echo "      filename(s): Filename to search for.  Comma Seperate each file with no spaces (eg. filename1,filename2,etc)."
    echo "                   All wild cards permited"
    echo "      from_date:   Search from date (including date).  Date be suplied in unix time"
    echo "      to_date:     Search to date (include date specifed). Date to be suplied in unix time" 
} 

function searchForFiles
{
    kount=0

    cmd="find $search_path -type f -name ${filename//[,]/ -o -name } | wc -l"
    echo $cmd

    #eval $cmd

    kount=`eval $cmd`
    
    echo "total: "$kount

    if [ $kount == 0 ] 
    then
        exit 1
    else
        exit 0

    fi
}

function validateArgs
{
    echo "$search_path"

    ##check args exist or help requested
    if [ -z "$search_path" ] || [ "$search_path" = "--help" ]
    then
        help
        exit 1
    elif [ ! -d $search_path ]
    then
        echo "Search path $search_path does not exist."
        exit 1
    ##else
    ##    exit 0


    fi



}

validateArgs

searchForFiles

