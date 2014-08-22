#!/usr/bin/env ruby

# Tool to decode F5 Big IP balancer cookies from:
# - A single IP in the argument
# - A file with the list of cookies to decode
# TODO: - A dump of burp requests
# 
# Decoding method described in http://blog.secureideas.com/2013/02/decoding-f5-cookie.html

require 'optparse'

def parseOptions()
    options = {:codefile => nil,:code => nil,:genericfile => nil,:verbose => false}
    optparse = OptionParser.new do|opts|   
        opts.banner = "Usage: #{__FILE__} [options]"   
        opts.on( '-v', '--verbose', 'Output more information' ) do     
            options[:verbose] = true
        end
        opts.on( '-c F5CODE', '--code F5CODE', 'Decode a single F5 code found inside a cookiei (format is like 1942628072.27950.0000)' ) do |code|
            options[:code] =  code
        end    
        opts.on( '-f CODEFILE', '--codefile CODEFILE', 'A file wit a list of codes with the F5 format separated by \\n' ) do|codefile|     
            options[:codefile] = codefile
        end     
        opts.on( '-g GENERICFILE', '--genericfile GENERICFILE', 'A file with a lot of text where to find F5 codes to decode' ) do|gfile|     
            options[:genericfile] = gfile
        end   
        opts.on( '-h', '--help', 'Display this screen' ) do     
            puts opts
            exit   
        end
    end 
    optparse.parse!
    return options
end

def decodeCookie(c)
    ip=port=""

    dip = c.split(".")[0].to_i.to_s(16).strip
    dport = c.split(".")[1].to_i.to_s(16).strip

    m = /(.{1,2})(.{2})(.{2})(.{2})/.match(dip)
    # rdip = (/(.{1,2})(.{2})(.{2})(.{2})/,"#{$4} #{$3} #{$2} #{$1}")
    rdip = "#{m[4]}.#{m[3]}.#{m[2]}.#{m[1]}"
    m = /(.{2})(.{2})/.match(dport)
    rdport = "#{m[2]}#{m[1]}"

    rdip.split(".").each{|o| ip +="#{o.to_i(16)} "}
    ip.strip!.gsub!(" ",".")
    port = rdport.to_i(16)

    return ip,port 
end

#############

def cleanCookie(c)
    c.scan(/\d{9,15}\.\d{3,6}\.0000/)
end

########
# MAIN #
########
cookie = ARGV[0]

options = parseOptions()

if !options[:code].nil?
    ip,port = decodeCookie(options[:code])
    puts "#{options[:code]} ==> #{ip}:#{port}"
elsif !options[:codefile].nil?
    if File.exist?(options[:codefile])
        f = File.open(options[:codefile],"r")
        f.each{|code|
            ip,port = decodeCookie(code)
            puts "#{code.strip} ==> #{ip}:#{port}"
        }
        f.close
    else
        $stderr.puts "Specified file #{options[:codefile]} does not exists."
        exit(1)
    end
elsif !options[:genericfile].nil?
    if File.exist?(options[:genericfile])
        f = File.open(options[:genericfile],"r")
        puts "Scanning the text file for F5 cookies..."
        codes = f.read.scan(/\d{9,15}\.\d{3,6}\.0000/)
        codes.each{|code|
            ip,port = decodeCookie(code)
            puts "#{code} ==> #{ip}:#{port}"
        }
        f.close
    else
        $stderr.puts "Specified file #{options[:genericfile]} does not exists."
        exit(1)
    end
else
    puts "Don't know what did you ordered me. Bye!"
    exit(1)
end

if cookie.nil?
    $stderr.puts "Usage: #{__FILE__} <f5_cookie>"
    exit(1)
end

cookies = cleanCookie(cookie)
cookies.each{|f5c|
    ip,port = decodeCookie(f5c)
    puts "#{cookie} ==> #{ip}:#{port}"
}
