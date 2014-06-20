class java::params
{
  $package     = hiera(openjdk-version)
  $java_path   = '/usr/lib/jvm/default-java'
  $java_target = '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64'

}