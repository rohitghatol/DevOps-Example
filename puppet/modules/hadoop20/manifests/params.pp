class hadoop20::params
{
  $download_url     = hiera(hadoop-download-url)
  $hadoop_archive = hiera(hadoop-tar-gz)
  $hadoop_path      = '/usr/lib/'
  $hadoop_home      = '${$hadoop_path}/hadoop-2.2.0'
  $hdfs_site_path   = '${$hadoop_path}/hadoop-2.2.0/etc/hadoop/hdfs-site.xml'
  $core_site_path   = '${$hadoop_path}/hadoop-2.2.0/etc/hadoop/core-site.xml'
  $yarn_site_path   = '${$hadoop_path}/hadoop-2.2.0/etc/hadoop/yarn-site.xml'
}