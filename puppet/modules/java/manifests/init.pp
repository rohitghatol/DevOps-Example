class java {

  require java::params
  package {'java::package':
    ensure => present,
    name   => $java::params::package,
  }

  file {'jvm::link':
    ensure  => link,
    path    => $java::params::java_path,
    target  => $java::params::java_target,
    require => Package['java::package'],
  }

  file {'java::link':
    ensure  => link,
    path    => '/usr/bin/java',
    target  => '/usr/lib/jvm/default-java/bin/java',
    require => File['jvm::link'],
  }

  file {'javac::link':
    ensure  => link,
    path    => '/usr/bin/javac',
    target  => '/usr/lib/jvm/default-java/bin/javac',
    require => File['java::link'],
  }

  file {'jps::link':
    ensure  => link,
    path    => '/usr/bin/jps',
    target  => '/usr/lib/jvm/default-java/bin/jps',
    require => File['javac::link'],
  }

}

