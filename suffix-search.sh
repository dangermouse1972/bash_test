#/bin/bash/
search_path=$1
filename=$2
from_date=$3
to_date=$4
echo $search_path
echo $filename
echo $from_date
echo $to_date

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
    echo ""
    echo "PLEASE NOTE.  Datetime must be in unix time.  For exampple run <date -d 'Apr 1 2020 13:00' +'%s'> to get unix time"
} 

function searchForFiles
{
    kount=0

    cmd="find $search_path -type f ! -newermt '$to_date' -newermt '$from_date' \( -name '${filename//[,]/\' -o -name \'}' \) # | wc -l"
#    cmd="find $search_path -type f  ! -mmin -$to_date \! -mmin -$from_date -name ${filename//[,]/ -o -name } | wc -l"
#     cmd="find $search_path  -newer $0.start \! -newer $0.stop -type f -name ${filename//[,]/ -o -name } | wc -l"   
    echo $cmd

    #eval $cmd

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

function validateArgs
{
    echo "$search_path"

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
    ##else
    ##    exit 0


    fi

    if [ -z "$from_date" ] 
    then
        #echo "from_date post check:"$from_date
        from_date=0

    fi
    
    from_date=`date -d @$from_date +"%Y-%m-%d %T"`
    #from_date=$(((`date +'%s'`-$from_date)/60))
    #touch -t `date -d @$from_date +%Y%m%d%H%M` $0.start



    if [ $? -gt 0 ]
    then
        echo "from_date:Incorrect Date Format"
        exit 1
    fi

    echo "$from_date"

    if [ -z "$to_date" ]
    then
        #use current datetime stamp
        to_date=`date +%s`
        echo $to_date
    fi

    to_date=`date -d @$to_date +"%Y-%m-%d %T"`
    #to_date=$(((`date +'%s'`-$to_date)/60))

    #touch -t `date -d @$to_date +%Y%m%d%H%M` $0.stop



    if [ $? -gt 0 ]
    then
        echo "to_date:Incorrect Date Format"
        exit 1
    fi

    echo "$to_date"




}

validateArgs

searchForFiles


