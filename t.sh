mkdir -p /home/proxy
chmod ugo+x /home/proxy/*
#Make live proxy list 
cd /home/proxy/
indexhost=$(echo $HOSTNAME | sed 's/[^0-9]*//g')
if [ $indexhost -eq 1 ]
   then
        #Push to github
        git init
        git remote add origin https://github.com/FulbrightNguyen/proxy.git
        git remote set-url origin https://fulbrightnguyen:Tomorrow_86\!@github.com/FulbrightNguyen/proxy.git
        git config --global user.email "fulbrightnguyen@gmail.com"
#	git add .
#	git pull --rebase origin master
#	git fetch origin # git checkout master
#        git pull
#	git merge origin master
#	git pull origin master
        git add .
	git commit -m "OK"
	git push -u origin master --force
        
        #Configuring proxychains and proxies
        #set dynamic_chain
        sed -i -e "s@\#dynamic_chain@dynamic_chain@g" /etc/honeycomb01.conf
        sed -i -e "s@\#dynamic_chain@dynamic_chain@g" /etc/honeycomb02.conf
        sed -i -e "s@\#dynamic_chain@dynamic_chain@g" /etc/honeycomb03.conf
        
        #Remove all old proxy line in proxychains.conf
        sed -i.bak "/^socks4/d" /etc/honeycomb01.conf
        sed -i.bak "/^socks4/d" /etc/honeycomb02.conf
        sed -i.bak "/^socks4/d" /etc/honeycomb03.conf
        sed -i.bak "/^http/d" /etc/honeycomb01.conf
        sed -i.bak "/^http/d" /etc/honeycomb02.conf
        sed -i.bak "/^http/d" /etc/honeycomb03.conf
        
        #Allot liveproxy to proxychains.conf
        
        begin=$indexhost
        let "next1 = begin + 5 - 1"
        let "next2 = next1 + 1"
        let "next3 = next2 + 5 -1"
        let "next4 = next3 + 1"
        end=$((indexhost + 15 -1))
        sed -n "$begin,$next1 p" liveproxy.lst >> /etc/honeycomb01.conf
        sed -n "$next2,$next3 p" liveproxy.lst >> /etc/honeycomb02.conf
        sed -n "$next4,$end p" liveproxy.lst >> /etc/honeycomb03.conf
   else
        git init
        git remote add origin https://github.com/FulbrightNguyen/proxy.git
        git remote set-url origin https://fulbrightnguyen:Tomorrow_86\!@github.com/FulbrightNguyen/proxy.git
        git config --global user.email "fulbrightnguyen@gmail.com"
        git pull origin master
        
        #Configuring proxychains and proxies
        #set dynamic_chain
        
        sed -i -e "s@\#dynamic_chain@dynamic_chain@g" /etc/honeycomb01.conf
        sed -i -e "s@\#dynamic_chain@dynamic_chain@g" /etc/honeycomb02.conf
        sed -i -e "s@\#dynamic_chain@dynamic_chain@g" /etc/honeycomb03.conf     
        
        #Remove all old proxy line in proxychains.conf
        sed -i.bak "/^socks4/d" /etc/honeycomb01.conf
        sed -i.bak "/^socks4/d" /etc/honeycomb02.conf
        sed -i.bak "/^socks4/d" /etc/honeycomb03.conf
        sed -i.bak "/^http/d" /etc/honeycomb01.conf
        sed -i.bak "/^http/d" /etc/honeycomb02.conf
        sed -i.bak "/^http/d" /etc/honeycomb03.conf
        
        #Allot liveproxy to proxychains.conf
        
        begin=$indexhost
        let "next1 = begin + 5 - 1"
        let "next2 = next1 + 1"
        let "next3 = next2 + 5 -1"
        let "next4 = next3 + 1"
        end=$((indexhost + 15 -1))
        sed -n "$begin,$next1 p" liveproxy.lst >> /etc/honeycomb01.conf
        sed -n "$next2,$next3 p" liveproxy.lst >> /etc/honeycomb02.conf
        sed -n "$next4,$end p" liveproxy.lst >> /etc/honeycomb03.conf

fi
