#!/usr/bin/env ruby

# encoding: UTF-8

require 'optparse'
require 'pry'

options = Hash.new 

opt_parser = OptionParser.new do |opt| #Declarer le parser
  opt.banner = "Usage: ruby shift_subtitle.rb --delay='delaytime' --file=subtitlefile" #declare la commande avec les options

  opt.on("--delay N", String , "Le delais de temps , positif ou negatif") do | v | #declare option delay
    options[:delay] = v
  end

  opt.on("--file N" , String , "Specifier le type de fichier en STR") do | v | #declare option du Fichier exploité par le script
    options[:file] = v
  end
end.parse! 

if options[:delay].nil?
  puts "delay time required"
  exit 0
elsif options[:file].nil? or !File.exist?(options[:file])
  puts "File not found"
  exit 0
end

 
f = File.open(options[:file], "r:ISO-8859-1")
ChangeTime = options[:delay].to_f


f.each_line do | l |

  # "01:25:15,049 --> 01:25:18,712\r\n"
  if l =~ /([0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{0,3})\s-->\s([0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{0,3})/
    prem_plage , deu_plage  = l.split(/-->/)
    h1,m1,s1 = prem_plage.split(/:/)
    s1,ms1 = s1.split(/,/)
    f = s1.to_i + m1.to_i*60 + h1.to_i*60*60 + ms1.to_i*0.001

    
    fx = f + ChangeTime
    h1x,y = fx.divmod(60*60)
    m1x,s1x = y.divmod(60)
    s1x = s1x.round(3)
    s1x,ms1x  = s1x.to_s.split('.')
    ms1x = "#{ms1x}00"
    prem_result = "#{h1x.to_s.rjust(2,'0')}:#{m1x.to_s.rjust(2,'0')}:#{s1x.to_s.rjust(2,'0')},#{ms1x}"

    h2,m2,s2 = deu_plage.split(/:/)
    s2,ms2 = s2.split(/,/)
    f = s2.to_i + m2.to_i*60 + h2.to_i*60*60 + ms2.to_i*0.001

    fx = f + ChangeTime
    h2x,y = fx.divmod(60*60)
    m2x,s2x = y.divmod(60)
    s2x = s2x.round(3)
    s2x,ms2x = s2x.to_s.split('.')
    ms2x = "#{ms2x}00"
    deux_result = "#{h2x.to_s.rjust(2,'0')}:#{m2x.to_s.rjust(2,'0')}:#{s2x.to_s.rjust(2,'0')},#{ms2x}"

    puts ("#{prem_result}--> #{deux_result}")

  else

    print l
  end
end


