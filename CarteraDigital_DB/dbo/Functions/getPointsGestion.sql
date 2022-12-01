create   function getPointsGestion(@value decimal(20,2)) returns decimal(20,2)
BEGIN
    return (select case
        when @value < 1.99 then 100
        when @value between 2.00 and 2.99 then 95
        when @value between 3.00 and 3.99 then 90
        when @value between 4.00 and 4.99 then 85
        when @value between 5.00 and 5.99 then 80
        when @value between 6.00 and 6.99 then 75
        when @value between 7.00 and 7.99 then 70
        when @value between 8.00 and 8.99 then 65
        when @value between 9.00 and 9.99 then 60
        when @value between 10.00 and 12.99 then 55
        when @value between 13.00 and 15.99 then 50
        when @value between 16.00 and 18.99 then 45
        when @value between 19.00 and 21.99 then 40
        when @value between 22.00 and 24.99 then 35
        when @value between 25.00 and 28.99 then 30
        when @value between 29.00 and 32.99 then 25
        when @value between 33.00 and 36.99 then 20
        when @value between 37.00 and 40.99 then 15
        when @value between 41.00 and 50 then 10
        when @value >= 50  then 0
    end)
END
