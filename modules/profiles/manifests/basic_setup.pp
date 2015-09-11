# profiles::nasic_setup.pp
class profiles::basic_setup {
    $sshd_port     = hiera('profiles::basic_setup::sshd_port')
    $default_user = hiera('profiles::basic_setup::default_user')
    $default_pwd  = hiera('profiles::basic_setup::default_pwd')
    $sshd_service = hiera('profiles::basic_setup::sshd_service')

    file_line { 'sshd_permitrootlogin':
        path    => '/etc/ssh/sshd_config',
        match   => ".?PermitRootLogin yes",
        line    => "PermitRootLogin no",
        replace => true,
        notify  => Service[$sshd_service],
    } ->
    file_line { 'sshd_config':
        path    => '/etc/ssh/sshd_config',
        match   => ".?Port ",
        line    => "Port ${sshd_port}",
        replace => true,
        notify  => Service[$sshd_service],
    } ->
    class { 'basic_fw':
        sshd_port => $sshd_port,
    }

    service { $sshd_service:
        ensure => running,
        enable => true,
    }


    # puppet module install saz-sudo
    class { '::sudo':
        purge               => false,
        config_file_replace => false,
    }

    user { $default_user:
        ensure     => 'present',
        managehome => yes,
        password   => $default_pwd,
        shell      => '/bin/bash',
    } ->
    sudo::conf { $default_user:
         content => "%${default_user} ALL=(ALL) NOPASSWD: ALL",
    }
}
