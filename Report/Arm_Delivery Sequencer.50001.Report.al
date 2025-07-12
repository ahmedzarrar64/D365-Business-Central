report 50001 "Arm_Delivery Sequencer"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord();
            begin
                if not DeliveryScheduleLine.GET(OrderType, OrderNo) then
                    ERROR(CannotFindScheduleLine, OrderType, OrderNo);

                if not DeliverySequence.GET(CustPostGroup, DeliveryScheduleLine."Load Type") then
                    ERROR(CannotFindSequence, CustPostGroup, DeliveryScheduleLine."Load Type");

                if DeliveryScheduleLine.Sequence = 0 then begin
                    DeliveryScheduleLine.Sequence := DeliverySequence."Sequence No.";
                    DeliveryScheduleLine.MODIFY;
                end else if DeliveryScheduleLine.Sequence <> DeliverySequence."Sequence No." then
                        ERROR(SequenceMismatch, DeliveryScheduleLine.Sequence, DeliverySequence."Sequence No.");

                if WholeOrderDate <> 0D then begin
                    HoldDate := WholeOrderDate;
                    HoldSequence := 0;
                end else if PassedDate <> 0D then begin
                    HoldDate := PassedDate;
                    HoldSequence := DeliveryScheduleLine.Sequence;
                end else begin
                    HoldDate := DeliveryScheduleLine."Shipment Date";
                    HoldSequence := DeliveryScheduleLine.Sequence;
                end;

                DeliverySequenceLoop.RESET;
                DeliverySequenceLoop.SETCURRENTKEY("Customer Posting Group", "Sequence No.");
                DeliverySequenceLoop.SETRANGE("Customer Posting Group", CustPostGroup);
                if HoldSequence <> 0 then
                    DeliverySequenceLoop.SETFILTER("Sequence No.", '>%1', HoldSequence);
                if DeliverySequenceLoop.FINDSET then begin
                    repeat
                        if FORMAT(DeliverySequenceLoop."Date Calculation") <> '' then begin
                            NewDate := CALCDATE(DeliverySequenceLoop."Date Calculation", HoldDate);
                            HoldDate := NewDate;
                        end;

                        DeliveryLine.RESET;
                        DeliveryLine.SETCURRENTKEY("Customer Posting Group", "Sell-to Customer No.", Sequence);
                        DeliveryLine.SETRANGE("Customer Posting Group", CustPostGroup);
                        DeliveryLine.SETRANGE(Sequence, DeliverySequenceLoop."Sequence No.");
                        DeliveryLine.SETRANGE("Sell-to Customer No.", CustNo);
                        if DeliveryLine.FINDFIRST then begin
                            DeliveryLine.VALIDATE("Shipment Date", NewDate);
                            DeliveryLine.MODIFY;
                        end;
                    until DeliverySequenceLoop.NEXT = 0;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(OrderType; OrderType)
                {
                    Caption = 'Order Type';
                }
                field(OrderNo; OrderNo)
                {
                    Caption = 'Order No.';
                }
                field(WholeOrderDate; WholeOrderDate)
                {
                    Caption = 'Use Order Date';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        OrderType: Enum Arm_OrderType;
        OrderNo: Code[20];
        Sequence: Integer;
        DeliveryScheduleLine: Record "Arm_Delivery Schedule Line";
        NewDate: Date;
        CannotFindScheduleLine: Label 'Cannot find a Delivery Schedule Line for Order Type %1, Order No. %2';
        DeliveryLine: Record "Arm_Delivery Schedule Line";
        CannotFindSequence: Label 'Cannot find a Delivery Sequence for Customer Posting Group %1, Load Type %2';
        DeliverySequence: Record "Arm_Delivery Sequence";
        SequenceMismatch: Label 'The Delivery Line Sequence No. %1 doesn''t match the Sequence No. %2 for the Customer Posting Group, Load Type combo.';
        DeliverySequenceLoop: Record "Arm_Delivery Sequence";
        HoldDate: Date;
        CustPostGroup: Code[10];
        WholeOrderDate: Date;
        HoldSequence: Integer;
        CustNo: Code[20];
        PassedDate: Date;

    procedure GetScheduleDetails(var InOrderType: Enum Arm_OrderType; var InOrderNo: Code[20]; var InCustPostGroup: Code[10]; var InCustNo: Code[20]; var InDate: Date);
    begin
        OrderType := InOrderType;
        OrderNo := InOrderNo;
        CustPostGroup := InCustPostGroup;
        CustNo := InCustNo;
        PassedDate := InDate;
    end;
}