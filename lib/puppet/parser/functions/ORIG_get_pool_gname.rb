#
#
#
module Puppet::Parser::Functions
  newfunction(:get_pool_gname, :type => :rvalue, :doc => <<-'ENDOFDOC'
This function takes a vo and returns name of the group by parsing groups.conf file
  
ENDOFDOC
  ) do |arguments|

    require 'rubygems'
    require 'etc'
    vo = arguments[0]
    filename = arguments[1]
    gname =''

    File.open(filename).each_line do | line |
    tmp = line.split(":")
      if tmp[4] == vo
#        if tmp[5] != 'pilot'
         if tmp[5] == ''
           if tmp[3].include? ","
            gname = tmp[3].split(",")[0]  # primary group name
#           gname = tmp[3][/^(\w+?),/, 1]  # primary group name
           else
             gname = tmp[3]
           end
        end

      end
    end
    return gname
  end
end 
