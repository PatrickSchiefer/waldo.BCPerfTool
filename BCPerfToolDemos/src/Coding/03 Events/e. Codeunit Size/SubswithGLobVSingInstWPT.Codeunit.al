#pragma warning disable
codeunit 62266 "Subs with GLobV SingInst WPT"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Demo - Codeunit Size WPT", 'OnAfterDoingSomething_SubsWithGlobalVarsSingleInst', '', false, false)]
    procedure MyProcedure()
    begin
        SomeFunction();
    end;

    var
        SalesLine: Record "Sales Line";
        SalesLine1: Record "Sales Line";
        SalesLine2: Record "Sales Line";
        SalesLine3: Record "Sales Line";
        SalesLine4: Record "Sales Line";
        SalesLine5: Record "Sales Line";
        SalesLine6: Record "Sales Line";
        SalesPost2: Codeunit "Sales-Post";


    procedure SomeFunction()
    var
        i: Integer;
    begin
        // for i := 1 to 1000 do;
    end;

}