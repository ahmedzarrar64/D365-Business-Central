tableextension 50006 Arm_SalesLineExt extends "Sales Line"
{
    fields
    {
        field(50000; "Package Code"; Code[100])
        {
            TableRelation = Arm_Package;
            trigger OnValidate();
            var
                SalesHeader: Record "Sales Header";
            begin
                if "Package Code" = '' then
                    exit;
                SalesHeader := GetSalesHeader;
                Package.GET("Package Code");
                if SalesHeader."Load Type" <> Package."Load Type" then begin
                    if (SalesHeader."Load Type" <> '') and GUIALLOWED then
                        if not CONFIRM(Text001, false, "Package Code", Package."Load Type", SalesHeader."Load Type") then
                            ERROR('');
                    SalesHeader.LOCKTABLE;
                    SalesHeader.GET("Document Type", "Document No.");
                    SalesHeader."Load Type" := Package."Load Type";
                    SalesHeader."Delivery Sequence" := GetDeliverySequence(SalesHeader, Package."Load Type");
                    SalesHeader.MODIFY;
                end;
            end;
        }
    }
    var
        Package: Record Arm_Package;
        Text001: Label 'Load Type for Package Code %1 does not match Load Type on Sales Header:  %2 <> %3.  Is it OK to continue and update the Sales Header with Load Type %2?';

    procedure GetDeliverySequence(salesHeader: Record "Sales Header"; LoadType: Code[20]): Integer
    var
        DeliverySequence: Record "Arm_Delivery Sequence";
    begin
        DeliverySequence.Get(salesHeader."Customer Posting Group", LoadType);
        exit(DeliverySequence."Sequence No.");
    end;
}

