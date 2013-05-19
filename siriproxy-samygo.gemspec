# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-samygo"
  s.version     = "0.0.3" 
  s.authors     = ["Federico Soldani"]
  s.email       = ["pippo@daemon-ware.com"]
  s.homepage    = "http://www.daemon-ware.com"
  s.summary     = %q{Remote TV controller for SamyGo}
  s.description = %q{This is a remote TV controller plugin for SamyGo. }

  s.files         = `git ls-files 2> /dev/null`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/* 2> /dev/null`.split("\n")
  s.executables   = `git ls-files -- bin/* 2> /dev/null`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"

  s.add_runtime_dependency "siriproxy", ">= 0.5.4"
end
