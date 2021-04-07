clear all
set more off

cd "C:\Users\malka\Desktop\DTA" 
* Read in LISTINGS FILE
insheet using listings.csv, clear
list
browse
sort id 
count if id==.
save listings, replace


* Read in REVIEWS FILE
insheet using reviews.csv, clear
list
browse
drop comments
rename id id1 ???
rename listing_id id
sort id
count if id==.
generate YEAR=substr(date,1,4)
destring YEAR,generate (year)
drop YEAR
keep if year >= 2015 
save reviews, replace

* Read in CALENDAR FILE
insheet using calendar.csv, clear
list
browse
rename listing_id id
sort id
count if id==.
save calendar, replace

* Merge LISTINGS AND REVIEWS FILES
use listings, clear 
merge 1:m id using reviews
sort id
collapse (mean) number_of_reviews price ,by(id)
summarize number_of_reviews price 
* The average number of reviews (as mentioned, starting in 2015???):27.12143 
* The average price:17474.24 
regress number_of_reviews price
*One US dollar increase in the price of the apartment reduces the amount of reviews in 0.000253 on average .The effect is significant in the confidence level of 95%.
twoway (scatter number_of_reviews price,sort) (lfit number_of_reviews price) ytitle(Number of Reviews) xtitle(Price) title(Scatter Plot: Reviews vs. Price) note(Data: Airbnb) legend(on)



*question number 6 
use listings, clear
encode neighbourhood, generate(neighbourhood_new1) label(name_n)
label list name_n
histogram price, by (neighbourhood_new1) /* for all neighbourhoods */
forvalues x = 24/28 {
	display "neighbourhood_new1 = `x’”???
	histogram price if neighbourhood_new1== `x', name(`x’) width(2.5)frequency note( Data:Airbnb) legend( on) title(“Airbnb Prices in neighbourhood `x' in Tokyo")
graph export `x'.png ,replace
}

graph 24 25 26 27 28, col(2) row (2) 


*question number 7
use listings, clear
encode neighbourhood, generate(neighbourhood_new1) label(name_n)
keep if room_type =="Entire home/apt"
bysort neighbourhood_new1: egen mean_price=mean(price)
generate gap_price = price- mean_price
regress reviews_per_month gap_price
*An increase in a unit in the  gap between the price and the average price increases the amount of reviews per month in  6.48e-07  on average .However,we can not reject the hypothesis that the effect is different from zero in the population in the confidence level of 95%.



*question number 8
use listings, clear
drop price 
merge 1:m id using calendar
sort id
destring price , generate (price1) ignore ("$" ",")
gen new_date=date(date,"YMD")
format new_date %td
encode available, generate(available_new1) label(name_n1)
collapse (mean) price1,by(new_date available_new1)
generate price1f = price1 if available_new1==1
generate price1t = price1 if available_new1==2
twoway line price1f price1t new_date, sort ytitle(" Average price ($)") xtitle("date") legend(label(1 " not available") label(2 "available")) title("Average Airbnb
 Price by Availability in Tokyo")
graph export 8a.png ,replace


*second way 
use listings, clear
drop price 
merge 1:m id using calendar
sort id
destring price , generate (price1) ignore ("$" ",")
gen new_date=date(date,"YMD")
format new_date %td
encode available, generate(available_new1) label(name_n1)
generate price1f = price1 if available_new1==1
generate price1t = price1 if available_new1==2
collapse (mean) price1f price1t,by(new_date)
twoway line price1f price1t new_date, sort ytitle(" Average price ($)") xtitle("date") legend(label(1 " not available") label(2 "available")) title("Average  Airbnb
 Price by Availability in Tokyo") Price by Availability in Tokyo")
graph export 8b.png ,replace


*third way
use listings, clear
drop price 
merge 1:m id using calendar
sort id
destring price , generate (price1) ignore ("$" ",")
gen new_date=date(date,"YMD")
format new_date %td
encode available, generate(available_new1) label(name_n1)
collapse (mean) price1,by(new_date available_new1)
twoway line price1 new_date if available_new==1 || line price1 new_date if available_new==1, sort ytitle(" Average price ($)") xtitle("date") legend(label(1 " not available") label(2 "available")) title("Average  Airbnb Price by Availability in Tokyo") Price by Availability in Tokyo")
graph export 8c.png ,replace










