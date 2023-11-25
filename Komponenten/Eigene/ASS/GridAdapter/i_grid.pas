{*---------------------------------------------------------------------
  Interface für alle Objekte, die den GridAdapter nutzen möchten

  @Author Markus Müller
  @version 0.1
----------------------------------------------------------------------}
unit i_grid;

interface

uses Graphics, Classes;


type IGrid = interface

     function getObject(aIdx: integer): TObject;

     function  Grd_getHeader(aCol: integer): string;
     function  Grd_getValue(aCol, aRow: integer): string;
     procedure Grd_getColor(aCol, aRow: integer; var aBrush: TBrush);
     procedure Grd_getFont(aCol, aRow: integer; var aFont: TFont);
     procedure Grd_getAlignment(aCol, aRow: integer; var aHAlignment: TAlignment);
     function  Grd_getRowCount: integer;
     function  Grd_getColCount: integer;
     function  Grd_getButtonspalte : integer;

     procedure Grd_setValue(aCol, aRow: integer; aWert: string);
     function  Grd_canEdit(aCol, aRow: integer): boolean;
     function  Grd_getImage(aCol, aRow: integer): integer;
end;




implementation

end.
