class hadoop20 {

  include ::java

  require hadoop20::params

  Exec {
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/","/usr/lib/hadoop-2.2.0/bin","/usr/lib/hadoop-2.2.0/sbin" ],
    environment => ["JAVA_HOME=/usr/lib/jvm/default-java","HADOOP_PREFIX=/usr/lib/hadoop-2.2.0","HADOOP_HOME=/usr/lib/hadoop-2.2.0","HADOOP_COMMON_HOME=/usr/lib/hadoop-2.2.0","HADOOP_CONF_DIR=/usr/lib/hadoop-2.2.0/etc/hadoop","HADOOP_HDFS_HOME=/usr/lib/hadoop-2.2.0","HADOOP_MAPRED_HOME=/usr/lib/hadoop-2.2.0","HADOOP_YARN_HOME=/usr/lib/hadoop-2.2.0"]
  }

  exec { '/etc/init.d/iptables save':

  }

  exec {'/etc/init.d/iptables stop':
    require => Exec['/etc/init.d/iptables save']
  }

  exec {'chkconfig iptables off':
    require => Exec['/etc/init.d/iptables stop']
  }

  file { 'env.sh':
    ensure => present,
    path => '/etc/profile.d/env.sh',
    content=>template('hadoop20/env.sh.erb'),
    require => Exec['chkconfig iptables off']

  }

  file { 'hadoop-2.0 home dir':
    ensure => directory,
    path => $hadoop20::params::hadoop_path,
    require => File['env.sh']
  }

  exec {'hadoop-2.0::package':
    cwd => $hadoop20::params::hadoop_path,
    command => "wget $hadoop20::params::download_url",
    creates => "/usr/lib/hadoop-2.2.0.tar.gz",
    require=> File['hadoop-2.0 home dir']
  }
  exec {'untar hadoop-2.0::package':

    cwd => $hadoop20::params::hadoop_path,
    command => "tar zxvf $hadoop20::params::hadoop_archive",
    creates => "/usr/lib/hadoop-2.2.0",
    require=> Exec['hadoop-2.0::package']
  }

  file { 'hdfs-site.xml':
    ensure => present,
    path => '/usr/lib/hadoop-2.2.0/etc/hadoop/hdfs-site.xml',
    content=>template('hadoop20/hdfs-site.xml.erb'),
    require=>Exec['untar hadoop-2.0::package']
  }

  file { 'core-site.xml':
    ensure => present,
    path => '/usr/lib/hadoop-2.2.0/etc/hadoop/core-site.xml',
    content=>template('hadoop20/core-site.xml.erb'),
    require=>File['hdfs-site.xml']
  }

  file { 'yarn-site.xml':
    ensure => present,
    path => '/usr/lib/hadoop-2.2.0/etc/hadoop/yarn-site.xml',
    content=>template('hadoop20/yarn-site.xml.erb'),
    require=>File['core-site.xml']
  }

  exec { 'format hdfs':
    cwd => '/usr/lib/hadoop-2.2.0/bin',

    command => "hdfs namenode -format",
    creates => "/usr/lib/hadoop-2.2.0/hdfs",
    logoutput => on_failure,
    require=> File['yarn-site.xml']
  }

  exec { 'start namenode':
    cwd => '/usr/lib/hadoop-2.2.0/sbin',
    command => "hadoop-daemon.sh start namenode",
    logoutput => on_failure,
    require=> Exec['format hdfs']
  }

  exec { 'start datanode':
    cwd => '/usr/lib/hadoop-2.2.0/sbin',
    command => "hadoop-daemon.sh start datanode",
    logoutput => on_failure,
    require=> Exec['start namenode']
  }

  exec { 'start resource manager':
    cwd => '/usr/lib/hadoop-2.2.0/sbin',
    command => "yarn-daemon.sh start resourcemanager",
    logoutput => on_failure,
    require=> Exec['start datanode']
  }


  exec { 'start node manager':
    cwd => '/usr/lib/hadoop-2.2.0/sbin',
    command => "yarn-daemon.sh start nodemanager",
    logoutput => on_failure,
    require=> Exec['start resource manager']
  }

}
