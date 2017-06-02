# This function takes a vo and returns gid of the group by parsing users.conf file 
Puppet::Functions.create_function(:'grid_pool_accounts::get_pool_gid') do
    
    dispatch :get_pool_gid do
        param 'String', :vo
        param 'String', :filename
    end

    def get_pool_gid(vo, filename)
        gid = ''
        File.open(filename).each_line do | line |
            tmp = line.split(":")
            if tmp[4] == vo
                if tmp[5] == ''
                    if tmp[2].include? ","
                    gid = tmp[2].split(",")[0]   # primary group id
                    else
                    gid = tmp[2]
                    end
                end
            end
        end
        return gid
    end

end
