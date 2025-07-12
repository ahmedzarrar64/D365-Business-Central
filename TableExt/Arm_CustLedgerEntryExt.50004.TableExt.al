tableextension 50004 Arm_CustLedgerEntryExt extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; "Load Type"; Code[20])
        {
            Caption = 'Load Type';
            DataClassification = CustomerContent;
        }
    }

}