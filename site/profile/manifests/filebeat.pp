class profile::filebeat (
	String $config_file_path = "puppet:///modules/profile/config.yml",
) {
	notify { "config file is ${config_file_path}": }
}
