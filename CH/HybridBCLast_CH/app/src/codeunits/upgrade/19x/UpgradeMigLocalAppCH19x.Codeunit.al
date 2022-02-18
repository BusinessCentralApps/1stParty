codeunit 11507 "Upgrade Mig Local App CH 19x"
{
    ObsoleteState = Pending;
    ObsoleteReason = 'This functionality will be replaced by invoking the actual upgrade from each of the apps';
    ObsoleteTag = '19.0';

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"W1 Company Handler", 'OnUpgradePerCompanyDataForVersion', '', false, false)]
    local procedure OnCompanyMigrationUpgrade(TargetVersion: Decimal)
    begin
        if TargetVersion <> 19.0 then
            exit;

        UpgradeCheckPartnerVATID();
    end;

#if not CLEAN19
    procedure UpgradeCheckPartnerVATID()
    var
        CompanyInformation: Record "Company Information";
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeTagDefCountry: Codeunit "Upgrade Tag Def - Country";
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTagDefCountry.GetCheckPartnerVATIDTag()) then
            exit;

        if CompanyInformation.Get() then begin
            CompanyInformation."Check for Partner VAT ID" := true;
            CompanyInformation."Check for Country of Origin" := true;
            if CompanyInformation.Modify() then;
        end;

        UpgradeTag.SetUpgradeTag(UpgradeTagDefCountry.GetCheckPartnerVATIDTag());
    end;
#endif
}