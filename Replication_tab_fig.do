global path "yourpath"
cd "$path"

use "$path\maindata.dta", clear

*// Tables and figures: below are the replication codes for the tables and figures in the Journal of Comparative Economics article by de Leeuw & Wacker (2026) "How does FDI transmit into domestice investment? Exploring intra-industry and financial channels". Codes for tables and figure are ordered in the way they appear in the journal article.

**# Figure 1: Excel-graph, data cannot be shared due to proprietary nature

**# Table 1 & 2: descriptive, no replication code needed

**# Table 3: descriptive statistics
sum gfcf2 fdi2 fin_fdi lendcoeff_avg lendcoeff_IO inflation fin_dev cap_price bank_crisis fin_fdi_stock f_banks f_assets fin_prod if gfcf2 != . & fdi2 != . & fin_fdi != .

**# Figure 2: see Excel attachment in replication files

**# Table 4
ssc install reghdfe
ssc install ftools

reghdfe gfcf2 fdi2 fin_fdi inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store model1

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_avg, absorb(country sector year) vce(cluster country)
est store model2

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_avg inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store model3

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_IO, absorb(country sector year) vce(cluster country)
est store model4

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_IO inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store model5

esttab model1 model2 model3 model4 model5 using "$path\table4.rtf", replace onecell r2 star(* 0.10 ** 0.05 *** 0.01) se(3) coeflabels(fdi2 "FDI" fin_fdi "Financial FDI" c.fin_fdi#c.lendcoeff_avg "Financial FDI x Financial linkage weights" c.fin_fdi#c.lendcoeff_IO "Financial FDI x Financial linkage weights" lendcoeff_avg "Financial linkage weights" lendcoeff_IO "Financial linkage weights" inflation "Inflation" fin_dev "Financial development" bank_crisis "Bank crisis" cap_price "Capital price" _cons "Constant") mtitles("" "LEND" "LEND" "IO" "IO")

**# Figure 3
* panel a
reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_avg inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
margins, dydx(fin_fdi) grand at(lendcoeff_avg=(0(.05)0.5)) level(90)
marginsplot, x(lendcoeff_avg) title("Average marginal effects of financial FDI on domestic investment") xtitle("LEND Financial linkage weights") recast(line) plot1opts(lcolor(gs0)) ciopt(color(black%20)) recastci(rarea) level(90)
graph export "$path\figure3_panel_a1.png", replace

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_IO inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
margins, dydx(fin_fdi) grand at(lendcoeff_IO=(0(.05)0.5)) level(90)
marginsplot, x(lendcoeff_IO) title("Average marginal effects of financial FDI on domestic investment") xtitle("IO Financial linkage weights") recast(line) plot1opts(lcolor(gs0)) ciopt(color(black%20)) recastci(rarea) 
graph export "$path\figure3_panel_a2.png", replace

* panel b
label var lendcoeff_avg "Financial linkage weights (LEND)"
graph box lendcoeff_avg if sector != 9, over(sector, label(labsize(small)) relabel(1 "{it:Agriculture, forestry and fishing}" 2 "{it:Mining and quarrying}" 3 "{it:Manufacturing}" 4 "{it:Electricity, water and utilities}" 5 "{it:Construction}" 6 "{it:Wholesale, retail trade, etc.}" 7 "{it:Transportation and communication}" 8 "{it:Accommodation and food services}" 9 "{it:Real estate and business services}" 10 "{it:Other services}")) box(1, color(navy) lwidth(vthin)) horizontal yscale(range(0 .1 .2 .3 .4 .5)) ylabel(0(.1).5)
graph export "$path\figure3_panel_b1.png", replace

label var lendcoeff_IO "Financial linkage weights (IO)"
graph box lendcoeff_IO if sector != 9, over(sector, label(labsize(small)) relabel(1 "{it:Agriculture, forestry and fishing}" 2 "{it:Mining and quarrying}" 3 "{it:Manufacturing}" 4 "{it:Electricity, water and utilities}" 5 "{it:Construction}" 6 "{it:Wholesale, retail trade, etc.}" 7 "{it:Transportation and communication}" 8 "{it:Accommodation and food services}" 9 "{it:Real estate and business services}" 10 "{it:Other services}")) box(1, color(navy) lwidth(vthin)) horizontal 
graph export "$path\boxIO.png", replace

**# Table 5
reghdfe gfcf2 fdi2, absorb(country#year sector) vce(cluster country)
est store model1

reghdfe gfcf2 fdi2 c.fin_fdi#c.lendcoeff_avg, absorb(country#year sector) vce(cluster country)
est store model2

reghdfe gfcf2 fdi2 c.fin_fdi#c.lendcoeff_IO, absorb(country#year sector) vce(cluster country)
est store model3

esttab model1 model2 model3 using "$path\table5.rtf", append onecell r2 star(* 0.10 ** 0.05 *** 0.01) se(3) coeflabels(fdi2 "FDI" fin_fdi "Financial FDI" c.fin_fdi#c.lendcoeff_avg "Financial FDI x Financial linkage weights" c.fin_fdi#c.lendcoeff_IO "Financial FDI x Financial linkage weights" lendcoeff_avg "Financial linkage weights" lendcoeff_IO "Financial linkage weights" _cons "Constant") mtitles("" "LEND" "IO")

**# Table 6
reghdfe gfcf2 fdi2 c.fin_fdi_stock##c.lendcoeff_avg inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store model1

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_avg inflation fin_dev bank_crisis cap_price f_banks f_assets, absorb(country sector year) vce(cluster country)
est store model2

reghdfe fin_prod fin_fdi inflation bank_crisis cap_price f_banks fin_dev, absorb(country year) vce(cluster country)
est store model3

reghdfe fin_dev fin_fdi inflation bank_crisis cap_price f_banks, absorb(country year) vce(cluster country)
est store model4

esttab model1 model2 model3 model4 using "$path\table6.rtf", replace onecell r2 star(* 0.10 ** 0.05 *** 0.01) se(3) coeflabels(fdi2 "FDI" fin_fdi_stock "Financial FDI stock" c.fin_fdi_stock#c.lendcoeff_avg "Financial FDI stock x Financial linkage weights" fin_fdi "Financial FDI" c.fin_fdi#c.lendcoeff_avg "Financial FDI x Financial linkage weights" c.fin_fdi#c.lendcoeff_IO "Financial FDI x Financial linkage weights" lendcoeff_avg "Financial linkage weights" lendcoeff_IO "Financial linkage weights" inflation "Inflation" fin_dev "Financial development" bank_crisis "Bank crisis" cap_price "Capital price" f_banks "Foreign banks (% of total banks)" f_assets "Foreign bank assets (% total bank assets)" _cons "Constant") mtitles("Inward stock of Financial FDI" "Controlling for foreign bank presence" "Financial FDI and financial sector efficiency" "Financial FDI and credit supply") 

**# APPENDICES BELOW
**# Appendix A1
pwcorr gfcf2 fdi2 fin_fdi lendcoeff_avg lendcoeff_IO inflation fin_dev cap_price bank_crisis fin_fdi_stock f_banks f_assets fin_prod

**# Appendix A2, see Excel attachment in replication files
preserve
collapse (mean) lendcoeff_al lendcoeff_hu lendcoeff_ee lendcoeff_sk lendcoeff_cz lendcoeff_bg, by(sector)
drop in 9
reshape long lendcoeff_, i(sector) j(country) string
reshape wide lendcoeff_, i(country) j(sector)
replace country = "Albania" if country == "al"
replace country = "Bulgaria" if country == "bg"
replace country = "Czechia" if country == "cz" 
replace country = "Estonia" if country == "ee"
replace country = "Hungary" if country == "hu"
replace country = "Slovakia" if country == "sk"
graph bar lendcoeff*, ///
    over(country, label(labsize(small))) stack ///
    bar(1, color(navy)) ///
    bar(2, color(gs10)) ///
    bar(3, color(eltblue)) ///
    bar(4, color(gs12)) ///
    bar(5, color(emidblue)) ///
    bar(6, color(gs14)) ///
    bar(7, color(ebblue)) ///
    bar(8, color(gs16)) ///
    bar(9, color(ltblue)) ///
    bar(10, color(blue)) ///
    legend(pos(6) row(4) size(vsmall) symxsize(*0.8) ///
        label(1 "Agriculture, forestry and fishing") ///
        label(2 "Mining and quarrying") ///
        label(3 "Manufacturing") ///
        label(4 "Electricity, water and utilities") ///
        label(5 "Construction") ///
        label(6 "Wholesale, retail trade, etc.") ///
        label(7 "Transportation and communication") ///
        label(8 "Accommodation and food services") ///
        label(9 "Real estate and business services") ///
        label(10 "Other services"))
graph export "$path\appendixa2.png", replace
restore

**# Appendix A3, descriptive, no replication code needed

**# Appendix A4
reghdfe gfcf2 fdi2 fin_fdi_gdp inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store model1

reghdfe gfcf2 fdi2 c.fin_fdi_gdp##c.lendcoeff_avg inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store model2

reghdfe gfcf2 fdi2 c.fin_fdi_gdp##c.lendcoeff_IO inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store model3

esttab model1 model2 model3 using "$path\appendixa4.rtf", replace onecell r2 star(* 0.10 ** 0.05 *** 0.01) se(3) coeflabels(fdi2 "FDI" fin_fdi_gdp "Financial FDI" c.fin_fdi_gdp#c.lendcoeff_avg "Financial FDI x Financial linkage weights" c.fin_fdi_gdp#c.lendcoeff_IO "Financial FDI x Financial linkage weights" lendcoeff_avg "Financial linkage weights" lendcoeff_IO "Financial linkage weights" inflation "Inflation" fin_dev "Financial development" bank_crisis "Bank crisis" cap_price "Capital price" _cons "Constant") mtitles("" "LEND" "IO")

**# Appendix A5
preserve
collapse (mean) fdi_inflowR2c, by(country sector)
bys country: egen fdi_all = total(fdi_inflowR2c)
gen fdi_share = fdi_inflowR2c / fdi_all
drop fdi_inflowR2c fdi_all
reshape wide fdi_share, i(country) j(sector)
replace fdi_share11 = .000001 if fdi_share11 == .
graph hbar fdi_share9 fdi_share3 fdi_share1 fdi_share2 fdi_share4 fdi_share5 fdi_share6 fdi_share7 fdi_share8 fdi_share10 fdi_share11, ///
    over(country, label(labsize(small))) stack ///
    bar(1, color(navy)) /// 
    bar(2, color(gs14))    ///
    bar(3, color(olive_teal)) ///
    bar(4, color(sand))       ///
    bar(5, color(eltblue))      ///
    bar(6, color(dknavy))     ///
    bar(7, color(khaki))       ///
    bar(8, color(emidblue))   ///
    bar(9, color(green))    ///
    bar(10, color(stone))     ///
    bar(11, color(ebblue))    ///
    legend(pos(6) row(4) size(vsmall) symxsize(*0.8) ///
        label(3 "Agriculture, forestry and fishing") ///
        label(4 "Mining and quarrying") ///
        label(2 "Manufacturing") ///
        label(5 "Electricity, water and utilities") ///
        label(6 "Construction") ///
        label(7 "Wholesale, retail trade, etc.") ///
        label(8 "Transportation and communication") ///
        label(9 "Accommodation and food services") ///
        label(1 "Financial and insurance activities") ///
        label(10 "Real estate and business services") ///
        label(11 "Other services"))
graph export "$path\appendixa5.png", replace
restore 

**# Appendix A6
preserve
replace lendcoeff_avg = . if lendcoeff_IO == .
replace fdi2 = . if lendcoeff_IO == .
replace fin_fdi = . if lendcoeff_IO == .

reghdfe gfcf2 fdi2 fin_fdi inflation fin_dev bank_crisis cap_price, absorb(country year sector) vce(cluster country)
est store model1

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_avg, absorb(country year sector) vce(cluster country)
est store model2

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_avg inflation fin_dev bank_crisis cap_price, absorb(country year sector) vce(cluster country)
est store model3

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_IO, absorb(country year sector) vce(cluster country)
est store model4

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_IO inflation fin_dev bank_crisis cap_price, absorb(country year sector) vce(cluster country)
est store model5

esttab model1 model2 model3 model4 model5 using "$path\appendixa6.rtf", replace onecell r2 star(* 0.10 ** 0.05 *** 0.01) se(3) coeflabels(fdi2 "FDI" fin_fdi "Financial FDI" c.fin_fdi#c.lendcoeff_avg "Financial FDI x Financial linkage weights" c.fin_fdi#c.lendcoeff_IO "Financial FDI x Financial linkage weights" lendcoeff_avg "Financial linkage weights" lendcoeff_IO "Financial linkage weights" inflation "Inflation" fin_dev "Financial development" bank_crisis "Bank crisis" cap_price "Capital price" _cons "Constant") mtitles("" "LEND" "LEND" "IO" "IO")
restore

**# Appendix A7
reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_avg inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
margins, dydx(fin_fdi) grand at(lendcoeff_avg=(0(.05)0.5)) level(90)

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_IO inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
margins, dydx(fin_fdi) grand at(lendcoeff_IO=(0(.05)0.5)) level(90)

**# Appendix A8
gen temp = lendcoeff_IO if year == 2000
bys country sector (year): egen lendcoeff_IO2000 = max(temp)
drop temp 
gen temp = lendcoeff_IO if year == 2014
bys country sector (year): egen lendcoeff_IO2014 = max(temp)
drop temp 

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_IO inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store fix1

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_IO2000 inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store fix2

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_IO2014 inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store fix3

esttab fix1 fix2 fix3 using "$path\appendixa8.rtf", replace onecell r2 star(* 0.10 ** 0.05 *** 0.01) se(3) coeflabels(fdi2 "FDI" fin_fdi "Financial FDI" c.fin_fdi#c.lendcoeff_IO "Financial FDI x Financial linkage weights" lendcoeff_IO "Financial linkage weights" c.fin_fdi#c.lendcoeff_IO2000 "Financial FDI x Financial linkage weights 2000" lendcoeff_IO2000 "Financial linkage weights 2000" c.fin_fdi#c.lendcoeff_IO2014 "Financial FDI x Financial linkage weights 2014" lendcoeff_IO2014 "Financial linkage weights 2014" inflation "Inflation" fin_dev "Financial development" bank_crisis "Bank crisis" cap_price "Capital price" _cons "Constant") mtitles("Baseline" "Financial linkage weights fixed at 2000 level" "Financial linkage weights fixed at 2014 level")

**# Appendix A9
sort country year 
bys country: gen lfin_fdi = fin_fdi[_n-11]
bys country: gen l2fin_fdi = fin_fdi[_n-22]
bys country: gen l3fin_fdi = fin_fdi[_n-33]

reghdfe gfcf2 fdi2 c.lfin_fdi##c.lendcoeff_avg inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store model1
reghdfe gfcf2 fdi2 c.l2fin_fdi##c.lendcoeff_avg inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store model2
reghdfe gfcf2 fdi2 c.l3fin_fdi##c.lendcoeff_avg inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store model3
reghdfe gfcf2 fdi2 c.lfin_fdi##c.lendcoeff_IO inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store model4
reghdfe gfcf2 fdi2 c.l2fin_fdi##c.lendcoeff_IO inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store model5
reghdfe gfcf2 fdi2 c.l3fin_fdi##c.lendcoeff_IO inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store model6

esttab model1 model2 model3 model4 model5 model6 using "$path\appendixa9.rtf", replace onecell r2 star(* 0.10 ** 0.05 *** 0.01) se(3) coeflabels(fdi2 "FDI" fin_fdi "Financial FDI" c.fin_fdi#c.lendcoeff_avg "Financial FDI x Financial linkage weights" c.fin_fdi#c.lendcoeff_IO "Financial FDI x Financial linkage weights" lendcoeff_avg "Financial linkage weights" lendcoeff_IO "Financial linkage weights" inflation "Inflation" fin_dev "Financial development" bank_crisis "Bank crisis" cap_price "Capital price" _cons "Constant") mtitles(" LEND FinFDI t-1" " LEND FinFDI t-2" " LEND FinFDI t-3" "IO FinFDI t-1" "IO FinFDI t-2" "IO FinFDI t-3")

**# Appendix A10
gen trend = ln(year)

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_avg c.trend#i.country, absorb(country sector year) vce(cluster country)
est store model1

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_avg c.trend#i.sector, absorb(country sector year) vce(cluster country)
est store model2

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_avg c.trend#i.country c.trend#i.sector, absorb(country sector year) vce(cluster country)
est store model3

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_IO c.trend#i.country, absorb(country sector year) vce(cluster country)
est store model4

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_IO c.trend#i.sector, absorb(country sector year) vce(cluster country)
est store model5

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_IO c.trend#i.country c.trend#i.sector, absorb(country sector year) vce(cluster country)
est store model6

esttab model1 model2 model3 model4 model5 model6 using "$path\appendixa10.rtf", replace onecell r2 star(* 0.10 ** 0.05 *** 0.01) se(3) coeflabels(fdi2 "FDI" c.fin_fdi#c.lendcoeff_avg "Fin. FDI X CB data intermediation coefficients" c.fin_fdi#c.lendcoeff_IO "Fin. FDI X IO intermediation coefficients" fin_fdi "Financial sector FDI" lfin_fdi "Financial sector FDI T-1" cap_price "Capital Price" lendcoeff_avg "CB data intermediation coefficients" inflation "Inflation" fin_dev "Financial Development" bank_crisis "Bank crisis" _cons "Constant") mtitles("LEND" "LEND" "LEND" "IO" "IO" "IO") 

**# Appendix A11
reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_avgb, absorb(country sector year) vce(cluster country)
est store r2r1

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_avgb inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store r2r2

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_IOb, absorb(country sector year) vce(cluster country)
est store r2r3

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_IOb inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country)
est store r2r4

esttab r2r1 r2r2 r2r3 r2r4 using "$path\appendixa11.rtf", replace onecell r2 star(* 0.10 ** 0.05 *** 0.01) se(3) coeflabels(fdi2 "FDI" fin_fdi "Financial FDI" c.fin_fdi#c.lendcoeff_avg "Financial FDI x Financial linkage weights" c.fin_fdi#c.lendcoeff_IO "Financial FDI x Financial linkage weights" lendcoeff_avg "Financial linkage weights" lendcoeff_IO "Financial linkage weights" inflation "Inflation" fin_dev "Financial development" bank_crisis "Bank crisis" cap_price "Capital price" _cons "Constant") mtitles("LEND" "LEND" "IO" "IO")

**# Appendix A12
* panel a
preserve
reghdfe gfcf2 c.fin_fdi#c.lendcoeff_avg#i.country
gen country1_finfdi = _b[i1.country#c.fin_fdi#c.lendcoeff_avg]
replace country1_finfdi = . if country != 1
gen country2_finfdi = _b[i2.country#c.fin_fdi#c.lendcoeff_avg]
replace country2_finfdi = . if country != 2
gen country3_finfdi = _b[i3.country#c.fin_fdi#c.lendcoeff_avg]
replace country3_finfdi = . if country != 3
gen country4_finfdi = _b[i5.country#c.fin_fdi#c.lendcoeff_avg]
replace country4_finfdi = . if country != 5
gen country5_finfdi = _b[i6.country#c.fin_fdi#c.lendcoeff_avg]
replace country5_finfdi = . if country != 6
gen country6_finfdi = _b[i7.country#c.fin_fdi#c.lendcoeff_avg]
replace country6_finfdi = . if country != 7
gen country7_finfdi = _b[i10.country#c.fin_fdi#c.lendcoeff_avg]
replace country7_finfdi = . if country != 10
gen country8_finfdi = _b[i11.country#c.fin_fdi#c.lendcoeff_avg]
replace country8_finfdi = . if country != 11
gen country9_finfdi = _b[i12.country#c.fin_fdi#c.lendcoeff_avg]
replace country9_finfdi = . if country != 12
gen country10_finfdi = _b[i13.country#c.fin_fdi#c.lendcoeff_avg]
replace country10_finfdi = . if country != 13
gen country11_finfdi = _b[i16.country#c.fin_fdi#c.lendcoeff_avg]
replace country11_finfdi = . if country != 16
gen country12_finfdi = _b[i17.country#c.fin_fdi#c.lendcoeff_avg]
replace country12_finfdi = . if country != 17

egen trip_finfdi = rowtotal(country1_finfdi country2_finfdi country3_finfdi country4_finfdi country5_finfdi country6_finfdi country7_finfdi country8_finfdi country9_finfdi country10_finfdi country11_finfdi country12_finfdi), missing

drop country1_finfdi country2_finfdi country3_finfdi country4_finfdi country5_finfdi country6_finfdi country7_finfdi country8_finfdi country9_finfdi country10_finfdi country11_finfdi country12_finfdi

twoway dropline trip_finfdi country, horizontal mlabel(CountryCode) mlabcolor(gs8)mlabposition(12) xtitle("Estimates GFCF = FinFDI # LEND # Country")
graph export "$path\appendixa12a.png", replace
restore

* panel b
preserve
reghdfe gfcf c.fin_fdi#i.country
gen country1_finfdi = _b[i1.country#c.fin_fdi]
replace country1_finfdi = . if country != 1
gen country2_finfdi = _b[i2.country#c.fin_fdi]
replace country2_finfdi = . if country != 2
gen country3_finfdi = _b[i3.country#c.fin_fdi]
replace country3_finfdi = . if country != 3
gen country4_finfdi = _b[i5.country#c.fin_fdi]
replace country4_finfdi = . if country != 5
gen country5_finfdi = _b[i6.country#c.fin_fdi]
replace country5_finfdi = . if country != 6
gen country6_finfdi = _b[i7.country#c.fin_fdi]
replace country6_finfdi = . if country != 7
gen country7_finfdi = _b[i10.country#c.fin_fdi]
replace country7_finfdi = . if country != 10
gen country8_finfdi = _b[i11.country#c.fin_fdi]
replace country8_finfdi = . if country != 11
gen country9_finfdi = _b[i12.country#c.fin_fdi]
replace country9_finfdi = . if country != 12
gen country10_finfdi = _b[i13.country#c.fin_fdi]
replace country10_finfdi = . if country != 13
gen country11_finfdi = _b[i16.country#c.fin_fdi]
replace country11_finfdi = . if country != 16
gen country12_finfdi = _b[i17.country#c.fin_fdi]
replace country12_finfdi = . if country != 17

egen country_finfdi = rowtotal(country1_finfdi country2_finfdi country3_finfdi country4_finfdi country5_finfdi country6_finfdi country7_finfdi country8_finfdi country9_finfdi country10_finfdi country11_finfdi country12_finfdi), missing

drop country1_finfdi country2_finfdi country3_finfdi country4_finfdi country5_finfdi country6_finfdi country7_finfdi country8_finfdi country9_finfdi country10_finfdi country11_finfdi country12_finfdi

twoway dropline country_finfdi country, horizontal mlabel(CountryCode) mlabcolor(gs8)mlabposition(12) xtitle("Estimates GFCF = FinFDI # Country") xscale(range(-6(1)6)) xlabel(-6(2)6)
graph export "$path\appendixa12b.png", replace
restore

**# Appendix A13
reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_avg inflation fin_dev bank_crisis cap_price, absorb(country sector year) vce(cluster country) // baseline
est store m1

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_avg inflation fin_dev bank_crisis cap_price c.fin_fdi#i.country, absorb(country sector year) vce(cluster country) // with country*finfdi
est store m2

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_avg inflation fin_dev bank_crisis cap_price if country != 1, absorb(country sector year) vce(cluster country) // omitting Albania
est store m3

reghdfe gfcf2 fdi2 c.fin_fdi##c.lendcoeff_avg inflation fin_dev bank_crisis cap_price if country != 1 & country != 10 & country != 12, absorb(country sector year) vce(cluster country) // omitting Albania, NM & Latvia
est store m4

esttab m1 m2 m3 m4 using "$path\appendixa13.rtf", replace onecell r2 star(* 0.10 ** 0.05 *** 0.01) se(3) coeflabels(gfcf2 "Gross fixed capital formation" fdi2 "FDI" c.fin_fdi_gdp#c.lendcoeff_avg "Fin. FDI x CB data intermediation coefficients" fin_fdi_gdp "Financial sector FDI" cap_price "Capital Price" lendcoeff_avg "CB data intermediation coefficients" inflation "Inflation" fin_dev "Financial Development" bank_crisis "Bank crisis" _cons "Constant") mtitles("Baseline" "Interaction fin FDI x country dummies" "Albania omitted" "Albania, North Macedonia & Latvia omitted") 

