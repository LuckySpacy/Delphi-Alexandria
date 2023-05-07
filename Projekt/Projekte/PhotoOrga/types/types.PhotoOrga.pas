unit types.PhotoOrga;

interface


type
  TQueueProcess = (c_quNone, c_quReadFiles, c_quReadAllBilder, c_quLadeBilderFromDB);
  TNotifyStrEvent = procedure (aValue: string) of object;
  TNotifyIntEvent = procedure (aValue: Integer) of object;
  TProgressEvent = procedure (aIndex: Integer; aValue: string) of Object;
  TNotifyIntObjEvent = procedure (aIndex: Integer; aObject: TObject) of Object;
  TNotifyStrObjEvent = procedure (aIndex: string; aObject: TObject) of Object;


implementation

end.
