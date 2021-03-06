. ../common
function Get-NameList
{
    param ( $count, $length = 1 )
    $words = (get-lorem 100).split() | sort -uniq | %{ [char]::ToUpper($_[0]) + $_.substring(1) }
    $wordcollection = get-RandomListFromList $words ($count * $length)
    for($i = 0; $i -lt $wordcollection.count; $i += $length )
    {
        $wordcollection[$i..($i+$length-1)] -join " "
    }
}
# questions will all be the same, based on the hashtable which describes the questions
$questions = @{
    MAP = "Description"
    TYPE = "Text"
    QUESTION = "What's wrong?"
    },@{
    MAP = "ContactMethod"
    TYPE = "Text"
    QUESTION = "How To Contact?"
    ANSWER = "Telephone","Telegraph","Email","MMS","Carrier Pigeon"
    },@{
    MAP = "RequiredBy"
    TYPE = "Date"
    QUESTION = "When is this needed?"
    },@{
    MAP = "Urgency"
    ANSWER = "ServiceRequestUrgencyEnum"
    QUESTION = "What is the urgency of the request?"
    TYPE = "MP ENUM List"
    },@{
    QUESTION = "Attached Document"
    MAP = ""
    TYPE = "Attachment"
    }
$blank = new-object psobject -property @{
"Category" = ""
"Service Offering" = ""
"SO Overview" = ""
"SO Description" = ""
"SO Icon" = ""
"Request Offering" = ""
"RO Description" = ""
"Question" = ""
"Answer" = ""
"Required" = ""
"Question Type" = ""
"Map" = ""
"RO Owner" = ""
"RO Icon" = ""
}
$catlog = @()
$categories = Get-NameList $random.next(4,8)
foreach($category in $categories)
{
    $SOList = Get-NameList $random.next(3,6)
    foreach ( $SO in $SOList )
    {
        $ROList = Get-NameList $random.next(5,8) 2
        foreach($RO in $ROList)
        {
            #"${category}:${sO}:${RO}"
            $catlog += new-object psobject -property @{
            "Category" = $category
            "Service Offering" = $SO
            "SO Overview" = ""
            "SO Description" = ""
            "SO Icon" = ""
            "Request Offering" = $RO
            "RO Description" = ""
            "Question" = ""
            "Answer" = ""
            "Required" = ""
            "Question Type" = ""
            "Map" = ""
            "RO Owner" = ""
            "RO Icon" = ""
            } 
        }
    }

}
$catlog | Select "Category","Service Offering","SO Overview" ,
"SO Description" ,"SO Icon" ,"Request Offering" ,"RO Description" ,
"Question" ,"Answer" ,"Required" ,"Question Type" ,"Map",
"RO Owner" ,"RO Icon" |
    convertto-csv | %{ $_ -replace '"' }|?{$_ -notmatch "^#TYPE" }