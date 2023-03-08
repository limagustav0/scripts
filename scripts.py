from jinja2 import FileSystemLoader, Environment
import pandas as pd
from calendar import month_name
from datetime import datetime
from constants import starting_year, current_year, current_month

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

print(period)

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
    estate="RJ",
    filename=f"mestres_{filename}"
)


product_data = products_template.render(
    seller_ids= str((211,212,213,222,233,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,320,321,322,323,364,365,371,383)),
    company_ids=str((6)),
    start_period=str(("2020-01-01")),
    filename="mestres_rj"
)


class Script:
    def __init__(self, month, start_period, end_period, company_ids, month_year, months_values, seller_ids, estate, filename):
        self.month = month
        self.start_period = list(start_period)
        self.end_period = end_period
        self.company_ids = list(company_ids)
        self.month_year = month_year
        self.months_values = months_values
        self.seller_ids = list(seller_ids)
        self.estate = estate
        self.filename = filename




