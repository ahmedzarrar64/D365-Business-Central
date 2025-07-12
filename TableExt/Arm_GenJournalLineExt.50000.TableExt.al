tableextension 50000 Arm_GenJournalLineExt extends "Gen. Journal Line"
{
    fields
    {
        field(50000; Memo; Text[250])
        {
            Caption = 'Memo';
            DataClassification = CustomerContent;
        }
        field(50001; "Memo 2"; Text[250])
        {
            Caption = 'Memo 2';
            DataClassification = CustomerContent;
        }
        field(50002; "Load Type"; Code[20])
        {
            Caption = 'Load Type';
            DataClassification = CustomerContent;
        }
    }
}