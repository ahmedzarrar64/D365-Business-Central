report 50000 "Arm_Delivery Ticket"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './ReportLayout/Arm_Delivery Ticket.rdlc';


    dataset
    {
        dataitem(DelivSchedLine; "Integer")
        {
            DataItemTableView = SORTING(Number);
            dataitem("Sales Order"; "Sales Header")
            {
                DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = FILTER(Order | "Return Order"));
                PrintOnlyIfDetail = true;
                column(Sales_Order_Document_Type; "Document Type")
                {
                }
                column(Sales_Order_No; "No.")
                {
                }
                column(Sales_Order_Customer_No; "Sell-to Customer No.")
                {
                }
                column(Sales_Order_ShipTo_Name; "Ship-to Name")
                {
                }
                column(Sales_Order_ShipTo_Name2; "Ship-to Name 2")
                {
                }
                column(Sales_Order_ShipTo_Address; "Ship-to Address")
                {
                }
                column(Sales_Order_ShipTo_Address2; "Ship-to Address 2")
                {
                }
                column(Sales_Order_ShipTo_Address3; ShipToAddress3)
                {
                }
                column(Sales_Order_Shipment_Date; "Shipment Date")
                {
                }
                column(Sales_Order_Shipment_Method; "Shipment Method Code")
                {
                }
                column(Sales_Order_Schedule_Status; "Schedule Status")
                {
                }
                column(Sales_Order_Load_Type; "Load Type")
                {
                }
                column(Sales_Order_Ext_Doc_No; "External Document No.")
                {
                }
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE(Type = CONST(Item));
                    column(Sales_Line_No; "No.")
                    {
                    }
                    column(Sales_Line_Description; Description + ' ' + "Description 2")
                    {
                    }
                    column(Sales_Line_Qty_To_Ship; "Qty. to Ship")
                    {
                    }
                    column(Sales_Line_Unit_Of_Measure; "Unit of Measure Code")
                    {
                    }
                    column(Sales_Line_Bin_Code; "Sales Line"."Bin Code")
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        if (("Document Type" = "Document Type"::Order) and ("Qty. to Ship" = 0)) or
                           (("Document Type" = "Document Type"::"Return Order") and
                            ("Return Qty. to Receive" = 0))
                        then
                            CurrReport.SKIP;

                        if ("Document Type" = "Document Type"::"Return Order") then
                            "Qty. to Ship" := "Return Qty. to Receive";   // for printing only


                        if Consolidated then begin
                            if not TempItem.GET("No.") then begin
                                TempItem."No." := "No.";
                                TempItem."Base Unit of Measure" := "Unit of Measure Code";
                                TempItem.Description := Description;
                                TempItem."Reorder Point" := "Qty. to Ship";
                                TempItem.INSERT;
                            end else begin
                                TempItem."Reorder Point" += "Qty. to Ship";
                                TempItem.MODIFY;
                            end;
                            if not TempSalesHeader.GET("Sales Order"."Document Type", "Sales Order"."No.") then begin
                                TempSalesHeader := "Sales Order";
                                TempSalesHeader.INSERT;
                            end;
                        end;

                    end;
                }
                dataitem("Sales Comment Line"; "Sales Comment Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"), "No." = FIELD("No.");
                    DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") ORDER(Ascending) WHERE("Document Line No." = CONST(0), "Print On Delivery Ticket" = CONST(true));
                    column(TestLabel; TestLabel)
                    {
                    }
                    column(Comment_SalesCommentLine; "Sales Comment Line".Comment)
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        if CommentCount = 1 then
                            TestLabel := 'Comment'
                        else
                            TestLabel := '';

                        CommentCount += 1;
                    end;

                    trigger OnPreDataItem();
                    begin
                        CommentCount := 1
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    ShipToAddress3 := COPYSTR(
                      "Ship-to City" + ', ' + "Ship-to County" + '  ' + "Ship-to Post Code",
                      1, MAXSTRLEN(ShipToAddress3));
                end;

                trigger OnPreDataItem();
                begin

                    SETRANGE("Document Type", TempDeliveryScheduleLine."Order Type");
                    SETRANGE("No.", TempDeliveryScheduleLine."Order No.");

                end;
            }

            trigger OnAfterGetRecord();
            begin

                if Number = 1 then
                    TempDeliveryScheduleLine.FINDFIRST
                else
                    TempDeliveryScheduleLine.NEXT;

            end;

            trigger OnPreDataItem();
            begin

                TempDeliveryScheduleLine.RESET;
                SETRANGE(Number, 1, TempDeliveryScheduleLine.COUNT);

            end;
        }
        dataitem(ConsolidDocuments; "Integer")
        {
            DataItemTableView = SORTING(Number);
            column(DocNo; TempSalesHeader."No.")
            {
            }
            column(DocName; TempSalesHeader."Ship-to Name")
            {
            }

            trigger OnAfterGetRecord();
            begin

                if Number = 1 then
                    TempSalesHeader.FINDFIRST
                else
                    TempSalesHeader.NEXT;
            end;

            trigger OnPreDataItem();
            begin

                TempSalesHeader.RESET;
                SETRANGE(Number, 1, TempSalesHeader.COUNT);

            end;
        }
        dataitem(ConsolidItems; "Integer")
        {
            DataItemTableView = SORTING(Number);
            column(ItemNo; TempItem."No.")
            {
            }
            column(ItemDesc; TempItem.Description)
            {
            }
            column(ItemBUoM; TempItem."Base Unit of Measure")
            {
            }
            column(ItemQty; TempItem."Reorder Point")
            {
            }

            trigger OnAfterGetRecord();
            begin
                if Number = 1 then
                    TempItem.FINDFIRST
                else
                    TempItem.NEXT;
            end;

            trigger OnPreDataItem();
            begin
                TempItem.RESET;
                SETRANGE(Number, 1, TempItem.COUNT);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(Consolidated; Consolidated)
                    {
                        Caption = 'Consolidated';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        Label4_DeliveryTicketTitle = 'VAN METRE BASE, LLC - DISTRIBUTION'; Label4_Document_Type = 'Order Type'; Label4_Customer_No = 'Customer Number'; Label4_Document_No = 'Order Number'; Label4_ShipTo_Name = 'Customer Name'; Label4_ShipTo_Address = 'Address'; Label4_Shipment_Date = 'Delivery Date'; Label4_Shipment_Method = 'Shipment Method'; Label4_Load_Type = 'Load Type'; Label4_Line_No = 'Item Number'; Label4_Line_Description = 'Description'; Label4_Line_Qty_To_Ship = 'Quantity'; Label4_Line_Unit_Of_Measure = 'UOM'; LabelFoot_Pulled = 'Pulled by:______________________________'; LabelFoot_Confirmed = 'Confirmed by:___________________________'; Label4_Bin_Code = 'Bin Code'; CommentLabel = 'Comments'; Label4_Ext_Doc_No = 'Your Order';
    }

    var
        ShipToAddress3: Text[80];
        Consolidated: Boolean;
        TempDeliveryScheduleLine: Record "Arm_Delivery Schedule Line" temporary;
        TempSalesHeader: Record "Sales Header" temporary;
        TempItem: Record Item temporary;
        TestLabel: Text[10];
        CommentCount: Integer;

    procedure SetDeliverySchedule(var NewDeliveryScheduleLine: Record "Arm_Delivery Schedule Line");
    begin

        if NewDeliveryScheduleLine.FINDSET then
            repeat
                TempDeliveryScheduleLine := NewDeliveryScheduleLine;
                TempDeliveryScheduleLine.INSERT;
            until NewDeliveryScheduleLine.NEXT = 0;

    end;
}

