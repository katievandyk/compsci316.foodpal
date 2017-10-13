-- Food you ate last wednesday
SELECT foodname, vendorname, quantity, timestamp
FROM foodlog
WHERE dukecardnumber = yourcardnumber 
AND   timestamp > last_tuesday 
AND   timestamp < last_thursday;


-- Everything you bought last week
SELECT price, vendorname
FROM transactions
WHERE dukecardnumber = yourcardnumber
AND   timestamp > last_week_start 
and   timestamp < last_week_end;

-- Calories today
SELECT sum(calories*quantity)
FROM foodlog, food
WHERE dukecardnumber = yourcardnumber
AND   timestamp > today_start 
and   timestamp < today_end;

-- Get all food available right now
SELECT vendorname, foodname
FROM isavailableat
WHERE day = today
AND   current_time > open_time
AND   current_time < close_time;