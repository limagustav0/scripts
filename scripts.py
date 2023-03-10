from jinja2 import FileSystemLoader, Environment
import pandas as pd
from calendar import month_name
from datetime import datetime
from constants import starting_year, current_year, current_month
from pydantic import BaseModel
import json
import os


loader = FileSystemLoader("templates")
env = Environment(loader=loader)
months_master_template = env.get_template("months_master.sql")
master_template =  env.get_template("master.sql")
products_template = env.get_template("porducts.sql")

period = pd.period_range(
    start=starting_year+1,
    end=f'{current_year}-{current_month-1}',
    freq='M'
)

month_data = ''
for p in period:
    #month master sql

    month_data += "\n" +  months_master_template.render(
        #print(f"{month_name[p.month]} {p.year}"),
        month=p.month,
        start_period=f"\"{p.year}-01-01\"",
        end_period=f"\"{p.year}-12-01\"",
        company_ids=str((6)),
        month_year=f"{month_name[p.month]}_{p.year}",
    )+"\n"




#mastersql
master_data = master_template.render(
    company_ids=str((6)),
    months_values=str(month_data),
    seller_ids=str(((211,212,213,222,233,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,320,321,322,323,364,365,371,383))),
    filename=f"mestres_{{filename}}"
)


product_data = products_template.render(
    seller_ids= str((211,212,213,222,233,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,320,321,322,323,364,365,371,383)),
    company_ids=str((6)),
    filename="mestres_rj"
)

with open("variables.json") as f:
    data = json.load(f)


if not os.path.exists("pasta_teste"):
    os.makedirs("pasta_teste")

# for var in range (0,len(data)):
    # master_data = master_template.render(
    #     company_ids=data[var]["company_ids"],
    #     filename=f"mestres_{data[var]['filename']}",
    #     months_values=str(month_data),
    #     seller_ids=data[var]["seller_ids"],
    # )

    # product_data = products_template.render(
    #     seller_ids= data[var]["seller_ids"],
    #     company_ids= data[var]["company_ids"],
    #     filename="mestres_rj"
    # )

    # file_path = os.path.join("pasta_teste", f"arquivo_{var}.sql")
    
    # with open(file_path, "w") as file:
    #     file.write(master_data)


class Report(BaseModel):
    company_ids: str
    seller_ids: str
    filename:str

# for report_data in data:
#     report = Report(**report_data)

#     master_data = master_template.render(
#         company_ids=report.company_ids,
#         filename=f"mestres_{report.filename}",
#         months_values=str(month_data),
#         seller_ids=report.seller_ids,
#     )

#     product_data = products_template.render(
#         seller_ids= report.seller_ids,
#         company_ids=report.company_ids,
#         filename=f"produtos_{report.filename}",
#     )


if not os.path.exists("reports"):
    os.makedirs("reports")

for report_data in data:
    report = Report(**report_data)

    # Define the path where the master file should be saved
    master_path = os.path.join("reports", f"mestres{report.filename}")

    master_data = master_template.render(
        company_ids=report.company_ids,
        filename=master_path,
        months_values=str(month_data),
        seller_ids=report.seller_ids,
    )

    # Define the path where the product file should be saved
    product_path = os.path.join("reports", f"produtos{report.filename}")

    product_data = products_template.render(
        seller_ids= report.seller_ids,
        company_ids=report.company_ids,
        filename=product_path,
    )

    # Save the files in the specified paths
    with open(master_path, "w") as f:
        f.write(master_data)

    with open(product_path, "w") as f:
        f.write(product_data)