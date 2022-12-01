create   function getPointsPorceInverso(@value decimal(20,2)) returns decimal(20,2)
BEGIN
    return (select case
        when @value < 1 then 0
        when @value between 1.00 and 3.99 then 5
        when @value between 4.00 and 8.99 then 10
        when @value between 9.00 and 15.99 then 20
        when @value between 16.00 and 25.99 then 30
        when @value between 26.00 and 35.99 then 40
        when @value between 36.00 and 40.99 then 60
        when @value between 41.00 and 49.99 then 70
        when @value between 50.00 and 60.99 then 75
        when @value between 61.00 and 70.99 then 85
        when @value between 71.00 and 80.99 then 90
        when @value between 81.00 and 90.99 then 95
        when @value >= 91.00 then 100
    end)
END
