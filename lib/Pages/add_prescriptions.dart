import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/Pages/Prescriptions.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Widgets/ImageFromGalleryEx.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class ActiveIngredient {
  final String name;

  ActiveIngredient({
    required this.name,
  });

  Map toJson() => {
    'name': "$name"
  };
}

class AddPrescriptions extends StatefulWidget {
  final AddPrescriptionsStorage storage;

  AddPrescriptions({Key? key, required this.storage}) : super(key: key);
  @override
  _AddPrescriptionsState createState() => _AddPrescriptionsState();
}

class _AddPrescriptionsState extends State<AddPrescriptions>  {

  var LanguageData =0;
  var Title = ["Prescriptions","الوصفات الطبية",""];
  var AddTitle = ["Add Prescription","اضافة وصفة طبية",""];
  var DateTitle = ["Date **","التاريخ **",""];
  var NameTitle = ["Doctor Name **","اسم الطبيب **",""];
  var IngredientsTitle = ["Active Ingredients **","المواد الفعالة **",""];
  var SearchTitle = ["Search","بحث",""];
  var SpecialityTitle = ["Doctor Speciality","تخصص الطبيب",""];
  var DescriptionTitle = ["Description","الوصف",""];
  var SaveBtnTitle = ["Save","حفظ",""];
  var SaveFailedTitle = ["Save Failed, Check Required Info.","فشل الحفظ ، تحقق من المعلومات المطلوبة.",""];


  TextEditingController DateController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController DoctorController = TextEditingController();

  final verticalScroll = ScrollController();

  var DoctorSpicialities = const ["Podiatrist","General Practitioner","Pediatrician","Endocrinologist","Neurologist","Rheumatologist","Allergist/Immunologist","Psychiatrist","Nephrologist","OB/GYN obstetrician/gynecologist","Pulmonologist","Surgeon","Emergency Physician","Ophthalmologist","Oncologist","Urologist","Otolaryngologist","Anesthesiologist","Dermatologist","Radiologist","Gastroenterologist","Cardiologist","Orthopedist","Dentist","physiotherapis"];

  List<String> ActiveIngredients = const ["respiratory_syncytial_virus_immune_globulin","acetaminophen/aluminum_hydroxide/aspirin/caffeine/magnesium_hydroxide","acetazolamide","acetaminophen/aspirin","adefovir","acetaminophen/aspirin/caffeine","anisindione","abciximab","alteplase","ardeparin","acetaminophen/aspirin/caffeine/salicylamide","bisacodyl/sodium_biphosphate/sodium_phosphate","acetaminophen/aspirin/phenylpropanolamine","acetaminophen/tramadol","5-hydroxytryptophan","acetaminophen/propoxyphene","acetaminophen/brompheniramine/dextromethorphan/pseudoephedrine","aspirin/caffeine/propoxyphene","acetaminophen/brompheniramine/phenylpropanolamine","benzphetamine","acetaminophen/caffeine/chlorpheniramine/phenylpropanolamine","bisacodyl/polyethylene_glycol_3350/potassium_chloride/sodium_bicarbonate/sodium_chloride","acetaminophen/brompheniramine/pseudoephedrine","citric_acid/potassium_citrate","acetaminophen/caffeine/chlorpheniramine/hydrocodone/phenylephrine","alvimopan","acetaminophen/butalbital/caffeine/codeine","buprenorphine/naloxone","acetaminophen/caffeine/dihydrocodeine","bupropion","acetaminophen/caffeine/phenylpropanolamine/salicylamide","botulism_immune_globulin","acetaminophen/caffeine/magnesium_salicylate","brinzolamide_ophthalmic","acetaminophen/caffeine/magnesium_salicylate/phenyltoloxamine","cidofovir","acetaminophen/caffeine/phenyltoloxamine/salicylamide","citric_acid/potassium_citrate/sodium_citrate","acetaminophen/caffeine/phenyltoloxamine","ethanol","acetaminophen","leflunomide","abacavir","abacavir/lamivudine","abacavir/lamivudine/zidovudine","adalimumab","abatacept","bcg","aldesleukin","certolizumab","altretamine","amitriptyline","acetaminophen/caffeine/guaifenesin/phenylephrine","amitriptyline/chlordiazepoxide","acetaminophen/chlorpheniramine/codeine/phenylephrine","amitriptyline/perphenazine","acetaminophen/chlorpheniramine/dextromethorphan/phenylephrine","amoxapine","acetaminophen/chlorpheniramine/phenylephrine","clomipramine","acetaminophen/chlorpheniramine/phenylephrine/phenylpropanolamine/pyrilamine","bromocriptine","acetaminophen/caffeine/isometheptene_mucate","furazolidone","acetaminophen/chlorpheniramine/codeine","droperidol","abarelix","amiodarone","adenosine","arbutamine","acebutolol","aminophylline","atenolol","aminophylline/amobarbital/ephedrine","atenolol/chlorthalidone","aminophylline/ephedrine/guaifenesin/phenobarbital","bendroflumethiazide/nadolol","albuterol","arsenic_trioxide","albuterol/ipratropium","artemether/lumefantrine","alfuzosin","amoxicillin/clarithromycin/lansoprazole","alfentanil","amprenavir","amlodipine/atorvastatin","atazanavir","astemizole","aprepitant","bupivacaine/fentanyl","boceprevir","aminophylline/ephedrine/phenobarbital/potassium_iodide","aliskiren/valsartan","amiloride","amlodipine/benazepril","allopurinol","azathioprine","clozapine","albendazole","alemtuzumab","deferiprone","anakinra","etanercept","anti-thymocyte_globulin_(rabbit)","golimumab","asparaginase_escherichia_coli","infliximab","azacitidine","influenza_virus_vaccine _h1n1 _live","acetaminophen/chlorpheniramine/phenylephrine/salicylamide","cytomegalovirus_immune_globulin","acetaminophen/magnesium_salicylate/pamabrom","dasatinib","aluminum_hydroxide/aspirin/calcium_carbonate/magnesium_hydroxide","aspirin/citric_acid/sodium_bicarbonate","alginic_acid/aluminum_hydroxide/magnesium_carbonate","caffeine/pheniramine/phenylephrine/sodium_citrate/sodium_salicylate","alginic_acid/aluminum_hydroxide/magnesium_trisilicate","calcium_citrate","aluminum_carbonate","citric_acid/glucono-delta-lactone/magnesium_carbonate_topical","aluminum_hydroxide","citric_acid/potassium_bicarbonate","aluminum_hydroxide/calcium_carbonate/magnesium_hydroxide/simethicone","citric_acid/simethicone/sodium_bicarbonate","aluminum_hydroxide/diphenhydramine/lidocaine/magnesium_hydroxide/simethicone_topical","citric_acid/sodium_citrate","aluminum_hydroxide/magnesium_hydroxide","codeine/pheniramine/phenylephrine/sodium_citrate","aluminum_hydroxide/magnesium_hydroxide/simethicone","paricalcitol","alendronate/cholecalciferol","calcitriol","calcifediol","doxercalciferol","calcium_carbonate/cholecalciferol/ferrous_fumarate","dimercaprol","ascorbic_acid/ferrous_fumarate","ascorbic_acid/ferrous_sulfate","ascorbic_acid/iron_polysaccharide","carbonyl_iron","chromic_chloride_hexahydrate/copper_sulfate/manganese_sulfate/selenium/sodium_iodide/zinc_sulfate","chromic_chloride_hexahydrate/copper_sulfate/manganese_sulfate/selenium/zinc_sulfate","docusate/ferrous_fumarate","ferrous_fumarate","ferrous_fumarate/folic_acid","capecitabine","cyanocobalamin/folic_acid/pyridoxine/strontium_gluconate","fluorouracil","dicumarol","acetaminophen/butalbital","hemin","acetaminophen/butalbital/caffeine","levomethadyl_acetate","acetaminophen/caffeine/pyrilamine","potassium_acetate/potassium_bicarbonate/potassium_citrate","acetaminophen/chlorpheniramine","potassium_bicarbonate/potassium_chloride","acetaminophen/chlorpheniramine/dextromethorphan","citalopram","acetaminophen/chlorpheniramine/dextromethorphan/guaifenesin","desvenlafaxine","acetaminophen/chlorpheniramine/dextromethorphan/phenylpropanolamine","dexfenfluramine","acetaminophen/chlorpheniramine/dextromethorphan/pseudoephedrine","duloxetine","acetaminophen/chlorpheniramine/guaifenesin/phenylpropanolamine","escitalopram","acetaminophen/chlorpheniramine/phenylpropanolamine","fenfluramine","acetaminophen/dextromethorphan","fluoxetine","acetaminophen/dextromethorphan/diphenhydramine","fluoxetine/olanzapine","acetaminophen/dextromethorphan/diphenhydramine/phenylephrine","desipramine","acetaminophen/chlorpheniramine/phenylephrine/phenyltoloxamine","doxepin","acetaminophen/codeine/guaifenesin/phenylephrine","droperidol/fentanyl","acetaminophen/codeine","hyoscyamine/methenamine/methylene_blue/sodium_biphosphate","acetaminophen/codeine/guaifenesin/pseudoephedrine","iohexol","acetaminophen/dextromethorphan/guaifenesin/phenylpropanolamine","fluvoxamine","acetaminophen/dextromethorphan/diphenhydramine/pseudoephedrine","isocarboxazid","acetaminophen/chlorpheniramine/pseudoephedrine","linezolid","acetaminophen/clemastine/pseudoephedrine","phenelzine","acetaminophen/dexbrompheniramine/pseudoephedrine","potassium_bicarbonate/potassium_citrate","acetaminophen/dextromethorphan/doxylamine","milnacipran","acetaminophen/dextromethorphan/doxylamine/phenylephrine","imipramine","acetaminophen/dextromethorphan/guaifenesin/phenylephrine","mirtazapine","acetaminophen/dextromethorphan/doxylamine/pseudoephedrine","nefazodone","acetaminophen/dextromethorphan/guaifenesin/pseudoephedrine","paroxetine","acetaminophen/dextromethorphan/phenylephrine","nortriptyline","acetaminophen/diphenhydramine/phenylephrine","potassium_chloride","acetaminophen/dextromethorphan/pseudoephedrine/pyrilamine","potassium_chloride/sodium_chloride","acetaminophen/diphenhydramine","potassium_citrate","acetaminophen/diphenhydramine/pseudoephedrine","potassium_citrate/sodium_citrate","acetaminophen/doxylamine/pseudoephedrine","procarbazine","acetaminophen/dextromethorphan/phenylpropanolamine","iopamidol","acetaminophen/hydrocodone","magnesium_sulfate/potassium_sulfate/sodium_sulfate","acetaminophen/oxycodone","emtricitabine/lopinavir/ritonavir/tenofovir","acetaminophen/phenyltoloxamine/salicylamide","deferasirox","acetaminophen/salicylamide","efavirenz/emtricitabine/tenofovir","amikacin","abobotulinumtoxinA","atracurium","botulinum_toxin_type_b","cisatracurium","gentamicin","agalsidase_beta","chloroquine","auranofin","atovaquone/proguanil","aurothioglucose","hydroxychloroquine","gold_sodium_thiomalate","mefloquine","bepridil","anhydrous_calcium_iodide/isoproterenol","cisapride","aliskiren/amlodipine/hydrochlorothiazide","cyclosporine","aliskiren","itraconazole","aliskiren/amlodipine","dolasetron","aliskiren/hydrochlorothiazide","dofetilide","amiloride/hydrochlorothiazide","amlodipine/hydrochlorothiazide/olmesartan","chlorpheniramine/codeine/phenylephrine/potassium_iodide","amlodipine/hydrochlorothiazide/valsartan","dronedarone","amphotericin_b","emtricitabine/nelfinavir/tenofovir","amphotericin_b_cholesteryl_sulfate","emtricitabine/rilpivirine/tenofovir","amphotericin_b_lipid_complex","emtricitabine/tenofovir","amphotericin_b_liposomal","gallium_nitrate","immune_globulin_intravenous","aspirin","chlorpheniramine/ibuprofen/pseudoephedrine","aspirin/brompheniramine/dextromethorphan/phenylpropanolamine","dalteparin","anagrelide","danaparoid","anistreplase","argatroban","bivalirudin","dabigatran","clopidogrel","armodafinil","ranolazine","aminoglutethimide","amobarbital","propoxyphene","acetaminophen/dichloralphenazone/isometheptene_mucate","selegiline","acetaminophen/dextromethorphan/pseudoephedrine","rasagiline","ammonium_chloride/chlorpheniramine/dextromethorphan/ephedrine/ipecac/phenylephrine","methenamine/sodium_biphosphate","acetaminophen/pentazocine","metrizamide","amantadine","sodium_biphosphate/sodium_phosphate","aminophylline/guaifenesin","betaxolol","diltiazem","betaxolol_ophthalmic","diltiazem/enalapril","bisoprolol","disopyramide","apomorphine","alosetron","crizotinib","asenapine","dextromethorphan/quinidine","azithromycin","gatifloxacin","acarbose","acetohexamide","azithromycin/trovafloxacin","betamethasone","cinoxacin","cortisone","ciprofloxacin","dexamethasone","caspofungin","carbamazepine","clarithromycin","atorvastatin","clofibrate","aspirin/pravastatin","colchicine","cerivastatin","colchicine/probenecid","conivaptan","belladonna/caffeine/ergotamine/pentobarbital","almotriptan","belladonna/ergotamine/phenobarbital","darunavir","atropine/hyoscyamine/phenobarbital/scopolamine","delavirdine","alprazolam","fluconazole","caffeine/ergotamine","dihydroergotamine","efavirenz","ergonovine","dinoprostone_topical","diclofenac/misoprostol","desirudin","antithrombin_iii","drotrecogin_alfa","antithrombin_(recombinant)","enoxaparin","aspirin/butalbital","dichlorphenamide","aspirin/butalbital/caffeine","diphenhydramine/ibuprofen","aspirin/butalbital/caffeine/codeine","dorzolamide_ophthalmic","aspirin/caffeine","dorzolamide/timolol_ophthalmic","arformoterol","brimonidine/timolol_ophthalmic","articaine/epinephrine","carteolol","bitolterol","carteolol_ophthalmic","budesonide/formoterol","carvedilol","bupivacaine/epinephrine","desflurane","chlorpheniramine/epinephrine","enflurane","epinephrine","halothane","dyphylline","bisoprolol/hydrochlorothiazide","dyphylline/ephedrine/guaifenesin/phenobarbital","esmolol","dyphylline/guaifenesin","hydrochlorothiazide/metoprolol","ephedrine/guaifenesin/theophylline","enoxacin","dexamethasone/lidocaine","fosamprenavir","ceftriaxone/lidocaine","calcium_chloride","ceftriaxone","calcium_gluceptate","digitoxin","calcium_gluconate","digoxin","saquinavir","chlorpromazine","grepafloxacin","codeine/phenylephrine/promethazine","halofantrine","cimetidine","carmustine","influenza_virus_vaccine _live _trivalent","alefacept","measles_virus_vaccine","basiliximab","measles_virus_vaccine/mumps_virus_vaccine/rubella_virus_vaccine","belatacept","measles_virus_vaccine/mumps_virus_vaccine/rubella_virus_vaccine/varicella_virus_vaccine","belimumab","measles_virus_vaccine/rubella_virus_vaccine","bendamustine","mumps_virus_vaccine","bexarotene","conjugated_estrogens/medroxyprogesterone","acitretin","bismuth_subcitrate_potassium/metronidazole/tetracycline","busulfan","bismuth_subsalicylate/metronidazole/tetracycline","etretinate","demeclocycline","isotretinoin","doxycycline","methotrexate","amoxicillin","amoxicillin/clavulanate","ampicillin","ampicillin/probenecid","ketorolac","aspirin/caffeine/dihydrocodeine","famotidine/ibuprofen","aspirin/caffeine/orphenadrine","fondaparinux","aspirin/caffeine/salicylamide","hydrocodone/ibuprofen","aspirin/calcium_carbonate","ibritumomab","aspirin/carisoprodol","ibuprofen","aspirin/carisoprodol/codeine","ibuprofen/oxycodone","aspirin/chlorpheniramine/dextromethorphan","ibuprofen/pseudoephedrine","aspirin/chlorpheniramine/dextromethorphan/phenylpropanolamine","immune_globulin_intravenous_and_subcutaneous","aspirin/chlorpheniramine/phenylephrine","iodine_i_131_tositumomab","aspirin/chlorpheniramine/phenylpropanolamine","methamphetamine","aspirin/diphenhydramine/phenylpropanolamine","methazolamide","aspirin/codeine","naloxone","ammonium_chloride/chlorpheniramine/codeine/phenylephrine","naloxone/pentazocine","anhydrous_calcium_iodide/codeine","sodium_oxybate","acetaminophen/pamabrom/pyrilamine","topiramate","acetaminophen/pheniramine/phenylephrine","protriptyline","acetaminophen/guaifenesin/phenylephrine","tranylcypromine","acetaminophen/guaifenesin/pseudoephedrine","acetaminophen/phenylephrine","trimipramine","atropine/chlorpheniramine/hyoscyamine/phenylephrine/phenylpropanolamine/scopolamine","sertraline","amphetamine","pimozide","abiraterone","tamoxifen","aspirin/diphenhydramine","rivaroxaban","aspirin/dipyridamole","eptifibatide","dipyridamole","prasugrel","benzoic_acid/methenamine/sodium_salicylate","sirolimus","acyclovir","tacrolimus","aspirin/hydrocodone","tenofovir","aspirin/meprobamate","tinzaparin","aspirin/methocarbamol","tipranavir","aspirin/oxycodone","lopinavir/ritonavir","atropine/phenobarbital","etravirine","ephedrine/phenobarbital/potassium_iodide/theophylline","amlodipine/olmesartan","ephedrine/potassium_iodide","amlodipine/telmisartan","ezetimibe/simvastatin","amlodipine","niacin/simvastatin","amlodipine/valsartan","hydrochlorothiazide/spironolactone","azilsartan_medoxomil","hydrochlorothiazide/triamterene","azilsartan_medoxomil/chlorthalidone","iodine/potassium_iodide","benazepril","iron_dextran","benazepril/hydrochlorothiazide","lithium","bendroflumethiazide","tizanidine","acetaminophen/caffeine","ambrisentan","amyl_nitrite","sildenafil","amyl_nitrite/sodium_nitrite/sodium_thiosulfate","tadalafil","hydralazine/isosorbide_dinitrate","diazoxide","hydralazine","hydralazine/hydrochlorothiazide","ziprasidone","bendroflumethiazide/rauwolfia_serpentina","benzthiazide","bumetanide","kanamycin","bacitracin","neomycin","capreomycin","netilmicin","colistimethate","incobotulinumtoxinA","doxacurium","onabotulinumtoxinA","metocurine","paromomycin","mivacurium","polymyxin_b","pancuronium","streptomycin","ethacrynic_acid","tobramycin","furosemide","magnesium_sulfate","pipecuronium","rapacuronium","rocuronium","succinylcholine","torsemide","tubocurarine","vecuronium","spectinomycin","candesartan/hydrochlorothiazide","lvp_solution_with_potassium","candesartan","parenteral_nutrition_solution_w/electrolytes","captopril","potassium_acetate","captopril/hydrochlorothiazide","potassium_acid_phosphate","enalapril","potassium_bicarbonate","enalapril/felodipine","potassium_bicarbonate/sodium_bicarbonate","enalapril/hydrochlorothiazide","potassium_gluconate","eplerenone","carbetapentane/phenylephrine/phenylpropanolamine/potassium_guaiacolsulfonate","sibutramine","amphetamine/dextroamphetamine","tapentadol","aspirin/pentazocine","tositumomab","aspirin/phenyltoloxamine","warfarin","amobarbital/secobarbital","aspirin/pseudoephedrine","belladonna/butabarbital","zonisamide","acetaminophen/phenyltoloxamine","acetaminophen/pseudoephedrine/triprolidine","acrivastine","acrivastine/pseudoephedrine","amylase/cellulase/hyoscyamine/lipase/phenyltoloxamine/protease","aripiprazole","metoclopramide","codeine/promethazine","haloperidol","daunorubicin","ibutilide","bretylium","daunorubicin_liposomal","iloperidone","cinacalcet","tetrabenazine","chlorothiazide/reserpine","chlorthalidone/reserpine","dextromethorphan/promethazine","mesoridazine","degarelix","methadone","didanosine","hydroxyurea","mumps_virus_vaccine/rubella_virus_vaccine","bleomycin","natalizumab","brentuximab","poliovirus_vaccine _live _trivalent","cabazitaxel","rotavirus_vaccine","canakinumab","rubella_virus_vaccine","carboplatin","samarium_sm_153_lexidronam","bevacizumab","panitumumab","irinotecan","ephedrine/phenobarbital/theophylline","hydrochlorothiazide/propranolol","chlorothiazide/methyldopa","hydrochlorothiazide/timolol","ephedrine/hydroxyzine/theophylline","labetalol","epinephrine/etidocaine","isoflurane","epinephrine/lidocaine","levobunolol_ophthalmic","epinephrine/prilocaine","methoxyflurane","doxycycline/omega-3_polyunsaturated_fatty_acids","tretinoin","aminocaproic_acid","anti-inhibitor_coagulant_complex","tranexamic_acid","desogestrel/ethinyl_estradiol","bosentan","dienogest/estradiol","dantrolene","chlorotrianisene","lenalidomide","conjugated_estrogens","conjugated_estrogens/meprobamate","conjugated_estrogens/methyltestosterone","darbepoetin_alfa","drospirenone/estradiol","griseofulvin","drospirenone/ethinyl_estradiol","telaprevir","drospirenone/ethinyl_estradiol/levomefolate_calcium","dutasteride/tamsulosin","indinavir","docetaxel","nelfinavir","dexlansoprazole","rilpivirine","esomeprazole","esomeprazole/naproxen","hyoscyamine/phenobarbital","lurasidone","erythromycin","cabergoline","erythromycin/sulfisoxazole","dalfopristin/quinupristin","doxorubicin","moxifloxacin","doxepin_topical","buspirone","hyoscyamine/methenamine/methylene_blue/phenyl_salicylate","maprotiline","flumazenil","methylene_blue","st._john s_wort","maraviroc","fosphenytoin","dopamine","ethotoin","mephenytoin","phenytoin","ticagrelor","isoniazid/pyrazinamide/rifampin","nevirapine","isoniazid/rifampin","praziquantel","rifampin","isoniazid","rifabutin","voriconazole","eletriptan","ergotamine","frovatriptan","methylergonovine","ketoconazole","everolimus","fosaprepitant","fentanyl","clotrimazole","fentanyl/ropivacaine","imatinib","smallpox_vaccine","budesonide","mifepristone","beclomethasone","corticorelin","corticotropin","cosyntropin","fludrocortisone","gemifloxacin","hydrocortisone","levofloxacin","methylprednisolone","lomefloxacin","prednisolone","nalidixic_acid","chlorambucil","thalidomide","anastrozole","asparaginase_erwinia_chrysanthemi","cetuximab","cisplatin","thiotepa","cyclophosphamide","typhoid_vaccine _live","cladribine","varicella_virus_vaccine","clofarabine","yellow_fever_vaccine","cytarabine","zoster_vaccine_live","dacarbazine","daclizumab","dactinomycin","decitabine","denileukin_diftitox","doxorubicin_liposomal","nilotinib","epirubicin","procainamide","eribulin","quinidine","ezogabine","sotalol","flecainide","ritonavir","disulfiram","black_cohosh","fluticasone","fluticasone_nasal","fluticasone/salmeterol","metipranolol_ophthalmic","formoterol","nadolol","formoterol/mometasone","penbutolol","guaifenesin/oxtriphylline","levobetaxolol_ophthalmic","guaifenesin/theophylline","metoprolol","methacholine","pindolol","hydrochlorothiazide/methyldopa","propranolol","indacaterol","timolol","isoetharine","timolol_ophthalmic","levalbuterol","metaproterenol","sparfloxacin","fluphenazine","methimazole","propylthiouracil","thioridazine","brompheniramine/diphenhydramine","brompheniramine/diphenhydramine/phenylephrine","carbetapentane/diphenhydramine","carbetapentane/diphenhydramine/phenylephrine","celecoxib","clobazam","codeine/diphenhydramine/phenylephrine","tramadol","belladonna/opium","benzocaine/phenylephrine/phenylpropanolamine","venlafaxine","benzocaine/dextromethorphan","trazodone","brompheniramine/dextromethorphan/guaifenesin/phenylephrine","vilazodone","brompheniramine/codeine/phenylpropanolamine","brompheniramine/dextromethorphan/guaifenesin/phenylpropanolamine","brompheniramine/dextromethorphan/guaifenesin/pseudoephedrine","brompheniramine/dextromethorphan/phenylephrine","brompheniramine/dextromethorphan/phenylpropanolamine","brompheniramine/dextromethorphan/pseudoephedrine","brompheniramine/phenylephrine/phenylpropanolamine","brompheniramine/phenylpropanolamine","caramiphen/phenylpropanolamine","carbinoxamine/dextromethorphan/phenylephrine","carbinoxamine/dextromethorphan/pseudoephedrine","chlorpheniramine/codeine/phenylephrine/phenylpropanolamine","chlorpheniramine/dextromethorphan","chlorpheniramine/dextromethorphan/guaifenesin/methscopolamine/phenylephrine","chlorpheniramine/dextromethorphan/guaifenesin/phenylephrine","chlorpheniramine/dextromethorphan/methscopolamine","chlorpheniramine/dextromethorphan/phenylephrine","chlorpheniramine/dextromethorphan/phenylpropanolamine","chlorpheniramine/dextromethorphan/pseudoephedrine","chlorpheniramine/dihydrocodeine/phenylephrine/phenylpropanolamine","chlorpheniramine/methscopolamine/phenylpropanolamine","chlorpheniramine/phenindamine/phenylpropanolamine","chlorpheniramine/phenylephrine/phenylpropanolamine","chlorpheniramine/phenylephrine/phenylpropanolamine/phenyltoloxamine","chlorpheniramine/phenylephrine/phenylpropanolamine/pyrilamine","chlorpheniramine/phenylpropanolamine","clemastine/phenylpropanolamine","codeine/guaifenesin/phenylpropanolamine","dexbrompheniramine/dextromethorphan/phenylephrine","dexbrompheniramine/dextromethorphan/phenylephrine/pyrilamine","dexbrompheniramine/dextromethorphan/pseudoephedrine","dexchlorpheniramine/dextromethorphan/phenylephrine","dexchlorpheniramine/dextromethorphan/phenylephrine/pyrilamine","dexchlorpheniramine/dextromethorphan/pseudoephedrine","dextroamphetamine","dextromethorphan","dextromethorphan/diphenhydramine/phenylephrine","dextromethorphan/doxylamine","dextromethorphan/doxylamine/pseudoephedrine","dextromethorphan/guaifenesin","dextromethorphan/guaifenesin/phenylephrine","dextromethorphan/guaifenesin/phenylpropanolamine","dextromethorphan/guaifenesin/potassium_guaiacolsulfonate","spironolactone","carbetapentane/phenylephrine/potassium_guaiacolsulfonate","triamterene","dextromethorphan/potassium_guaiacolsulfonate","eprosartan","potassium_iodide","eprosartan/hydrochlorothiazide","potassium_iodide/theophylline","fosinopril","potassium_phosphate","fosinopril/hydrochlorothiazide","potassium_phosphate/sodium_phosphate","hydrochlorothiazide/irbesartan","hydrochlorothiazide/lisinopril","hydrochlorothiazide/losartan","hydrochlorothiazide/moexipril","hydrochlorothiazide/olmesartan","hydrochlorothiazide/quinapril","hydrochlorothiazide/telmisartan","hydrochlorothiazide/valsartan","irbesartan","lisinopril","losartan","moexipril","olmesartan","perindopril","quinapril","ramipril","telmisartan","trandolapril","trandolapril/verapamil","lovastatin","danazol","lovastatin/niacin","fenofibrate","fluvastatin","fenofibric_acid","pitavastatin","gemfibrozil","metformin/repaglinide","diatrizoate","glipizide/metformin","diatrizoate/iodipamide","glyburide/metformin","iodamide","metformin","iodipamide","metformin/pioglitazone","iodixanol","metformin/rosiglitazone","iopromide","metformin/saxagliptin","iothalamate","metformin/sitagliptin","ioversol","ioxaglate","ioxilan","pravastatin","mibefradil","pseudoephedrine/terfenadine","miconazole","terfenadine","posaconazole","methysergide_maleate","naproxen/sumatriptan","naratriptan","rizatriptan","sumatriptan","zolmitriptan","troleandomycin","pazopanib","telithromycin","midazolam","olanzapine","chlordiazepoxide","chlordiazepoxide/clidinium","chlordiazepoxide/methscopolamine","clonazepam","clorazepate","diazepam","lorazepam","quinine","toremifene","granisetron","vandetanib","idarubicin","trastuzumab","vemurafenib","isoproterenol","isoproterenol/phenylephrine","lapatinib","meperidine/promethazine","methdilazine","methotrimeprazine","norfloxacin","prednisone","ofloxacin","triamcinolone","trovafloxacin","vigabatrin","aloe_polysaccharides/iodoquinol_topical","clioquinol_topical","clioquinol/hydrocortisone_topical","clioquinol/hydrocortisone/pramoxine_topical","deferoxamine","ethambutol","hydrocortisone/iodoquinol_topical","hydroxyquinoline_topical","iodoquinol","paramethadione","trimethadione","ondansetron","paliperidone","palonosetron","pentamidine","foscarnet","zalcitabine","perflutren","perphenazine","phenylephrine/promethazine","probucol","prochlorperazine","promazine","promethazine","propafenone","propiomazine","quetiapine","risperidone","ritodrine","nebivolol","oxtriphylline","theophylline","verapamil","simvastatin","niacin","red_yeast_rice","rosuvastatin","simvastatin/sitagliptin","romidepsin","sorafenib","sunitinib","telavancin","terbutaline","thiethylperazine","trifluoperazine","triflupromazine","trimeprazine","vardenafil","isosorbide","isosorbide_dinitrate","isosorbide_mononitrate","nitroglycerin","nitroprusside","vasopressin","ruxolitinib","salmeterol","silodosin","tamsulosin","tolvaptan","triazolam","vinblastine","vincristine","vinorelbine","zileuton","repaglinide","valsartan","guaifenesin/potassium_guaiacolsulfonate","hydrocodone/potassium_guaiacolsulfonate","hydrocodone/potassium_guaiacolsulfonate/pseudoephedrine","phenylephrine/potassium_guaiacolsulfonate","potassium_guaiacolsulfonate","potassium_perchlorate","mitotane","dextromethorphan/guaifenesin/pseudoephedrine","dextromethorphan/pheniramine/phenylephrine","dextromethorphan/phenylephrine","dextromethorphan/phenylephrine/pyrilamine","dextromethorphan/phenylpropanolamine","dextromethorphan/pseudoephedrine","dextromethorphan/pseudoephedrine/pyrilamine","diethylpropion","guaifenesin/hydrocodone/pheniramine/phenylephrine/phenylpropanolamine","guaifenesin/hydrocodone/pheniramine/phenylpropanolamine/pyrilamine","guaifenesin/phenylephrine/phenylpropanolamine","guaifenesin/phenylpropanolamine","hydrocodone/pheniramine/phenylephrine/phenylpropanolamine/pyrilamine","hydrocodone/phenylpropanolamine","lisdexamfetamine","ma_huang","mazindol","meperidine","pentazocine","phendimetrazine","pheniramine/phenylpropanolamine/phenyltoloxamine/pyrilamine","pheniramine/phenylpropanolamine/pyrilamine","phentermine","phenylpropanolamine","remifentanil","ropivacaine/sufentanil","sufentanil","tryptophan","bethanechol","bromodiphenhydramine/codeine","brompheniramine/codeine","brompheniramine/codeine/phenylephrine","brompheniramine/codeine/pseudoephedrine","brompheniramine/dihydrocodeine/phenylephrine","brompheniramine/dihydrocodeine/pseudoephedrine","brompheniramine/hydrocodone/phenylephrine","brompheniramine/hydrocodone/pseudoephedrine","bupivacaine/hydromorphone","buprenorphine","butorphanol","carbetapentane/chlorpheniramine/ephedrine/phenylephrine","carbinoxamine/hydrocodone/phenylephrine","carbinoxamine/hydrocodone/pseudoephedrine","chlorcyclizine/codeine","chlorcyclizine/codeine/phenylephrine","chlorcyclizine/codeine/pseudoephedrine","chlorpheniramine/codeine","chlorpheniramine/codeine/pseudoephedrine","chlorpheniramine/dihydrocodeine/phenylephrine","chlorpheniramine/dihydrocodeine/pseudoephedrine","chlorpheniramine/ephedrine/guaifenesin","chlorpheniramine/guaifenesin/hydrocodone/pseudoephedrine","chlorpheniramine/hydrocodone","chlorpheniramine/hydrocodone/phenylephrine","chlorpheniramine/hydrocodone/pseudoephedrine","cilastatin/imipenem","divalproex_sodium","doripenem","valproic_acid","ertapenem","lamotrigine","meropenem","sodium_benzoate/sodium_phenylacetate","sodium_phenylacetate","vorinostat","codeine","codeine/dexbrompheniramine/pseudoephedrine","codeine/dexchlorpheniramine/phenylephrine","codeine/guaifenesin","codeine/guaifenesin/phenylephrine","codeine/guaifenesin/pseudoephedrine","codeine/phenylephrine","codeine/phenylephrine/pyrilamine","codeine/pseudoephedrine","codeine/pseudoephedrine/pyrilamine","codeine/pseudoephedrine/triprolidine","cyclobenzaprine","cycloserine","dalfampridine","dexbrompheniramine/hydrocodone/phenylephrine","dexchlorpheniramine/hydrocodone/phenylephrine","dexmethylphenidate","dezocine","dihydrocodeine/guaifenesin","dihydrocodeine/guaifenesin/phenylephrine","dihydrocodeine/guaifenesin/pseudoephedrine","dihydrocodeine/phenylephrine","dihydrocodeine/phenylephrine/pyrilamine","diphenhydramine/hydrocodone/phenylephrine","donepezil","doxapram","ephedrine","ephedrine/guaifenesin","galantamine","guaifenesin/hydrocodone","guaifenesin/hydrocodone/phenylephrine","guaifenesin/hydrocodone/pseudoephedrine","guaifenesin/hydromorphone","heroin","homatropine/hydrocodone","hydrocodone","hydrocodone/phenylephrine","hydrocodone/phenylephrine/pyrilamine","hydrocodone/pseudoephedrine","hydrocodone/pseudoephedrine/triprolidine","hydromorphone","interferon_alfa-2a","lamivudine/zidovudine","ganciclovir","zidovudine","interferon_alfa-2b","telbivudine","interferon_alfa-2b/ribavirin","mercaptopurine","febuxostat","ribavirin","interferon_alfa-n1","interferon_alfacon-1","peginterferon_alfa-2a","peginterferon_alfa-2b","interferon_alfa-n3","interferon_beta-1a","interferon_beta-1b","interferon_gamma-1b","valganciclovir","levorphanol","lidocaine","lidocaine/oxytetracycline","vitamin_a","doxycycline/salicylic_acid_topical","minocycline","oxytetracycline","oxytetracycline/phenazopyridine/sulfamethizole","potassium_aminobenzoate","phenazopyridine/sulfamethoxazole","phenazopyridine/sulfisoxazole","pyrimethamine/sulfadoxine","sulfadiazine","sulfadoxine","sulfamethizole","sulfamethoxazole","sulfamethoxazole/trimethoprim","leucovorin","trimethoprim","levoleucovorin_calcium","sulfasalazine","sulfisoxazole","tetracycline","lidocaine/sodium_bicarbonate","sodium_polystyrene_sulfonate","aluminum_hydroxide/mineral_oil","sodium_bicarbonate/sodium_citrate","dihydroxyaluminum_sodium_carbonate","sodium_citrate","calcium_acetate/magnesium_carbonate","calcium_carbonate","calcium_carbonate/famotidine/magnesium_hydroxide","calcium_carbonate/fluoride","calcium_carbonate/magnesium_carbonate","calcium_carbonate/magnesium_hydroxide","calcium_carbonate/magnesium_hydroxide/simethicone","calcium_carbonate/risedronate","calcium_carbonate/simethicone","calcium/vitamin_d","cascara_sagrada/magnesium_hydroxide","charcoal/sorbitol","magaldrate","magaldrate/simethicone","magnesium_carbonate","magnesium_hydroxide","magnesium_hydroxide/mineral_oil","magnesium_oxide","mannitol/sorbitol_topical","meloxicam","omeprazole/sodium_bicarbonate","potassium_bitartrate/sodium_bicarbonate","sodium_bicarbonate","sodium_bicarbonate/tartaric_acid","sorbitol","lindane_topical","loxapine","methylphenidate","mexiletine","molindone","morphine","morphine_liposomal","morphine/naltrexone","muromonab-cd3","nalbuphine","nelarabine","neostigmine","opium","oxamniquine","oxycodone","oxymorphone","pemoline","physostigmine","piperazine","rimantadine","rivastigmine","tacrine","thiothixene","darifenacin","diphenhydramine","diphenhydramine/guaifenesin","diphenhydramine/magnesium_salicylate","diphenhydramine/phenylephrine","diphenhydramine/pseudoephedrine","diphenhydramine/tripelennamine_topical","gefitinib","goldenseal","hydroxypropyl_chitosan/terbinafine_topical","primaquine","quinacrine","terbinafine","ticlopidine","tirofiban","heparin","ipilimumab","lepirudin","reteplase","streptokinase","temsirolimus","tenecteplase","urokinase","methyldopa","pirbuterol","garlic","paclitaxel","paclitaxel_protein-bound","rifapentine","efalizumab","etoposide","fingolimod","floxuridine","fludarabine","pentostatin","gemcitabine","gemtuzumab","ifosfamide","oprelvekin","ifosfamide/mesna","ixabepilone","levamisole","lomustine","lymphocyte_immune_globulin _anti-thy_(equine)","mechlorethamine","melphalan","mitomycin","mitoxantrone","mycophenolate_mofetil","mycophenolic_acid","ofatumumab","oxaliplatin","topotecan","pemetrexed","plicamycin","pralatrexate","rilonacept","rituximab","streptozocin","temozolomide","teniposide","thioguanine","tocilizumab","trimetrexate","uracil_mustard","ustekinumab","diethylstilbestrol","estramustine","exemestane","letrozole","megestrol","pegaspargase","porfimer","flunisolide","mometasone","zafirlukast","nisoldipine","mephobarbital","phenobarbital","pyrazinamide","raltegravir","chlorthalidone/clonidine","clonidine","lansoprazole","lansoprazole/naproxen","omeprazole","oxcarbazepine","pantoprazole","rabeprazole","estradiol/levonorgestrel","estradiol/medroxyprogesterone","estradiol/norethindrone","estradiol/norgestimate","ethinyl_estradiol","ethinyl_estradiol/ethynodiol","ethinyl_estradiol/etonogestrel","ethinyl_estradiol/levonorgestrel","ethinyl_estradiol/norelgestromin","ethinyl_estradiol/norethindrone","ethinyl_estradiol/norgestimate","ethinyl_estradiol/norgestrel","etonogestrel","levonorgestrel","medroxyprogesterone","mestranol/norethindrone","norethindrone","norgestrel","epoetin_alfa","epoetin_beta-methoxy_polyethylene_glycol","esterified_estrogens","esterified_estrogens/methyltestosterone","estradiol","estradiol/testosterone","estrone","estropipate","quinestrol","conjugated_estrogens_topical","dienestrol_topical","estradiol_topical","estradiol/norethindrone_topical","estropipate_topical","glyburide","factor_ix_complex","aprotinin","norepinephrine","sevoflurane","primidone","bortezomib","glatiramer","oxygen","stavudine","hydralazine/hydrochlorothiazide/reserpine","hydrochlorothiazide/reserpine","hydroflumethiazide/reserpine","methyclothiazide/reserpine","polythiazide/reserpine","reserpine","reserpine/trichlormethiazide","moricizine","atropine","atropine/chlorpheniramine/hyoscyamine/phenylephrine/scopolamine","atropine/chlorpheniramine/hyoscyamine/pseudoephedrine/scopolamine","atropine/difenoxin","atropine/diphenoxylate","atropine/edrophonium","atropine/pralidoxime","azatadine","azatadine/pseudoephedrine","belladonna","benztropine","biperiden","brompheniramine","brompheniramine/carbetapentane/phenylephrine","brompheniramine/chlophedianol/pseudoephedrine","brompheniramine/chlorpheniramine/methscopolamine/phenylephrine/pseudoephedrine","brompheniramine/phenylephrine","brompheniramine/pseudoephedrine","butabarbital/hyoscyamine/phenazopyridine","carbetapentane/carbinoxamine/phenylephrine","carbetapentane/chlorpheniramine","carbetapentane/chlorpheniramine/phenylephrine","carbetapentane/dexchlorpheniramine/phenylephrine","carbetapentane/phenylephrine/pyrilamine","carbetapentane/pseudoephedrine/pyrilamine","carbetapentane/pyrilamine","carbinoxamine","carbinoxamine/methscopolamine/pseudoephedrine","carbinoxamine/phenylephrine","carbinoxamine/pseudoephedrine","cellulase/hyoscyamine/pancrelipase/phenyltoloxamine","chlophedianol/chlorcyclizine","chlophedianol/chlorcyclizine/pseudoephedrine","chlophedianol/dexbrompheniramine/phenylephrine","chlophedianol/dexchlorpheniramine/pseudoephedrine","chlophedianol/phenylephrine/triprolidine","chlophedianol/triprolidine","chlorcyclizine","chlorcyclizine/phenylephrine","chlorcyclizine/pseudoephedrine","chlorpheniramine","chlorpheniramine/guaifenesin/methscopolamine/phenylephrine","chlorpheniramine/guaifenesin/phenylephrine","chlorpheniramine/guaifenesin/pseudoephedrine","chlorpheniramine/methscopolamine","chlorpheniramine/methscopolamine/phenylephrine","chlorpheniramine/methscopolamine/phenylephrine/pseudoephedrine","chlorpheniramine/methscopolamine/pseudoephedrine","chlorpheniramine/phenylephrine","chlorpheniramine/phenylephrine/phenyltoloxamine","chlorpheniramine/phenylephrine/pyrilamine","chlorpheniramine/pseudoephedrine","clemastine","clidinium","cyclizine","cyproheptadine","dexbrompheniramine/phenylephrine","dexbrompheniramine/phenylephrine/pyrilamine","dexbrompheniramine/pseudoephedrine","dexbrompheniramine/pyrilamine","dexchlorpheniramine","dexchlorpheniramine/guaifenesin/pseudoephedrine","dexchlorpheniramine/methscopolamine/phenylephrine","dexchlorpheniramine/methscopolamine/pseudoephedrine","dexchlorpheniramine/phenylephrine","dexchlorpheniramine/pseudoephedrine","dicyclomine","dimenhydrinate","doxylamine","doxylamine/pseudoephedrine","flavoxate","glycopyrrolate","guaifenesin/phenylephrine/pyrilamine","hydroxyzine","hyoscyamine","hyoscyamine/methenamine","hyoscyamine/phenyltoloxamine","lactobacillus_acidophilus/methscopolamine","magnesium_salicylate/phenyltoloxamine","meclizine","mepenzolate","methscopolamine","methscopolamine/phenylephrine","methscopolamine/pseudoephedrine","orphenadrine","oxybutynin","phenindamine","pheniramine/phenylephrine_nasal","pheniramine/phenyltoloxamine/pseudoephedrine/pyrilamine","pheniramine/phenyltoloxamine/pyrilamine","phenylephrine/pyrilamine","phenylephrine/triprolidine","procyclidine","propantheline","pseudoephedrine/pyrilamine","pseudoephedrine/triprolidine","pyrilamine","scopolamine","solifenacin","tolterodine","trihexyphenidyl","tripelennamine","triprolidine","trospium","bromfenac","butabarbital","butalbital","diclofenac","dicloxacillin","diflunisal","indomethacin","etodolac","fenoprofen","fluoxymesterone","flurbiprofen","ketoprofen","meclofenamate","mefenamic_acid","methohexital","methyltestosterone","metronidazole","miconazole_topical","miconazole/zinc_oxide_topical","nabumetone","nafcillin","nandrolone","naproxen","naproxen/pseudoephedrine","oxandrolone","oxaprozin","oxymetholone","pentobarbital","phenylbutazone","piroxicam","secobarbital","stanozolol","sulfinpyrazone","sulindac","testosterone","thiopental","tolmetin","bismuth_subsalicylate","caffeine/magnesium_salicylate","choline_salicylate","choline_salicylate/magnesium_salicylate","cilostazol","epoprostenol","iloprost","magnesium_salicylate","salsalate","sodium_salicylate","sodium_thiosalicylate","treprostinil","chlorothiazide","chlorthalidone","deserpidine/hydrochlorothiazide","deserpidine/methyclothiazide","digoxin_immune_fab","edetate_disodium_(edta)","fenoldopam","guanethidine/hydrochlorothiazide","minoxidil","guanadrel","guanethidine","hydrochlorothiazide","hydroflumethiazide","indapamide","methyclothiazide","metolazone","polythiazide","polythiazide/prazosin","trichlormethiazide","caffeine","caffeine/sodium_benzoate","clevidipine","cyclandelate","deserpidine","dexmedetomidine","doxazosin","ethaverine","famotidine","felodipine","guanabenz","guanfacine","inamrinone","isoxsuprine","isradipine","mecamylamine","milrinone","nesiritide","nicardipine","niclosamide","nifedipine","nimodipine","papaverine","phenoxybenzamine","phentolamine","prazosin","rauwolfia_serpentina","rofecoxib","terazosin","thiabendazole","tolazoline","trimethaphan_camsylate","vitamin_e","dextran_1","dextran _high_molecular_weight","dextran _low_molecular_weight","balsalazide","etidronate","ibandronate","mesalamine","olsalazine","pamidronate","valdecoxib","vancomycin","zoledronic_acid","valacyclovir","atomoxetine","dirithromycin","carbetapentane/guaifenesin/phenylephrine","carbetapentane/phenylephrine","chlophedianol/guaifenesin/phenylephrine","dobutamine","guaifenesin/phenylephrine","levonordefrin/mepivacaine","metaraminol","methoxamine","phenylephrine","phenylephrine/pramoxine_topical","acetaminophen/pseudoephedrine","apraclonidine_ophthalmic","brewer s_yeast","brimonidine_ophthalmic","carbetapentane","carbetapentane/guaifenesin","carbetapentane/guaifenesin/pseudoephedrine","carbetapentane/pseudoephedrine","carbidopa/entacapone/levodopa","carbidopa/levodopa","cetirizine/pseudoephedrine","chlophedianol/guaifenesin/pseudoephedrine","chlophedianol/pseudoephedrine","desloratadine/pseudoephedrine","entacapone","etomidate","fexofenadine/pseudoephedrine","fospropofol","guaifenesin/pseudoephedrine","ketamine","levodopa","liver_derivative_complex","loratadine/pseudoephedrine","mephentermine","nitrous_oxide","propofol","pseudoephedrine","tolcapone","acetylcarbromal","baclofen","benzocaine/trimethobenzamide","calamine/diphenhydramine_topical","carisoprodol","chloral_hydrate","chlormezanone","chlorphenesin","chlorzoxazone","diphenhydramine_topical","diphenhydramine/hydrocortisone_topical","diphenhydramine/hydrocortisone/nystatin_topical","diphenhydramine/hydrocortisone/nystatin/tetracycline_topical","diphenhydramine/lidocaine/nystatin_topical","diphenhydramine/zinc_acetate_topical","dronabinol","estazolam","eszopiclone","ethchlorvynol","ethosuximide","felbamate","flurazepam","gabapentin","halazepam","levetiracetam","meprobamate","metaxalone","methocarbamol","methsuximide","nabilone","olopatadine_nasal","oxazepam","paraldehyde","pergolide","phenacemide","phensuximide","pramipexole","pregabalin","quazepam","ramelteon","ropinirole","rotigotine","temazepam","tiagabine","trimethobenzamide","valerian","zaleplon","zolpidem","probenecid","ampicillin/sulbactam","bacampicillin","benzathine_penicillin/procaine_penicillin","carbenicillin","clavulanate/ticarcillin","cloxacillin","methicillin","mezlocillin","oxacillin","penicillin","piperacillin","piperacillin/tazobactam","procaine_penicillin","ticarcillin","lacosamide","edetate_calcium_disodium","intravenous_electrolyte_solution","pentetate_calcium_trisodium","misoprostol","oxytocin","urea","chlorpropamide","glimepiride","glimepiride/pioglitazone","glimepiride/rosiglitazone","glipizide","insulin","insulin_aspart","insulin_aspart_protamine","insulin_aspart/insulin_aspart_protamine","insulin_detemir","insulin_glargine","insulin_glulisine","insulin_inhalation _rapid_acting","insulin_isophane","insulin_isophane/insulin_regular","insulin_lispro","insulin_lispro_protamine","insulin_lispro/insulin_lispro_protamine","insulin_regular","insulin_zinc","insulin_zinc_extended","miglitol","nateglinide","pioglitazone","rosiglitazone","tolazamide","tolbutamide","troglitazone","mannitol","ziconotide","modafinil","chloramphenicol","tocainide","orlistat","proguanil","pyrimethamine","alendronate","aminosalicylic_acid","diclofenac_topical","risedronate","tiludronate","midodrine","nalmefene","naltrexone","cannabis","somatrem","somatropin","ferrous_fumarate/folic_acid/iron_polysaccharide","ferrous_sulfate/folic_acid","folic_acid","multivitamin","multivitamin_with_iron","multivitamin_with_minerals","multivitamin _prenatal","ferrous_fumarate/iron_polysaccharide","ferrous_gluconate","ferrous_sulfate","ferumoxides","ferumoxsil","ferumoxytol","heme_iron_polypeptide","heme_iron_polypeptide/iron_polysaccharide","iron_polysaccharide","iron_protein_succinylate","iron_sucrose","multivitamin_with_iron_and_fluoride","selenium","sodium_ferric_gluconate_complex","cholecalciferol","cholecalciferol/genistein/zinc_chelazome","cholecalciferol/genistein/zinc_glycinate","dihydrotachysterol","ergocalciferol","multivitamin_with_fluoride","sucralfate","dapsone","flucytosine","guanidine","penicillamine","metronidazole_topical","tinidazole","sodium_iodide-i-131","ethionamide","acetaminophen/guaifenesin","acetaminophen/pamabrom","acetaminophen/pamabrom/pyridoxine","atovaquone","bicalutamide","chaparral","chenodeoxycholic_acid","clavulanate","comfrey","dehydroepiandrosterone","eltrombopag","emtricitabine","erlotinib","flutamide","kava","lamivudine","niacinamide","nilutamide","nitrofurantoin","pennyroyal","phenazopyridine","riluzole","fomepizole","acetophenazine","fesoterodine","cocaine","methicillin_acyl-serine","sulfacytine","tenoxicam","roxithromycin","cinitapride","calcium","gadobutrol","heptabarbital","lumefantrine","edrophonium","hetacillin","thyroglobulin","cortisone_acetate","cefazolin","salicylate-sodium","bezafibrate","ezetimibe","ranitidine","dihydroquinidine_barbiturate","ceftizoxime","loratadine","polystyrene_sulfonate","propericiazine","sitaxentan","lopinavir","cephalexin","desogestrel","cinolazepam","aluminium","quinethazone","ropivacaine","l-tryptophan","cefditoren","penicillin_g","penicillin_v","bromodiphenhydramine","dapiprazole","spirapril","ceftazidime","ceforanide","etoricoxib","fondaparinux_sodium","dexbrompheniramine","tiotropium","ginkgo_biloba","triflusal","rotigotine_transdermal_patch","diphenoxylate","clindamycin","pilocarpine","homatropine_methylbromide","dinoprostone","cefoxitin","nizatidine","exenatide","cephalothin_group","echothiophate","flunitrazepam","flunarizine","sulfamethazine","hexobarbital","methacycline","oxyphencyclimine","cefixime","d-tryptophan","vindesine","butethal","tiaprofenic_acid","ethynodiol_diacetate","gliclazide","pyridostigmine","benzylpenicilloyl_polylysine","vitamin_c","metipranolol","pivmecillinam","methylphenobarbital","penciclovir","acetylcholine","latanoprost","asparaginase","bevantolol","udenafil","cyclacillin","demecarium","flucloxacillin","cefprozil","phenmetrazine","iron","phencyclidine","cilastatin","glucosamine","secretin","talbutal","oxyphenbutazone","liothyronine","cilazapril","etidronic_acid","moclobemide","lercanidipine","aprobarbital","somatropin_recombinant","mesalazine","ephedra","ketazolam","magnesium","imipenem","polymyxin_b_sulfate","tasosartan","glycodiazine","cefotetan","calcium_acetate","raloxifene","s-adenosylmethionine","aceprometazine","saprisartan","ursodeoxycholic_acid","prazepam","cyclopentolate","fluticasone_propionate","ribavirin_monophosphate","levothyroxine","amifostine","meticillin","aciclovir","oxymetazoline","dextrothyroxine","memantine","acepromazine","levobunolol","zopiclone","pramlintide","adefovir_dipivoxil","cefepime","acenocoumarol","alfacalcidol","colestipol","pimecrolimus","alverine","cefotaxime","dihydrocodeine","nitrazepam","encainide","lincomycin","zuclopenthixol","rolitetracycline","temafloxacin","dabigatran_etexilate","cefoperazone","methylscopolamine","cefradine","norgestimate","citric_acid","desloratadine","domperidone","diphenylpyraline","orciprenaline","montelukast","clodronate","sulfadimethoxine","oxprenolol","dipivefrin","moxalactam_derivative","attapulgite","cisatracurium_besylate","saxagliptin","sevelamer","quinupristin","sitagliptin","meclofenamic_acid","paramethasone","clocortolone","doxacurium_chloride","isopropamide","pivampicillin","ambenonium","testolactone","cefmetazole","anisotropine_methylbromide","octreotide","melatonin","lumiracoxib","zinc","progesterone","glutethimide","sertindole","yohimbine","methysergide","levonordefrin","cefonicid","phytonadione","cefamandole","brimonidine","ketotifen","liraglutide","ipratropium_bromide","dorzolamide","trioxsalen","liotrix","acetylsalicylic_acid","cefaclor","mestranol","pipobroman","josamycin","azlocillin","cholestyramine","sulfapyridine","amsacrine","tridihexethyl","deslanoside","bupivacaine","aztreonam","calcipotriol","pipotiazine","methoxsalen","tigecycline","ethopropazine","cefuroxime","quinidine_barbiturate","cefalotin","chlorprothixene","pargyline","bromazepam","nadroparin","erythrityl_tetranitrate","nandrolone_decanoate","artemether","norelgestromin","methantheline","sulfathiazole","azelastine","testosterone_propionate","gadofosveset_trisodium","ergoloid_mesylate","tazobactam","carbachol","cyclothiazide","cephaloglycin","nitrendipine","filgrastim","dihydroergotoxine","cephapirin","sulfamerazine","fexofenadine","ginseng","practolol","forasartan","fusidic_acid","muromonab","drospirenone","colesevelam","valrubicin","mebendazole","metyrapone","cevimeline","fenoterol","clobetasol","dihydroxyaluminium","interferon_alfa-2a _recombinant","alseroxylon","thioproperazine","pentoxifylline","interferon_alpha-2b","isometheptene","brinzolamide","bimatoprost","apraclonidine","flupenthixol","potassium","trisalicylate-choline","salbutamol","tryptophanyl-5 amp","glisoxepide","torasemide","apramycin","nandrolone_phenpropionate","procaterol","carbetocin","interferon_alfa-2b _recombinant","clomifene","pefloxacin","kaolin","loracarbef","ciclesonide","cefadroxil","estriol","transdermal_testosterone_gel","pizotifen","spiramycin","doxorubicin_transdrug","trientine_hydrochloride","roflumilast","pentaerythritol_tetranitrate","methenamine_mandelate","use_of_two_serotonin_modulators _such_as_zolmitriptan_and_carbergoline _inc","rufinamide","iodine","celiprolol","use_of_two_serotonin_modulators _such_as_zolmitriptan_and_bromocriptine _in","certolizumab_pegol","corticotropin-releasing_factor","estrogen","regadenoson","insulin_inhaled"];
  List<String> _selectedActiveIngredients = [];

  var _DoctorSpicialities;
  String description = "";
  String Doctor = "";

  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  String? _content;
  XFile? _image = null;
  final picker = ImagePicker();


  var imagePicker;
  Future<void> _getDirPath(var type) async {
    var source = type == ImageSourceType.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    XFile imagefile = await imagePicker.pickImage(
        source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
    setState(() {
      _image = imagefile;
    });
  }

  @override
  void initState() {
    imagePicker = new ImagePicker();

    // TODO: implement initState
    widget.storage._readSettingsData("icare_Language").then((String value) async{
      if(value != "No Data" && value != "")
      {

        setState(() {
          LanguageData = int.parse(value);
        });

      }
      else
      {
        setState(() {
          LanguageData = 0;
        });
      }

    });

    super.initState();


  }

  void _handleURLButtonPress(BuildContext context, var type) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Directionality( // use this
        textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
        child: ImageFromGalleryEx("/Prescriptions", type,storage: ImageStorage(),))),);
  }

  @override
  Widget build(BuildContext context) {

    double edge = 120.0;
    double padding = edge / 10.0;
    var now =  DateTime.now();
    var outputFormat = DateFormat('MM/dd/yyyy');
    var outputDate = outputFormat.format(now);
    String? DateNow = outputDate.toString();

    return Scaffold(
      //extendBodyBehindAppBar: true,
        drawer: MainMenu(storage: MainMenuStorage()),
        appBar: AppBar(
          title: Text(Title[LanguageData],
            style: const TextStyle(
              color: Colors.white,),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Color.fromRGBO(47, 150, 185, 1), Color.fromRGBO(84, 199, 212, 1),Color.fromRGBO(47, 150, 185, 1)])
            ),
          ),
          elevation: 0,

        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/img/grmain.png'),
                  fit: BoxFit.fill
              )
          ),
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          child:Scrollbar(
            isAlwaysShown: true,
            thickness: 0.0,
            //scrollbarOrientation: ScrollbarOrientation.bottom,
            controller: verticalScroll,
            child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                scrollDirection: Axis.vertical,
                controller: verticalScroll,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    // Form Title
                    Container(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        height: 80,
                        width: 80,
                        color: Colors.transparent,
                        child: SvgPicture.asset(
                          'assets/svg/prescriptions.svg',
                          width: 50,
                          height: 50,
                          alignment: AlignmentDirectional.center,
                          // color: Colors.white,
                          allowDrawingOutsideViewBox: false,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Add Form
                    Container(
                      margin: const EdgeInsets.only(top:5.0),
                      //padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.white,
                              Colors.white,
                            ]
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4,
                            offset: Offset(0, 2), // Shadow position
                          ),
                        ],
                      ),
                      child: ModalProgressHUD(
                        inAsyncCall: showProgress,
                        child: Column(
                          children: <Widget>[

                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child:  Card(
                                  color: const Color.fromRGBO(32, 116, 150, 1.0),
                                  shadowColor: Colors.grey,
                                  elevation: 4.0,
                                  margin: const EdgeInsets.only(top:0.0,left:0.0,bottom:5.0,right:0.0),
                                  child: ListTile(
                                    title:Text(AddTitle[LanguageData],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ) ,
                                  )
                              ),
                            ),

                            const SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child:TextField(
                                controller: DateController, //editing controller of this TextField
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.date_range), //icon of text field
                                  labelText: DateTitle[LanguageData],
                                  labelStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),  //label text of field
                                ),
                                readOnly: true,  //set it true, so that user will not able to edit text
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context, initialDate: DateTime.now(),
                                      firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2101)
                                  );

                                  if(pickedDate != null ){
                                    //var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
                                    var outputFormat = DateFormat('MM/dd/yyyy');
                                    var outputDate = outputFormat.format(pickedDate);
                                    DateController.text =  outputDate.toString();
                                    setState(() {
                                      DateController.text = outputDate.toString(); //set output date to TextField value.
                                    });
                                  }else{
                                    print("Date is not selected");
                                  }
                                },
                                style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                  fontSize: 16,
                                  //fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                controller: DoctorController,
                                onChanged: (value) {
                                  Doctor = value;
                                  //get value from textField
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: NameTitle[LanguageData],
                                  labelStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: const Icon(Icons.account_box),
                                ),
                                style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                  fontSize: 16,
                                  //fontWeight: FontWeight.w500,
                                ),
                              ),

                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: DropdownButtonFormField(
                                isDense: true,
                                isExpanded: true,
                                items: DoctorSpicialities.map((String Prescription) {
                                  return  DropdownMenuItem(
                                    alignment: Alignment.centerLeft,
                                    value: Prescription,
                                    child: Text(Prescription,
                                        style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                          fontSize: 16,
                                          //fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  // do other stuff with _Prescription
                                  _DoctorSpicialities = newValue;
                                },
                                value: _DoctorSpicialities,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                                  filled: false,
                                  fillColor: Colors.grey[200],
                                  prefixIcon: const Icon(Icons.category_outlined) ,
                                  hintText: SpecialityTitle[LanguageData],
                                  hintStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                  // errorText: 'Select Sub Prescriptions',
                                ),
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child:MultiSelectDialogField(
                                searchable: true,
                                items: ActiveIngredients.map((option) => MultiSelectItem(option, option)).toList(),
                                title: Text(IngredientsTitle[LanguageData],
                                  style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                  fontSize: 16,
                                  //fontWeight: FontWeight.w500,
                                ),),
                                selectedColor: Colors.teal,
                                selectedItemsTextStyle:
                                const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                  fontSize: 16,
                                  //fontWeight: FontWeight.w500,
                                ),

                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                ),
                                buttonIcon: const Icon(
                                  Icons.settings_input_component_outlined,
                                  color: Colors.grey,
                                ),
                                buttonText: Text(
                                  IngredientsTitle[LanguageData],
                                  style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                     fontSize: 16,
                                     //fontWeight: FontWeight.w500,
                                    ),
                                ),
                                  onConfirm: (values) {
                                    setState(() {
                                      _selectedActiveIngredients = values.cast<String>();
                                    });
                                  },
                                ),
                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                controller: DescriptionController,
                                onChanged: (value) {
                                  description = value;
                                  //get value from textField
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: DescriptionTitle[LanguageData],
                                  labelStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: const Icon(Icons.notes),
                                ),
                                style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                  fontSize: 16,
                                  //fontWeight: FontWeight.w500,
                                ),
                              ),

                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                const SizedBox(width: 20.0),
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      //_handleURLButtonPress(context, ImageSourceType.camera);
                                      _getDirPath(ImageSourceType.camera);
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/svg/camera.svg',
                                      height: 30.0,
                                      width: 30.0,
                                      allowDrawingOutsideViewBox: true,
                                      // color : Colors.white,
                                    ),
                                    label: const Text('',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Color.fromRGBO(66, 133, 244, 1.0))
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      // primary: Color.fromRGBO(66, 133, 244, 1.0),
                                      primary: Colors.white,
                                      // side: const BorderSide(width: 1.0, color: Color.fromRGBO(32, 116, 150, 1.0)),
                                      side: const BorderSide(width: 1.0, color: Colors.transparent),
                                      textStyle: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                // Profile Picture
                                Container(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    color: Colors.transparent,
                                    child:
                                    _image != null
                                        ? Image.file(
                                      File(_image!.path),
                                    )
                                        :SvgPicture.asset(
                                      'assets/svg/prescriptions.svg',
                                      width: 50,
                                      height: 50,
                                      alignment: AlignmentDirectional.center,
                                      // color: Colors.white,
                                      allowDrawingOutsideViewBox: false,
                                      // fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  // optional flex property if flex is 1 because the default flex is 1
                                  flex: 1,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // _handleURLButtonPress(context, ImageSourceType.gallery);
                                      _getDirPath(ImageSourceType.gallery);
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/svg/gallery.svg',
                                      height: 30.0,
                                      width: 30.0,
                                      allowDrawingOutsideViewBox: true,
                                      // color : Colors.white,
                                    ),
                                    label: const Text('',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Color.fromRGBO(66, 133, 244, 1.0))
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      // primary: Color.fromRGBO(66, 133, 244, 1.0),
                                      primary: Colors.white,
                                      //side: const BorderSide(width: 1.0, color: Color.fromRGBO(32, 116, 150, 1.0)),
                                      side: const BorderSide(width: 1.0, color: Colors.transparent),
                                      textStyle: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                              ],
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Container(
                                height: 50,
                                width: 300.0,
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ElevatedButton(
                                  child: Text(SaveBtnTitle[LanguageData]),
                                  onPressed: ()  async {
                                    try {
                                      if(DateController.text != "" && _DoctorSpicialities != "" && _selectedActiveIngredients != "" && Doctor != "") {
                                      setState(() {
                                        showProgress = true;
                                      });

                                      widget.storage._writeData(DateController.text+"#"
                                          +_DoctorSpicialities+"#"
                                          +_selectedActiveIngredients.toString()+"#"
                                          +Doctor+"#"
                                          +description+"\n",
                                          "icare_prescriptions");
                                      _image != null
                                          ?widget.storage._writeData(_image!.path+"\n", "icare_pictures")
                                          :widget.storage._writeData(""+"\n", "icare_pictures");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Directionality( // use this
                                                textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                                child: PrescriptionsPage(storage: PrescriptionsStorage(), key: null,)),),
                                      );
                                      setState(() {
                                        showProgress = false;
                                      });

                                      }
                                      else {
                                        setState(() {
                                          showProgress = false;
                                        });
                                        Fluttertoast.showToast(
                                            msg: SaveFailedTitle[LanguageData],
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.teal,
                                            textColor: Colors.white,
                                            fontSize: 14.0);
                                      }
                                    } catch (e) {
                                      setState(() {
                                        showProgress = false;
                                      });
                                      Fluttertoast.showToast(
                                          msg: SaveFailedTitle[LanguageData],
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.teal,
                                          textColor: Colors.white,
                                          fontSize: 14.0);
                                    }
                                  },
                                )
                            ),

                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                )
            ),
          ),
        )
    );
  }

}



class AddPrescriptionsStorage
{
  Future<String> createSettingsFolder() async {
    var dir = await getApplicationDocumentsDirectory();
    final path = Directory('${dir.path}/ICare/Settings');
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }

  // This function is triggered when the "Read" button is pressed
  Future<String> _readSettingsData(String Filename) async {
    final dirPath =  await createSettingsFolder();
    final myFile = await File('$dirPath/'+Filename+'.txt');

    if(await myFile.exists())
    {
      String data = await myFile.readAsString();
      return  data;
    }
    else
    {
      return "No Data";
    }

  }
// Find the Documents path
  Future<String> _getDirPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<String> createFolder() async {
    var dir = await getApplicationDocumentsDirectory();
    final path = Directory('${dir.path}/ICare/Prescriptions');
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }

// This function is triggered when the "Read" button is pressed
  Future<String> _readData(String Filename) async {
    final dirPath =  await createFolder();
    final myFile = await File('$dirPath/'+Filename+'.txt');

    if(await myFile.exists())
    {
      String data = await myFile.readAsString();
      return  data;
    }
    else
    {
      return "No Data";
    }

  }



// This function is triggered when the "Write" buttion is pressed
  Future<void> _writeData(String Data, String Filename) async {
    final _dirPath = await createFolder();

    final _myFile = File('$_dirPath/'+Filename+'.txt');
// If data.txt doesn't exist, it will be created automatically

    await _myFile.writeAsString(Data,mode: FileMode.append);
  }

}
