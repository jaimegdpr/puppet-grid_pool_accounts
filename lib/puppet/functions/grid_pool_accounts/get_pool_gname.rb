#This function takes a vo and returns name of the group by parsing users.conf file

Puppet::Functions.create_function(:'grid_pool_accounts::get_pool_gname') do

    dispatch :get_pool_gname do
        param 'String', :vo
        param 'String', :filename
    end

    def get_pool_gname(vo, filename)
        gname =''
        File.open(filename).each_line do | line |
            tmp = line.split(":")
            if tmp[4] == vo
                if tmp[5] == ''
                    if tmp[3].include? ","
                        gname = tmp[3].split(",")[0]  # primary group name
                    else
                        gname = tmp[3]
                    end
                end
            end
        end
        return gname
    end

end
