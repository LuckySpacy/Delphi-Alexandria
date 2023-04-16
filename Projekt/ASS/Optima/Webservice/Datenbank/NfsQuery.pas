unit NfsQuery;

interface

  uses IBX.IBQuery, Classes;

  type
    TNfsQuery = class(TIBQuery)

      protected
        _checkRuntime: boolean;

      public
        property CheckRuntime: boolean read _checkRuntime write _checkRuntime;

        constructor Create(aOwner: TComponent); override;

        procedure Open; reintroduce;

        ///	<summary>
        ///	  Gibt das erste Feld einer Query als Integer-Wert zurück
        ///	</summary>
        function intSkalar: integer;

        ///	<summary>
        ///	  Gibt das erste Feld einer Query als String-Wert zurück
        ///	</summary>
        function stringSkalar: string;
//        procedure CalculatedFeldHinzufuegen;
    end;


implementation
  uses Windows, SysUtils;

{ TNfsQuery }

constructor TNfsQuery.Create(aOwner: TComponent);
begin
  inherited;
  _checkRuntime := true;
end;

procedure TNfsQuery.Open;
var
  Start: Cardinal;
  Duration: Cardinal;
begin

  Start := GetTickCount;
  inherited Open;
  Duration := GetTickCount-Start;

  if (Duration > 30) and (checkRuntime) then
  begin
    //TLogging.debug(Format('Long running Query! %d ms ' + sLineBreak + '%s', [Duration, self.SQL.Text]));
    {
    TLogging.debug(Format('Long running Query! %d ms ', [Duration]));
    if TLogging.getInstance.Logger_QueryLongRunner <> nil then
      TLogging.getInstance.Logger_QueryLongRunner.Debug(Format('Long running Query! %d ms ' + sLineBreak + '%s', [Duration, self.SQL.Text]));
    }
  end;

end;

function TNfsQuery.intSkalar: integer;
begin
  Open;
  try
    result := Fields[0].AsInteger;
  except
    result := 0;
  end;
  Close;
end;

function TNfsQuery.stringSkalar: string;
begin
  Open;
  try
    result := Fields[0].asString;
  except
    result := '';
  end;
  Close;
end;


end.
