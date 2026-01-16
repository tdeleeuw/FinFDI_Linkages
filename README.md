# FinFDI_Linkages

Replication materials for the article  
**“How does FDI transmit into domestic investment? Exploring intra‑industry and financial channels”**  
T. de Leeuw & K. M. Wacker (2026), *Journal of Comparative Economics*

## Overview

This repository contains the Stata code and data structure required to reproduce the tables and figures presented in the paper. The replication package is designed to run the full empirical workflow once the necessary proprietary data sources have been obtained.

## Files Included

- `replication_tab_fig.do` — Main replication script generating all tables and figures.  
- `maindata.dta` — Data file required by the replication script (with proprietary variables replaced by missing values).

## Instructions for Replication

1. Download `replication_tab_fig.do` and `maindata.dta` and place them in a folder of your choice.  
2. Open the `.do` file and update the first line by replacing `"yourpath"` with the path to the folder where you saved the files.  
3. Run the `.do` file in Stata.  
   - All output (tables, figures, and intermediate files) will be saved automatically in the directory specified in line 1.

For detailed information on variable definitions, data sources, and construction procedures, consult **Appendix A3** of the paper.

## Data Access Requirements

**Important:**  
The replication files rely on proprietary data from the Vienna Institute for International Economic Studies (wiiw).  
The downloadable version of `maindata.dta` replaces all variables originating from these sources with missing values. To fully reproduce the results, you can obtain access to the data with a wiiw subscription to the following databases:

1. **wiiw Annual Database**  
   https://data.wiiw.ac.at/annual-database.html  
2. **wiiw FDI Database**  
   https://data.wiiw.ac.at/foreign-direct-investment.html  

Cleaning scripts used to prepare these databases for the analysis are available upon request.
