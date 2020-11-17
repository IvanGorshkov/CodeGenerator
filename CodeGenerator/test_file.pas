Program BlockToCode;

var x: integer;
var y: integer;
Begin
	x := 5;
	y := 6;
	Read(x);
	Write(x);
	if x > 0 then begin
		x := x+12;
	end
	else begin
		while x <> 0 do begin
			x := Max(x,y);
		end;
	end;
	for x := 1 to 10 do begin
		Write(x);
	end;
End.
