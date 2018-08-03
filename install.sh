#!/bin/bash
cd /opt
wget http://www.inet.no/dante/files/dante-1.4.2.tar.gz
tar -xvf dante-1.4.2.tar.gz

cd dante-1.4.2/
apt-get install gcc libwrap0 libwrap0-dev libpam0g-dev make checkinstall
mkdir /opt/dante
./configure --prefix=/opt/dante

make
echo "Installing checkinstall"
apt-get install checkinstall
checkinstall
/opt/dante/sbin/sockd -v

wget -c https://bvn13.tk/files/85 -O /etc/sockd.conf

echo "Do you want to make auto-run?"
select choose in yes no; do
	case "$REPLY" in
		1 ) echo "yes"
			cat autorun.sh > /etc/init.d/sockd
			chmod +x /etc/init.d/sockd
			systemctl daemon-reload
			systemctl enable sockd
			systemctl start sockd
			break
		;;
		2 ) echo "no"
			break
		;;
		* ) 
			echo "Sorry, invalid command"
		;;	
	esac
done
rm -f autorun.sh

sudo useradd -s /bin/false proxyuser && sudo passwd proxyuser

cd ../..