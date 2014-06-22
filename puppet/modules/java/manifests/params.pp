class java::params
{
  $package     = hiera(openjdk-version)
  $java_path   = hiera(java_path)
  $java_target = '/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.55.x86_64'

}