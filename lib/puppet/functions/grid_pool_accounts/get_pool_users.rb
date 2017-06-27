# This function takes a vo and returns an array of normal users  by parsing users.conf file 

Puppet::Functions.create_function(:'grid_pool_accounts::get_pool_users') do

    dispatch :get_pool_users do
        param 'String', :vo
        param 'String', :filename
        return_type 'Array'
    end

    def get_pool_users(vo, filename)
        users = Array.new()
        File.open(filename).each_line do | line |
            tmp = line.split(":")
            if tmp[4] == vo
                if tmp[5] == "" 
                    users.push(tmp[1])
                end
            end
        end
        return users
    end

end
