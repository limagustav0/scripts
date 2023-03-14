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

with open("variables.json") as f:
    data = json.load(f)

class Report(BaseModel):
    company_ids: str
    seller_ids: str
    filename:str


if not os.path.exists("reports"):
    os.makedirs("reports")

for report_data in data:
    report = Report(**report_data)

    master_path = os.path.join("reports", f"mestres{report.filename}")
    
    period = pd.period_range(
    start=starting_year+1,
    end=f'{current_year}-{current_month-1}',
    freq='M'
    )

    month_data = ''
    for p in period:
        month_data += "\n" +  months_master_template.render(
            month=p.month,
            start_period=f"\"{p.year}-01-01\"",
            end_period=f"\"{p.year}-12-01\"",
            company_ids=report.company_ids,
            month_year=f"{month_name[p.month]}_{p.year}",
        )+"\n"
    
    master_data = master_template.render(
        company_ids=report.company_ids,
        filename=master_path,
        months_values=str(month_data),
        seller_ids=report.seller_ids,
    )

    product_path = os.path.join("reports", f"produtos{report.filename}")

    product_data = products_template.render(
        seller_ids= report.seller_ids,
        company_ids=report.company_ids,
        filename=product_path,
    )

    with open(master_path, "w") as f:
        f.write(master_data)

    with open(product_path, "w") as f:
        f.write(product_data)