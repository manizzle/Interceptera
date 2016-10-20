#!/bin/bash
##Interceptor First stage setup gateway  host
##SecurityGuru.Ca
##Adnan Ahmad	
##

function localadaptor {
echo "Enter lan side ethernet adaptor name"
read adaptorname
echo ""
echo ""
echo "Enter subnet range ea. 192.168.99 for /24"
read subnetrange
echo ""
echo ""
echo "allow-hotplug $adaptorname" >> /etc/network/interfaces
echo "iface $adaptorname inet static" >> /etc/network/interfaces
echo "address $subnetrange.1" >> /etc/network/interfaces
echo "netmask 255.255.255.0" >> /etc/network/interfaces
echo "network $subnetrange.0" >> /etc/network/interfaces
echo "broadcast $subnetrange.255" >> /etc/network/interfaces
}

function dnsmasquerade {		
apt-get install dnsmasq
echo "interface=$adaptorname" >> /etc/dnsmasq.conf 
echo "listen-address=127.0.0.1" >> /etc/dnsmasq.conf
echo "domain=localhost.localdomain" >> /etc/dnsmasq.conf
echo "dhcp-range=$subnetrange.100,$subnetrange.200,12h" >> /etc/dnsmasq.conf

}

function ipforwarding {
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
}

function iptablessetup {
echo "iptables -t nat -A POSTROUTING -o $gatewayadaptor" -s $subnetrange.0/24 -j MASQUERADE" >> /etc/iptables.save
echo "pre-up iptables-restore < /etc/iptables.save" >> /etc/network/interfaces
}
echo "Initial Setup - Interceptor"
echo "Please select"
echo "1. Local adaptor setup"
echo "2. DNS Masquerading"
echo "3. IP forwarding"
echo "4. Iptables rules"
echo "5. Full setup"
echo  "Select the right option 1-5"
read  theoption

if [ $theoption = 0 ] ; then
echo "Please enter gatewayadaptor name ea. eth0"
read gatewayadaptor
echo "Please enter lan adaptor name ea. eth1"
read adaptorname
echo  "Please enter subnet range ea. 192.168.99"
read subnetrange

elif [ $theoption = 1 ] ; then 
localadaptor;
elif [ $theoption = 2 ] ; then
dnsmasquerade
elif [ $theoption = 3 ] ; then
ipforwarding
elif [ $theoption = 4 ] ; then 
iptablessetup
elif [ $theoption = 5 ] ; then
#add all the function here
fi
