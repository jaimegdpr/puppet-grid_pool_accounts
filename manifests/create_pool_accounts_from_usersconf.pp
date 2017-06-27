# Define: create_pool_accounts_from_usersconf
#
define grid_pool_accounts::create_pool_accounts_from_usersconf (
  $vo                      = $title,
  $users_conf              = '/etc/puppet/files/grid/users.conf',
  $create_home_dir         = true,
  $gridmapdir              = '/etc/grid-security/gridmapdir',
  $create_gridmapdir_entry = false,
) {


  # These custom functions parse file defined by $users_conf.
  # Accounts without type 
  $users         = grid_pool_accounts::get_pool_users($vo, $users_conf)
  $uids          = grid_pool_accounts::get_pool_uid($vo, $users_conf)
  $primary_group = grid_pool_accounts::get_pool_gid($vo, $users_conf)
  $primary_gname = grid_pool_accounts::get_pool_gname($vo, $users_conf)

  $uid_size  = size($uids)
  $user_size = size($users)

  $defaults = {
    manage_home             => $create_home_dir,
    primary_group           => $primary_gname,
    gridmapdir              => $gridmapdir,
    create_gridmapdir_entry => $create_gridmapdir_entry,
  }

  # Check number of UIDs and usernames
  if $uid_size == $user_size {

      # Create group
      grid_pool_accounts::pool_group { $primary_gname:
        gid => $primary_group,
      }
      
      #Create accounts
     $accounts = grid_pool_accounts::create_account_hash($users, $uids)
#     $accounts = create_account_hash($users, $uids)
     
      create_resources('grid_pool_accounts::pool_account', $accounts, $defaults)

  } else {
      notify { "create_pool_accounts_from_usersconf_error_${title}":
        message => "configuration error in ${users_conf}, UID range is not the same as account range. number of UID: ${uid_size}, number of accounts: ${user_size}",
      }
  }

  # Get account types
  $types = grid_pool_accounts::get_types_for_vo($vo, $users_conf)

  # Iterate over all account types
  $types.each |String $type| {

    if $type != "" {

      # These custom functions parse file defined by $users_conf.
      # Accounts with type
      $pilot_users   = grid_pool_accounts::get_pilot_users($vo, $users_conf, $type)
      $pilot_uid     = grid_pool_accounts::get_pilot_uid($vo, $users_conf, $type)
      $pilot_gid     = grid_pool_accounts::get_pilot_gid($vo, $users_conf, $type)
      $pilot_gname   = grid_pool_accounts::get_pilot_gname($vo, $users_conf, $type)

      $pilot_users_size = size($pilot_users)
      $pilot_uid_size = size($pilot_uid)

      if $pilot_uid_size == $pilot_users_size {

          $defaults_pilot = {
            manage_home             => $create_home_dir,
            primary_group           => $pilot_gname,
            gridmapdir              => $gridmapdir,
            create_gridmapdir_entry => $create_gridmapdir_entry,
            # Condition for special accounts without secondary group
            groups                  => $pilot_gname ? {
                $primary_gname      => undef,
                default             => $primary_gname,
            }
          }

          # Avoid creating existing groups for special accounts without secondary group
          if ! defined(Grid_pool_accounts::Pool_group[$pilot_gname]) {
              # Create group
              grid_pool_accounts::pool_group {$pilot_gname:
                gid => $pilot_gid,
              }
          }

          # Create account
          $pilot_accounts = grid_pool_accounts::create_account_hash($pilot_users, $pilot_uid)
#          $pilot_accounts = create_account_hash($pilot_users, $pilot_uid)
          create_resources('grid_pool_accounts::pool_account', $pilot_accounts, $defaults_pilot)

       } else {
              notify { "create_pool_accounts_from_usersconf_error_${title}":
                message => "configuration error in ${users_conf}, UID range is not the same as account range. number of UID: ${uid_size}, number of accounts: ${user_size}",
              }
            }
      }
  }
}
