#This function takes an array of users and an array of UIDs and combines them in the form
#{username => {uid => $uid}}
#Usage:
#  create_account_hash([user1, user2], [1111, 1112])
#returns:
#{user1 => {uid => 1111}, user2 => {uid => 1112}}


Puppet::Functions.create_function(:'grid_pool_accounts::create_account_hash') do

    dispatch :create_account_hash do
        param 'Array', :usernames
        param 'Array', :uids
    end

    def create_account_hash
#        # Check that both args are arrays. (NOT NECCESARY)
#        unless usernames.is_a?(Array) and uids.is_a?(Array)
#          raise(Puppet::ParseError, 'create_account_hash(): Requires two arrays to work with')
#        end

        accounts = Hash.new()
        usernames.zip(uids).each do |username, uid|
            accounts[username] = Hash.new()
            accounts[username]['uid'] = uid
        end

        return accounts
    end

end
