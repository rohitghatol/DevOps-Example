class java {
  require java::params
  package {'java::package':
    ensure => present,
    name   => $java::params::package,
  }

  file {'java::link':
    ensure  => link,
    path    => $java::params::java_path,
    target  => $java::params::java_target,
    require => Package['java::package'],
  }

}

