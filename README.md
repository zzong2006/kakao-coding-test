# kakao-coding-test
This is kakao coding test made by Woosung Hwang.

## docker
* Run docker
	* `docker build -t mysql-custom:0.0 .`
	  * If you encounter any error during build, do
	    `docker rmi -f $(docker images -f "dangling=true" -q)`
	    to remove <none> image file
	* `docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag`
	  * Example) `docker run –-name mysql-test -e MYSQL_ROOT_PASSWORD=1234 -d mysql-custom:0.0`
	  * 
* Change MySQL setting
  * nano /etc/mysql/my.cnf
  * docker restart container-name
* JDK : 1.8 version, Parquet : 버전 1.9 version, Hadoop : equal or more than 3.0.0 version 

* 

## 문제 4

* `com.mysql.cj.jdbc.Driver` 에러 발생시 (Ubuntu 환경 기준)
  * Util 폴더의  `mysql-connector-java-8.0.21.jar` 파일을 `$JAVA_HOME/jre/lib/ext/`로 복사
  * 