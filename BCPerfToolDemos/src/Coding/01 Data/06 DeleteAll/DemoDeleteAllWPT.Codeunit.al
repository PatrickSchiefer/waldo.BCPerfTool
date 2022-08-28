codeunit 62238 "Demo - DeleteAll WPT" implements "PerfToolCodeunit WPT"
{

    //Remark: this behaviour is different on SaaS!

    #region DeleteAllLocksTable
    procedure DeleteAllLocksTable()
    var
        SessionId: Integer;
    begin
        //session1
        StartSession(SessionId, Codeunit::"DeleteAllWaldosAndSleep WPT");

        //Session2
        Sleep(2000); //Sleep to make sure the above transaction has started

        RefreshVjeko();
    end;

    local procedure RefreshVjeko()
    var
        EmptyTableWPT: Record "EmptyTable WPT";
    begin
        //Some Silly way to insert a silly record
        EmptyTableWPT.Setrange(Code, 'Vjeko');
        EmptyTableWPT.DeleteAll(true);

        EmptyTableWPT.Init();
        EmptyTableWPT.Code := 'Vjeko';
        EmptyTableWPT.Description := 'Msg1';
        EmptyTableWPT.insert(true);
    end;
    #endregion

    #region DeleteAllWithIsemptyCheck
    procedure DeleteAllWithIsemptyCheck()
    var
        SessionId: Integer;
    begin
        //session1
        StartSession(SessionId, Codeunit::"DeleteAllWaldosAndSleep WPT");

        //Session2
        Sleep(2000); //Sleep to make sure the above transaction has started

        InsertVjekoWithIsemptyCheck();
    end;


    local procedure InsertVjekoWithIsemptyCheck()
    var
        EmptyTableWPT: Record "EmptyTable WPT";
    begin
        //Some Silly way to insert a silly record
        EmptyTableWPT.Setrange(Code, 'Vjeko');
        if not EmptyTableWPT.IsEmpty() then
            EmptyTableWPT.DeleteAll(true);

        EmptyTableWPT.Init();
        EmptyTableWPT.Code := 'Vjeko';
        EmptyTableWPT.insert(true);
    end;
    #endregion

    procedure PrepDemoData()
    var
        EmptyTableWPT: Record "EmptyTable WPT";
    begin
        EmptyTableWPT.InsertWaldoAndCommit(true, 'Msg1'); //DeletesAllFirst

        page.RunModal(page::"EmptyTable WPT");
    end;

    #region InterfaceImplementation
    procedure Run(ProcedureName: Text) Result: Boolean;
    begin
        case ProcedureName of
            GetProcedures().Get(1):
                PrepDemoData();
            GetProcedures().Get(2):
                DeleteAllLocksTable();
            GetProcedures().Get(3):
                DeleteAllWithIsemptyCheck();

        end;

        Result := true;
    end;

    procedure GetProcedures() Result: List of [Text[50]];
    begin
        Result.Add('PrepDemoData');
        Result.Add('DeleteAllLocksTable');
        Result.Add('DeleteAllWithIsemptyCheck');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Install Suites WPT", 'OnInstallAppPerCompanyFillSuite', '', false, false)]
    local procedure OnAfterInsertSuiteGroup();
    var
        PerfToolSuiteHeaderWPT: Record "PerfTool Suite Header WPT";
        WPTSuiteLine: Record "PerfTool Suite Line WPT";
        PerfToolGroupWPT: Record "PerfTool Group WPT";
        CreatePerfToolDataLibraryWPT: Codeunit "Create PerfToolDataLibrary WPT";
    begin
        CreatePerfToolDataLibraryWPT.CreateGroup('01.DATA', 'Data Access', PerfToolGroupWPT);

        CreatePerfToolDataLibraryWPT.CreateSuite(PerfToolGroupWPT, '6. DeleteAll', 'DeleteAll Locking Issue', PerfToolSuiteHeaderWPT);

        CreatePerfToolDataLibraryWPT.CreateSuiteLine(PerfToolSuiteHeaderWPT, WPTSuiteLine."Object Type"::Page, Page::"EmptyTable WPT", true, false, WPTSuiteLine);
        CreatePerfToolDataLibraryWPT.CreateSuiteLines(PerfToolSuiteHeaderWPT, WPTSuiteLine."Object Type"::Codeunit, enum::"PerfToolCodeunit WPT"::DeleteAll, true, true, WPTSuiteLine);
    end;
    #endregion
}