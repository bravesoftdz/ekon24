unit DiscountCalculator;

interface

uses
  System.Classes,
  Data.DB;

type
  TDiscountCalculator = class
    class function Calculate(const dsThresholds: TDataSet; const aLevel: String;
      aTotalValue: Currency): Integer; static;
  end;

implementation

function InRange(aValue: Currency; aLimit1: Currency;
  aLimit2: Currency): boolean;
begin
  Result := (aLimit1 <= aValue) and (aValue < aLimit2);
end;

class function TDiscountCalculator.Calculate(const dsThresholds: TDataSet;
  const aLevel: String; aTotalValue: Currency): Integer;
var
  limit1, limit2: Currency;
begin
  dsThresholds.Open();
  dsThresholds.Locate('Level', aLevel, []);
  Result := 0;
  limit1 := 0;
  while not(dsThresholds.Eof) and
    (dsThresholds.FieldByName('Level').AsString = aLevel) do
  begin
    limit2 := dsThresholds.FieldByName('LimitBottom').AsCurrency;
    if InRange(aTotalValue, limit1, limit2) then
      Exit;
    Result := dsThresholds.FieldByName('Discount').AsInteger;
    limit1 := limit2;
    dsThresholds.Next;
  end;
end;

end.
