const Map<String, String> appSw = {
  // Common
  'common_email': 'Barua Pepe',
  'common_password': 'Nenosiri',
  'common_full_name': 'Jina Kamili',
  'common_cancel': 'Ghairi',
  'common_delete': 'Futa',
  'common_ok': 'Sawa',
  'common_na': 'Haina',
  'common_user': 'Mtumiaji',
  'common_buyer': 'Mnunuzi',
  'common_seller': 'Muuzaji',
  'common_pass': 'IMEPITA',
  'common_fail': 'IMESHINDWA',
  'common_risk_score': 'Alama ya Hatari',
  'common_verification_passed': 'Uthibitisho umepita',
  'common_verification_blocked': 'Uthibitisho umekatwa',
  'common_unknown': 'Haijulikani',
  'common_unknown_time': 'Muda haijulikani',
  'common_error': 'Hitilafu',
  'common_brand': 'Angalia Ardhi',

  // Validation / controller messages
  'err_email_password_required': 'Barua pepe na nenosiri zinahitajika.',
  'err_login_failed': 'Kuingia kumeshindikana: :error',
  'err_register_required': 'Jina, barua pepe, na nenosiri zinahitajika.',
  'err_passwords_mismatch': 'Nenosiri hazifanani.',
  'err_register_failed': 'Usajili umeshindikana: :error',
  'err_plot_required': 'Rejea ya kiwanja inahitajika.',
  'err_plot_unexpected': 'Hitilafu isiyotarajiwa wakati wa kutafuta kiwanja.',
  'err_nin_required': 'NIN inahitajika.',
  'err_nin_length': 'NIN lazima iwe herufi 20 haswa (mfano, 19901215-25555-00001).',
  'err_nin_format': 'NIN lazima ifuate muundo YYYYMMDD-#####-##### (mfano, 19901215-25555-00001).',
  'err_session_missing': 'Kipindi cha uthibitisho hakipo. Anza tena.',
  'err_nin_unexpected': 'Hitilafu isiyotarajiwa wakati wa kutengeneza maswali.',
  'err_challenge_expired': 'Muda wa changamoto umeisha. Tengeneza maswali mapya.',
  'err_answer_all': 'Tafadhali jibu maswali yote.',
  'err_answers_unexpected': 'Hitilafu isiyotarajiwa wakati wa kuwasilisha majibu.',
  'err_auth_required': 'Uthibitisho wa kuingia unahitajika.',

  // Verdicts
  'verdict_safe': 'Salama',
  'verdict_caution': 'Tahadhari',
  'verdict_blocked': 'Imekatwa',
  'verdict_do_not_buy': 'USINUNUE',

  // Landing
  'landing_tagline': 'Uthibitisho wa Ardhi Tanzania',
  'landing_hero_title': 'Hakikisha Ardhi\nKabla ya Kununua',
  'landing_hero_subtitle': 'Jilinde kabla ya kulipa',
  'landing_hero_description':
      'Jilinde dhidi ya udanganyifu wa ardhi. Thibitisha umiliki, hali ya kisheria, na uhalisia kabla ya kufanya muamala.',
  'landing_step_gps': 'GPS',
  'landing_step_nida': 'NIDA',
  'landing_step_alerts': 'Tahadhari',
  'landing_get_started': 'Anza Sasa',
  'landing_has_account': 'Tayari Nina Akaunti',

  // Login
  'login_welcome_back': 'Karibu Tena',
  'login_title': 'Ingia',
  'login_subtitle': 'Fikia akaunti yako kwa usalama',
  'login_forgot_password': 'Umesahau Nenosiri?',
  'login_no_account': 'Huna akaunti? ',
  'login_register': 'Jiunge',

  // Register
  'register_tagline': 'Jifunze Kuangalia',
  'register_title': 'Fungua Akaunti',
  'register_subtitle': 'Weka wasifu wako wa uthibitisho',
  'register_phone_optional': 'Nambari ya Simu (si lazima)',
  'register_i_am_a': 'Mimi ni',
  'register_confirm_password': 'Thibitisha Nenosiri',
  'register_has_account': 'Tayari una akaunti? ',

  // Home
  'home_greeting': 'Habari,',
  'home_verify_land': 'Thibitisha Ardhi',
  'home_check_before_buy': 'Kagua kabla ya kununua',
  'home_start_verification': 'Anza Uthibitisho',
  'home_step_plot': 'Shamba',
  'home_step_gps': 'GPS',
  'home_step_nida': 'NIDA',
  'home_step_alerts': 'Tahadhari',
  'home_summary_total': 'Jumla',
  'home_summary_safe': 'Salama',
  'home_summary_avg_risk': 'Hatari Wastani',
  'home_recent_verifications': 'Uthibitisho wa Hivi Karibuni',
  'home_total_count': ':count jumla',
  'home_empty_title': 'Hakuna Uthibitisho Bado',
  'home_empty_subtitle':
      'Historia yako ya uthibitisho wa ardhi itaonekana hapa.',
  'home_logout': 'Toka',
  'home_logout_title': 'Toka?',
  'home_logout_confirm': 'Una uhakika unataka kutoka kwenye ArdhiLens?',
  'history_tap_hint': 'Angalia',
  'history_detail_title': 'Maelezo ya Uthibitisho',
  'history_when': 'Wakati',
  'history_log_id': 'Namba ya Logi',

  // Plot
  'plot_step_1_of_4': 'HATUA 1 KATI YA 4',
  'plot_title': 'Tafuta Shamba Lako',
  'plot_subtitle': 'Weka nambari ya marejeo ya shamba lako',
  'plot_reference': 'Nambari ya Shamba',
  'plot_reference_hint': 'mfano, PLOT-001',
  'plot_find': 'Tafuta Shamba',

  // GPS
  'gps_step_2_of_4': 'HATUA 2 KATI YA 4',
  'gps_title': 'Thibitisha Eneo la Kiwanja',
  'gps_subtitle':
      'Thibitisha kiwanja chochote kilichosajiliwa kutoka mbali. GPS ya simu ni hiari kwa alama ya kuwa eneo.',
  'gps_coordinates': 'Kuratibu za kiwanja',
  'gps_latitude': 'Urefu (Latitude)',
  'gps_lat_hint': 'mfano, -6.8012',
  'gps_longitude': 'Upana (Longitude)',
  'gps_lng_hint': 'mfano, 39.2021',
  'gps_verify': 'Endelea na uthibitisho',
  'gps_not_recorded': 'GPS ya shamba haijaandikwa',
  'gps_demo_title': 'Mfano wa Maonyesho',
  'gps_demo_desc':
      'Simulia viwianishi vya GPS kwa maonyesho darasani. Duara la kijani linaonyesha eneo la uthibitisho la mita 250.',
  'gps_sim_nearby': 'Simulia Karibu',
  'gps_sim_nearby_sub': 'Ndani ya mita 250',
  'gps_sim_far': 'Simulia Mbali',
  'gps_sim_far_sub': 'Nje ya mita 250',
  'gps_use_device_title': 'Hiari: Niko kwenye kiwanja',
  'gps_use_device_desc':
      'Tumia GPS ya simu kupata alama ya kuwa eneo. Bado unaweza kuthibitisha kutoka popote bila hii.',
  'gps_use_device_btn': 'Tumia Eneo Langu Sasa',
  'gps_use_plot_btn': 'Tumia Eneo Lililosajiliwa la Kiwanja',
  'gps_location_disabled': 'Huduma za eneo zimezimwa kwenye kifaa hiki.',
  'gps_location_denied': 'Ruhusa ya eneo imekataliwa.',
  'gps_location_denied_forever':
      'Ruhusa ya eneo imekataliwa kabisa. Iwashe kwenye mipangilio ya mfumo.',
  'gps_location_failed': 'Imeshindwa kusoma eneo lako la GPS.',
  'gps_coords_invalid': 'Weka latitudo na longitudo sahihi.',
  'gps_session_missing': 'Kipindi cha uthibitisho hakipo. Anza tena kutoka utafutaji wa shamba.',
  'gps_move_closer': 'Karibia zaidi eneo la shamba lililosajiliwa.',
  'gps_unexpected_error': 'Hitilafu isiyotarajiwa ya GPS. Jaribu tena.',
  'gps_mode_remote_title': 'Ukaguzi wa mbali',
  'gps_mode_remote_body':
      'Kiwanja kimethibitishwa kutoka mbali. Unaendelea bila kulazimika kuwa kwenye kiwanja.',
  'gps_mode_on_site_title': 'Imethibitishwa eneo',
  'gps_mode_on_site_body':
      'Eneo lako linalingana na eneo la kiwanja lililosajiliwa.',

  // NIN
  'nin_step_3_of_4': 'HATUA 3 KATI YA 4',
  'nin_title': 'Uthibitisho wa Utambulisho',
  'nin_subtitle':
      'Weka NIN yoyote halali ya NIDA (muundo YYYYMMDD-#####-#####). Inahifadhiwa na uthibitisho huu.',
  'nin_disclaimer':
      'NIN yako inatumika kwa uthibitisho pekee na haiunganishwi kama mmiliki wa kudumu wa kiwanja.',
  'nin_label': 'Nambari ya Kitambulisho (NIDA)',
  'nin_hint': '19901215-25555-00001',
  'nin_generate': 'Tengeneza Maswali',
  'nin_demo_map':
      'NIN za mfano (kiwanja chochote): 19901215-25555-00001 · 19750310-25555-00003 · 19920822-25555-00004 · 19811105-25555-00005',

  // Questions
  'q_step_4_of_4': 'HATUA 4 KATI YA 4',
  'q_title': 'Maswali ya Usalama',
  'q_subtitle': 'Majibu yanapaswa kulingana na rekodi ya NIDA ya NIN uliyoweka',
  'q_submit': 'Wasilisha Majibu',
  'q_fallback': 'Swali',
  'q_hint': 'Weka thamani sahihi kama ilivyo kwenye rekodi ya NIDA',
  'q_demo_title': 'Majibu ya mfano kwa NIN hii',
  'q_demo_desc':
      'Thamani hizi zinatokana na wasifu wa NIDA uliopandwa. Bonyeza jaza, kisha wasilisha.',
  'q_demo_fill': 'Jaza majibu ya mfano',

  // Result
  'result_loading': 'Inapakia matokeo...',
  'result_passed': 'Uthibitisho Umepita',
  'result_completed': 'Uthibitisho Umekamilika',
  'result_blocked': 'Uthibitisho Umekatwa',
  'result_identity_info': 'Taarifa za Utambulisho',
  'result_gender': 'Jinsia',
  'result_nin': 'NIN',
  'result_nida_failed':
      'Uthibitisho wa utambulisho wa NIDA umeshindwa. Matokeo yamejengwa kwa hatua nyingine za uthibitisho pekee.',
  'result_id_photo': 'Picha ya Kitambulisho',
  'result_image_unavailable': 'Picha haipatikani',
  'result_risk_assessment': 'Tathmini ya Hatari',
  'result_recommendation': 'Pendekezo',
  'result_reasons': 'Sababu za Uthibitisho',
  'result_start_new': 'Anza Uthibitisho Mpya',
  'result_steps': 'Hatua za Uthibitisho',
  'result_step_plot_found': 'Shamba Limepatikana',
  'result_step_gps': 'Uthibitisho wa GPS',
  'result_step_nida': 'Kagua Utambulisho wa NIDA',
  'result_step_owner': 'Kagua Muunganisho wa Mmiliki',
  'result_certificate': 'Cheti cha Uthibitisho',
  'result_cert_number': 'Nambari ya Cheti',
  'result_issued': 'Imetolewa',
  'result_view_cert': 'Angalia Cheti',
  'result_owner_link': 'Muunganisho wa Mmiliki',
  'result_owner_link_buyer_hint':
      'Muunganisho wa Mmiliki unalinganisha NIN yako na mmiliki aliyesajiliwa kwenye shamba. Kama mnunuzi, "Hapana" ni kawaida — unakagua ardhi ya mtu mwingine, si kuthibitisha umiliki wako.',
  'result_owner_link_seller_hint':
      'Muunganisho wa Mmiliki umeshindikana. Kwenye Eneo la Muuzaji, wasilisha KYC kwa NIN iliyosajiliwa kama mmiliki wa shamba hili, kisha fanya uthibitisho tena ukitumia NIN hiyo hiyo katika Hatua ya 3.',
  'result_plot_owner_match': 'Mmiliki wa Shamba Anafanana',
  'result_history_match': 'Historia Inafanana',
  'result_yes': 'Ndiyo',
  'result_no': 'Hapana',
  'result_block_reasons': 'Sababu za Kukatwa',
  'result_assistant': 'Msaidizi wa Ardhi',
  'result_assistant_desc':
      'Pata ufafanuzi zaidi kuhusu matokeo yako ya uthibitisho kutoka kwa msaidizi wetu wa AI.',
  'result_ref_log': 'Rejeo: :id',
  'result_assistant_unavailable': 'Msaidizi haupatikani kwa matokeo haya.',
  'result_open_chat': 'Fungua Mazungumzo',

  // Chat
  'chat_title': 'Msaidizi wa Ardhi',
  'chat_fallback_title': 'Mazungumzo',
  'chat_ref_log': 'Rejeo: :id',
  'chat_unavailable_title': 'Msaidizi Haupatikani',
  'chat_unavailable_desc':
      'Mazungumzo hayo hayapatikani. Fanya uthibitisho kwanza.',
  'chat_empty_title': 'Anza mazungumzo',
  'chat_empty_desc':
      'Uliza maswali kuhusu matokeo yako ya uthibitisho na upate ufafanuzi unaotolewa na AI.',
  'chat_thinking': 'Msaidizi anafikiria...',
  'chat_input_hint': 'Uliza swali la ziada...',
  'chat_assistant_label': 'Msaidizi',
  'chat_out_of_scope': 'Nje ya kikomo cha uthibitisho',
  'chat_recommended': 'Pendekezo: :action',
  'chat_default_question': 'Naomba ufafanuzi wa kina wa matokeo haya kwa mnunuzi.',
  'chat_default_question_sw':
      'Naomba ufafanuzi wa kina wa matokeo haya kwa mnunuzi.',
  'chat_error_response':
      'Samahani, nimekwama kujibu swali hilo kwa sasa. Tafadhali jaribu tena au uliza kwa namna nyingine.',
  'chat_error_response_sw':
      'Samahani, nimekwama kujibu swali hilo kwa sasa. Tafadhali jaribu tena au uliza kwa namna nyingine.',
  'chat_unexpected_error':
      'Hitilafu isiyotarajiwa wakati wa kupata ufafanuzi.',
  'chat_unexpected_error_sw':
      'Hitilafu isiyotarajiwa wakati wa kupata ufafanuzi.',
  'chat_service_error':
      'Huduma ya maelezo imepata hitilafu ya muda. Tafadhali jaribu tena baada ya muda mfupi.',
  'chat_service_error_sw':
      'Huduma ya maelezo imepata hitilafu ya muda. Tafadhali jaribu tena baada ya muda mfupi.',
  'chat_quick_1': 'Hii sababu ina maana gani kwa mnunuzi?',
  'chat_quick_2': 'Nyaraka gani nihakiki kabla ya kulipa?',
  'chat_quick_3': 'Madhara gani nikipuuzia tahadhari hizi?',
  'chat_quick_4': 'Niende wapi kupata msaada rasmi wa ardhi?',
  'chat_quick_1_sw': 'Hii sababu ina maana gani kwa mnunuzi?',
  'chat_quick_2_sw': 'Nyaraka gani nihakiki kabla ya kulipa?',
  'chat_quick_3_sw': 'Madhara gani nikipuuzia tahadhari hizi?',
  'chat_quick_4_sw': 'Niende wapi kupata msaada rasmi wa ardhi?',

  // Notifications
  'notif_title': 'Tahadhari',
  'notif_mark_all_read': 'Weka zote zimesomwa',
  'notif_empty_title': 'Hakuna Tahadhari',
  'notif_empty_desc':
      'Umekamilisha! Tahadhari kuhusu uthibitisho wa ardhi yako zitaonekana hapa.',
  'notif_delete_title': 'Futa Tahadhari',
  'notif_delete_confirm':
      'Una uhakika unataka kufuta tahadhari hii?',
  'notif_just_now': 'Sasa hivi',
  'notif_minutes_ago': 'dakika :count zilizopita',
  'notif_hours_ago': 'masaa :count yaliyopita',
  'notif_days_ago': 'siku :count zilizopita',
  'notif_weeks_ago': 'wiki :count zilizopita',
  'notif_months_ago': 'miezi :count iliyopita',

  // Certificates
  'cert_title': 'Vyeti vya Uthibitisho',
  'cert_yours': 'Vyeti Vyako',
  'cert_total_count': ':count jumla',
  'cert_plot_label': 'Shamba: :ref',
  'cert_expired': 'IMEISHIA',
  'cert_expired_badge': 'Imeisha',
  'cert_download': 'Pakua PDF',
  'cert_view': 'Angalia kwenye app',
  'cert_downloading': 'Inapakua...',
  'cert_view_failed': 'Imeshindwa kufungua cheti ndani ya app.',
  'cert_open_failed': 'Imeshindwa kufungua faili iliyohifadhiwa.',
  'cert_saved_to': 'Imehifadhiwa kwenye :path',
  'cert_email_copy_hint': 'Nakala pia imetumwa kwa barua pepe yako.',
  'cert_download_failed': 'Imeshindwa kupakua PDF ya cheti.',
  'cert_open_saved': 'Imehifadhiwa: :path',
  'cert_download_endpoint': 'Mwisho wa kupakua: :url',
  'cert_empty_title': 'Hakuna Vyeti Bado',
  'cert_empty_desc':
      'Hakuna vyeti bado. Kamilisha uthibitisho wa ardhi ili upokee cheti.',

  // Documents
  'docs_title': 'Nyaraka',
  'docs_subtitle': 'Pakia na simamia faili za muamala wa ardhi',
  'docs_subtitle_seller':
      'Chagua shamba, kisha pakia nyaraka za umiliki na mauzo kwa shamba hilo pekee.',
  'docs_subtitle_buyer':
      'Weka rejea ya shamba ili kuona nyaraka za muuzaji (angalia tu).',
  'docs_upload_section': 'Pakia Nyaraka',
  'docs_type_label': 'Aina ya nyaraka',
  'docs_upload_btn': 'Chagua Faili & Pakia',
  'docs_list_title': 'Nyaraka Zako',
  'docs_list_title_buyer': 'Nyaraka za Muuzaji',
  'docs_empty_title': 'Hakuna Nyaraka Bado',
  'docs_empty_desc':
      'Pakia mikataba ya mauzo, hati miliki, ramani za uchunguzi, au kitambulisho hapa.',
  'docs_empty_desc_seller':
      'Chagua shamba lililounganishwa hapo juu, kisha pakia hati, ramani, au mikataba.',
  'docs_empty_desc_buyer':
      'Weka rejea (mf. PLOT-001) ili ukague nyaraka za muuzaji kabla ya kununua.',
  'docs_open': 'Fungua',
  'docs_view_only': 'Angalia',
  'docs_view_plot_docs': 'Angalia Nyaraka za Shamba',
  'docs_select_plot': 'Chagua shamba kabla ya kupakia.',
  'docs_select_plot_hint':
      'Nyaraka lazima ziunganishwe na shamba lako lililounganishwa.',
  'docs_plot_label': 'Shamba',
  'docs_no_linked_plots':
      'Hakuna mashamba yaliyounganishwa. Kamilisha KYC ya muuzaji kwanza.',
  'docs_seller_only': 'Wauzaji pekee wanaweza kupakia nyaraka za shamba.',
  'docs_buyer_lookup_title': 'Tafuta nyaraka za shamba',
  'docs_buyer_lookup_hint':
      'Ufikiaji wa kuangalia tu hukusaidia kuthibitisha muuzaji ameshiriki nyaraka halali.',
  'docs_uploaded_title': 'Imepakiwa',
  'docs_uploaded_body': 'Nyaraka zimehifadhiwa kwa shamba lililochaguliwa.',
  'docs_upload_failed': 'Upakiaji wa nyaraka umeshindwa.',
  'docs_pick_failed': 'Imeshindwa kusoma faili iliyochaguliwa.',
  'docs_open_failed': 'Imeshindwa kufungua nyaraka.',
  'docs_type_sale_agreement': 'Mkataba wa Mauzo',
  'docs_type_transfer_form': 'Fomu ya Uhamisho',
  'docs_type_certificate_of_occupancy': 'Cheti cha Umiliki',
  'docs_type_survey_plan': 'Ramani ya Uchunguzi',
  'docs_type_identification': 'Kitambulisho',
  'docs_type_other': 'Nyingine',
  'home_documents': 'Nyaraka',
  'home_certificates': 'Vyeti',

  // Settings
  'settings_title': 'Mipangilio',
  'settings_subtitle': 'Sanidi programu yako',
  'settings_subtitle_new': 'Lugha, wasifu, na akaunti',
  'settings_api_config': 'Usanidi wa API',
  'settings_base_url': 'URL Msingi',
  'settings_emulator_hint':
      'Simu Wi‑Fi: http://192.168.1.7:8000 · Emulator: http://10.0.2.2:8000',
  'settings_language': 'Lugha',
  'settings_save': 'Hifadhi Mipangilio',
  'settings_missing_field': 'Sehemu inakosekana',
  'settings_base_url_required': 'URL msingi inahitajika.',
  'settings_save_failed': 'Kuhifadhi kumeshindwa',
  'settings_save_error': 'Hitilafu isiyotarajiwa wakati wa kuhifadhi mipangilio.',
  'settings_profile_hint': 'Hariri jina, simu, na picha yako ya wasifu.',
  'settings_open_profile': 'Fungua wasifu',
  'settings_connection': 'Muunganisho',
  'settings_live_api': 'Imeunganishwa na seva hai ya ArdhiLens:',

  // Profile
  'profile_title': 'Wasifu',
  'profile_subtitle': 'Maelezo ya akaunti yako',
  'profile_save': 'Hifadhi mabadiliko',
  'profile_saved': 'Wasifu umesasishwa.',
  'profile_photo_updated': 'Picha ya wasifu imesasishwa.',
  'profile_load_failed': 'Imeshindwa kupakia wasifu.',
  'profile_required_fields': 'Jina na barua pepe zinahitajika.',
  'common_name': 'Jina kamili',
  'common_phone': 'Nambari ya simu',

  // Seller
  'seller_home_brand': 'ENEO LA MUUZAJI',
  'seller_home_subtitle': 'KYC, nyaraka za umiliki, na wanunuzi wanaotaka shamba lako',
  'seller_kyc_title': 'KYC ya utambulisho wa muuzaji',
  'seller_kyc_status': 'Hali: :status',
  'seller_kyc_submit': 'Wasilisha KYC ya NIDA',
  'seller_kyc_submitted': 'KYC imewasilishwa kwa ukaguzi.',
  'seller_kyc_explainer':
      'Unganisha NIDA yako na mashamba yaliyosajiliwa kwa jina lako. Wanunuzi watakupata wanapowasilisha nia ya kununua.',
  'seller_kyc_required_for_proof':
      'Kamilisha KYC ya NIDA kwanza ili tuunganishe mashamba yako.',
  'seller_plot_link_title': 'Hali ya muunganisho wa shamba',
  'seller_plot_link_hint':
      'Wasilisha NIN yako kuunganisha mashamba ambapo owner_nida inalingana na utambulisho wako.',
  'seller_ownership_proof': 'Thibitisha umiliki',
  'seller_ownership_proof_hint':
      'Fanya uthibitisho wa umiliki kwenye shamba lililounganishwa na NIN yako. Hii ni tofauti na ukaguzi wa mnunuzi.',
  'seller_start_ownership_proof': 'Anza uthibitisho wa umiliki',
  'seller_attestations': 'Vyeti vya umiliki',
  'seller_action_needed': 'Hatua inahitajika',
  'seller_kyc_status_verified': 'Imethibitishwa',
  'seller_kyc_status_pending': 'Imewasilishwa — inakaguliwa',
  'seller_kyc_status_review': 'Inahitaji ukaguzi wa mkono',
  'seller_kyc_status_rejected': 'Imekataliwa',
  'seller_kyc_status_required': 'KYC inahitajika',
  'seller_kyc_submitted_note':
      'NIN yako imesajiliwa. Unaweza kuthibitisha umiliki na kupokea maombi ya wanunuzi wakati msimamizi anakagua KYC.',
  'seller_kyc_verified_note':
      'KYC yako ya muuzaji imethibitishwa. Unaweza kuthibitisha umiliki na kupokea maombi ya wanunuzi.',
  'seller_kyc_rejected_note':
      'KYC yako ya muuzaji imekataliwa. Soma maelezo katika Arifa, kisha wasilisha tena NIN sahihi.',
  'seller_kyc_review_note':
      'KYC yako inahitaji ukaguzi wa mkono. Unaweza kuwasilisha NIN tena ikiwa inahitajika.',
  'seller_kyc_required_note':
      'Kamilisha KYC ya NIDA ili tuunganishe mashamba yako na kuwezesha zana za muuzaji.',
  'seller_kyc_nin_linked': 'NIN iliyounganishwa: :nin',
  'seller_kyc_resubmit': 'Wasilisha NIN tena',
  'seller_nin_invalid': 'Weka NIN sahihi ya herufi 20.',
  'seller_load_failed': 'Imeshindwa kupakia dashibodi ya muuzaji.',
  'seller_alerts': 'Tahadhari',
  'seller_my_plots': 'Mashamba yangu',
  'seller_no_plots': 'Hakuna mashamba yaliyounganishwa na NIN yako bado.',
  'seller_has_boundary': 'Mpaka upo',
  'seller_no_boundary': 'Kituo tu',
  'seller_ownership_docs': 'Nyaraka za umiliki',
  'seller_buyers_title': 'Wanunuzi wanaopendezwa',
  'seller_buyers_subtitle': 'Angalia nani anataka kununua na ujibu.',
  'seller_no_buyers': 'Hakuna mnunuzi bado. Utajulishwa anapowasiliana.',
  'seller_pending_buyers': 'Wanunuzi wanasubiri',
  'seller_accept': 'Kubali',
  'seller_decline': 'Kataa',
  'seller_reply_hint': 'Jibu kwa mnunuzi (si lazima)',
  'seller_response_saved': 'Jibu limetumwa kwa mnunuzi.',
  'seller_recent_checks': 'Ukaguzi wa hivi karibuni wa wanunuzi',
  'seller_no_checks': 'Hakuna mnunuzi aliyekagua mashamba yako bado.',
  'common_status': 'Hali',

  // Buyer workspace
  'buyer_workspace': 'Zana za mnunuzi',
  'buyer_workspace_hint': 'Thibitisha ardhi, kagua nyaraka, na wasiliana na muuzaji.',
  'buyer_check_docs': 'Uhalali wa nyaraka',
  'buyer_check_docs_hint': 'Pakia na angalia alama za uhalali',
  'buyer_interest': 'Wasiliana na muuzaji',
  'buyer_interest_hint': 'Tuma nia ya kununua shamba',
  'buyer_certificates': 'Vyeti vya alama',
  'buyer_certificates_hint': 'Pakua PDF zilizotiwa saini',
  'buyer_alerts_hint': 'Matokeo na majibu ya muuzaji',

  // Interest / communication
  'interest_title': 'Nia ya kununua',
  'interest_express': 'Mwambie muuzaji unataka shamba hili',
  'interest_express_hint': 'Muuzaji ataona ombi lako kwenye dashibodi yake.',
  'interest_message_hint': 'Ujumbe kwa muuzaji (si lazima)',
  'interest_send': 'Tuma nia',
  'interest_sent': 'Muuzaji amearifiwa kuhusu nia yako.',
  'interest_my_requests': 'Maombi yangu',
  'interest_empty_buyer': 'Bado hujawasiliana na muuzaji yeyote.',
  'interest_seller_reply': 'Jibu la muuzaji',
  'interest_seller': 'Muuzaji',
  'interest_plot_required': 'Weka kumbukumbu ya shamba.',
  'interest_load_failed': 'Imeshindwa kupakia maombi yako.',
  'interest_default_message': 'Nimekagua shamba hili na nina nia ya kununua.',

  // Certificate extras
  'result_fingerprint': 'Alama ya kidijitali',
  'cert_download_fingerprint': 'Pakua PDF ya alama',
  'result_certificate_missing': 'Hati ya alama haijawa tayari',
  'result_certificate_missing_hint':
      'Ukaguzi wako unastahili cheti kilichotiwa saini. Bonyeza kutengeneza sasa.',
  'result_generate_certificate': 'Tengeneza hati ya alama',
  'cert_type_buyer': 'Cheti cha Ukaguzi Kabla ya Ununuzi',
  'cert_type_seller': 'Cheti cha Uthibitisho wa Umiliki',
  'result_interest_title': 'Unapendezwa na shamba hili?',
  'result_interest_hint': 'Mjulishe muuzaji ili aone ombi lako na ajibu.',
  'result_interest_cta': 'Mwambie muuzaji nataka kununua',

  // Auth extras
  'auth_forgot_title': 'Weka Upya Nenosiri',
  'auth_forgot_subtitle': 'Tutakutumia msimbo wa tarakimu 6',
  'auth_forgot_step1': 'Weka barua pepe ya akaunti',
  'auth_forgot_step1_hint':
      'Tutakutumia msimbo wa mara moja wa kuweka upya nenosiri.',
  'auth_forgot_step2': 'Weka msimbo na nenosiri jipya',
  'auth_forgot_step2_hint':
      'Angalia kikasha/spam kwa msimbo wa tarakimu 6 wa ArdhiLens.',
  'auth_send_code': 'Tuma Msimbo',
  'auth_code_sent': 'Msimbo umetumwa. Angalia barua pepe (na spam).',
  'auth_code_onscreen':
      'Barua pepe imeshindwa. Msimbo wako ni :code (umejazwa hapa chini).',
  'auth_otp_code': 'Msimbo wa tarakimu 6',
  'auth_reset_password': 'Weka Nenosiri Jipya',
  'auth_reset_success': 'Nenosiri limesasishwa. Ingia tena.',
  'auth_back_to_email': 'Tumia barua pepe nyingine',

  // Date / months
  'date_jan': 'Januari',
  'date_feb': 'Februari',
  'date_mar': 'Machi',
  'date_apr': 'Aprili',
  'date_may': 'Mei',
  'date_jun': 'Juni',
  'date_jul': 'Julai',
  'date_aug': 'Agosti',
  'date_sep': 'Septemba',
  'date_oct': 'Oktoba',
  'date_nov': 'Novemba',
  'date_dec': 'Desemba',

  // Step badges
  'step_badge_1': 'HATUA 1 KATI YA 4',
  'step_badge_2': 'HATUA 2 KATI YA 4',
  'step_badge_3': 'HATUA 3 KATI YA 4',
  'step_badge_4': 'HATUA 4 KATI YA 4',
};
