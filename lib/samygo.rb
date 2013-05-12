require 'socket'
require 'rexml/document'

module SiriSamyGo
	class RemoteControl
		attr_accessor :url
		attr_accessor :portRest
		attr_accessor :portSoap

		def initialize(url, portRest=2345, portSoap=52235)
			self.url = url
			self.portRest = portRest
			self.portSoap = portSoap
		end

		def sendKey(key)
			sock = TCPSocket.new(url, portRest)
			sock.puts key
			sock.close
			return 0
		rescue
			return -1
		end
	
		def setVolume(volume)
			soapMessage = %&<?xml version="1.0" encoding="UTF-8"?>
<s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
<s:Body>
<ns0:SetVolume xmlns:ns0="urn:schemas-upnp-org:service:RenderingControl:1">
<InstanceID>0</InstanceID>
<Channel>Master</Channel>
<DesiredVolume>#{volume}</DesiredVolume>
</ns0:SetVolume>
</s:Body>
</s:Envelope>&

			executeSoap('SetVolume', soapMessage)
			return 0
		rescue
			return -1
		end

		def getVolume()
		soapMessage = %&<?xml version="1.0" encoding="UTF-8"?>
<s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
<s:Body>
<ns0:GetVolume xmlns:ns0="urn:schemas-upnp-org:service:RenderingControl:1">
<InstanceID>0</InstanceID>
<Channel>Master</Channel>
</ns0:GetVolume>
</s:Body>
</s:Envelope>&

			response = executeSoap('GetVolume', soapMessage)
			xmlDoc = REXML::Document.new response.body
			return Integer(REXML::XPath.match(xmlDoc, "/s:Envelope/s:Body/u:GetVolumeResponse/CurrentVolume/text()")[0].value)
		rescue
			return -1
		end
		
		private

		def executeSoap(action, soapMessage)
			http = Net::HTTP.new(url, portSoap)
			request = Net::HTTP::Post.new("/upnp/control/RenderingControl1")
			request.add_field('POST', '/upnp/control/RenderingControl1 HTTP/1.0')
			request.add_field('Content-Type', 'text/xml; charset="utf-8"')
			request.add_field('SOAPACTION', '"SoapAction:urn:schemas-upnp-org:service:RenderingControl:1#'+action+'"')
			request.add_field('Cache-Control', 'no-cache')
			request.add_field('Host', url+':'+portSoap.to_s())
			request.add_field('Content-length', soapMessage.length.to_s())
			request.add_field('Connection', 'Close')
			request.body = soapMessage
			return http.request(request)
		end
	end
end