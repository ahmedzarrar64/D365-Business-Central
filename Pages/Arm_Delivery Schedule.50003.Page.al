page 50003 "Arm_Delivery Schedule"
{
    Caption = 'Delivery Schedule';
    DeleteAllowed = false;
    InsertAllowed = false;
    UsageCategory = Lists;
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Arm_Delivery Schedule Line";
    SourceTableTemporary = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Selected; Rec.Selected)
                {
                    Visible = false;
                }
                field("Order Type"; Rec."Order Type")
                {
                    Visible = false;
                }
                field("Order No."; Rec."Order No.")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("Schedule Status"; Rec."Schedule Status")
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {

                    trigger OnValidate();
                    begin
                        if (xRec."Shipment Date" <> 0D) and
                          (xRec."Shipment Date" <> Rec."Shipment Date") then
                            Rec.RunDeliverySequence(false);
                    end;
                }
                field("Load Type"; Rec."Load Type")
                {
                }
                field(Sequence; Rec.Sequence)
                {
                    Editable = false;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                }
                field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
                {
                    Visible = false;
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    Visible = false;
                }
                field("Sell-to County"; Rec."Sell-to County")
                {
                    Visible = false;
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                }
                field("Order Status"; Rec."Order Status")
                {
                    Visible = false;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    Visible = false;
                }
                field("Package Tracking No."; Rec."Package Tracking No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Refresh Data")
            {
                Caption = 'Refresh Data';
                Image = RefreshLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    RefreshData;
                end;
            }
            action("Show Document")
            {
                Caption = 'Show Document';
                Image = ShowSelected;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    ShowDocumentPage;
                end;
            }
            action("Update Sequence Dates")
            {
                Caption = 'Update Sequence Dates';
                Image = DateRange;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    Report.Run(Report::"Arm_Delivery Sequencer", true);
                end;
            }
            action("Print Delivery Ticket")
            {
                Caption = 'Print Delivery Ticket';
                Ellipsis = true;
                Image = Shipment;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    //PrintDeliveryTicket;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        RefreshData;
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesOrderCard: Page "Sales Order";
        ReturnOrderCard: Page "Sales Return Order";
        DeliveryTicketReport: Report "Arm_Delivery Ticket";

    procedure RefreshData();
    var
        SaveDeliveryLineFilters: Record "Arm_Delivery Schedule Line";
    begin
        //  Load this temporary table from the Sales Orders plus Return Orders
        SaveDeliveryLineFilters.COPYFILTERS(Rec);  // save filters
        SaveDeliveryLineFilters.RESET;
        SaveDeliveryLineFilters.DELETEALL;

        // Sales Orders
        SalesHeader.RESET;
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
        if SalesHeader.FIND('-') then
            repeat
                Rec.TRANSFERFIELDS(SalesHeader);
                Rec.Sequence := SalesHeader."Delivery Sequence";
                Rec."Customer Posting Group" := SalesHeader."Customer Posting Group";
                Rec.INSERT;
            until SalesHeader.NEXT = 0;
        // Sales Return Orders
        SalesHeader.RESET;
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::"Return Order");
        if SalesHeader.FIND('-') then
            repeat
                Rec.TRANSFERFIELDS(SalesHeader);
                Rec.Sequence := SalesHeader."Delivery Sequence";
                Rec."Customer Posting Group" := SalesHeader."Customer Posting Group";
                Rec.INSERT;
            until SalesHeader.NEXT = 0;

        COMMIT;
    end;

    procedure ShowDocumentPage();
    begin
        SalesHeader.GET(SalesHeader."No.", Rec."Order No.");
        SalesHeader.SETRECFILTER;

        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            CLEAR(SalesOrderCard);
            SalesOrderCard.SETTABLEVIEW(SalesHeader);
            SalesOrderCard.RUN;
        end else begin
            CLEAR(ReturnOrderCard);
            ReturnOrderCard.SETTABLEVIEW(SalesHeader);
            ReturnOrderCard.RUN;
        end;
    end;

    procedure PrintDeliveryTicket();
    var
        SaveDeliveryLineFilters: Record "Arm_Delivery Schedule Line";
        CurrRec: Record "Arm_Delivery Schedule Line" temporary;
    begin
        CurrRec := Rec;
        CurrRec.INSERT;
        SaveDeliveryLineFilters.COPYFILTERS(Rec);  // save filters
        Rec.SETRANGE(Selected, true);
        if Rec.ISEMPTY then begin
            Rec.SETRANGE(Selected);
            Rec.GET(CurrRec."Order Type", CurrRec."Order No.");
            Rec.Selected := true;
            Rec.MODIFY;
            Rec.SETRANGE(Selected, true);
        end;
        DeliveryTicketReport.SetDeliverySchedule(Rec);
        Commit();
        DeliveryTicketReport.Run();
        Rec.SETRANGE(Selected);
        if Rec.FINDSET(true) then
            Rec.MODIFYALL(Selected, false);
        Rec.COPYFILTERS(SaveDeliveryLineFilters);          // restore filters
        CurrPage.UPDATE(false);                        // refresh the page
        Rec.GET(CurrRec."Order Type", CurrRec."Order No."); // restore cursor position

    end;
}

