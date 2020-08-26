# kakao-coding-test
This is kakao coding test made by Woosung Hwang.

* JDK : 1.8 version, Parquet : 버전 1.9 version, Hadoop : 3.2.1
* MySQL : equal or more than 8.0.0 version (`WITH` clause 사용을 위해 필수)

## 문제 4 (problem4/kakaotest04)

* JAVA 프로그램 :  `problem04/kakaotest04/out/artifacts/kakaotest04_jar/kakaotest04.jar`

* 프로그램 프로젝트 경로 (intellij-idea-community 로 maven project 생성 후 artifact build)
  : `problem04/kakaotest04/`

* 주요 class 

  * SQLToParquet : 주어진 MySQL 데이터를 Parquet 데이터로 변환
    * 변환 결과 : `problem04/parquet_output/`
    * 실행 시 출력 결과 : `problem04/kakaotest04_SQLToParquet_실행_결과.output`
    * 소스 경로 : `problem04/kakaotest04/src/main/java/com/kakaotest/sqlparquet/SQLToParquet.java`
  * ParquetToText : 변환된 Parquet 데이터를 Text 데이터 변환 (올바르게 변환되었는지 확인용)
    * 변환 결과 : `problem04/text_output/`
    * 실행 시 출력 결과 : `problem04/kakaotest04_ParquetToText_실행_결과.output`
    * 소스 경로 : `problem04/kakaotest04/src/main/java/com/kakaotest/sqlparquet/ParquetToText.java`
  * 단위 테스트용 클래스 `SQLToParqeutTest`포함
    * 경로 : `problem04/kakaotest04/src/test/java/com/kakaotest/sqlparquet/SQLToParquetTest.java`

* 실행 방법

  1. Hadoop 클러스터 실행 (테스트 환경: 단일 JVM의 Pseudo-Distributed Operation)
  2. `problem4/kakaotest04/tempJson.json` 을 자신의 환경에 맞춰서 수정
  3. `problem4/kakaotest04`으로 접근 후, 아래의 명령어를 실행

  * MySQL DB를 Parquet으로 변환
    * `yarn jar ${kakao-coding-test_folder_path}/problem04/kakaotest04/out/artifacts/kakaotest04_jar/kakaotest04.jar com.kakaotest.sqlparquet.SQLToParquet tempJson.json`

  * 변환된 Parquet 데이터를 Text File로 변환
    * `yarn jar ${kakao-coding-test_folder_path}/problem04/kakaotest04/out/artifacts/kakaotest04_jar/kakaotest04.jar com.kakaotest.sqlparquet.ParquetToText tempJson.json ${output_path}`

* `com.mysql.cj.jdbc.Driver` 에러 발생시 (Ubuntu 환경 기준)

  * `utils/mysql-connector-java-8.0.21.jar` 파일을 `$JAVA_HOME/jre/lib/ext/`로 복사

* 참고 사항

  * `ParquetWriter`는 thread-safe하지 않음
    * https://stackoverflow.com/questions/31909636/can-parquet-support-concurrent-write-operations
    * `json`파일 (`problem4/kakaotest04/tempJson.json`)의 concurrency 값이 2이상이면 multi-threading map 가능
      * 하지만 parquet으로 변환되는 MySQL 레코드의 순서가 달라짐
      * ParquetToText 결과 `problem04/text_output/`를 통해 확인가능

  