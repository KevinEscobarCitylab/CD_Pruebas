create   function getPointsDay(@value decimal(20,2)) returns decimal(20,2)
BEGIN
    return (select case
        when @value between 0 and 0.99 then 100
        when @value between 1 and 1.99 then 99
        when @value between 2 and 3.99 then 95
        when @value between 4 and 6.99 then 90
        when @value between 7 and 12.99 then 80
        when @value between 13 and 18.99 then 75
        when @value between 19 and 25.99 then 70
        when @value between 26 and 35.99 then 55
        when @value between 36 and 45.99 then 50
        when @value between 46 and 50.99 then 45
        when @value between 51 and 60.99 then 40
        when @value between 61 and 70.99 then 25
        when @value between 71 and 90.99 then 20
        when @value between 91 and 120.99 then 10
        when @value between 121 and 180.99 then 5
        when @value between 181 and 250 then 2
        when @value >= 250 then 0
    end)
END
