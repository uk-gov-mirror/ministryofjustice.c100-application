def base_page
  @base_page ||= BasePage.new
end

def home_page
  @home_page ||= HomePage.new
end

def what_you_need_page
  @what_you_need_page ||= WhatYouNeedPage.new
end

def consent_order_page
  @consent_order_page ||= ConsentOrderPage.new
end

def upload_consent_order_page
  @upload_consent_order_page ||= UploadConsentOrderPage.new
end

def child_protection_case_page
  @child_protection_case_page ||= ChildProtectionCasePage.new
end

def child_protection_info_page
  @child_protection_info_page ||= ChildProtectionInfoPage.new
end

def miam_acknowledgement_page
  @miam_acknowledgement_page ||= MiamAcknowledgementPage.new
end

def miam_attended_page
  @miam_attended_page ||= MiamAttendedPage.new
end

def miam_exemption_claim_page
  @miam_exemption_claim_page ||= MiamExemptionClaimPage.new
end

def miam_exemptions_adr_page
  @miam_exemptions_adr_page ||= MiamExemptionsAdrPage.new
end

def miam_exemptions_details_page
  @miam_exemptions_details_page ||= MiamExemptionsDetailsPage.new
end

def miam_exemptions_domestic_page
  @miam_exemptions_domestic_page ||= MiamExemptionsDomesticPage.new
end

def miam_exemptions_misc_page
  @miam_exemptions_misc_page ||= MiamExemptionsMiscPage.new
end

def miam_exemptions_protection_page
  @miam_exemptions_protection_page ||= MiamExemptionsProtectionPage.new
end

def miam_exemptions_reasons_page
  @miam_exemptions_reasons_page ||= MiamExemptionsReasonsPage.new
end

def miam_exemptions_exemption_upload_page
  @miam_exemptions_exemption_upload_page ||= MiamExemptionsExemptionUploadPage.new
end

def miam_exemptions_reasons_playback_page
  @miam_exemptions_reasons_playback_page ||= MiamExemptionsReasonsPlaybackPage.new
end

def miam_exemptions_urgency_page
  @miam_exemptions_urgency_page ||= MiamExemptionsUrgencyPage.new
end

def miam_certification_page
  @miam_certification_page ||= MiamCertificationPage.new
end

def miam_certification_exit_page
  @miam_certification_exit_page ||= MiamCertificationExitPage.new
end

def miam_certification_upload_page
  @miam_certification_upload_page ||= MiamCertificationUploadPage.new
end

def miam_page
  @miam_page ||= MiamPage.new
end

def safety_concern_page
  @safety_concern_page ||= SafetyConcernPage.new
end

def safety_concern_abduction_page
  @safety_concern_abduction_page ||= SafetyConcernAbductionPage.new
end

def abduction_children_have_passport_page
  @abduction_children_have_passport_page ||= AbductionChildrenHavePassportPage.new
end

def abduction_international_page
  @abduction_international_page ||= AbductionInternationalPage.new
end

def abduction_passport_details_page
  @abduction_passport_details_page ||= AbductionPassportDetailsPage.new
end

def abduction_previous_attempt_details_page
  @abduction_previous_attempt_details_page ||= AbductionPreviousAttemptDetailsPage.new
end

def abduction_previous_attempt_page
  @abduction_previous_attempt_page ||= AbductionPreviousAttemptPage.new
end

def abduction_risk_details_page
  @abduction_risk_details_page ||= AbductionRiskDetailsPage.new
end

def abuse_concerns_page
  @abuse_concerns_page ||= AbuseConcernsPage.new
end

def abuse_concerns_children_info_page
  @abuse_concerns_children_info_page ||= AbuseConcernsChildrenInfoPage.new
end

def abuse_concerns_question_page
  @abuse_concerns_question_page ||= AbuseConcernsQuestionPage.new
end

def abuse_concerns_physical_page
  @abuse_concerns_physical_page ||= AbuseConcernsPhysicalPage.new
end

def abuse_concerns_financial_page
  @abuse_concerns_financial_page ||= AbuseConcernsFinancialPage.new
end

def abuse_concerns_financial_details_page
  @abuse_concerns_financial_details_page ||= AbuseConcernsFinancialDetailsPage.new
end

def abuse_concerns_psychological_page
  @abuse_concerns_psychological_page ||= AbuseConcernsPsychologicalPage.new
end

def abuse_concerns_emotional_page
  @abuse_concerns_emotional_page ||= AbuseConcernsEmotionalPage.new
end

def abuse_concerns_children_other_page
  @abuse_concerns_children_other_page ||= AbuseConcernsChildrenOtherPage.new
end

def abuse_concerns_children_other_details_page
  @abuse_concerns_children_other_details_page ||= AbuseConcernsChildrenOtherDetailsPage.new
end

def abuse_concerns_applicant_info_page
  @abuse_concerns_applicant_info_page ||= AbuseConcernsApplicantInfoPage.new
end

def abuse_concerns_applicant_question_page
  @abuse_concerns_applicant_question_page ||= AbuseConcernsApplicantQuestionPage.new
end

def abuse_concerns_applicant_physical_page
  @abuse_concerns_applicant_physical_page ||= AbuseConcernsApplicantPhysicalPage.new
end

def abuse_concerns_applicant_financial_page
  @abuse_concerns_applicant_financial_page ||= AbuseConcernsApplicantFinancialPage.new
end

def abuse_concerns_applicant_psychological_page
  @abuse_concerns_applicant_psychological_page ||= AbuseConcernsApplicantPsychologicalPage.new
end

def abuse_concerns_applicant_emotional_page
  @abuse_concerns_applicant_emotional_page ||= AbuseConcernsApplicantEmotionalPage.new
end

def abuse_concerns_applicant_other_page
  @abuse_concerns_applicant_other_page ||= AbuseConcernsApplicantOtherPage.new
end

def applicant_has_protection_court_order_page
  @applicant_has_protection_court_order_page ||= ApplicantHasProtectionCourtOrderPage.new
end

def abuse_concerns_contact_page
  @abuse_concerns_contact_page ||= AbuseConcernsContactPage.new
end

def abuse_concerns_psychological_details_page
  @abuse_concerns_psychological_details_page ||= AbuseConcernsPsychologicalDetailsPage.new
end

def abuse_concerns_emotional_details_page
  @abuse_concerns_emotional_details_page ||= AbuseConcernsEmotionalDetailsPage.new
end

def abuse_concerns_applicant_question_details_page
  @abuse_concerns_applicant_question_details_page ||= AbuseConcernsApplicantQuestionDetailsPage.new
end

def abuse_concerns_applicant_physical_details_page
  @abuse_concerns_applicant_physical_details_page ||= AbuseConcernsApplicantPhysicalDetailsPage.new
end

def abuse_concerns_applicant_financial_details_page
  @abuse_concerns_applicant_financial_details_page ||= AbuseConcernsApplicantFinancialDetailsPage.new
end

def abuse_concerns_applicant_psychological_details_page
  @abuse_concerns_applicant_psychological_details_page ||= AbuseConcernsApplicantPsychologicalDetailsPage.new
end

def abuse_concerns_applicant_emotional_details_page
  @abuse_concerns_applicant_emotional_details_page ||= AbuseConcernsApplicantEmotionalDetailsPage.new
end

def abuse_concerns_applicant_other_details_page
  @abuse_concerns_applicant_other_details_page ||= AbuseConcernsApplicantOtherDetailsPage.new
end

def safety_concern_substance_page
  @safety_concern_substance_page ||= SafetyConcernSubstancePage.new
end

def safety_concern_abuse_page
  @safety_concern_abuse_page ||= SafetyConcernAbusePage.new
end

def safety_concern_domestic_page
  @safety_concern_domestic_page ||= SafetyConcernDomesticPage.new
end

def safety_concern_other_page
  @safety_concern_other_page ||= SafetyConcernOtherPage.new
end

def petition_orders_page
  @petition_orders_page ||= PetitionOrdersPage.new
end

def petition_playback_page
  @petition_playback_page ||= PetitionPlaybackPage.new
end

def petition_protection_page
  @petition_protection_page ||= PetitionProtectionPage.new
end

def alternative_court_page
  @alternative_court_page ||= AlternativeCourtPage.new
end

def alternative_page
  @alternative_page ||= AlternativePage.new
end

def alternative_negotiation_page
  @alternative_negotiation_page ||= AlternativeNegotiationPage.new
end

def alternative_mediation_page
  @alternative_mediation_page ||= AlternativeMediationPage.new
end

def alternative_lawyer_page
  @alternative_lawyer_page ||= AlternativeLawyerPage.new
end

def alternative_collaborative_law_page
  @alternative_collaborative_law_page ||= AlternativeCollaborativeLawPage.new
end

def children_names_page
  @children_names_page ||= ChildrenNamesPage.new
end

def child_personal_details_page
  @child_personal_details_page ||= ChildPersonalDetailsPage.new
end

def child_orders_page
  @child_orders_page ||= ChildOrdersPage.new
end

def other_children_names_page
  @other_children_names_page ||= OtherChildrenNamesPage.new
end

def other_children_personal_details_page
  @other_children_personal_details_page ||= OtherChildrenPersonalDetailsPage.new
end

def special_guardianship_page
  @special_guardianship_page ||= SpecialGuardianshipPage.new
end

def parental_responsibility_page
  @parental_responsibility_page ||= ParentalResponsibilityPage.new
end

def child_additional_details_page
  @child_additional_details_page ||= ChildAdditionalDetailsPage.new
end

def has_other_children_page
  @has_other_children_page ||= HasOtherChildrenPage.new
end

def applicant_names_page
  @applicant_names_page ||= ApplicantNamesPage.new
end

def applicant_privacy_known_page
  @applicant_privacy_known_page ||= ApplicantPrivacyKnownPage.new
end

def applicant_privacy_preferences_page
  @applicant_privacy_preferences_page ||= ApplicantPrivacyPreferencesPage.new
end

def applicant_privacy_summary_page
  @applicant_privacy_summary_page ||= ApplicantPrivacySummaryPage.new
end

def applicant_refuge_page
  @applicant_refuge_page ||= ApplicantRefugePage.new
end

def applicant_personal_details_page
  @applicant_personal_details_page ||= ApplicantPersonalDetailsPage.new
end

def applicant_relationship_page
  @applicant_relationship_page ||= ApplicantRelationshipPage.new
end

def address_lookup_page
  @address_lookup_page ||= AddressLookupPage.new
end

def applicant_address_details_page
  @applicant_address_details_page ||= ApplicantAddressDetailsPage.new
end

def applicant_contact_details_page
  @applicant_contact_details_page ||= ApplicantContactDetailsPage.new
end

def applicant_has_solicitor_page
  @applicant_has_solicitor_page ||= ApplicantHasSolicitorPage.new
end

def solicitor_personal_details_page
  @solicitor_personal_details_page ||= SolicitorPersonalDetailsPage.new
end

def solicitor_address_details_page
  @solicitor_address_details_page ||= SolicitorAddressDetailsPage.new
end

def solicitor_contact_details_page
  @solicitor_contact_details_page ||= SolicitorContactDetailsPage.new
end

def respondent_names_page
  @respondent_names_page ||= RespondentNamesPage.new
end

def respondent_personal_details_page
  @respondent_personal_details_page ||= RespondentPersonalDetailsPage.new
end

def respondent_relationship_page
  @respondent_relationship_page ||= RespondentRelationshipPage.new
end

def respondent_address_lookup_page
  @respondent_address_lookup_page ||= RespondentAddressLookupPage.new
end

def respondent_address_details_page
  @respondent_address_details_page ||= RespondentAddressDetailsPage.new
end

def respondent_contact_details_page
  @respondent_contact_details_page ||= RespondentContactDetailsPage.new
end

def respondent_refuge_page
  @respondent_refuge_page ||= RespondentRefugePage.new
end

def has_other_parties_page
  @has_other_parties_page ||= HasOtherPartiesPage.new
end

def other_party_names_page
  @other_party_names_page ||= OtherPartyNamesPage.new
end

def other_party_personal_details_page
  @other_party_personal_details_page ||= OtherPartyPersonalDetailsPage.new
end

def other_party_address_details_page
  @other_party_address_details_page ||= OtherPartyAddressDetailsPage.new
end

def other_party_children_cohabit_page
  @other_party_children_cohabit_page ||= OtherPartyChildrenCohabitPage.new
end

def other_party_identity_preferences_page
  @other_party_identity_preferences_page ||= OtherPartyIdentityPreferencesPage.new
end

def other_party_privacy_preferences_page
  @other_party_privacy_preferences_page ||= OtherPartyPrivacyPreferencesPage.new
end

def other_party_refuge_page
  @other_party_refuge_page ||= OtherPartyRefugePage.new
end

def child_residence_page
  @child_residence_page ||= ChildResidencePage.new
end

def previous_proceedings_page
  @previous_proceedings_page ||= PreviousProceedingsPage.new
end

def previous_court_proceedings_page
  @previous_court_proceedings_page ||= PreviousCourtProceedingsPage.new
end

def existing_court_order_page
  @existing_court_order_page ||= ExistingCourtOrderPage.new
end

def existing_court_order_uploadable_page
  @existing_court_order_uploadable_page ||= ExistingCourtOrderUploadablePage.new
end

def existing_court_order_upload_page
  @existing_court_order_upload_page ||= ExistingCourtOrderUploadPage.new
end

def urgent_hearing_page
  @urgent_hearing_page ||= UrgentHearingPage.new
end

def urgent_hearing_details_page
  @urgent_hearing_details_page ||= UrgentHearingDetailsPage.new
end

def without_notice_page
  @without_notice_page ||= WithoutNoticePage.new
end

def without_notice_details_page
  @without_notice_details_page ||= WithoutNoticeDetailsPage.new
end

def international_resident_page
  @international_resident_page ||= InternationalResidentPage.new
end

def international_jurisdiction_page
  @international_jurisdiction_page ||= InternationalJurisdictionPage.new
end

def international_request_page
  @international_request_page ||= InternationalRequestPage.new
end

def application_details_page
  @application_details_page ||= ApplicationDetailsPage.new
end

def litigation_capacity_page
  @litigation_capacity_page ||= LitigationCapacityPage.new
end

def litigation_capacity_details_page
  @litigation_capacity_details_page ||= LitigationCapacityDetailsPage.new
end

def attending_court_intermediary_page
  @attending_court_intermediary_page ||= AttendingCourtIntermediaryPage.new
end

def attending_court_language_page
  @attending_court_language_page ||= AttendingCourtLanguagePage.new
end

def attending_court_special_arrangements_page
  @attending_court_special_arrangements_page ||= AttendingCourtSpecialArrangementsPage.new
end

def attending_court_special_assistance_page
  @attending_court_special_assistance_page ||= AttendingCourtSpecialAssistancePage.new
end

def submission_page
  @submission_page ||= SubmissionPage.new
end

def submission_email_check_page
  @submission_email_check_page ||= SubmissionEmailCheckPage.new
end

def application_payment_page
  @application_payment_page ||= ApplicationPaymentPage.new
end

def cya_page
  @cya_page ||= CYAPage.new
end

def cookie_management_page
  @cookie_management_page ||= CookieManagementPage.new
end

def completion_confirmation_page
  @completion_confirmation_page ||= CompletionConfirmationPage.new
end

def get_birthdate(age)
  today = Date.today
  dob_date = today - age.to_i.years

  day = dob_date.day.to_s.rjust(2, '0')
  month = dob_date.month.to_s.rjust(2, '0')
  year = dob_date.year

  "#{day}-#{month}-#{year}"
end

def stub_courtfinder_api
  stub_resp = {
    "slug"=>"childcare-arrangements",
    "name"=>"Childcare arrangements if you separate from your partner",
    "onlineText"=>nil,
    "onlineUrl"=>"https://apply-to-court-about-child-arrangements.service.justice.gov.uk/",
    "courts"=>[{"name"=>"Coventry Combined Court Centre",
                "slug"=>"coventry-combined-court-centre",
                "distance"=>10.6,
                "areasOfLawSpoe"=>["Children"]}]
  }
  court_lookup_resp = {"name"=>"Coventry Combined Court Centre", "slug"=>"coventry-combined-court-centre", "info"=>"<p><a href=https://www.gov.uk/government/news/scammers-using-hmcts-telephone-numbers>Scammers are mimicking genuine HMCTS phone numbers and email addresses</a>. They may demand payment and claim to be from HMRC or enforcement. If you're unsure, do not pay anything and report the scam to <a href=https://www.actionfraud.police.uk/>Action Fraud</a>.</p>", "open"=>true, "directions"=>nil, "image_file"=>"coventry_combined_court_centre.jpg", "lat"=>52.4055836530515, "lon"=>-1.50643963844351, "urgent_message"=>"", "crown_location_code"=>417, "family_location_code"=>180, "magistrates_location_code"=>nil, "tribunal_location_code"=>nil, "areas_of_law"=>[{"name"=>"Adoption", "external_link"=>"https://www.gov.uk/child-adoption", "display_url"=>nil, "external_link_desc"=>"Information about adopting a child", "display_name"=>nil, "display_external_link"=>"https://www.gov.uk/child-adoption/applying-for-an-adoption-court-order"}, {"name"=>"Bankruptcy", "external_link"=>"https://www.gov.uk/apply-for-bankruptcy", "display_url"=>nil, "external_link_desc"=>"Information about applying for bankruptcy", "display_name"=>nil, "display_external_link"=>"https://www.gov.uk/bankruptcy"}, {"name"=>"Children", "external_link"=>"", "display_url"=>nil, "external_link_desc"=>nil, "display_name"=>"Childcare arrangements if you separate from your partner", "display_external_link"=>"https://www.gov.uk/looking-after-children-divorce"}, {"name"=>"Crime", "external_link"=>"", "display_url"=>nil, "external_link_desc"=>nil, "display_name"=>nil, "display_external_link"=>nil}, {"name"=>"Divorce", "external_link"=>"https://www.gov.uk/divorce", "display_url"=>nil, "external_link_desc"=>"Information about getting a divorce", "display_name"=>"Divorce hearings", "display_external_link"=>nil}, {"name"=>"Domestic violence", "external_link"=>"", "display_url"=>nil, "external_link_desc"=>nil, "display_name"=>"Domestic abuse", "display_external_link"=>"https://www.gov.uk/injunction-domestic-violence"}, {"name"=>"High Court District Registry", "external_link"=>"", "display_url"=>nil, "external_link_desc"=>nil, "display_name"=>"High Court cases – serious or high profile criminal or civil law cases", "display_external_link"=>nil}, {"name"=>"Housing possession", "external_link"=>"https://www.gov.uk/evicting-tenants", "display_url"=>nil, "external_link_desc"=>"Information about evicting tenants", "display_name"=>"Housing", "display_external_link"=>nil}, {"name"=>"Money claims", "external_link"=>"https://www.gov.uk/make-court-claim-for-money", "display_url"=>nil, "external_link_desc"=>"Information about making a court claim for money", "display_name"=>nil, "display_external_link"=>nil}, {"name"=>"Single justice procedure", "external_link"=>"", "display_url"=>nil, "external_link_desc"=>nil, "display_name"=>nil, "display_external_link"=>nil}], "types"=>["Family Court", "County Court", "Crown Court"], "emails"=>[{"address"=>"warwickcrowncourt@justice.gov.uk", "description"=>"Crown court", "explanation"=>nil}, {"address"=>"bailiffs.coventry.countycourt@justice.gov.uk", "description"=>"Enforcement", "explanation"=>nil}, {"address"=>"civilenquiries.coventry.countycourt@justice.gov.uk", "description"=>"County court", "explanation"=>"Civil enquiries"}, {"address"=>"Civilhearings.coventry.countycourt@justice.gov.uk", "description"=>"Listing", "explanation"=>nil}, {"address"=>"coventry.breathingspace@justice.gov.uk", "description"=>"Breathing space enquiries", "explanation"=>""}, {"address"=>"divorce.coventry.countycourt@justice.gov.uk", "description"=>"Family court", "explanation"=>nil}, {"address"=>"children.coventry.countycourt@justice.gov.uk", "description"=>"Family public law (children in care)", "explanation"=>"Paper process"}, {"address"=>"contactfpl@justice.gov.uk", "description"=>"Family public law (children in care)", "explanation"=>"Digital process for case numbers starting with C5"}, {"address"=>"coventryprivatelawapplications@justice.gov.uk", "description"=>"Applications", "explanation"=>"C100 applications"}], "contacts"=>[{"number"=>"0300 332 1000", "description"=>"Enquiries", "explanation"=>"Witness Services enquiries"}, {"number"=>"0300 123 5577", "description"=>"County court", "explanation"=>""}, {"number"=>"0247 653 6322", "description"=>"Counter appointments", "explanation"=>""}, {"number"=>"01926 429 133", "description"=>"Crown court", "explanation"=>""}, {"number"=>"0330 808 4424", "description"=>"Family public law (children in care)", "explanation"=>"Digital process for case numbers starting with C5"}, {"number"=>"01264 347 973", "description"=>"Fax", "explanation"=>""}], "opening_times"=>[{"description"=>"Counter service by appointment only", "hours"=>"Monday to Friday 10am to 2pm", "description_cy"=>nil}, {"description"=>"Telephone enquiries answered", "hours"=>"Monday to Friday 8:30am to 5pm", "description_cy"=>nil}, {"description"=>"Court open", "hours"=>"Monday to Friday 9am to 5pm", "description_cy"=>nil}], "application_updates"=>[], "facilities"=>[{"description"=>"This building has level access to the building entrance, and court room.\r\n ", "name"=>"Disabled access", "order"=>2}, {"description"=>"Assistance dogs are welcome.", "name"=>"Assistance dogs", "order"=>4}, {"description"=>"The building has hearing enhancement facilities available by prior arrangement.  Please contact the Court office by telephone or email if necessary.", "name"=>"Hearing Loop", "order"=>5}, {"description"=>"Refreshments are available via Vending Machine.", "name"=>"Refreshments", "order"=>11}, {"description"=>"4 interview rooms are available on the ground floor", "name"=>"Interview room", "order"=>12}, {"description"=>"This Court has a childrens room facility.", "name"=>"Children's waiting room", "order"=>14}, {"description"=>"Baby changing facilities are available in the disabled toilets on the ground floor\r\n ", "name"=>"Baby changing facility", "order"=>15}, {"description"=>"Court/hearing room video conferencing facilities and prison to court video link facilities are available by prior arrangement.Please contact the Court administration to check availability.\r\n \r\n.\r\n ", "name"=>"Video facilities", "order"=>17}, {"description"=>" \r\nSupport for witnesses is available from the <a href=\"https://www.citizensadvice.org.uk/\" rel=\"nofollow\">Citizens Advice</a> witness service. Support Through Court is available on Mondays to provide assistance.", "name"=>"Witness service", "order"=>19}], "addresses"=>[{"address_lines"=>["140 Much Park Street"], "postcode"=>"CV1 2SN", "town"=>"Coventry", "type"=>"Visit or contact us", "county"=>"Warwickshire", "description"=>nil, "fields_of_law"=>nil}], "gbs"=>"Y260", "dx_number"=>["701580 Coventry 5"], "service_area"=>[], "in_person"=>true, "access_scheme"=>true, "additional_links"=>[{"url"=>"https://www.gov.uk/guidance/debt-respite-breathing-space-scheme-creditors-responsibilities-to-the-court", "description"=>"Breathing Space"}], "common_flag"=>false, "service_centre"=>{"is_a_service_centre"=>false, "intro_paragraph"=>"", "intro_paragraph_cy"=>""}}
  C100App::NewCourtfinderApi.any_instance.stub(:court_for).and_return(stub_resp)
  C100App::NewCourtfinderApi.any_instance.stub(:court_lookup).and_return(court_lookup_resp)
end