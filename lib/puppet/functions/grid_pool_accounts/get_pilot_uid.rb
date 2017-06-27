# This function takes a vo and a type and returns an array of pilot uid by parsing users.conf file 
#
Puppet::Functions.create_function(:'grid_pool_accounts::get_pilot_uid') do

    dispatch :get_pilot_uid do
        param 'String', :vo
        param 'String', :filename
        param 'String', :type
        return_type 'Array'
    end

    def get_pilot_uid(vo, filename, type)
        uids = Array.new()
        File.open(filename).each_line do | line |
            tmp = line.split(":")
            if tmp[4] == vo
                if tmp[5] == type
                    uids.push(tmp[0])
                end
            end
        end
        return uids
    end

end
