#
#
#
module Puppet::Parser::Functions
  newfunction(:get_pilot_gname, :type => :rvalue, :doc => <<-'ENDOFDOC'
 This function takes a vo and returns name of pilot group by parsing groups.conf file 
ENDOFDOC
  ) do |arguments|

    require 'rubygems'
    require 'etc'
    vo = arguments[0]
    filename = arguments[1]
    type = arguments[2]

    gname = ''
    File.open(filename).each_line do | line |
    tmp = line.split(":")
      if tmp[4] == vo
        if tmp[5] == type
          if tmp[3].include? ","
            gname = tmp[3].split(",")[0]
          else
            gname = tmp[3]
          end
        end
      end
    end
    return gname
  end
end 
