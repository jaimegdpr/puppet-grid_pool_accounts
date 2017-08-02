#
#
#
module Puppet::Parser::Functions
  newfunction(:get_types_for_vo, :type => :rvalue, :doc => <<-'ENDOFDOC'
 This function takes a vo and returns an array of account types by parsing users.conf file 
ENDOFDOC
  ) do |arguments|

    require 'rubygems'
    require 'etc'
    vo = arguments[0]
    filename = arguments[1]
    types = Array.new()

    File.open(filename).each_line do | line |
        tmp = line.split(":")
        if tmp[4] == vo
            type = tmp[5]
            unless types.include? type
                types.push(type)
            end
        end
    end
    return types
end
end
