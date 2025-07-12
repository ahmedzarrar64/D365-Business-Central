table 50002 "Arm_Delivery Schedule Line"
{
    LookupPageID = "Arm_Delivery Schedule";

    fields
    {
        field(1; "Order Type"; Enum Arm_OrderType)
        {
            Editable = false;
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            CaptionML = ENU = 'Customer No.',
                        ESM = 'Nº cliente',
                        FRC = 'N° client',
                        ENC = 'Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(3; "Order No."; Code[20])
        {
            Editable = false;
            TableRelation = "Sales Header"."No." WHERE("Document Type" = FIELD("Order Type"));
        }
        field(4; "Bill-to Customer No."; Code[20])
        {
            CaptionML = ENU = 'Bill-to Customer No.',
                        ESM = 'Factura-a Nº cliente',
                        FRC = 'Nº client facturé',
                        ENC = 'Bill-to Customer No.';
            Editable = false;
            NotBlank = true;
            TableRelation = Customer;
        }
        field(21; "Shipment Date"; Date)
        {
            Caption = 'Delivery Date';

            trigger OnValidate();
            begin

                SalesHeader.GET("Order Type", "Order No.");
                SalesHeader.VALIDATE("Shipment Date", "Shipment Date");
                SalesHeader.MODIFY;

            end;
        }
        field(27; "Shipment Method Code"; Code[10])
        {
            CaptionML = ENU = 'Shipment Method Code',
                        ESM = 'Cód. método de envío',
                        FRC = 'Code méthode de livraison',
                        ENC = 'Shipment Method Code';
            Editable = false;
            TableRelation = "Shipment Method";
        }
        field(28; "Location Code"; Code[10])
        {
            CaptionML = ENU = 'Location Code',
                        ESM = 'Cód. almacén',
                        FRC = 'Code d''emplacement',
                        ENC = 'Location Code';

            Editable = false;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(79; "Sell-to Customer Name"; Text[50])
        {
            CaptionML = ENU = 'Name',
                        ESM = 'Nombre',
                        FRC = 'Nom',
                        ENC = 'Name';
            Editable = false;
        }
        field(80; "Sell-to Customer Name 2"; Text[50])
        {
            CaptionML = ENU = 'Name 2',
                        ESM = 'Nombre 2',
                        FRC = 'Nom 2',
                        ENC = 'Name 2';
            Editable = false;
        }
        field(81; "Sell-to Address"; Text[50])
        {
            CaptionML = ENU = 'Address',
                        ESM = 'Dirección',
                        FRC = 'Adresse',
                        ENC = 'Address';
            Editable = false;
        }
        field(82; "Sell-to Address 2"; Text[50])
        {
            CaptionML = ENU = 'Address 2',
                        ESM = 'Colonia',
                        FRC = 'Adresse 2',
                        ENC = 'Address 2';
            Editable = false;
        }
        field(83; "Sell-to City"; Text[30])
        {
            CaptionML = ENU = 'City',
                        ESM = 'Municipio/Ciudad',
                        FRC = 'Ville',
                        ENC = 'City';
            Editable = false;
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(88; "Sell-to Post Code"; Code[20])
        {
            CaptionML = ENU = 'ZIP Code',
                        ESM = 'C.P.',
                        FRC = 'Code postal',
                        ENC = 'Postal/ZIP Code';
            Editable = false;
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(89; "Sell-to County"; Text[30])
        {
            CaptionML = ENU = 'State',
                        ESM = 'Provincia',
                        FRC = 'Comté',
                        ENC = 'Province/State';
            Editable = false;
        }
        field(90; "Sell-to Country/Region Code"; Code[10])
        {
            CaptionML = ENU = 'Country/Region Code',
                        ESM = 'Cód. país/región',
                        FRC = 'Code pays/région',
                        ENC = 'Country/Region Code';
            Editable = false;
            TableRelation = "Country/Region";
        }
        field(100; "External Document No."; Code[35])
        {
            CaptionML = ENU = 'External Document No.',
                        ESM = 'Nº documento externo',
                        FRC = 'N° document externe',
                        ENC = 'External Document No.';

            Editable = false;
        }
        field(105; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            CaptionML = ENU = 'Shipping Agent Code',
                        ESM = 'Cód. transportista',
                        FRC = 'Code agent de livraison',
                        ENC = 'Shipping Agent Code';

            TableRelation = "Shipping Agent";

            trigger OnValidate();
            begin

                SalesHeader.GET("Order Type", "Order No.");
                SalesHeader."Shipping Agent Code" := "Shipping Agent Code";
                SalesHeader.MODIFY;

            end;
        }
        field(106; "Package Tracking No."; Text[30])
        {
            CaptionML = ENU = 'Package Tracking No.',
                        ESM = 'Nº seguimiento bulto',
                        FRC = 'N° de traçabilité',
                        ENC = 'Package Tracking No.';


            trigger OnValidate();
            begin

                SalesHeader.GET("Order Type", "Order No.");
                SalesHeader."Package Tracking No." := "Package Tracking No.";
                SalesHeader.MODIFY;

            end;
        }
        field(120; "Order Status"; Option)
        {
            Editable = false;
            OptionCaptionML = ENU = 'Open,Released,Pending Approval,Pending Prepayment',
                              ESM = 'Abierto,Lanzado,Aprobación pendiente,Anticipo pendiente',
                              FRC = 'Ouvert,Libéré,Approbation en attente,Paiement anticipé en attente',
                              ENC = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(5794; "Shipping Agent Service Code"; Code[10])
        {
            CaptionML = ENU = 'Shipping Agent Service Code',
                        ESM = 'Cód. servicio transportista',
                        FRC = 'Code prestation agent de livraison',
                        ENC = 'Shipping Agent Service Code';

            TableRelation = "Shipping Agent Services".Code WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"));

            trigger OnValidate();
            begin

                SalesHeader.GET("Order Type", "Order No.");
                SalesHeader."Shipping Agent Service Code" := "Shipping Agent Service Code";
                SalesHeader.MODIFY;

            end;
        }
        field(50000; "Load Type"; Code[20])
        {
            Editable = false;
        }
        field(50001; "Schedule Status"; Code[20])
        {
            TableRelation = "Arm_Schedule Status";

            trigger OnValidate();
            begin
                SalesHeader.GET("Order Type", "Order No.");
                SalesHeader."Schedule Status" := "Schedule Status";
                SalesHeader.MODIFY;
            end;
        }
        field(50004; Selected; Boolean)
        {
            Caption = 'Selected';

        }
        field(50005; Sequence; Integer)
        {
        }
        field(50006; "Customer Posting Group"; Code[10])
        {
        }
        field(50007; "Ship-to Name"; Text[100])
        {
            CalcFormula = Lookup("Sales Header"."Ship-to Name" WHERE("Document Type" = FIELD("Order Type"),
                                                                      "No." = FIELD("Order No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Order Type", "Order No.")
        {
        }
        key(Key2; "Shipment Date", "Order No.")
        {
        }
        key(Key3; "Customer Posting Group", "Sell-to Customer No.", Sequence)
        {
        }
    }

    fieldgroups
    {
    }

    var
        SalesHeader: Record "Sales Header";
        OrderType: Enum "Sales Document Type";

    procedure RunDeliverySequence(UseReqPage: Boolean);
    var
        RunDeliverySequence: Label 'The Shipment Date has changed.  Would you like to update the dates for the rest of the sequence?';
        CancelUpdate: Label 'The update has been cancelled.';
        SeqReport: Report "Arm_Delivery Sequencer";
    begin
        if UseReqPage = false then begin
            if CONFIRM(RunDeliverySequence) then begin
                CLEAR(SeqReport);
                SeqReport.USEREQUESTPAGE(false);
                SeqReport.GetScheduleDetails("Order Type", "Order No.", "Customer Posting Group", "Sell-to Customer No.", "Shipment Date");
                SeqReport.RUNMODAL;
            end else
                MESSAGE(CancelUpdate);
        end else begin
            CLEAR(SeqReport);
            SeqReport.USEREQUESTPAGE(true);
            SeqReport.GetScheduleDetails("Order Type", "Order No.", "Customer Posting Group", "Sell-to Customer No.", "Shipment Date");
            SeqReport.RUNMODAL;
        end;
    end;
}

