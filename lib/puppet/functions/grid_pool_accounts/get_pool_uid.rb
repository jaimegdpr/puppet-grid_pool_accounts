# This function takes a vo and returns an array of pool account uid by parsing users.conf file 

Puppet::Functions.create_function(:'grid_pool_accounts::get_pool_uid') do

    dispatch :get_pool_uid do
        param 'String', :vo
        param 'String', :filename
    end

    def get_pool_uid(vo, filename)
        uids = Array.new()
        File.open(filename).each_line do | line |
            tmp = line.split(":")
            if tmp[4] == vo
              if tmp[5] == ""
                  uids.push(tmp[0])
              end
            end
        end
        return uids
    end

end
