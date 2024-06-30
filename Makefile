# Makefile to run the analysis for the paper and compile the manuscript

## Recursively look for all files in the current directory and its subdirectories
VPATH = $(shell find . -type d)

## List of inputs
INPUT_TARGETS = artifacts_forwards.rds \
artifacts_exchange_rates.rds \
artifacts_announcement_days.rds \
artifacts_assets.rds \
artifacts_bonds.rds \
artifacts_commodities.rds

## Generating the manuscript 
monetary_policy_surprises.pdf: monetary_policy_surprises.qmd $(INPUT_TARGETS)
	quarto render $<
	
## Generating rds inputs to manuscript
artifacts_announcement_days.rds: 01_repo_change_days.R repo_rate.xlsx
	Rscript $<

artifacts_commodities.rds: 02_commodities.R alluminium.xlsx copper.xlsx gold_spot.xlsx coal.xlsx \
lead.xlsx nickel.xlsx platinum_spot.xlsx silver_spot.xlsx palladium_spot.xlsx  zinc.xlsx 
	Rscript $<

artifacts_bonds.rds: 03_bonds.R 2032.xlsx 2030.xlsx 2035.xlsx 2037.xlsx 2040.xlsx 2044.xlsx 2048.xlsx \
2053.xlsx R186.xlsx R213.xlsx R214.xlsx
	Rscript $<

artifacts_forwards.rds: 04_fowards.R $(wildcard ZAR(*).xlsx)
	Rscript $<

artifacts_assets.rds: 05_jse.R JALSH.xlsx jse_equity.xlsx jset40.xlsx
	Rscript $<

artifacts_exchange_rates.rds: 06_exchange_rates.R exchange_rates.xlsx
	Rscript $<






