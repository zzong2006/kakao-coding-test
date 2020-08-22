# kakao-coding-test
This is kakao coding test made by Woosung Hwang.

## docker
* Run docker
	* docker build -t mysql-custom:0.0 .
	  * If you encounter any error during build, do
	    `docker rmi -f $(docker images -f "dangling=true" -q)`
	    to remove <none> image file
	* docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag
* Change MySQL setting
  * nano /etc/mysql/my.cnf
  * docker restart container-name
* JDK : 1.8 version, Parquet : 버전 1.9 version, Hadoop : equal or more than 3.0.0 version 

## MySQL

* 느린 쿼리의 첫번째 문제는 Where절
  * 인덱스를 사용하자
    * 적절한 인덱스 생성 $\rightarrow$ 빠른 속도, but 과도한 인덱스는 업데이트에 오버헤드 발생
    * ORDER BY 절의 효율에도 영향을 미침 (e.g. B-tree Index)
  * 

