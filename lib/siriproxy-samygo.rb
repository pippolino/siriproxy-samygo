require 'cora'
require 'siri_objects'
require 'pp'
require 'samygo'
require 'rpilibcec'

class SiriProxy::Plugin::SamyGo < SiriProxy::Plugin

  def initialize(config)
    #if you have custom configuration options, process them here!
    @remote = SiriSamyGo::RemoteControl.new(config["url"], config["portRest"], config["portSoap"])
    puts "[SamyGO - Initialization] url: #{@remote.url}, portRest: #{@remote.portRest}, portSoap: #{@remote.portSoap}"
    @cec = RpiLibCec::LibCec.new()
  end

  def sendKey(key)
    if (@remote.sendKey(key) >= 0)
      say 'Fatto!'
    else
      if(@cec.status_tv() == 0)
        if(key == '2')
          say 'La tv è già spenta, cosa stai cercando di fare?'
        else
          response = ask 'La tv è spenta, vuoi accenderla?' #ask the user for something

          if(response =~ /sì|si|yes/i) #process their response
            say 'Bene!'
            @cec.turnOn_tv()
          else
            say 'E allora cosa vuoi fare ...'
          end
        end
      else
        say 'Errore!'
      end
    end
  end

  listen_for /spegni tv/i do
    sendKey('2')
    request_completed
  end

  listen_for /stato tv/i do
    if @cec.status_tv() == 0
      say 'TV spenta!'
    else
      say 'TV accesa!'
    end
    request_completed
  end

  listen_for /accendi tv/i do
    if @cec.turnOn_tv() == 0
      say 'Buona Visione!'
    else
      say 'Alzati e cammina!'
    end
    request_completed
  end

  listen_for /tv muto/i do
    sendKey('15')
    request_completed
  end

  listen_for /tv volume attuale/i do
    valumeActual = @remote.getVolume()
    if (valumeActual >= 0)
      say "Volume attuale " + valumeActual.to_s()
    else
      say 'Errore!'
    end
    request_completed
  end

  listen_for /tv volume ([+-]{0,1}[0-9]{1,2})/i do |number|
    if number =~ /^[+-]{1}[0-9]{1,2}/i
      valumeActual = @remote.getVolume()
      if (valumeActual < 0)
        say "Errore!"
        request_completed
        return
      end

      number = (valumeActual + Integer(number)).to_s()
    end

    if (@remote.setVolume(number) >= 0)
      say "Fatto! Volume #{number}"
    else
      say "Errore!"
    end

    request_completed
  end

  listen_for /passa (?:a )?apple tv/i do
    sendKey('190')
    request_completed
  end

  listen_for /passa (?:a )?sky/i do
    sendKey('233')
    request_completed
  end
end