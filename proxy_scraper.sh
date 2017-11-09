#!/bin/bash
# HR Proxy Scraper Script
# Rebuilded By Kyxrec0n
# Demo video : youtube.com/watch?v=iXCeR_XsP6o
# USAGE: ./proxy-scraper.sh <ARGUMENT> <OPTIONS>
# ARGUMENTS: 
#	Proxy Checker - Single Proxy Check
#	        -s <IP>:<PORT>
#
#	Proxy Checker - List Scan:
#	        -x </path/to/list/of/proxies/to/check>
#
#	Sites List Scraper Session:
#		-L /path/to/list/of/proxy/pages/to/scrape
#
#	Pre-Built Scraper Sessions:
#		-P <OPTION>
#			1  = Samair.ru Free Proxy List
#			2  = Atomintersoft.com Free Proxy Lists
#			3  = Multiproxy.org Free Proxy List
#			4  = Proxz.com Free Proxy Lists
#			5  = Aliveproxy.com Free Proxy Lists
#			6  = Xroxy.com Free Proxy Lists
#			7  = Proxylists.net Free Proxy Lists
#			8  = Proxynova.com Free Proxy Lists
#			9  = Elite-proxies.blogspot.com Daily Proxy Lists
#			10 = Dailyproxylists.com Daily Proxy List
#			11 = Proxy-ip-list.com Daily Proxy Lists
#			12 = Nntime.com Free Proxy Lists
#			13 = HideMyAss.com Free Proxy Lists
#			14 = Freeproxylists.com Elite Proxy Lists
#			15 = Proxys.com.ar Free Proxy Lists
#
# EX: ./proxy-scraper.sh -L scraper-samair.lst
# EX: ./proxy-scraper.sh -P 1
# EX: ./proxy-scraper.sh -x /home/HR/scraped_proxynova_proxies.lst
# EX: ./proxy-scraper.sh -s 127.0.0.1:8080
#
# ****List should contain one link per line, each link should point to page to be scraped for proxies****
#
# Pre-requisite: parallel (not the one from moreutils package :p)
# To-Install:
# ftp://ftp.gnu.org/gnu/parallel/<latest-copy>
# ftp://ftp.gnu.org/gnu/parallel/parallel-latest.tar.bz2
#    Tested with => ftp://ftp.gnu.org/gnu/parallel/parallel-20120622.tar.bz2
# tar -jxvf parallel-<latest-copy>.tar.bz2
# cd parallel-<latest-copy>/
# ./configure && make
# sudo make install
#

# Let the magic begin....
JUNK=/tmp
LIST="$2"
PREOPT="$2"
SPROXY="$2"
SITE_LIST="$2"
STOR=$(mktemp -p "$JUNK" -t fooooobarproxyscraper.tmp.XXX)
STOR2=$(mktemp -p "$JUNK" -t fooooobarproxyscraper2.tmp.XXX)
#1=Opera, 2=Chrome, 3=FireFox, 4=IE
uagent1="Opera/9.80 (Windows NT 6.1; U; es-ES) Presto/2.9.181 Version/12.00"
uagent2="Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120427 Firefox/15.0a1"
uagent3="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1092.0 Safari/536.6"
uagent4="Mozilla/5.0 (compatible; MSIE 10.6; Windows NT 6.1; Trident/5.0; InfoPath.2; SLCC1; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 2.0.50727) 3gpp-gba UNTRUSTED/1.0"
JUDGE="https://premproxy.com/proxy-service/proxyjudge.php?send="
ATOMLINKS="
http://atomintersoft.com/proxy_list_United-States_us";
ALIVELINKS="
http://aliveproxy.com/high-anonymity-proxy-list/
http://aliveproxy.com/anonymous-proxy-list/";
XROXYLINKS="
http://www.xroxy.com/proxylist.php?port=&type=Anonymous&ssl=&country=US&latency=&reliability=&sort=reliability&desc=true&pnum=1#table
http://www.xroxy.com/proxylist.php?port=&type=Anonymous&ssl=&country=US&latency=&reliability=&sort=reliability&desc=true&pnum=2#table
http://www.xroxy.com/proxylist.php?port=&type=Anonymous&ssl=&country=US&latency=&reliability=&sort=reliability&desc=true&pnum=3#table";
PROXYIPLISTLINKS="
http://proxy-ip-list.com/free-usa-proxy-ip.html";

#First a simple Bashtrap function to handle interupt (CTRL+C)
trap bashtrap INT

bashtrap(){
	echo
	echo
	echo 'CTRL+C has been detected!.....shutting down now' | grep --color '.....shutting down now'
	rm -f "$STOR" 2> /dev/null
	rm -f "$STOR2" 2> /dev/null
	#exit entire script if called
	exit;
}
#End bashtrap()



function usage_info(){
	echo
	echo "Hood3dRob1n's Proxy Scraper Script" | grep --color -E 'Hood3dRob1n||s Proxy Scraper Script'
	echo
	echo "USAGE: $0 <ARGUMENT> <OPTIONS>" | grep --color 'USAGE'
	echo "Proxy Checker - Single IP:" | grep --color -E 'Proxy Checker||Single IP'
	echo "	-s <IP>:<PORT>"
	echo
	echo "Proxy Checker - List Scan:" | grep --color -E 'Proxy Checker||List Scan'
	echo "	-x </path/to/list/of/proxies/to/check>"
	echo
	echo "Custom Sites List Scraper Session:" | grep --color -E 'Custom Sites List Scraper Session'
	echo "	-L /path/to/list/of/proxy/pages/to/scrape"
	echo
	echo "Pre-Built Scraper Sessions:" | grep --color -E 'Pre||Built Scraper Sessions'
	echo "	-P <OPTION>"
	echo "		1  => Samair.ru Free Proxy List" | grep --color '1'
	echo "		2  => Atomintersoft.com Free Proxy Lists" | grep --color '2'
	echo "		3  => Multiproxy.org Free Proxy List" | grep --color '3'
	echo "		4  => Proxz.com Free Proxy Lists" | grep --color '4'
	echo "		5  => Aliveproxy.com Free Proxy Lists" | grep --color '5'
	echo "		6  => Xroxy.com Free Proxy Lists" | grep --color '6'
	echo "		7  => Proxylists.net Free Proxy Lists" | grep --color '7'
	echo "		8  => Proxynova.com Free Proxy Lists" | grep --color '8'
	echo "		9  => Elite-proxies.blogspot.com Daily Proxy Lists" | grep --color '9'
	echo "		10 => Dailyproxylists.com Daily Proxy Lists" | grep --color '10'
	echo "		11 => Proxy-ip-list.com Daily Proxy Lists" | grep --color '11'
	echo "		12 => Nntime.com Daily Proxy Lists" | grep --color '12'
	echo "		13 => HideMyAss.com Daily Proxy Lists" | grep --color '13'
	echo "		14 => Freeproxylists.com Elite Proxy Lists" | grep --color '14'
	echo "		15 => Proxys.com.ar Free Proxy Lists" | grep --color '15'
	echo
	echo "EX: $0 -L scraper-samair.lst" | grep --color 'EX'
	echo "EX: $0 -P 1" | grep --color 'EX'
	echo "EX: $0 -x /home/HR/scraped_proxynova_proxies.lst" | grep --color 'EX'	
	echo "EX: $0 -s 127.0.0.1:8080" | grep --color 'EX'
	echo
	echo "****List should contain one link per line, each link should point to page to be scraped for proxies****"
	exit
}
#End of usage_info()


function type_check(){
	if [ "$METH" == 1 ]; then 
		FINOUT="$SPROXY"	
	else
		FINOUT="$IP"
	fi
	case $RESP in
		transparent)
			echo "[ TRANSPARENT ] $FINOUT" | grep --color -E "\[ TRANSPARENT \]"
			echo "      [ COUNTRY: $CCODE ]" | grep --color -E "\[ COUNTRY||\]"
			echo $FINOUT >> transparent-proxies.lst 2> /dev/null
		;;
		anonymous)
			echo "[ ANON ] $FINOUT" | grep --color -E "\[ ANON \]"
			echo "    [ COUNTRY: $CCODE ]" | grep --color -E "\[ COUNTRY||\]"
			echo $FINOUT >> anonymous-proxies.lst 2> /dev/null
		;;
		high-anonymous)
			echo "[ HIGH-ANON ] $FINOUT" | grep --color -E "\[ HIGH-ANON \]"
			echo "     [ COUNTRY: $CCODE ]" | grep --color -E "\[ COUNTRY||\]"
			echo $FINOUT >> high-anonymous-proxies.lst 2> /dev/null
		;;
		*)
			echo "[BAD] $FINOUT"
		;;
	esac
}



function single_scan(){
	TARGET="$JUDGE$SPROXY"
	echo
	echo "Checking single proxy address...." | grep --color 'Checking single proxy address'
	curl --url $TARGET --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxyjudge" -A "$uagent3" -o "$STOR" 2> /dev/null
	RESP=$(awk '{ print $0 }' $STOR | cut -d'|' -f2)
	CCODE=$(awk '{ print $0 }' $STOR | cut -d'|' -f3)
	METH=1
	type_check
}
#End single_scan()



function list_scan(){
	echo
	if [ ! -r "$LIST" ]; then
		echo
		echo "Unable to read provided list file! Please check permissions or path and re-try...." | grep --color -E 'Unable to read provided list file||Please check permissions or path and re||try'
		echo
		usage_info
	fi
	echo "Preparing to check proxies from proxy list...." | grep --color 'Preparing to check proxies from proxy list'
	METH=2
	RESULTS=$(cat "$LIST" | parallel -k -j 20 curl $JUDGE{} --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null)
	echo "$RESULTS" | while read res
	do
		IP=$(echo "$res" | cut -d'|' -f1)
		RESP=$(echo "$res" | cut -d'|' -f2)
		CCODE=$(echo "$res" | cut -d'|' -f3)
		type_check
	done
}
#End list_scan()



function scraper(){
	echo
	echo "Starting proxy scraping, please hang tight - this might take a minute or two...." | grep --color -E 'Starting proxy scraping||please hang tight||this might take a minute or two'
	cat $SITE_LIST | parallel -k -j 0 -X curl {} --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' >> "$STOR" 2> /dev/null
	cat "$STOR" | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:[0-9]\{1,5\}" >> "$STOR2" 2> /dev/null
	NUMPROX=$(wc -l "$STOR2" | cut -d' ' -f1)
	cat "$STOR2" | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:[0-9]\{1,5\}" | sort | uniq > scraped_proxies.lst 2> /dev/null
	NUMPROXTOTAL=$(wc -l scraped_proxies.lst | cut -d' ' -f1)
	echo
	echo "RESULTS FROM PROXY SCRAPING:" | grep --color 'RESULTS FROM PROXY SCRAPING'
	echo "Proxies Found: $NUMPROX" | grep --color 'Proxies Found'
	cat scraped_proxies.lst
	echo
}



function pre_built_scraper(){
	case $PREOPT in
		1)
			echo
			echo "Starting Samair.ru pre-built proxy scraper, hang tight this might take a few...." | grep --color -E 'Starting Samair||ru pre||built proxy scraper||hang tight this might take a few'
			seq 1 9 | parallel -k -j 0 -X curl http://www.samair.ru/proxy/proxy-0{}.htm --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' >> "$STOR" 2> /dev/null
			seq 10 75 | parallel -k -j 0 -X curl http://www.samair.ru/proxy/proxy-{}.htm --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' >> "$STOR" 2> /dev/null
			cat "$STOR" | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:[0-9]\{1,5\}" >> "$STOR2"
			cat "$STOR2" | sort | uniq > scraped_samair_proxies.lst
			NUMPROX=$(wc -l scraped_samair_proxies.lst | cut -d' ' -f1)
			echo
			echo "RESULTS FROM PROXY SCRAPING:" | grep --color 'RESULTS FROM PROXY SCRAPING'
			echo "Proxies Found: $NUMPROX" | grep --color 'Proxies Found'
			echo
			cat scraped_samair_proxies.lst
			echo
		;;
		2)
			echo "Starting Scraper for atomintersoft.com, hang tight this might take a minute..." | grep --color -E 'Starting Scraper for atomintersoft||com||hang tight this might take a minute'
			echo "${ATOMLINKS[@]}" | parallel -k -j 0 --xapply curl {} --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://atomintersoft.com/" -A 'proxb0t' >> "$STOR" 2> /dev/null
			cat "$STOR" | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:[0-9]\{1,5\}" >> "$STOR2"
			cat "$STOR2" | sort | uniq > scraped_atomintersoft_proxies.lst
			NUMPROX=$(wc -l scraped_atomintersoft_proxies.lst | cut -d' ' -f1)
			echo
			echo "RESULTS FROM PROXY SCRAPING:" | grep --color 'RESULTS FROM PROXY SCRAPING'
			echo "Proxies Found: $NUMPROX" | grep --color 'Proxies Found'
			echo
			cat scraped_atomintersoft_proxies.lst
			echo
		;;
		3)
			echo "Starting Scraper for multiproxy.org, hang tight this might take a minute..." | grep --color -E 'Starting Scraper for multiproxy||org||hang tight this might take a minute'
			curl --url http://multiproxy.org/cgi-bin/search-proxy.pl --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A "$uagent1" > "$STOR" 2> /dev/null
			cat "$STOR" | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:[0-9]\{1,5\}" >> "$STOR2"
			cat "$STOR2" | sort | uniq > scraped_multiproxy_proxies.lst
			NUMPROX=$(wc -l scraped_multiproxy_proxies.lst | cut -d' ' -f1)
			echo
			echo "RESULTS FROM PROXY SCRAPING:" | grep --color 'RESULTS FROM PROXY SCRAPING'
			echo "Proxies Found: $NUMPROX" | grep --color 'Proxies Found'
			echo
			cat scraped_multiproxy_proxies.lst
			echo
		;;
		4)
			echo "Starting proxz.com pre-built proxy scraper, hang tight this might take a few...." | grep --color -E 'Starting proxz||com pre||built proxy scraper||hang tight this might take a few'
			seq 0 6 | parallel -k -j 0 curl http://www.proxz.com/proxy_list_high_anonymous_{}.html --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null | grep "javascript'>eval(unescape('" | sed "s/<\/td><\/tr><script type='text\/javascript'>eval(unescape('//" | sed "s/'));<\/script><noscript>Please enable javascript<\/noscript><tr><td colspan=\"3\">//" | printf $(cat - | sed 's/\\/\\\\/g;s/\(%\)\([0-9a-fA-F][0-9a-fA-F]\)/\\x\2/g') | sed 's/<\/td><td>/:/g' | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:[0-9]\{1,5\}" | sort | uniq > scraped_proxz_proxies.lst
			NUMPROX=$(wc -l scraped_proxz_proxies.lst | cut -d' ' -f1)
			echo
			echo "RESULTS FROM PROXY SCRAPING:" | grep --color 'RESULTS FROM PROXY SCRAPING'
			echo "Proxies Found: $NUMPROX" | grep --color 'Proxies Found'
			echo
			cat scraped_proxz_proxies.lst
			echo
		;;
		5)
			echo "Starting Scraper for aliveproxy.com, hang tight this might take a minute..." | grep --color -E 'Starting Scraper for aliveproxy||com||hang tight this might take a minute'
			echo "${ALIVELINKS[@]}" | parallel -k -j 0 --xapply curl {} --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://aliveproxy.com/" -A 'proxb0t' >> "$STOR" 2> /dev/null
			cat "$STOR" | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:[0-9]\{1,5\}" >> "$STOR2"
			cat "$STOR2" | sort | uniq > scraped_aliveproxy_proxies.lst
			NUMPROX=$(wc -l scraped_aliveproxy_proxies.lst | cut -d' ' -f1)
			echo
			echo "RESULTS FROM PROXY SCRAPING:" | grep --color 'RESULTS FROM PROXY SCRAPING'
			echo "Proxies Found: $NUMPROX" | grep --color 'Proxies Found'
			echo
			cat scraped_aliveproxy_proxies.lst
			echo			
		;;
		6)
			echo "Starting Scraper for xroxy.com, hang tight this might take a minute..." | grep --color -E 'Starting Scraper for xroxy||com||hang tight this might take a minute'
			echo "${XROXYLINKS[@]}" | parallel -k -j 0 curl {} --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.xroxy.com/proxylist.php" -A 'proxb0t' >> "$STOR" 2> /dev/null
			cat "$STOR" | sed 's/&port=/:/g' | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:[0-9]\{1,5\}" >> "$STOR2"	
			cat "$STOR2" | sort | uniq > scraped_xroxy_proxies.lst
			NUMPROX=$(wc -l scraped_xroxy_proxies.lst | cut -d' ' -f1)
			echo
			echo "RESULTS FROM PROXY SCRAPING:" | grep --color 'RESULTS FROM PROXY SCRAPING'
			echo "Proxies Found: $NUMPROX" | grep --color 'Proxies Found'
			echo
			cat scraped_xroxy_proxies.lst
			echo				
		;;
		7)
			echo "Starting proxylists.net pre-built proxy scraper, hang tight this might take a few...." | grep --color -E 'Starting proxylists||net pre||built proxy scraper||hang tight this might take a few'
			seq 1 10 | parallel -k -j 0 curl http://www.proxylists.net/us_{}.html --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null | grep "javascript'>eval(unescape('" | sed "s/<tr><td><script type='text\/javascript'>eval(unescape('//g" | sed "s/'));<\/script><noscript>Please enable javascript<\/noscript><\/td><td>/:/g" | sed "s/<\/td><\/tr>//g" >> "$STOR"
			seq 1 24 | parallel -k -j 0 curl http://www.proxylists.net/br_{}.html --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null | grep "javascript'>eval(unescape('" | sed "s/<tr><td><script type='text\/javascript'>eval(unescape('//g" | sed "s/'));<\/script><noscript>Please enable javascript<\/noscript><\/td><td>/:/g" | sed "s/<\/td><\/tr>//g" >> "$STOR"
			seq 1 35 | parallel -k -j 0 curl http://www.proxylists.net/cn_{}.html --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null | grep "javascript'>eval(unescape('" | sed "s/<tr><td><script type='text\/javascript'>eval(unescape('//g" | sed "s/'));<\/script><noscript>Please enable javascript<\/noscript><\/td><td>/:/g" | sed "s/<\/td><\/tr>//g" >> "$STOR"
			seq 1 2 | parallel -k -j 0 curl http://www.proxylists.net/cz_{}.html --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null | grep "javascript'>eval(unescape('" | sed "s/<tr><td><script type='text\/javascript'>eval(unescape('//g" | sed "s/'));<\/script><noscript>Please enable javascript<\/noscript><\/td><td>/:/g" | sed "s/<\/td><\/tr>//g" >> "$STOR"
			seq 1 2 | parallel -k -j 0 curl http://www.proxylists.net/nl_{}.html --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null | grep "javascript'>eval(unescape('" | sed "s/<tr><td><script type='text\/javascript'>eval(unescape('//g" | sed "s/'));<\/script><noscript>Please enable javascript<\/noscript><\/td><td>/:/g" | sed "s/<\/td><\/tr>//g" >> "$STOR"
			seq 1 2 | parallel -k -j 0 curl http://www.proxylists.net/de_{}.html --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null | grep "javascript'>eval(unescape('" | sed "s/<tr><td><script type='text\/javascript'>eval(unescape('//g" | sed "s/'));<\/script><noscript>Please enable javascript<\/noscript><\/td><td>/:/g" | sed "s/<\/td><\/tr>//g" >> "$STOR"
			seq 1 3 | parallel -k -j 0 curl http://www.proxylists.net/in_{}.html --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null | grep "javascript'>eval(unescape('" | sed "s/<tr><td><script type='text\/javascript'>eval(unescape('//g" | sed "s/'));<\/script><noscript>Please enable javascript<\/noscript><\/td><td>/:/g" | sed "s/<\/td><\/tr>//g" >> "$STOR"
			seq 1 4 | parallel -k -j 0 curl http://www.proxylists.net/ru_{}.html --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null | grep "javascript'>eval(unescape('" | sed "s/<tr><td><script type='text\/javascript'>eval(unescape('//g" | sed "s/'));<\/script><noscript>Please enable javascript<\/noscript><\/td><td>/:/g" | sed "s/<\/td><\/tr>//g" >> "$STOR"
			seq 1 5 | parallel -k -j 0 curl http://www.proxylists.net/eg_{}.html --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null | grep "javascript'>eval(unescape('" | sed "s/<tr><td><script type='text\/javascript'>eval(unescape('//g" | sed "s/'));<\/script><noscript>Please enable javascript<\/noscript><\/td><td>/:/g" | sed "s/<\/td><\/tr>//g" >> "$STOR"
			curl http://www.proxylists.net/gb_0.html --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null | grep "javascript'>eval(unescape('" | sed "s/<tr><td><script type='text\/javascript'>eval(unescape('//g" | sed "s/'));<\/script><noscript>Please enable javascript<\/noscript><\/td><td>/:/g" | sed "s/<\/td><\/tr>//g" >> "$STOR"
			curl http://www.proxylists.net/ca_0.html --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null | grep "javascript'>eval(unescape('" | sed "s/<tr><td><script type='text\/javascript'>eval(unescape('//g" | sed "s/'));<\/script><noscript>Please enable javascript<\/noscript><\/td><td>/:/g" | sed "s/<\/td><\/tr>//g" >> "$STOR"
			curl http://www.proxylists.net/au_0.html --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null | grep "javascript'>eval(unescape('" | sed "s/<tr><td><script type='text\/javascript'>eval(unescape('//g" | sed "s/'));<\/script><noscript>Please enable javascript<\/noscript><\/td><td>/:/g" | sed "s/<\/td><\/tr>//g" >> "$STOR"
			curl http://www.proxylists.net/fr_0.html --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null | grep "javascript'>eval(unescape('" | sed "s/<tr><td><script type='text\/javascript'>eval(unescape('//g" | sed "s/'));<\/script><noscript>Please enable javascript<\/noscript><\/td><td>/:/g" | sed "s/<\/td><\/tr>//g" >> "$STOR"
			curl http://www.proxylists.net/hk_0.html --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null | grep "javascript'>eval(unescape('" | sed "s/<tr><td><script type='text\/javascript'>eval(unescape('//g" | sed "s/'));<\/script><noscript>Please enable javascript<\/noscript><\/td><td>/:/g" | sed "s/<\/td><\/tr>//g" >> "$STOR"
			cat "$STOR" | while read line;
			do
				printf $(echo $line | sed 's/\\/\\\\/g;s/\(%\)\([0-9a-fA-F][0-9a-fA-F]\)/\\x\2/g') | sed "s/\");//g" >> "$STOR2" 2> /dev/null;
			done;
			cat "$STOR2" | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:[0-9]\{1,5\}" | sort | uniq > scraped_proxylists_proxies.lst
			NUMPROX=$(wc -l scraped_proxylists_proxies.lst | cut -d' ' -f1)
			echo
			echo "RESULTS FROM PROXY SCRAPING:" | grep --color 'RESULTS FROM PROXY SCRAPING'
			echo "Proxies Found: $NUMPROX" | grep --color 'Proxies Found'
			echo
			cat scraped_proxylists_proxies.lst
			echo	
		;;
		8)
			echo "Starting proxynova.com pre-built proxy scraper, hang tight this might take a few...." | grep --color -E 'Starting proxynova||com pre||built proxy scraper||hang tight this might take a few'
			seq 1 10 | parallel -k -j 0 curl http://www.proxynova.com/proxy-server-list/?p={} --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.proxynova.com/proxy-server-list/" -A 'proxb0t' 2> /dev/null | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' -e 's/          //g' | grep -A 8 "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" | awk -F'--' '{ print $1 }' | sed -e 's/.$//' -e '/^$/d' > "$STOR"
			LINE_COUNT=0
			IP=""
			PORT=""
			cat "$STOR" | while read line
			do
				LINE_COUNT=$((LINE_COUNT +1));
				if [ "$LINE_COUNT" == 1 ]; then
					IP="$line"
				fi
				if [ "$LINE_COUNT" == 2 ]; then
					PORT="$line"
					echo "$IP:$PORT"
					echo "$IP:$PORT" >> "$STOR2"
					LINE_COUNT=0
				fi
			done
			cat "$STOR2" | uniq > scraped_proxynova_proxies.lst
			NUMPROX=$(wc -l scraped_proxynova_proxies.lst | cut -d' ' -f1)
			echo
			echo "RESULTS FROM PROXY SCRAPING:" | grep --color 'RESULTS FROM PROXY SCRAPING'
			echo "Proxies Found: $NUMPROX" | grep --color 'Proxies Found'
			echo
			cat scraped_proxynova_proxies.lst
			echo
		;;
		9)
			echo
			echo "Starting elite-proxies.blogspot.com pre-built proxy scraper, hang tight this might take a few...." | grep --color -E 'Starting elite||proxies||blogspot||com pre||built proxy scraper||hang tight this might take a few'
			curl http://elite-proxies.blogspot.com/ --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:[0-9]\{1,5\}" | sort | uniq > scraped_elite-proxies-blog_proxies.lst
			NUMPROX=$(wc -l scraped_elite-proxies-blog_proxies.lst | cut -d' ' -f1)
			echo
			echo "RESULTS FROM PROXY SCRAPING:" | grep --color 'RESULTS FROM PROXY SCRAPING'
			echo "Proxies Found: $NUMPROX" | grep --color 'Proxies Found'
			echo
			cat scraped_elite-proxies-blog_proxies.lst
			echo
		;;
		10)
			echo
			echo "Starting dailyproxylists.com pre-built proxy scraper, hang tight this might take a few...." | grep --color -E 'Starting dailyproxylists||com pre||built proxy scraper||hang tight this might take a few'
			curl http://www.dailyproxylists.com/index.php/proxy-lists --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' | grep 'document.write(unescape(\"' | sed -e 's/<div id=\"phoca\-top\"><SCRIPT LANGUAGE=\"JavaScript\">document\.write(unescape(\"//g' -e 's/\"))<\/SCRIPT><\/div>//g' -e 's/^[ \t]*//;s/[ \t]*$//' | printf $(cat - | sed 's/\\/\\\\/g;s/\(%\)\([0-9a-fA-F][0-9a-fA-F]\)/\\x\2/g') | sed 's/<\/td><td class=\"cell0\">/:/g' | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:[0-9]\{1,5\}" | sort | uniq > scraped_dailyproxylists_proxies.lst
			NUMPROX=$(wc -l scraped_dailyproxylists_proxies.lst | cut -d' ' -f1)
			echo
			echo "RESULTS FROM PROXY SCRAPING:" | grep --color 'RESULTS FROM PROXY SCRAPING'
			echo "Proxies Found: $NUMPROX" | grep --color 'Proxies Found'
			echo
			cat scraped_dailyproxylists_proxies.lst
			echo
		;;
		11)
			echo "Starting Scraper for proxy-ip-list.com, hang tight this might take a minute..." | grep --color -E 'Starting Scraper for proxy||ip||list||com||hang tight this might take a minute'
			echo "${PROXYIPLISTLINKS[@]}" | parallel -k -j 0 curl {} --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:[0-9]\{1,5\}" >> "$STOR" 2> /dev/null
			cat "$STOR" | sort | uniq > scraped_proxy-ip-list_proxies.lst
			NUMPROX=$(wc -l scraped_proxy-ip-list_proxies.lst | cut -d' ' -f1)
			echo
			echo "RESULTS FROM PROXY SCRAPING:" | grep --color 'RESULTS FROM PROXY SCRAPING'
			echo "Proxies Found: $NUMPROX" | grep --color 'Proxies Found'
			echo
			cat scraped_proxy-ip-list_proxies.lst
			echo			
		;;
		12)
			echo "Starting nntime.com pre-built proxy scraper, hang tight this might take a few...." | grep --color -E 'Starting nntime||com pre||built proxy scraper||hang tight this might take a few'
			seq 1 9 | parallel -k -j 0 curl http://nntime.com/proxy-list-0{}.htm --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null | grep 'onclick=\"choice()\"' | sed -e 's/<tr class=\"[a-z]\{1,4\}\"><td><input type=\"checkbox\" name=\"c[0-9]\{1,3\}\" id=\"row[0-9]\{1,2\}\"  value=//g' -e 's/onclick="choice()\" \/><\/td><td>//g' -e 's/<script type=\"text\/javascript\">document.write(\":"/:/g' -e 's/)<\/script><\/td>//g' -e 's/\"//g' | cut -d'.' -f4-8 | sed 's/+//g' | sed 's/:/ /g' | awk -F" " '{ print ""$2":"length($3)":"$1 }' | while read line; do IP=$(echo $line | awk -F":" '{ print $1 }' | sed 's/:[a-z]\{1,6\}//g'); MINUS=$(echo $line | awk -F":" '{ print $2 }' | sed 's/:[a-z]\{1,6\}//g'); FUNK=$(echo $line | awk -F":" '{ print $3 }' | sed 's/:[a-z]\{1,6\}//g'); LENGTH=$(echo $line | awk -F":" '{ print length($3) }'); PORT=${FUNK:(LENGTH - MINUS):LENGTH}; echo "$IP:$PORT" >> "$STOR"; done;
			seq 10 12 | parallel -k -j 0 curl http://nntime.com/proxy-list-{}.htm --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.google.com/q?=proxylists" -A 'proxb0t' 2> /dev/null | grep 'onclick=\"choice()\"' | sed -e 's/<tr class=\"[a-z]\{1,4\}\"><td><input type=\"checkbox\" name=\"c[0-9]\{1,3\}\" id=\"row[0-9]\{1,2\}\"  value=//g' -e 's/onclick="choice()\" \/><\/td><td>//g' -e 's/<script type=\"text\/javascript\">document.write(\":"/:/g' -e 's/)<\/script><\/td>//g' -e 's/\"//g' | cut -d'.' -f4-8 | sed 's/+//g' | sed 's/:/ /g' | awk -F" " '{ print ""$2":"length($3)":"$1 }' | while read line; do IP=$(echo $line | awk -F":" '{ print $1 }' | sed 's/:[a-z]\{1,6\}//g'); MINUS=$(echo $line | awk -F":" '{ print $2 }' | sed 's/:[a-z]\{1,6\}//g'); FUNK=$(echo $line | awk -F":" '{ print $3 }' | sed 's/:[a-z]\{1,6\}//g'); LENGTH=$(echo $line | awk -F":" '{ print length($3) }'); PORT=${FUNK:(LENGTH - MINUS):LENGTH}; echo "$IP:$PORT" >> "$STOR"; done;
 			cat "$STOR" | sort | uniq > scraped_nntime_proxies.lst
			NUMPROX=$(wc -l scraped_nntime_proxies.lst | cut -d' ' -f1)
			echo
			echo "RESULTS FROM PROXY SCRAPING:" | grep --color 'RESULTS FROM PROXY SCRAPING'
			echo "Proxies Found: $NUMPROX" | grep --color 'Proxies Found'
			echo
			cat scraped_nntime_proxies.lst
			echo
		;;
		13)
			echo "Starting HideMyAss.com pre-built proxy scraper, hang tight this might take a few...." | grep --color -E 'Starting HideMyAss||com pre||built proxy scraper||hang tight this might take a few'
			seq 2 50 | parallel -k -j 0 curl http://www.hidemyass.com/proxy-list/{} -b "PHPSESSID=f0997g34g7qee5speh0bian143" --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.hidemyass.com/proxy-list/" 2> /dev/null | grep -A2 '<div style=\"display:none\">' | sed -e 's/<\/style>//g' -e 's/\-\-//g' -e 's/         <td>//g' -e '/^$/d' | sed -e 's/_/-/g' -e 's/<span class="[a-zA-Z\-]\{1,4\}">/~/' -e 's/<div style=\"display:none\">/~/g' -e 's/<span class=\"[a-zA-Z0-9\-]\{1,4\}\">/~/g' -e 's/<span class=\"\" style=\"\">/~/g' -e 's/<span style=\"display: inline\">/~/g' -e 's/<span style=\"display:none\">/~/g' -e 's/<\/div>//g' -e 's/<\/span>//g' -e 's/<\/td>//g' -e 's/<span>//g' -e 's/^~//g' >> "$STOR"
			LINE_COUNT=0
			IP1=""
			IP2=""
			IP3=""
			IP4=""
			PORT=""
			cat "$STOR" | while read line
			do
				LINE_COUNT=$((LINE_COUNT +1));
				if [ "$LINE_COUNT" == 1 ]; then
					IP1=$(echo $line | awk -F"~" ' { print $1 }')
					IP2=$(echo $line | awk -F"." ' { print $2 }' | sed -e 's/^~//g' | awk -F"~" ' { print $1 } ')
					IP3=$(echo $line | awk -F"." ' { print $3 }' | sed -e 's/^~//g' | awk -F"~" '{ print $1 }')
					IP4=$(echo $line | awk -F"." ' { print $4 }' | sed -e 's/^~//g')
				fi
				if [ "$LINE_COUNT" == 2 ]; then
					PCHK=$(echo $line | awk '{print length($1)}')
					if [ $PCHK -le 5 ]; then
						PORT=$(echo $line | awk '{print $1}')
					fi
					echo "$IP1.$IP2.$IP3.$IP4:$PORT" >> "$STOR2"
					LINE_COUNT=0
				fi
			done
 			cat "$STOR2" | sort | uniq > scraped_HMA_proxies.lst
			NUMPROX=$(wc -l scraped_HMA_proxies.lst | cut -d' ' -f1)
			echo
			echo "RESULTS FROM PROXY SCRAPING:" | grep --color 'RESULTS FROM PROXY SCRAPING'
			echo "Proxies Found: $NUMPROX" | grep --color 'Proxies Found'
			echo
			cat scraped_HMA_proxies.lst
			echo
		;;
		14)
			echo "Starting freeproxylists.com pre-built proxy scraper, hang tight this might take a few...." | grep --color -E 'Starting freeproxylists||com pre||built proxy scraper||hang tight this might take a few'
			curl http://www.freeproxylists.com/elite.php --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.freeproxylists.com/" -A 'proxb0t' | grep 'elite/' | sed -e 's/<a href=//g' -e 's/>detailed list #[0-9]\{1,2\}<\/a> ([0-9].[0-9A-Z]\{1,5\})//g' -e 's/>elite #[0-9]\{1,2\}<\/a> ([0-9].[0-9A-Z]\{1,5\})//g' -e "s/'//g" > "$STOR"
			BASE="http://www.freeproxylists.com/load_"
			cat "$STOR" | sed 's/\//_/g' | while read line
			do
				LINK="$BASE$line"
				curl $LINK --header "Content-Type: text/xml" --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.freeproxylists.com/elite.php" -A 'proxb0t' | sed -e 's/&lt;/</g' -e 's/&gt;/>/g' -e 's/<\/td><td>/:/g' | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:[0-9]\{1,5\}" >> "$STOR2"
			done
 			cat "$STOR2" | sort | uniq > scraped_freeproxylists_proxies.lst
			NUMPROX=$(wc -l scraped_freeproxylists_proxies.lst | cut -d' ' -f1)
			echo
			echo "RESULTS FROM PROXY SCRAPING:" | grep --color 'RESULTS FROM PROXY SCRAPING'
			echo "Proxies Found: $NUMPROX" | grep --color 'Proxies Found'
			echo
			cat scraped_freeproxylists_proxies.lst
			echo

		;;
		15)
			echo "Starting proxys.com.ar pre-built proxy scraper, hang tight this might take a few...." | grep --color -E 'Starting proxys||com||ar pre||built proxy scraper||hang tight this might take a few'
			curl "http://www.proxys.com.ar/index.php?act=list&port=&type=&country=&page=[1-5]" --retry 2 --retry-delay 3 --connect-timeout 3 --no-keepalive -s -e "http://www.proxys.com.ar/" -A 'proxb0t' 2> /dev/null | grep -B5 "<td><a href=\"index.php?act=whois&ip=" >> "$STOR"
			count=1
			cat "$STOR" | while read line
			do
				if [ "$count" -le 2 ]; then
					echo $line | sed -e 's/<td>//' -e 's/<\/td>//' >> "$STOR2"
				fi
				if [ "$count" == 7 ]; then
					count=0
				fi
				count=$((count +1))
			done
			count=1
			cat "$STOR2" | while read pieces
			do
				if [ "$count" == 1 ]; then				
					IP="$pieces"
				elif [ "$count" == 2 ]; then
					PORT="$pieces"
					count=0
					echo "$IP:$PORT" >> "$STOR"
				fi
				count=$((count +1))
			done
 			cat "$STOR" | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}:[0-9]\{1,5\}" | sort | uniq > scraped_proxys-ar_proxies.lst
			NUMPROX=$(wc -l scraped_proxys-ar_proxies.lst | cut -d' ' -f1)
			echo
			echo "RESULTS FROM PROXY SCRAPING:" | grep --color 'RESULTS FROM PROXY SCRAPING'
			echo "Proxies Found: $NUMPROX" | grep --color 'Proxies Found'
			echo
			cat scraped_proxys-ar_proxies.lst
			echo			
		;;
		*)
			echo
			echo "Unrecognized option provided! Check usage and try again...." | grep --color -E 'Unrecognized option provided||Check usage and try again'
			echo
			usage_info
		;;
	esac
}



# MAIN-----------------------------------------------------
clear
if [ -z "$1" ] || [ "$1" == '-h' ] || [ "$1" == '--help' ]; then
	usage_info
fi
while getopts ":s:x:L:P:" usage_options; 
do
	case $usage_options in
		L)
			scraper
		;;
		P) 
			pre_built_scraper
		;;
		s)
			single_scan
		;;
		x) 
			list_scan
		;;
		*)
			usage_info
		;;
	esac
done

rm -f "$STOR" 2> /dev/null
rm -f "$STOR2" 2> /dev/null
#EOF