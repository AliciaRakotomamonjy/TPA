install.packages("RJDBC", repos = "http://cran.us.r-project.org")
library(RJDBC)
hive_jdbc_jar <- "C:/Jar/hive-jdbc-3.1.3-standalone.jar" 
hive_driver <- "org.apache.hive.jdbc.HiveDriver"


hive_url <- "jdbc:hive2://localhost:10000"


drv <- JDBC(hive_driver, hive_jdbc_jar)


conn <- dbConnect(drv, hive_url, "vagrant", "")


show_tables <- dbGetQuery(conn, "show tables")


print(show_tables);
