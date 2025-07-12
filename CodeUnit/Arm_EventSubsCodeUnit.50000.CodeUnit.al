codeunit 50000 Arm_EventSubsCodeUnit
{
    [EventSubscriber(ObjectType::codeunit, codeunit::"Release Sales Document", 'OnCodeOnBeforeSalesLineCheck', '', FALSE, FALSE)]
    procedure OnCodeOnBeforeSalesLineCheck(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        SalesLine.TestField("Package Code");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeader', '', false, false)]
    procedure OnAfterCopyGenJnlLineFromSalesHeader(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        if SalesHeader."Load Type" <> '' then
            GenJournalLine."Load Type" := SalesHeader."Load Type";
    end;

    [EventSubscriber(ObjectType::codeunit, codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCustLedgEntryInsert', '', FALSE, FALSE)]
    procedure OnBeforeCustLedgEntryInsert(var CustLedgerEntry: Record "Cust. Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register"; var TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; var NextEntryNo: Integer)
    begin
        if GenJournalLine."Load Type" <> '' then
            CustLedgerEntry."Load Type" := GenJournalLine."Load Type";
    end;
}