#/bin/bash/

######################################################################
#                                                                    #
# Script:  suffix_search.sh                                          #
#                                                                    #
# Description:                                                       #
# Searches a directory tree for files that match                     #
# one or more file basename specifications and which have a          #
# modification time within a given range                             #
#                                                                    #
# Author: Matt Whitmore                                              #
#                                                                    #
######################################################################


set -f

search_path=$1
filename=$2
from_date=$3
to_date=$4

#debug
echo "folder:"$search_path
echo "files:"$filename
echo "from date:"$from_date
echo "to_date:"$to_date


function help
{
    echo "suffix-search.sh <path> <fileNames> <from_date> <to_date>"
    echo "args:"
    echo "      path:        Root folder of search"
    echo "      filename(s): Filename to search for. Comma Seperate each file with no spaces (eg. filename1,filename2,etc)."
    echo "                   All wild cards permited"
    echo "      from_date:   Search from date (including date).  Date be suplied in unix time"
    echo "      to_date:     Search to date (include date specifed). Date to be suplied in unix time" 
    echo ""
    echo "PLEASE NOTE.  Datetime must be in unix time.  For exampple run <date -d 'Apr 1 2020 13:00' +'%s'> to get unix time"
} 

function validateArgs
{
    echo "path: $search_path"

    ##check args exist or help requested
    if [ -z "$search_path" ] || [ "$search_path" = "--help" ]
    then
        help
        exit 1
    fi

    # check path exist
    if [ ! -d $search_path ]
    then
        echo "Search path $search_path does not exist."
        exit 1
    fi

    # check from date not empty
    if [ -z "$from_date" ] 
    then
        help
    
    fi
    
    #format date to be used in search parameters
    from_date="`date -d @$from_date +'%Y-%m-%d %T'`"
 
    #if above cmd fails then date format incorrect.  report and exit.
    if [ $? -gt 0 ]
    then
        echo "from_date:Incorrect Date Format"
        exit 1
 
    fi

    # check to_date exists
    if [ -z "$to_date" ]
    then
        #use current datetime stamp
        #to_date=`date +%s`
        #echo $to_date
        help
    fi

    # format date for search parameters
    to_date="`date -d @$to_date +'%Y-%m-%d %T'`"


    # if above cmd is incorrect then report and exit
    if [ $? -gt 0 ]
    then
        echo "to_date:Incorrect Date Format"
        exit 1
    fi


    #debug
    echo "check from_date: $from_date"
    echo "check to_date: $to_date"



}


function searchForFiles
{
    kount=0

    cmd="find $search_path -type f ! -newermt '$to_date' -newermt '$from_date' \( -name '${filename//[,]/\' -o -name \'}' \) # | wc -l"
    echo $cmd

    eval $cmd -ls # added for test purposes to see result
    kount=`eval $cmd | wc -l`
    
    echo "total: "$kount

    if [ $kount == 0 ] 
    then
        exit 1
    else
        exit 0

    fi
}



# main
function main
{
    validateArgs

    searchForFiles

}

# start
main

exit 1