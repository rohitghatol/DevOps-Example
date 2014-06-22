File['jps::link'] -> Exec['format hdfs']

node hadoop{
  include java
  include hadoop20

}


