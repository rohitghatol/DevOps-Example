class hadoop20::params
{
  $download_url     = hiera(hadoop-download-url)
  $hadoop_path   = '/usr/lib/hadoop-2.0'
  $hadoop_archive = hiera(hadoop-tar-gz)
}