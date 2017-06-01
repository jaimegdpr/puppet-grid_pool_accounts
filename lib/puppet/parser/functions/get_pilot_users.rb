#
#
#
module Puppet::Parser::Functions
  newfunction(:get_pilot_users, :type => :rvalue, :doc => <<-'ENDOFDOC'
 This function takes a vo and returns an array of pilot users name by parsing groups.conf file 
ENDOFDOC
  ) do |arguments|

    require 'rubygems'
    require 'etc'
    vo = arguments[0]
    filename = arguments[1]
    type = arguments[2]

    users = Array.new()
    File.open(filename).each_line do | line |
    tmp = line.split(":")
    if tmp[4] == vo
      if tmp[5] == type
        users.push(tmp[1])
      end
    end
    end
    return users
  end
end 
