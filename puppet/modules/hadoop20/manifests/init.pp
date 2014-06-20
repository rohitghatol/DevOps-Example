class hadoop20 {
  require hadoop20::params
  file { 'hadoop-2.0 home dir':
    ensure => directory,
    path => $hadoop20::params::hadoop_path
  }
  exec {'hadoop-2.0::package':
    path => "/usr/bin",
    cwd => $hadoop20::params::hadoop_path,
    command => "wget $hadoop20::params::download_url",
    require=> File['hadoop-2.0 home dir']
  }
  exec {'untar hadoop-2.0::package':
    path => "/bin",
    cwd => $hadoop20::params::hadoop_path,
    command => "tar zxvf $hadoop20::params::hadoop_archive",
    require=> Exec['hadoop-2.0::package']
  }

}
