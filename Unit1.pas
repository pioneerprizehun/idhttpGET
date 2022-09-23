unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, Vcl.StdCtrls, System.JSON, Data.DB,
  Vcl.Grids, Vcl.DBGrids, IdAuthentication, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL;

type
  TForm1 = class(TForm)
    Button1: TButton;
    IdHTTP1: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const Url = 'https://api.odcloud.kr/api/15092258/v1/uddi:b209f7aa-2f4f-4843-aaa9-93ffe4187449?page=1&perPage=10&serviceKey=7KIl6dMmzuL4vfVttT1tRb1mfi%2BOvK6F8gtf0bOSYBQAeHBJBJsWhuJtUX7FkIFv5u1XOFDjlOwe%2Bc78mk76XA%3D%3D';

//====================================스트링그리드 컬럼크기자동조절================================
procedure AutoSizeGridColumn(Grid : TStringGrid; column : integer);
var
  i : integer;
  temp : integer;
  max : integer;
begin
  max := 0;
  for i := 0 to (Grid.RowCount-1) do
  begin
    // Grid Canvas를 기준으로한 지정한 Column의 각 row의 width중
    // 최대값을 구하여 column의 width로 결정한다
    temp := Grid.Canvas.TextWidth(grid.cells[column, i]);
    if temp > max then
      max := temp;
  end;
  Grid.ColWidths[column] := max + Grid.GridLineWidth + 20;
end;
//====================================스트링그리드 컬럼크기자동조절 끝=============================

procedure TForm1.Button1Click(Sender: TObject);
var
stream: TStringStream;
idHttpObj: TIdHTTP;
JSONValue : TJSONValue;
JSONArray : TJSONArray;
JSONObject, JSONdata: TJSONObject;
JSONCount: integer;
i: integer;
r: integer;
begin
stream := TStringStream.Create('', TEncoding.UTF8);

idHttpObj := TIdHTTP.Create(nil);
idHttpObj.Get(Url, stream);
idHttpObj.Free;

JSONValue := TJSONObject.ParseJSONValue(stream.DataString);


//*************************************************************

{배열카운터}
JSONObject := TJSONObject.ParseJSONValue(stream.DataString) as TJSONObject;
JSONArray := JSONObject.GetValue('data') as TJSONArray;
JSONCount := JSONArray.Count;
{배열카운터끝}

//***********************************************************
StringGrid1.RowCount := JSONCount+1;
{StringGrid1에 윗부분셀추가}
StringGrid1.Cells[00,0] := '의소대별';
StringGrid1.Cells[01,0] := '정원(남성대)';
StringGrid1.Cells[02,0] := '정원(여성대)';
StringGrid1.Cells[03,0] := '정원(총)';
StringGrid1.Cells[04,0] := '현원(남성대)';
StringGrid1.Cells[05,0] := '현원(여성대)';
StringGrid1.Cells[06,0] := '현원(총)';
{StringGrid1에 윗부분셀추가 끝}

//*************************************************************

{StringGrid1 셀크기 자동조절}
for i := 0 to StringGrid1.ColCount-1 do
begin
AutoSizeGridColumn(StringGrid1, i);
end;
{StringGrid1 셀크기 자동조절 끝}

//*************************************************************

{for문을 이용한 Memo1, StringGrid1 내용추가}
for i := 0 to Integer(JSONCount)-1 do
begin
  StringGrid1.Cells[0,i+1] := (JSONValue.GetValue<string>('data['+i.ToString+'].의소대별'));
  StringGrid1.Cells[1,i+1] := (JSONValue.GetValue<string>('data['+i.ToString+'].정원(남성대)'));
  StringGrid1.Cells[2,i+1] := (JSONValue.GetValue<string>('data['+i.ToString+'].정원(여성대)'));
  StringGrid1.Cells[3,i+1] := (JSONValue.GetValue<string>('data['+i.ToString+'].정원(총)'));
  StringGrid1.Cells[4,i+1] := (JSONValue.GetValue<string>('data['+i.ToString+'].현원(남성대)'));
  StringGrid1.Cells[5,i+1] := (JSONValue.GetValue<string>('data['+i.ToString+'].현원(여성대)'));
  StringGrid1.Cells[6,i+1] := (JSONValue.GetValue<string>('data['+i.ToString+'].현원(총)'));



end;

{for문을 이용한 Memo1, StringGrid1 내용추가 끝}

//*************************************************************
{Memo1 내용추가 끝}
  stream.Free;     //stream free선언

end;

end.
