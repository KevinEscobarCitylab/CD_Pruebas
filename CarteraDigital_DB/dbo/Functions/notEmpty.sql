	create   function notEmpty(@value varchar(max)) returns varchar(max) as  
	begin  
		return iif(rtrim(@value)='' or @value='null',null,@value)  
	end  
