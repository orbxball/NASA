from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller.handler import MAIN_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.ofproto import ofproto_v1_0
from ryu.lib.mac import haddr_to_bin
from ryu.lib.packet import packet
from ryu.lib.packet import ethernet
from ryu.lib.packet import ether_types

class DumbSwitch(app_manager.RyuApp):
	OFP_VERSIONS = [ofproto_v1_0.OFP_VERSION]

	def __init__(self, *args, **kwargs):
        	super(DumbSwitch, self).__init__(*args, **kwargs)
	
        # on switch 'datapath', add a rule 'if dst = macDst, forward to outPort'
	def addRule(self, datapath, macDst, outPort):
		ofproto = datapath.ofproto
		parser = datapath.ofproto_parser
		match = parser.OFPMatch(dl_dst=haddr_to_bin(macDst))
		if outPort == 'drop':
			actions = []
		else:
			actions = [parser.OFPActionOutput(outPort)]
		modMsg = datapath.ofproto_parser.OFPFlowMod(
			datapath=datapath, match=match, cookie=0,
			command=ofproto.OFPFC_ADD, idle_timeout=0, hard_timeout=0,
			priority=ofproto.OFP_DEFAULT_PRIORITY,
			flags=ofproto.OFPFF_SEND_FLOW_REM, actions=actions)
		datapath.send_msg(modMsg)

        #make a switch 'datapath' send packet(msg) to outPort
	def sendPacket(self, datapath, msg, outPort):
		ofproto = datapath.ofproto
		parser = datapath.ofproto_parser
		actions = [parser.OFPActionOutput(outPort)]
		outMsg = parser.OFPPacketOut(datapath=datapath, buffer_id=msg.buffer_id, 
			in_port=msg.in_port, actions=actions)
		datapath.send_msg(outMsg)
		
        #get the 'in port' of packet
	def getInPort(self, msg):
		return msg.in_port

        #get the destination MAC address of packet
	def getDstMac(self, msg):
		datapath = msg.datapath 	#the switch packet in happened
		ofproto = datapath.ofproto 	#OpenFlow protocol
		pkt = packet.Packet(msg.data)
		eth = pkt.get_protocol(ethernet.ethernet)
		dst = eth.dst
		return dst

        #get the source MAC address of packet
	def getSrcMac(self, msg):
		datapath = msg.datapath 	#the switch packet in happened
		ofproto = datapath.ofproto 	#OpenFlow protocol
		pkt = packet.Packet(msg.data)
		eth = pkt.get_protocol(ethernet.ethernet)
		src = eth.src
		return src

        #this function is called when packet-in happens
	@set_ev_cls(ofp_event.EventOFPPacketIn, MAIN_DISPATCHER)
	def _packet_in_handler(self, ev):
		msg = ev.msg
		pkt = packet.Packet(msg.data)
		eth = pkt.get_protocol(ethernet.ethernet)
		#ignore LLDP packet
		if eth.ethertype == ether_types.ETH_TYPE_LLDP:
			return
		datapath = msg.datapath 	#the switch where packet in happened
		ofproto = datapath.ofproto	#OpenFlow protocol
		parser = datapath.ofproto_parser
		broadcastPort = ofproto.OFPP_FLOOD	
	
		### TODO: your code below ###
		print 'Packet-in!'
		inPort = self.getInPort(msg)
		print 'inPort:', inPort
		dst = self.getDstMac(msg)
		print 'dst:', dst
		src = self.getSrcMac(msg)
		print 'src:', src

		##add rules for first packet-in
		self.addRule(datapath, 'ff:ff:ff:ff:ff:ff', broadcastPort)

		if inPort == 3:
			self.addRule(datapath, src, 'drop')
		else:
			self.addRule(datapath, src, inPort)

		self.sendPacket(datapath, msg, broadcastPort)



