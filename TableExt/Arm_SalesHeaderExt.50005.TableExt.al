tableextension 50005 Arm_SalesHeaderExt extends "Sales Header"
{
    fields
    {
        field(50000; "Load Type"; Code[20])
        {
            TableRelation = Arm_Package;
            trigger OnValidate()
            var
                package: Record Arm_Package;
            begin
                // TestStatusOpen();
                // if ("Load Type" <> xRec."Load Type") and
                //    (xRec."Sell-to Customer No." = "Sell-to Customer No.")
                // then
                //     MessageIfSalesLinesExist(FieldCaption("Load Type"));
                package.GET("Load Type");
                "Load Type" := package."Load Type";
            end;
        }
        field(50001; "Schedule Status"; Code[20])
        {
            TableRelation = "Arm_Schedule Status";
        }
        field(50005; "Delivery Sequence"; Integer)
        {
        }
    }
}

