tableextension 50001 Arm_PurchaseLineExt extends "Purchase line"
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
    }
}