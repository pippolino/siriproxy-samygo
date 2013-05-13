module RpiLibCec
	class LibCec

		def turnOn_tv
			return execCommand('echo "on 0000" | cec-client -d 1 -s "standby 0" RPI', 'opening a connection to the CEC adapter')
		end

		def standby_tv
			return execCommand('echo "standby 0000" | cec-client -d 1 -s "standby 0" RPI', 'opening a connection to the CEC adapter')
		end

		def status_tv
			return execCommand('echo "pow 0000" | cec-client -d 1 -s "standby 0" RPI', 'power status: standby')
		end

	private

		def execCommand(command, outputToSearch)
			if %x(#{command}).include? "#{outputToSearch}"
				return 0
			else
				return 1
		  end
	  end
  end
end