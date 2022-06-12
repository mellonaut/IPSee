# IPSee - IP Lookup Tool
# MelloSec
# A tool I made to check your exit node / do IP lookups when playing with malware

# Checks your current IP
# Could we make this a switch, so that you either want to look up your own IP first? If not, then we go on to just do a lookup on whatever IP was passed
function Get-MyIp {
    Invoke-RestMethod -Method GET -Uri "http://ifconfig.me/ip"
}
$ip = Get-MyIp

# Makes GET request the ipapi.com API to retrieve selected information about the IP address and store it in a CustomObject
# By default this uses your public IP from above
# You can also pass any IP address to this function and retrieve the same information.
function Get-IPInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ip
    )
    $IPObject = Invoke-RestMethod -Method GET -Uri "https://ipapi.co/$ip/json"

    [PSCustomObject]@{
        IP        =  $IPObject.IP
        City      =  $IPObject.City
        Country   =  $IPObject.Country_Name
        Region    =  $IPObject.Region
        Postal    =  $IPObject.Postal
        TimeZone  =  $IPObject.TimeZone
        ASN       =  $IPObject.asn
        Owner     =  $IPObject.org
    }
}
Get-IPInfo $ip

function Check-NeutrinoBlocklist {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ip,
        [Parameter(Mandatory)]
        [string]$userId,
        [Parameter(Mandatory)]
        [string]$apiKey
    )
    $IPObject = Invoke-RestMethod -Method GET -Uri "https://neutrinoapi.net/ip-blocklist?user-id=$userId&api-key=$apiKey&ip=$ip"

    [PSCustomObject]@{

        Ip                  =  $IPObject.ip
        CIDR                =  $IPObject.cidr
        IsListed            =  $IPObject.is-listed
        IsHijacked          =  $IPObject.is-hijacked
        IsSpider            =  $IPObject.is-spider
        IsTor               =  $IPObject.is-tor
        IsProxy             =  $IPObject.is-proxy
        IsMalware           =  $IPObject.is-malware
        IsVpn               =  $IPObject.is-vpn
        IsBot               =  $IPObject.is-bot
        IsSpamBot           =  $IPObject.is-spam-bot
        IsExploitBot        =  $IPObject.is-exploit-bot
        ListCount           =  $IPObject.list-count
        Blocklists          =  $IPObject.blocklists
        LastSeen            =  $IPObject.last-seen
        Sensors             =  $IPObject.sensors
    }
}
Check-NeutrinoBlocklist $ip $userId $apiKey

# Use Neutrino API to check reputation of the IP

# Check out that Void API that basically does what you want to do, but free is limited. His is separated into smaller APIs maybe we can use both of them