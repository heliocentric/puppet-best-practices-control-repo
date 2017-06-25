# vim: set expandtab ts=2 sw=2:
notify {"FQDN = ${::fqdn}": }

case $facts['fqdn'] {
  "puppetserver": {
    $hostgroup = "puppetserver"
  }
  "mom.test": {
    $mode = 'vagrant'
    $hostgroup = "puppetserver"
  }
  "centos7.test":{
    $mode = 'vagrant'
    $hostgroup = "test"
  }
  "win2008" : {
    $mode = 'vagrant'
  }
  "win2012" : {
    $mode = 'vagrant'
  }
  /test[0-9]+/ : {
    $hostgroup = "logagents"
  }
  default: {
    $hostgroup = "agents"
  }
}

if ($mode == 'vagrant') {
  simplib::firewall_rule { "ssh":
    proto    => "tcp",
    dports   => [ 22 ],
  }

}

if ($hostgroup == "logagents"){
  file { '/etc/pki/simp_apps':
    ensure => directory,
  }
  file { '/etc/pki/simp_apps/rsyslog':
    ensure => directory,
  }
  file { '/etc/pki/simp_apps/rsyslog/x509':
    ensure => directory,
  }
  file { '/etc/pki/simp_apps/rsyslog/x509/cacerts':
    ensure => directory,
  }
  file { '/etc/pki/simp_apps/rsyslog/x509/private':
    ensure =>  directory,
  }
  file { '/etc/pki/simp_apps/rsyslog/x509/public':
    ensure => directory,
  }
  file { "/etc/pki/simp_apps/rsyslog/x509/public/${::fqdn}.pub":
    ensure => present,
    source => 'puppet:///modules/local/public.pub',
    mode   => '0755',
    owner  => 'root',
  }
  file { "/etc/pki/simp_apps/rsyslog/x509/private/${::fqdn}.pem":
    ensure => present,
    source => 'puppet:///modules/local/private.pem',
    mode   => '0755',
    owner  => 'root',
  }
  file { '/etc/pki/simp_apps/rsyslog/x509/cacerts/cacerts.pem':
    ensure => present,
    source => 'puppet:///modules/local/cacerts.pem',
    mode   => '0755',
    owner  => 'root',
  }

  include simp_logger
  include openscap
}

if ($::osfamily == "RedHat") {
  package { 'epel-release': }
}

libkv::put("/hosts/${fqdn}", lookup("main_ipaddress", { "default_value" => $::ipaddress}))

$variable = libkv::list("/hosts")
$variable.each |$host, $ip | {
  host { $host:
    ip => $ip,
  }
}
notify{"Hostgroup = ${::hostgroup}":}

$classes = lookup("classes", { "default_value" => []})
if ($classes != []) {
  notify { "$classes": }
  $classes.include
}
$compliance_profile = 'disa_stig'
