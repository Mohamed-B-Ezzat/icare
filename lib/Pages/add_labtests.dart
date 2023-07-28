import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/Pages/LabTests.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Widgets/ImageFromGalleryEx.dart';
import 'package:dropdown_search/dropdown_search.dart';


class AddLabTests extends StatefulWidget {
  final AddLabTestsStorage storage;

  AddLabTests({Key? key, required this.storage}) : super(key: key);
  @override
  _AddLabTestsState createState() => _AddLabTestsState();
}
class _AddLabTestsState extends State<AddLabTests>  {

  var LanguageData =0;
  var Title = ["Lab Tests","فحوصات معملية",""];
  var AddTitle = ["Add Lab Test","اضافة فحص معملي",""];
  var DateTitle = ["Date","التاريخ",""];
  var GeneralTitle = ["General Lab Tests","فحوصات معملية عامة",""];
  var CombinedTitle = ["Combined Lab Tests","فحوصات معملية مجمعة",""];
  var DescriptionTitle = ["Description","الوصف",""];
  var SearchTitle = ["Search","بحث",""];
  var SaveBtnTitle = ["Save","حفظ",""];
  var SaveFailedTitle = ["Save Failed, Check Required Info.","فشل الحفظ ، تحقق من المعلومات المطلوبة.",""];


  TextEditingController DateController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();

  final verticalScroll = ScrollController();

  var GeneralLabTests = const ["ASOT ( Latex)","(8.21) by Fish","10-OH Carbazepine","11 Desoxycortisol (Compound S)","11q by FISH","13 q 14 by FISH","17 Alpha Hydroxyprogesterone","17 Hydroxy-Corticosteroids in urine","17 Ketosteroids In Urine","17 P by FISH","21 Hydroxylase Abs","25(OH) Vitamin D","5 q by FISH","5.Nucleotidase","5HIAA","7 q by FISH","A/G Ratio","Acetylcholine receptor antibodies.","Acid Phosphatase (Prostatic)","Acid Phosphatase (Total  and  Prostatic)","Acid Phosphatase (Total)","Acidified Glycerol lysis Time(Fresh-Incubated)","ACTH (am)","ACTH (pm)","ACTH Stimulation Test","ACTH Stimulation Test (Long Acting)","Actinomyces","Activated Protein C Resistance","Adeno Virus, Serology","Adenosine Deaminase","ADH (Antidiuretic Hormone)","Air Count","Albumin In CSF","Alcohol Level In Blood","Aldosterone in urine","Aldosterone.","Alkaline Phosphatase","Alkaline Phosphatase Isoenzymes","Alpha 2 macroglobulin","Alpha Feto Protein (AFP) in ser","Alpha Feto Protein (AFP)in preg","Alpha Glucosidase In Semen","Alpha1 Anti trypsin phenotype","Alpha-1 Antitrypsin in Serum","Alpha-Thalassemia Gene","Aluminum in plasma","Aluminum in water","AMA (Titre)","Aminogram (Plasma Quantitative)","Aminogram (Urine)","Amiodarone","Amitriptyline","Ammonia In Plasma","Amnicocentesis Culture","Amniocentesis","Amphetamine In Urine (Qualitati","Amphetamine In Urine (Quantitat","Amylase in Urine","Amylase, Fluid","Amylase/Creat Clearance Ratio","Amyloid A Protein","ANA Profile","ANCA (Titer)","ANCA-3-line","Androstenedione","Angiotensin Converting Enzyme (","Anion gap.","Anti Amoeba Antibodies","Anti Bilharzial Antibodies","Anti CCP Abs","Anti Centromere Ab .","Anti Desmoglein I  and III","Anti DNA (Anti-ds-DNA, Anti-nat","Anti DNA (Anti-ds-DNA,) by IF (","Anti DNA by ELISA","Anti Duffy system","Anti Endomysium Ab (IgG  and  IgA)","Anti Endomysium IgA Abs","Anti Endomysium IgG Abs","Anti Factor Xa Activity","Anti Glomerular Basment Membran","Anti haemophilic globulin","Anti Hu","Anti Hydatid Antibodies","Anti intrinsic Factor antibody","Anti Islet Cells Antibodies","Anti Kell system","Anti Keratin Abs","Anti MCV","Anti Microsomal Antibodies.","Anti Mitochondrial Antibodies (","Anti MNSs system","Anti Myelin-associated glycopro","Anti Neutrophil Cytoplasmic Ab","Anti Nuclear Ab Titre (ANA/Hep-","Anti Nuclear Antibodies (ANA/He","Anti Ovarian Antibodies (Anti O","Anti P1 system","Actinomyces","Activated Protein C Resistance","Adeno Virus, Serology","Adenosine Deaminase","ADH (Antidiuretic Hormone)","Air Count","Albumin In CSF","Alcohol Level In Blood","Aldosterone in urine","Aldosterone.","Alkaline Phosphatase","Alkaline Phosphatase Isoenzymes","Alpha 2 macroglobulin","Alpha Feto Protein (AFP) in ser","Alpha Feto Protein (AFP)in preg","Alpha Glucosidase In Semen","Alpha1 Anti trypsin phenotype","Alpha-1 Antitrypsin in Serum","Alpha-Thalassemia Gene","Aluminum in plasma","Aluminum in water","AMA (Titre)","Aminogram (Plasma Quantitative)","Aminogram (Urine)","Amiodarone","Amitriptyline","Ammonia In Plasma","Amnicocentesis Culture","Amniocentesis","Amphetamine In Urine (Qualitati","Amphetamine In Urine (Quantitat","Amylase in Urine","Amylase, Fluid","Amylase/Creat Clearance Ratio","Amyloid A Protein","ANA Profile","ANCA (Titer)","ANCA-3-line","Androstenedione","Angiotensin Converting Enzyme (","Anion gap.","Anti Amoeba Antibodies","Anti Bilharzial Antibodies","Anti CCP Abs","Anti Centromere Ab .","Anti Desmoglein I  and III","Anti DNA (Anti-ds-DNA, Anti-nat","Anti DNA (Anti-ds-DNA,) by IF (","Anti DNA by ELISA","Anti Duffy system","Anti Endomysium Ab (IgG  and  IgA)","Anti Endomysium IgA Abs","Anti Endomysium IgG Abs","Anti Factor Xa Activity","Anti Glomerular Basment Membran","Anti haemophilic globulin","Anti Hu","Anti Hydatid Antibodies","Anti intrinsic Factor antibody","Anti Islet Cells Antibodies","Anti Kell system","Anti Keratin Abs","Anti MCV","Anti Microsomal Antibodies.","Anti Mitochondrial Antibodies (","Anti MNSs system","Anti Myelin-associated glycopro","Anti Neutrophil Cytoplasmic Ab","Anti Nuclear Ab Titre (ANA/Hep-","Anti Nuclear Antibodies (ANA/He","Anti Ovarian Antibodies (Anti O","Anti P1 system","Anti Parietal Cell Antibodies","Anti Reticulin Abs.","Anti RNA","Anti RNP by ELISA.","Anti RNP U1 Qualitative","Anti SLA (AB)","Anti Smith Antibodies","Anti Smooth Muscle Abs (ASMA)T","Anti Smooth Muscle Antibodies(","Anti SP 100","Anti Sperm Antibodies (Semen).","Anti Sperm Antibodies (Serum).","Anti Striated Muscle Ab","Anti Tissue Transglutaminase(Q","Anti Tissue Transglutaminase(Q","Anti Treponema Pallidum Ab","Antibiogram for Fungi","Antibiogram for M.tuberculosis","Antibody screening test","Anticardiolipin IgG","Anticardiolipin IgM","Anti-Mullerian Hormone.","Anti-PM1","Antithrombin III Level","Antithyroglobulin (Anti TG) Ab","Antithyroid Antibodies (titre)","APCA (Titre)","Apolipoprotein A1.","Apolipoprotein B.","Apolipoprteins A1/ B  and  Ratio","Arsenic in Blood","Arsenic in Urine","Arterial Blood Gases.","Arylsulphatase","Ascaris Abs","Ascitic Fluid Culture For AFB","Ascitic Fluid Culture For Fung","Ascitic Fluid Examination","Ascitic Fluid Examination C/S","Ascitic Fluid Examination for","Ascitic Fluid Film For AFB (T.","ASOT (Turbidimetric)","Aspergillus Antigen in serum","B2-Microglobulin (Serum)","B2-Microglobulin (Urine)","Bactec Blood Culture For T.B","Bactec Culture for anaerobes","Bactec For T.B.","Barbiturates In Urine (Qualita","Barbiturates In Urine (Quantit","Basal Membrane Abs152) Basic m","Batter examination (chemical)","BCR - FISH (del.11, 12,13,17)","BCR-ABL by FISH","BCR-ABL by PCR","Becker versus Duchenne for mol","Bence Jones Protein In Urine","Benzidine test for Nipple disc","Benzodiazepine In Urine (Quant","Benzodiazepine In Urine(Qualit","Berca","Beta 2 Transferrin","Beta Human Chorionic Gonadotro","Beta Hydroxy Butyrate","Beta-2-Glycoprotein Abs(IgG  and I","B-HCG (Tumour Marker)","Bile Acid Total","Bilharzial Antigen in Urine","Bilirubin (Direct)","Bilirubin (Total)","Biopsy (Large)","Biopsy (Prost. 6 Sampls)","Biopsy (Small)","Biopsy : Consultation","Biopsy : Whole Kidney","Biopsy Culture for Fungi","Biopsy For H. pylori(Direct Fi","Biotin -Vitamin H","Biotinidase","Bleeding Time","Blood Culture (BACTEC).","Blood Culture C/S","Blood Culture For Fungi","Blood Gases, Venous","Blood Group  and  Rh","Blood group Subtype","Blood Urea Nitrogen","Blood Viscosity","Bone Marrow : Karyotyping","Bone Marrow Aspiration","Bone Marrow Aspiration (Doctor","Bone Marrow Doctor Fees(Biopsy","Bone Marrow Film : Consultatio","Bone Marrow Immuonophenotyping","Bone Marrow Silver Stain","Bone Marrow Trephine Biopsy","Bone Marrow Aspiration  and  Biops","Boron in water","Borrelia Burgdorferi Abs","Borreliosis (IgG and  IgM)","Brain Natriuretic Peptide (BNP","Bronchial lavage culture for T","Bronchial Lavage Examination","Bronchial Lavage Examination C","Bronchial Lavage Film For AFB","Brucella Abs CF","Brucella IgM","B-Thalassemia gene","Butterfly Fees","C1 Estrase Inhibitor (Activity","C1 Estrase Inhibitor (Antigen)","C5 - Complement Fraction","CA 72.4","Cadmium","Calcitonin (Thyro-Calcitonin)","Calcium in Milk","Calcium In Urine/24 hrs.","Calcium/Creatinine Ratio.","Calprotectin In Stool (Quantit","Campylobacter Serology","Candida Screening","Cannabinoids In Urine(Qualitat","Cannabinoids In Urine(Quantita","Cannabinoids in blood Quantita","Carbamazepin (Tegretol) Random","Carboxy Haemoglobin","Carcinoembryonic Antigen (CEA)","Carnitine in plasma","CASA (computerized semen analy","Catecholamines in blood","Catecholamines in Urine.","CD Markers","CD11c (TH)","CD31","CD4 / CD 8 ratio","Certican (Everolimus )","Ceruloplasmin Level","Cervical Film For AFB (T.B.)","Cervical Antisperms Ab (Total)","Cervical Culture For Fungi","Cervical Disch. Culture For AF","Cervical Discharge Exam.  and  C/S","CH 50","Chest Allergy(ALFA PNEUMO- CAR","Chlamydia Antibodies (IgA)","Chlamydia Antibodies (IgG)","Chlamydia Antigen","Chlamydia Pneumonia by PCR","Chlamydia Pneumoniae Ab","Chloride In Serum","Chol./HDL/LDL/Triglycer./Apo A","Cholinesterases","Chromium","Chromium (Urine)","Chromogranin A","Chromosomal Study","Chromosomal Study In Bone Marr","Circulating Immunocomplex","Citrate in urine","CK (Total)","CK Isoenzymes","CK-MB","CK-MB (Mass)","Clostridium Difficile toxins(A","Clot Lysis : Whole Blood","Clot Retraction test","Clotting Time (Lee-White)","Clozapine","CMV Antibodies (IgG)","CMV Antibodies (IgM)","CMV by PCR (Quantitative)","CMV by PCR in CSF","CMV IgG Avidity Test","Cocaine In Urine (Qualitative)","Cocaine In Urine (Quantitative","Coenzyme Q10","Coffee (Bacteriological examin","Coffee (Chemical examination)","Cold Agglutinin.","Complement C2 in Serum","Complement C3 in Serum","Complement C4 in Serum","Complement Component C2","Complete Blood Picture (CBC)","Complment level C1Q","Conjunctival Culture For Fungi","Conjunctival Discharge Exam. C","Conjunctival Discharge Exam. C","Copper In Blood","Copper in Hair","Copper in Milk","Copper In Urine","Corticosterone","Cortisol In Urine","Coxasack B1 - B6 (IgM)","Coxasackie B1- B6 IgG","Coxiella Burnetii (Q fever)","C-Peptide (fasting)","C-Peptide (postprandial)","C-Peptide in urine","C-Reactive Protein (CRP) Titre","Creatinine Clearance","Creatinine in Urine Random","Creatinine Level in 24hr Urine","CRP Ultrasensitive","Cryoglobulins","Cryptococcus Antigen","Cryptosporidia In Stool (direc","CSF Culture For AFB (T.B.)","CSF Culture For Fungi","CSF Examination","CSF Examination C/S","CSF Film For AFB (T.B.)","Culture for Anaerobes C/S","Culture for Campylobacter spp","Culture For T.B","CVD Strip Assay","Cyclic AMP in urine","Cyclosporine Level(Peak).","Cyclosporine Level(Trough)","Cystatin C","Cystic Fibrosis by PCR","Cystic Fluid Exam  and  Culture","Cystic Fluid Examination","Cysticercosis Serology","Cystine Level in Urine (Quant)","Cytochem, Leucocyte : Chlorac","Cytochem, Leucocyte : NASA","Cytochem, Leucocyte : NASA - F","Cytochem, Leucocyte : PAS","Cytochem, Leucocyte : Peroxida","Cytochem, Leucocyte : Sudan Bl","Cytochem,Non-specific Estrase","Cytochemistry : Acid Phosphata","Cytochemistry : Acid Phosphata","Cytochemistry : Leuc Alk. Ph.","Cytokeratin","Cytology : Consultation","Cytology.","Cytotoxic Antibodies (BL)","D-Dimer.","Delta Amino lovevulinic acid","Dengue virus IgM","Depakine (Valproic acid), Peak","Depakine (Valproic acid), Trou","Dexamethasone Suppression Test","Diazepam Structure (Valium)","Digoxin (Lanoxin)","Dihydro hodamine (DHR)","Dihydrotestosterone (DHT )","Diphtheria Abs356) Direct Coom","Dissolved Oxygen","DNA extraction","Double Marker Test","Drugs of Abuse (Qualitative)","Ear Culture For Fungi","Ear Discharge Exam. C/S (Left)","Ear Discharge Exam. C/S (Right","EBV by PCR","EBV by PCR in CSF","EBV-EA (IgG)","EBV-EA (IgM)","EBV-EBNA (IgG)-ELISA","EBV-VCA (IgM)","EBV-VCA-(IgG)","Elastase Feces","Eosinophil Smear : Conjunctiva","Eosinophil Smear: Nasal Secret","Eosinophil Smear: Sputum","Eosinophils in urine","Erythrocyte Sedimentation Rate","Erythropoietin","Estimated Glomerular Filtratio","Estradiol (E2)","Estriol (E3), Free","Estrogen Receptors (Breast)","Estron E1","Factor IX","Factor V","Factor V Leiden  and  Proth. 20210","Factor V Leiden  and  Prothrombin","Factor V Leiden G1691A mutatio","Factor VII","Factor VIII","Factor X","Factor XI","Factor XII (Hageman Factor)","FactorXIII","Familial Mediterranean Fever G","Fanconi anemia chromosomal bre","Fasciola Antibodies","Fasting Plasma Glucose","Ferritin in Serum","Fibrinogen Degradation Product","Fibrinogen Level (Titre)","FibroMax","Fibrotest and Actitest","Filariasis - Serology","Film For Malaria","FIP1L1 PDGFRa","FIP1L1 PDGFRb407) Fluoride in","FMC7","FNAC","Folic acid In RBCs","Folic Acid in serum","Fractional Excretion of Sodium","Fragile X Molecular Study (PCR","Free carbon dioxide","Free Fatty Acid","Free light chain in Serum","Free T3","Free T4","Free Testosterone","Free Testosterone and Index","Free Thyroxine Index (FTI)","Fructosamine (Serum)","Fructose in blood","Fructose in Semen","FSH","G6PD Activity (Qualitative)","G6PD Activity (Quantitative)","Galactosaemia Screen","Galactose-1-P uridyltransferas","Gamma GT (GGT)","Gastrin Level","Gastro-5-line","Genetic Councelling","Glucose Curve for Pregnants(3s","Glucose Curve for Pregnants(4s","Glucose In Urine","Glucose Tolerance Test (3 samp","Glucose Tolerance Test (5 Samp","Glutamate Decarboxylase ABS","Glutathione","Glycated Serum Protein.","Glycerol Lysis Test .","Glycine in CSF","Glycosylated Haemoglobin (HbA1","Gonorrhea by Gram stain","Growth Hormone","Growth Hormone Clonidine-Stimu","Growth Hormone Glucose-Suppr.","Growth Hormone Glucose-Suppr.","Growth Hormone Insulin-Stimula","H. pylori (Urea Breath Test)","H. pylori Abs (IgA)..","H. pylori Abs:IgG, IgA","H. pylori Ag In Stool.","H. pylori IgG Abs (Qualitative","H. pylori IgG Abs (Quantitativ","H. pylori IgM (Quantitative)45","H1N1 (Swine Flu) PCR","Haematocrit","Haemoglobin Electrophoresis.","Haemoglobin Level","Haemopexin","Haemophilus Influenzae B:IgG A","Haemosiderin","Hair culture for fungi","Hair Examination for fungi","Ham s Test","Haptoglobin Level","HAV antibodies - IgM","HAV antibody - IgG","Hb Variant by HPLC","HBc Antibodies IgM","HBc Antibodies Total","HBe Antibody","HBe Antigen","HBs Ab","HBs Antigen","HBV DNA by PCR (Qualitative)","HBV DNA by PCR (Quantitative)","HCV Antibody 3rd Generation","HCV IgM","HCV RNA (Quantitative)","HCV RNA by PCR (Qualitative)","HDL-Cholesterol","HDV Antibodies IgM","HDV Antigen","Heavy Metals In Water","Heinz Body Stain","Hemochromatosis Gene","Hemochromatosis gene(p.His63As","Her - 2","Herpes Simplex Virus by PCR (1","Herpes Virus Type 6 DNA","HEV Abs (IgG - IgM)","HEV IgG","HEV IgM","Histamine, Plasma","HIV 1  and  2 antibodies (AIDS tes","HIV by PCR (Quantitative)","HIV I ANTIGEN (P24)","HLA B27","HLA B5","HLA Class DQ (DQ2 - DQ 8)","HLA Class I - A by PCR","HLA Class I - B by PCR","HLA Class I (A and B) by PCR","HLA Final Cross Matching509) H","HOMA Test.","Homocysteine","Homocysteine in Urine","HPLC for Hb Variants","HSV - 1 IgG","HSV - 1 IgM","HSV - 2 IgG","HSV- 2 IgM","HTLV 1/2 Screening Serology (C","Human Corona virus 2012 (MERS)","Hyaluronic Acid","Hydroxyproline In Urine","IA2 Antibodies","IgA Level (Serum)","IgE Level (Total)","IgE Specific (Food Allergens)","IgE Specific (Inhalants).","IgG In CSF","IgG In Urine","IgG Level (Serum)","IgG Subclass 1","IgG Subclass 2","IgG Subclass 3","IgG Subclass 4","IgM Level (Serum)","Immunofixation in Urine","Immunoglobulin D","Immunohistochemistry (Biopsy)","Immunohistochemistry (One stai","Immunophenotyping","Immunophenotyping : CD (glycop","Immunophenotyping : CD (HLA-DR","Immunophenotyping : CD (MPO)","Immunophenotyping : CD 25","Immunophenotyping : CD103","Immunophenotyping : CD23","Immunophenotyping : CD45","Immunophenotyping : CD Tdt","Immunophenotyping : CD (kappa)","Immunophenotyping : CD 30","Immunophenotyping : CD1","Immunophenotyping : CD10","Immunophenotyping : CD13","Immunophenotyping : CD15","Immunophenotyping : CD19","Immunophenotyping : CD2","Immunophenotyping : CD20","Immunophenotyping : CD3","Immunophenotyping : CD4","Immunophenotyping : CD41560) I","Immunophenotyping : CD56 (NK)","Immunophenotyping : CD57","Immunophenotyping : CD7","Immunophenotyping : CD79a","Immunophenotyping : CD8","Immunophenotyping :CD 138","Immunophenotyping :CD 21","Immunophenotyping CD38.","Immunophenotyping: CD14","Immunophenotyping: CD16 (NK)","Immunophenotyping: CD22","Immunophenotyping: CD33","Immunophenotyping: CD34","Immunophenotyping: CD55","Immunophenotyping: CD59","Immunophenotyping: CD79b","Indirect Bilirubin , Serum","Indirect Coomb s Test","Influenza A/B","Inhibin B","Insulin Abs","Insulin Growth Factor1(IGF-1)","Insulin Level (1 h PP)","Insulin Level (2 h PP)","Insulin Level (Fasting)","Insulin Like GF Binding Protei","Insulin-Glucose T. Curve (5 sa","Insulin-Glucose T. Test (3 sam","Insulin-GlucoseT. Curve (6 sam","Interleukin 1- Beta","Interleukin 2","Interleukin 28B","Interleukin 6","Inv (16) by Fish","Iodine","Ionized Calcium (Ca++).","Iron in 24 hours urine","Iron Stain (Blood)","Iron Stain (BM)","Irregular antibody identificat","Itraconazole","JAK 2 Mutation (V617F)","Juice Chemical examination","Karyotyping For Chimerism","Karyotyping for Solid Tissue","Karyotyping, High Resolution","KJ 67","La (SS-B)","Lactate (CSF)","Lactic Acid611) Lamotrigin","LDH","LDH in CSF","LDH Isoenzymes","LDL-Cholesterol","LE Cells","Lead In Blood","Lead in urine","Legionella Abs","Legionella Antigen in urine","Leprosy (Microscopic Examinati","Leptin","Leptospira Ab","Leshmania Abs","Leucine Aminopeptidase","Levetiracetam Level in serum","LH-RH Stimulation Test","Lipase Level in Serum","Lipoprotein Electrophoresis.","Listeria (Total antibodies)","Lithium Level in Serum","Liver autoantibody Profile","Liver Kidney Microsome ( Anti","LKM (Titre)","Lp(a) qualitative","Lupus Anticoagulant","Luteinizing Hormone (LH)","Lymph Node Culture For AFB (T.","Lymph Node Film For AFB (T.B.)","Lymph. Node Asp. Exam./Cult.","Lymph. Node Culture For Fungi","Lyzosyme in serum","Magnesium - Erythrocytes","Magnesium In Urine/24 hrs","Malaria Antibodies","Malaria LDH Test","Manganese in Serum","Measles Abs (IgG and IgM)","Mercury in Blood","Mercury in Hair","Metabolic Screening","Metanephrine  and  Normetanephrine","Methadone In Urine","Methaemoglobin In Blood","Methotrexate","Methylene THF Reductase, MTHFR","Methylmalonic Acid in serum","Methylmalonic acid in urine","MFE : Hand Swab Culture......","Microalbumin Random sample(Alb","Microalbuminuria662) Microfila","Monospot Test","Mucopolysaccharides Screen","Mumps Abs (IgG and IgM)","Mycophenolate","Mycoplasma pneumonia IgG  and  IgM","Myelin Abs","Myelin Basic Protein Abs","Nail Culture For Fungi","Nail Examination for Fungi","Nasal Culture For AFB (T.B.)","Nasal Culture For Fungi","Nasal Discharge Film For AFB (","Nasal Swab Examination C/S","Nasopharyngeal Aspirate Exam.","Nasopharyngeal Culture For AFB","Nasopharyngeal Film For AFB (T","Natural Killer Cells (Nk)","Neonatal Screening 1","Neuromyelitis Optica Antibodie","Nicotine in Urine","Nipple Disch. Culture For AFB","Nipple Disch. Film For AFB (T.","Nipple Discharge Exam. C/S (Le","Nipple Discharge Exam. C/S (Ri","Nitro Blue Tetrazolium (N.B.T)","NSE (Neurone Specific Enolase","NSE,Cytokeratin,Chromogranin.","NTX in urine","Occult Blood In Stools","Occult Blood In Stools 3 Sampl","Oil,Chemical analysis","Oligoclonal Banding with index","Opiates In Urine(Qualitative)","Opiates In Urine(Quantitative)","Opiates in blood (quantitative","Organic Acids in Urine","Osmatic Fragility (Fresh -Incu","Osmolality in urine 24hr","Osmolality urine random","Osmolarity in serum (Calculate","Osmotic Fragility","Osmotic Fragility (Incubated)","Osteocalcin","Oxalate In 24-hr Urine","Panel for Immunophenotyping","Panel reactive Antibodies","PAP Smear","Paracetamol level","Parathyroid Hormone (PTH)","Partial Thromboplastin Time (P","Parvo Virus B19 Ab (IgG and IgM)","Paul Bunnel Test","PCP (Phencyclidin in urine)","Perianal Swab","Pericardial Fluid Culture For","Pericardial Fluid Culture For","Pericardial Fluid Examination","Pericardial Fluid Examination","Pericardial Fluid Film For AFB","Peritoneal Fluid Examination","Peritoneal Fluid Examination C","Peroxidase In Semen","PH (Stool)","Phenobarbital","Phenylalanine in blood","Phenytoin (Epanutin) Peak","Phenytoin (Epanutin) Trough","Philadelphia Chromosomes","Phosphorus / Creatinine ratio","Phosphorus in 24-hr Urine","Phytanic acid","Pl. Aggreg. Resp. to ADP","Pl. Aggreg. Resp. to Collagen","Pl. Aggreg. Resp. to Ristoceti","Plasma Glucose (Random)","Plasma glucose 1h after meal","Plasma Glucose 1hr After 50 g","Plasma Glucose 2hrs After 75 g","Plasma Glucose 2hrs PP","Plasma Metanephrine  and  Normetan","Plasma Renin Activity (FM)","Plasminogen","Platelet Antibodies (Direct )","Platelet Count","Platelet rich plasma (PRP)","Platelets Antibodies (Indirect","Pleural Fluid Culture For AFB","Pleural Fluid Culture For Fung","Pleural Fluid Examination C/S","Pleural Fluid Examination...","Pleural Fluid Film For AFB (T.","Pleural fluid for T.B by PCR","Porphobilinogen in Urine","Post Coital Test","Potassium - Creatinine Ratio","Pre albumin","Pregnancy Associated Plasma Pr","Pregnandiol","Procalcitonin (PCT)","Procollagen III764) Progestero","Progesterone Receptors (Breast","Proinsulin","Prolactin (PRL).","Prostatic Discharge Culture Fo","Prostatic Discharge Culture Fo","Prostatic Discharge Film For A","Prostatic Fl. Exam. C/S","Prostatic Fluid Examination","Prostatic Specific Antigen (Fr","Prostatic Specific Antigen (To","Protein Bound Iodine (PBI)","Protein C Activity","Protein electrophoresis in uri","Protein in CSF","Protein S Level","Protein-Creatinine Ratio in Ur","Proteins in 24hrs urine","Prothrombin 20210","Prothrombin Time  and  Conc...","PSA (Total  and  Free)","Pus Culture For AFB (T.B.)","Pus Culture For Fungi","Pus Examination  and  C/S","Pus Film For AFB (T.B.)","Pyruvate in CSF","Pyruvate in Whole Blood","Pyruvate Kinase (PK)","Quantiferon_TB Gold In _Tube","Rapid Plasma Reagin (RPR)","RARA gene by fish","RARA gene by PCR","RBCs Count","Ready to eat food","Reducing Sugar in Urine","Respiratory Syncitial Virurs -","Respiratory syncytial virus Ab","Result Retyping","Result Retyping DNA","Reticulocyte Count","Rh Genotyping","Rh group.","Rh(Du) .","Rheumatoid factor (IgA)","Rheumatoid Factor (Latex  and  Ros","Rheumatoid Factor (Rose-Waaler","Rheumatoid Factor Titre","RIBA Test For HCV","Ring Worm Examination","Rivotril (Clonazepam)","Ro (SS-A).815) Rotavirus Antig","Rubella Antibodies (IgG)","Rubella Antibodies (IgM)","Sacchromyces Cerevisiae ABS (A","Salicylate, Qualitative","Salmonella  and  Shigella Spp. (St","Schebo Test","SCL70 Ab Quant","Screening For Drugs of Abuse","Selenium in Serum (MX)","Semen Culture For AFB (T.B.)","Semen Culture For Fungi","Semen Examination","Semen Examination  and  C/S","Semen Film For AFB (T.B.)","Semen Processing","Serology For Brucella","Serotonin in Blood","Serotonin in urine","Serum Urea","Serum Albumin","Serum Aldolase","Serum Amylase","Serum Anti Sperm Antibodies (T","Serum Bicarbonates.","Serum Calcium (Total).","Serum Cannabis Confirmation Te","Serum Chloride","Serum Cholesterol","Serum Cortisol 5 pm","Serum Cortisol 9 am","Serum Cortisol 9 pm","Serum Creatinine","Serum DHEA","Serum DHEA-S","Serum Globulin","Serum Immunofixation","Serum Iron Level","Serum Magnesium.","Serum Myeloperoxidase Abs","Serum Myoglobin","Serum Osmolality","Serum Phosphorus","Serum Potassium (K)","Serum Protein Electrophoresis","Serum Sodium (Na)","Serum Sodium and Potassium","Serum Thyroglobulin Level","Serum Total Protein","Serum Uric Acid","Sex Hormone Binding Globulin (","SGPT (ALT)","Sickling test","Sirolimus","Skin Culture for fungi","Skin Examination For Fungi","Special Cultures : Campylobact","Special Cultures : Listeria Sp","Special Cultures : Mycoplasma","Special Cultures : Neisseria G","Special Cultures : Salmonella","Special Cultures : Salmonella","Special Cultures : Shigella Sp","Special Cultures : Shigella Sp","Special Cultures : Ureaplasma","Special Cultures : Ureaplasma","Special Staining","Special Test for MRSA","Spinal Musculer Atrophy","Spirometric Lung Function","Sputum Culture For AFB (T.B.)","Sputum Culture For Fungi","Sputum Examination C/S","Sputum Examination for fungi","Sputum Film For AFB (1 Sample)","Sputum Film For AFB (3 Samples","Sputum Film For AFB (5 Samples","Squamous Cell Carcinoma(SCC)","Stamey.s Test (Meares  and  Stamey","Stillbirth (Autopsy)","Stone Analysis","Stool Culture For AFB (T.B.) 3","Stool Culture For Fungi","Stool Examination","Stool Examination C/S","Stool Film For AFB (T.B.)","Stool For Bilharzia (Quantitat","Stool For Reducing Sugars","Streptococci group B (S.agalac","Succinylacetone in blood","Succinylacetone in urine","Sucrose Lysis Test","Sulpher","Superoxide Dismutase","Surface Immunoglobulin (SIG)","Sweat Chloride Test","Synovial Fluid Culture For AFB","Synovial Fluid Culture For Fun","Synovial Fluid Examination","Synovial Fluid Examination  and  C","Synovial Fluid Film For AFB (T","T.B. DNA by PCR (Blood)","T.B. DNA by PCR (Pleural Fluid","T.B. DNA by PCR (Sputum)","T.B. DNA by PCR (Urine)","T.B. in Biological fluid by PC","T3","T3 Uptake","T4","Tacrolimus (FK 506)","T-Cell Receptor (TCR)","Tegretol (Carbamazepine) Peak","Tegretol (Carbamazepine), Trou","Testicular Biopsy","Testosterone","Tetanus Abs","Thalasemia gene (Alpha)","Thalasemia gene (Beta)","Theophylline Level","Thiopurine-S-Methyltransferase","Throat Swab Culture For Fungi","Throat Swab Examination  and  C/S","Thrombin Time","Thyroxine Binding Globulin","Tissue biopsy culture and sens","Topiramate (LC-MS/MS) XXX","TORCH (IgG) (Toxo/Rub/CMV/HSV","TORCH (IgM) (Toxo/Rub/CMV/HSV","Total  and  Ionized Calcium (Ca++)","Total Iron Binding capacity (T","Total Leucocytic Count","Total Leucocytic count / Hb.  and ","Total Lipids","Total organic carbon","Toxocara Abs","Toxoplama IgG Avidity Test","Toxoplasma Antibodies (IgG)","Toxoplasma Antibodies (IgM)","Toxoplasmosis DNA by PCR","Tramadol in urine","Transferrin Level In Serum","Transferrin Saturation","Translocation 15,17 by FISH","Trichinella Serology","Trichinosis Abs","Triglycerides","Triple Marker Test","Trisomy 12 by FISH","Troponin I (quantitative).","Tryptase","TSH968) TSH receptors ABS (BL)","Tuberculin Test","Tumor Marker: CA 125","Tumor Marker: CA 15-3","Tumor Marker: CA 19-9","Tumor Necrosis Factor, Alpha","Ulcer Film For AFB (T.B.)","Ulcer Culture For AFB (T.B.)","Ulcer Culture For Fungi","Ulcer Swab Examination  and  Cultu","Unstable Haemoglobin","Urea Clearance","Urethral Culture For Fungi","Urethral Discharge Examination","Uric Acid / Creatinine","Urinary Bladder Cancer (UBC) D","Urinary Porphyrins","Urinary Potassium / 24hrs","Urinary Pregnanetriol","Urinary Sodium / 24hrs","Urine Culture For Fungi","Urine Analysis","Urine Analysis  and  C/S","Urine Chloride","Urine Culture For AFB (T.B.) 3","Urine Culture For AFB (T.B.),","Urine Examination (24 hours)","Urine Film For AFB (3 Samples)","Urine Film For AFB (one Sample","Urine Film For AFB(5 Samples)","Urine For Acetone","Urine For Bilharzia (Quantitat","Urine For Glucose  and  Acetone","Urine for Gram Stain","Urine Specific Gravity","Urine Uric Acid / 24hrs","Urobilinogen In Urine","Vaginal Culture For Fungi","Vaginal des. Doctor fees","Vaginal Discharge Exam.  and  C/S","Vaginal Film For Monilia","Valval Culture For Fungi","Vancomycin","Vanilmandelic Acid in Urine (","Varicella Zoster Antibodies I","Varicella Zoster Virus DNA","Vaso-Intestinal Polypeptide-","VDRL","Very long chain Fatty Acids","Vitamin A (Retinol)","Vitamin B11019) Vitamin B12 (","Vitamin B2","Vitamin B6","Vitamin C","Vitamin D (1,25 Dihydroxy)","Vitamin E (Alpha Tocopherol)","Vitamin K (Phylloquinone)","VLDL- Cholesterol","Von Willebrand Factor","Vulval Swab Exam.  and  C/S","Waste water examination","Water : Bacteriological Asses","Water : Chemical Analysis","Water :Biochemical Oxygen Dem","Water analysis : Total Suspen","Water examination : Mercury","Wax block","WBC count : Total  and  Different","WDT","Western Blot For HIV","Widal  and  Brucella Test","Widal Test","X - Y chromosome by Fish","Y-chromosomal deletion by PCR","Yellow Fever","Yersinia serology","ZAP 70","Zarontin (Ethosuximide) Level","Zinc In Blood","Zinc in hair","Zinc in Milk","Zinc In Urine"];

  var CombinedLabTests = const ["Semen analysis","Stool analysis","CSF analysis","URINE analysis ","CBC test ","Vitamins and Minerals analysis","Pregnancy and Andrology tests","Cardiac enzyme assays","Tumor analysis - Tumor markers","Lipids tests - Cholesterol tests","Blood flow and clotting tests","Liver function tests","Thyroid analyses","Pancreas analysis","Immunology tests","Germs analysis","Poisoning analysis","Diabetes tests","Adrenal gland analysis","Stomach tests","Parathyroid gland tests"];

  var _GeneralLabTests;
  var _SubLabTests;
  var LabTestID;
  String description = "";
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
        child: ImageFromGalleryEx("/LabTests", type,storage: ImageStorage(),)),));
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
                          'assets/svg/labtests.svg',
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
                              child:  DropdownSearch<String>(
                                popupProps: const PopupProps.dialog(
                                  showSelectedItems: true,
                                  showSearchBox: true,
                                  //disabledItemFn: (String s) => s.startsWith('I'),
                                ),
                                items: GeneralLabTests,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.medical_services_outlined) ,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    filled: false,
                                    // prefixIcon: Icon(Icons.settings_overscan) ,
                                    labelText: GeneralTitle[LanguageData],
                                    hintText: GeneralTitle[LanguageData],
                                    hintStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                      fontSize: 12,
                                      //fontWeight: FontWeight.w500,
                                    ),
                                    // errorText: 'Select Sub Prescriptions',
                                  ),
                                ),
                                onChanged: (newValue) {
                                  // do other stuff with _Prescription
                                  _GeneralLabTests = newValue;
                                  LabTestID = GeneralLabTests.indexOf(newValue.toString());
                                },
                                //show selected item
                                selectedItem: SearchTitle[LanguageData],
                              ),

                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: DropdownButtonFormField(
                                isExpanded: true,
                                items: CombinedLabTests.map((String LabTest) {
                                  return  DropdownMenuItem(
                                      alignment: Alignment.centerLeft,
                                      value: LabTest,
                                      child: Text(LabTest,
                                          style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                            fontSize: 16,
                                            //fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis
                                      ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  // do other stuff with _LabTest
                                  _SubLabTests = newValue;
                                },
                                value: _SubLabTests,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  prefixIcon: const Icon(Icons.medical_services),
                                  hintText: CombinedTitle[LanguageData],
                                  hintStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                  // errorText: 'Select Sub LabTests',
                                ),
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
                                      'assets/svg/labtests.svg',
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
                                      // if(fullname != "" && username != "") {
                                      setState(() {
                                        showProgress = true;
                                      });

                                      widget.storage._writeData(DateController.text+"#"
                                          +_GeneralLabTests+"#"
                                          +_SubLabTests+"#"
                                          +LabTestID.toString()+"#"
                                          +description+"\n",
                                          "icare_labtests");
                                      _image != null
                                          ?widget.storage._writeData(_image!.path+"\n", "icare_pictures")
                                          :widget.storage._writeData(""+"\n", "icare_pictures");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Directionality( // use this
                                                textDirection: LanguageData == 1 ?ui.TextDirection.rtl :ui.TextDirection.ltr ,
                                                child: LabTestsPage(storage: LabTestsStorage(), key: null,)),),
                                      );
                                      setState(() {
                                        showProgress = false;
                                      });

                                      // }
                                      // else {
                                      //   setState(() {
                                      //     showProgress = false;
                                      //   });
                                      //   Fluttertoast.showToast(
                                      //       msg: "E-mail and password are required",
                                      //       toastLength: Toast.LENGTH_SHORT,
                                      //       gravity: ToastGravity.BOTTOM,
                                      //       timeInSecForIosWeb: 1,
                                      //       backgroundColor: Colors.teal,
                                      //       textColor: Colors.white,
                                      //       fontSize: 14.0);
                                      // }
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



class AddLabTestsStorage
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
    final path = Directory('${dir.path}/ICare/LabTests');
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