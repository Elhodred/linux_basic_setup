#
class basic_fw(
    $sshd_port = 22
) {
    # puppet module install puppetlabs-firewall
    class { 'basic_fw::pre':
        sshd_port => $sshd_port,
    } ->
    class { 'basic_fw::post':
    }
}

