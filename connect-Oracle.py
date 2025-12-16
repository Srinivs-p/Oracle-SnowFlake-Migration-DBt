import oracledb
import os
from dotenv import load_dotenv
load_dotenv()

dbt_user_dsn = os.getenv("ORACLE_DSN")
dbt_user = os.getenv("ORACLE_DB_USER")
dbt_password = os.getenv("ORACLE_DB_PASSWORD")

dbuserpool = oracledb.SessionPool(user=dbt_user, password=dbt_password, dsn=dbt_user_dsn, min=2,
                             max=5, increment=1, encoding="UTF-8")


conn = dbuserpool.acquire()
db_run = conn.cursor()

# data = db_run.execute('select * from dual')
# for i in data:
#     print(i)