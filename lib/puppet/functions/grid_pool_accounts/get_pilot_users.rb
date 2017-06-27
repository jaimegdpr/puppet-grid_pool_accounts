# This function takes a vo and a type and returns an array of pilot users name by parsing users.conf file 
#
Puppet::Functions.create_function(:'grid_pool_accounts::get_pilot_users') do

    dispatch :get_pilot_users do
        param 'String', :vo
        param 'String', :filename
        param 'String', :type
        return_type 'Array'
    end

    def get_pilot_users(vo, filename, type)
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
