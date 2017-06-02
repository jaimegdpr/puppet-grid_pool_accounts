# This function takes a vo and a type and returns gid of the group by parsing users.conf file
#
Puppet::Functions.create_function(:'grid_pool_accounts::get_pilot_gid') do

    dispatch :get_pilot_gid do
        param 'String', :vo
        param 'String', :filename
        param 'String', :type
    end

    def get_pilot_gid(vo, filename, type)
        gid = ''
        File.open(filename).each_line do | line |
            tmp = line.split(":")
                if tmp[4] == vo
                    if tmp[5] == type
                        if tmp[2].include? ","
                            gid = tmp[2].split(",")[0]
                        else
                            gid = tmp[2]
                        end
                    end
                end
        end
        return gid
    end

end
