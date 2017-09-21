# Class: prometheus::kafka_zookeeper_exporter
#
# This module manages the kafka zookeeper prometheus exporter: https://github.com/cloudflare/kafka_zookeeper_exporter
#
# Parameters:
# ['zk_nodes']
# Zookeeper nodes to query for metrics about your Kafka cluster
#
# ['chroot']
# The ZK node to query, example: '/kafka/cluster'
#
# ['topics']
# The specific topics to aggregate metrics for, leave empty if you want all the metrics
#
# ['init_style']
# Only systemd is currently supported
class prometheus::kafka_zookeeper_exporter(
  $zk_nodes     = undef,
  $chroot       = undef, 
  $topics       = undef,
  $download_url = undef,
  
  $arch                 = $::prometheus::params::arch,
  $bin_dir              = $::prometheus::params::bin_dir,
  $download_extension   = $::prometheus::params::process_exporter_download_extension,
  $download_url_base    = $::prometheus::params::process_exporter_download_url_base,
  $extra_groups         = $::prometheus::params::process_exporter_extra_groups,
  $config_mode          = $::prometheus::params::config_mode,
  $group                = $::prometheus::params::process_exporter_group,
  $init_style           = $::prometheus::params::init_style,
  $install_method       = $::prometheus::params::install_method,
  $manage_group         = true,
  $manage_service       = true,
  $manage_user          = true,
  $os                   = $::prometheus::params::os,
  $package_ensure       = $::prometheus::params::process_exporter_package_ensure,
  $package_name         = $::prometheus::params::process_exporter_package_name,
  $purge_config_dir     = true,
  $restart_on_change    = true,
  $service_enable       = true,
  $service_ensure       = 'running',
  $user                 = $::prometheus::params::process_exporter_user,
  $version              = $::prometheus::params::process_exporter_version,
  $config_path          = $::prometheus::params::process_exporter_config_path,
) inherits prometheus::params {
 $real_download_url = pick($download_url,"${download_url_base}/download/v${version}/${package_name}-${version}.${os}-${arch}.${download_extension}")
  validate_bool($purge_config_dir)
  validate_bool($manage_user)
  validate_bool($manage_service)
  validate_bool($restart_on_change)
  
  $notify_service = $restart_on_change ? {
    true    => Service['kafka_zookeeper_exporter'],
    default => undef,
  }

  prometheus::daemon { 'kafka_zookeeper_exporter':
    install_method     => $install_method,
    version            => $version,
    download_extension => $download_extension,
    os                 => $os,
    arch               => $arch,
    real_download_url  => $real_download_url,
    bin_dir            => $bin_dir,
    notify_service     => $notify_service,
    package_name       => $package_name,
    package_ensure     => $package_ensure,
    manage_user        => $manage_user,
    user               => $user,
    extra_groups       => $extra_groups,
    group              => $group,
    manage_group       => $manage_group,
    purge              => $purge_config_dir,
    init_style         => $init_style,
    service_ensure     => $service_ensure,
    service_enable     => $service_enable,
    manage_service     => $manage_service,
  }
}
