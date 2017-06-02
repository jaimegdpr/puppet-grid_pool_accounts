# This function takes a vo and returns an array of account types by parsing users.conf file 

Puppet::Functions.create_function(:'grid_pool_accounts::get_types_for_vo') do

    dispatch :get_types_for_vo do
        param 'String', :vo
        param 'String', :filename
    end

    def get_types_for_vo(vo, filename)
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
