# This function takes a vo and a type and returns name of pilot group by parsing users.conf file

Puppet::Functions.create_function(:'grid_pool_accounts::get_pilot_gname') do

    dispatch :get_pilot_gname do
        param 'String', :vo
        param 'String', :filename
        param 'String', :type
    end

    def get_pilot_gname(vo, filename, type)
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
