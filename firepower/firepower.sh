#!/bin/bash


#dodac ?country_id=
#https://www.globalfirepower.com/
declare -a list=(
hungary
albania
austria
belgium
belarus
bosnia-and-herzegovina
bulgaria
croatia
montenegro
czech-republic
estonia
finland
greece
spain
netherlands
ireland
canada
kazakhstan
lithuania
latvia
macedonia
moldova
germany
norway
poland
portugal
russia
romania
serbia
slovakia
slovenia
switzerland
sweden
turkey
united-states-of-america
united-kingdom
italy
denmark
ukraine
france
)
COUNTRY=""
#sort
sorted=()
readarray -td '' sorted < <(printf '%s\0' "${list[@]}" | sort -z)

function country
{
curl "https://www.globalfirepower.com/country-military-strength-detail.asp?country_id=$COUNTRY" > input.html

cat input.html | grep "span class" | grep -v "openNav"| grep -v "textBold" | grep -v "textNormal" | grep -v "textSmall2" | grep textWhite | perl -ne 'print if not /textWhite/ && /textLtrGray/ or /%/' | awk -F"[<>]" '{print $3}' > intermediate.txt
    
echo "$COUNTRY" | cat - intermediate.txt > temp && mv temp intermediate.txt

#this strips string out of data (might be useful)
sed -i -e 's/\(bbl\|(est\.)\|km\|usd\|(LANDLOCKED)\|\$\|,\)//g' intermediate.txt
    
cat intermediate.txt | awk 'BEGIN {ORS="\t"}; {print};END {ORS="\n"; print ""}' >> countries.csv
rm intermediate.txt
rm input.html
}

printf "country\ttotal population\t availablemanpower\t fitforservice\t reachingmilitaryage\t total military power \t active personel\t reservepersonel\t paramilitary\t TOTAL AIRFORCE \t fighters\t dedicated attack\t transports\t trainers \t special mission \t tanker fleet \t helicopters \t attack helicopters\t tanks \t armored vehicles \t selfpropeled artilery\t tower artilery \t rocketprojectors \t TOTALNAVAL \t aircraft carriers \t helicopter carrier\t destroyer \t frigates\t corvetes \t submarines \t patrol \t minewarfare\t oil production \t oil consumption \t proven oil reserves\t labor force\t mechanr marine\t ports and terminals \t roadwaycoverage \t railway coverage \t servicable airports \t defense budget \t external debt \t res of foureign exchange/gold \t purchasing power parity\t square land area \t coastline coverage \t shared borders \t usable waterways\n" > countries.csv





# Read the array values with space
for val in "${sorted[@]}"; do
    echo $val
    COUNTRY=$val
    country
done







