import 'mpt_verse_meanings.dart';
import 'package:flutter/material.dart';

const _green = Color(0xFF116B53);
const _gold = Color(0xFFD8AF58);

String learningLabel(String lang, String key) {
  const words = <String, Map<String, String>>{
    'surah': {'en':'Surah','bn':'সূরা','ko':'수라','ar':'السور'},
    'dua': {'en':'Dua library','bn':'দোয়ার সংগ্রহ','ko':'두아 모음','ar':'مكتبة الأدعية'},
    'daily': {'en':'Daily duas','bn':'দৈনন্দিন দোয়া','ko':'일상 두아','ar':'أدعية يومية'},
    'salah': {'en':'Duas in Salah','bn':'নামাজের মধ্যে ব্যবহৃত দোয়া','ko':'예배 중의 두아','ar':'أدعية الصلاة'},
    'kalima': {'en':'Six Kalimas','bn':'৬ কালিমা','ko':'여섯 칼리마','ar':'الكلمات الست'},
    'kursi': {'en':'Ayatul Kursi','bn':'আয়াতুল কুরসি','ko':'아야툴 쿠르시','ar':'آية الكرسي'},
    'quran': {'en':'Quranic duas (13)','bn':'কুরআনিক দোয়া (১৩টি)','ko':'꾸란의 두아 (13)','ar':'أدعية قرآنية (١٣)'},
    'morning': {'en':'Morning and evening','bn':'সকাল ও সন্ধ্যার দোয়া','ko':'아침과 저녁 두아','ar':'أذكار الصباح والمساء'},
    'protection': {'en':'Protection duas','bn':'সুরক্ষার দোয়া','ko':'보호를 위한 두아','ar':'أدعية الحفظ'},
    'pron': {'en':'Pronunciation guide','bn':'উচ্চারণ','ko':'발음 안내','ar':'النص العربي'},
    'meaning': {'en':'Meaning','bn':'অর্থ','ko':'의미','ar':'شرح المعنى'},
    'verses': {'en':'verses','bn':'আয়াত','ko':'절','ar':'آيات'},
    'reference': {'en':'Reference','bn':'উৎস','ko':'출처','ar':'المصدر'},
    'note': {'en':'Bengali and Korean readings are approximate learning aids; verify recitation with a qualified teacher.','bn':'বাংলা ও কোরিয়ান উচ্চারণ আনুমানিক সহায়ক; শুদ্ধ তিলাওয়াতের জন্য যোগ্য শিক্ষকের কাছে যাচাই করুন।','ko':'음역은 학습 보조 자료이며 정확한 아랍어 낭송을 대체하지 않습니다.','ar':'النقل الصوتي للتعلم ولا يغني عن التلاوة الصحيحة.'},
  };
  return words[key]?[lang] ?? words[key]?['en'] ?? key;
}

class _Entry {
  final String title, arabic, roman, bn, en, ko, reference;
  const _Entry(this.title, this.arabic, this.roman, this.bn, this.en, this.ko, this.reference);
}

// Surah texts are arranged in the exact order requested. Bismillah is shown separately
// for surahs other than Al-Fatihah; it is not counted as an additional verse.
const _surahs = <_Surah>[
  _Surah(1, 'Al-Fatihah', 'ফাতিহা', '알파티하', 'الفاتحة', [
    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
    'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
    'الرَّحْمَٰنِ الرَّحِيمِ',
    'مَالِكِ يَوْمِ الدِّينِ',
    'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
    'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
    'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
  ], [
    'Bismillahir-Rahmanir-Rahim','Alhamdu lillahi Rabbil-alamin','Ar-Rahmanir-Rahim','Maliki yawmid-din','Iyyaka nabudu wa iyyaka nastain','Ihdinas-siratal-mustaqim','Siratal-ladhina anamta alayhim ghayril-maghdubi alayhim wa lad-dallin',
  ],
  'পরম করুণাময়, অতি দয়ালু আল্লাহর নামে। সকল প্রশংসা আল্লাহর, যিনি সকল জগতের প্রতিপালক; পরম করুণাময়, অতি দয়ালু; বিচার দিনের মালিক। আমরা কেবল আপনারই ইবাদত করি এবং আপনারই সাহায্য চাই। আমাদের সরল পথ দেখান—তাদের পথ, যাদের আপনি অনুগ্রহ করেছেন; যাদের ওপর ক্রোধ পড়েছে বা যারা পথভ্রষ্ট, তাদের পথ নয়।',
  'In the name of Allah, the Most Merciful. All praise belongs to Allah, Lord of the worlds, the Most Merciful, Master of Judgment Day. You alone we worship and ask for help. Guide us to the straight path: the path of those You have favored, not those who earned anger or went astray.',
  '가장 자비로우신 알라의 이름으로. 모든 찬미는 만유의 주님 알라께 있습니다. 그분은 자비로우시며 심판의 날의 주인이십니다. 저희는 오직 주님만을 경배하고 도움을 구합니다. 은혜받은 이들의 바른길로 인도하시고 노여움을 산 자들과 길을 잃은 자들의 길은 피하게 하소서.'),
  _Surah(103,'Al-Asr','আসর','알아스르','العصر',[
    'وَالْعَصْرِ','إِنَّ الْإِنْسَانَ لَفِي خُسْرٍ','إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ',
  ],['Wal-asr','Innal-insana lafi khusr','Illal-ladhina amanu wa amilus-salihati wa tawasaw bil-haqqi wa tawasaw bis-sabr'],
  'সময়ের শপথ! মানুষ অবশ্যই ক্ষতির মধ্যে রয়েছে; তবে তারা নয় যারা ঈমান আনে, সৎকাজ করে এবং পরস্পরকে সত্য ও ধৈর্যের উপদেশ দেয়।',
  'By time! Humanity is in loss, except those who believe, do good deeds, and urge one another to truth and patience.',
  '시간에 맹세하노니, 인간은 손실 가운데 있습니다. 다만 믿고 선행하며 서로 진리와 인내를 권하는 이들은 예외입니다.'),
  _Surah(106,'Quraysh','কুরাইশ','꾸라이시','قريش',[
    'لِإِيلَافِ قُرَيْشٍ','إِيلَافِهِمْ رِحْلَةَ الشِّتَاءِ وَالصَّيْفِ','فَلْيَعْبُدُوا رَبَّ هَٰذَا الْبَيْتِ','الَّذِي أَطْعَمَهُمْ مِنْ جُوعٍ وَآمَنَهُمْ مِنْ خَوْفٍ',
  ],['Li-ilafi Quraysh','Ilafihim rihlatash-shitai was-sayf','Falyabudu Rabba hadhal-bayt','Alladhi atamahum min juin wa amanahum min khawf'],
  'কুরাইশদের অভ্যস্ততার জন্য—শীত ও গ্রীষ্মের সফরে তাদের অভ্যস্ততার জন্য—তারা যেন এই ঘরের রবের ইবাদত করে, যিনি তাদের ক্ষুধায় আহার দিয়েছেন এবং ভয় থেকে নিরাপদ রেখেছেন।',
  'For the security of Quraysh and their winter and summer journeys, let them worship the Lord of this House, who fed them against hunger and made them safe from fear.',
  '꾸라이시의 겨울과 여름 여행이 안전하게 이어지도록 하셨으니, 그들은 이 집의 주님을 경배해야 합니다. 그분은 굶주림에서 먹이시고 두려움에서 안전하게 하셨습니다.'),
  _Surah(107,'Al-Maun','মাউন','알마운','الماعون',[
    'أَرَأَيْتَ الَّذِي يُكَذِّبُ بِالدِّينِ','فَذَٰلِكَ الَّذِي يَدُعُّ الْيَتِيمَ','وَلَا يَحُضُّ عَلَىٰ طَعَامِ الْمِسْكِينِ','فَوَيْلٌ لِلْمُصَلِّينَ','الَّذِينَ هُمْ عَنْ صَلَاتِهِمْ سَاهُونَ','الَّذِينَ هُمْ يُرَاءُونَ','وَيَمْنَعُونَ الْمَاعُونَ',
  ],['Araaytal-ladhi yukadhdhibu bid-din','Fadhalikal-ladhi yadul-yatim','Wa la yahuddu ala taamil-miskin','Fawaylul-lil-musallin','Alladhina hum an salatihim sahun','Alladhina hum yuraun','Wa yamnaunal-maun'],
  'আপনি কি তাকে দেখেছেন, যে প্রতিদান দিবসকে অস্বীকার করে? সে এতিমকে ধাক্কা দেয় এবং দরিদ্রকে খাদ্য দিতে উৎসাহ দেয় না। দুর্ভোগ তাদের, যারা নামাজে উদাসীন, লোকদেখানো কাজ করে এবং সামান্য সাহায্যও আটকে রাখে।',
  'Have you seen one who denies the Judgment? Such a person pushes away the orphan and does not encourage feeding the poor. Woe to those who are heedless of their prayer, show off, and withhold small acts of help.',
  '심판을 부정하는 자는 고아를 밀쳐 내고 가난한 이에게 음식을 주도록 권하지 않습니다. 예배에 소홀하고 남에게 보이려고 하며 작은 도움조차 거부하는 자들에게 경고가 있습니다.'),
  _Surah(108,'Al-Kawthar','কাউসার','알카우사르','الكوثر',[
    'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ','فَصَلِّ لِرَبِّكَ وَانْحَرْ','إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ',
  ],['Inna ataynakal-kawthar','Fasalli li-Rabbika wanhar','Inna shaniaka huwal-abtar'],
  'নিশ্চয়ই আমরা আপনাকে কাউসার দান করেছি। অতএব আপনার রবের জন্য নামাজ পড়ুন ও কুরবানি করুন। নিশ্চয়ই আপনার বিদ্বেষীই নির্বংশ।',
  'Indeed We have granted you abundance. So pray to your Lord and sacrifice. Surely your enemy is the one cut off.',
  '우리는 그대에게 풍성한 은혜를 주었습니다. 그러므로 주님께 예배하고 희생 제물을 바치십시오. 그대를 미워하는 자야말로 단절될 것입니다.'),
  _Surah(109,'Al-Kafirun','কাফিরুন','알카피룬','الكافرون',[
    'قُلْ يَا أَيُّهَا الْكَافِرُونَ','لَا أَعْبُدُ مَا تَعْبُدُونَ','وَلَا أَنْتُمْ عَابِدُونَ مَا أَعْبُدُ','وَلَا أَنَا عَابِدٌ مَا عَبَدْتُمْ','وَلَا أَنْتُمْ عَابِدُونَ مَا أَعْبُدُ','لَكُمْ دِينُكُمْ وَلِيَ دِينِ',
  ],['Qul ya ayyuhal-kafirun','La abudu ma tabudun','Wa la antum abiduna ma abud','Wa la ana abidum ma abadtum','Wa la antum abiduna ma abud','Lakum dinukum wa liya din'],
  'বলুন, হে অবিশ্বাসীরা! তোমরা যার ইবাদত কর, আমি তার ইবাদত করি না। আমি যার ইবাদত করি, তোমরাও তার ইবাদতকারী নও। তোমরা যার ইবাদত করেছ, আমি তার ইবাদতকারী নই; তোমরাও আমি যার ইবাদত করি তার ইবাদতকারী নও। তোমাদের ধর্ম তোমাদের জন্য, আমার ধর্ম আমার জন্য।',
  'Say: O disbelievers! I do not worship what you worship, nor do you worship what I worship. I will not worship what you have worshipped, nor will you worship what I worship. For you is your religion, and for me mine.',
  '말하라. 불신자들이여, 나는 너희가 숭배하는 것을 숭배하지 않으며 너희도 내가 경배하는 분을 경배하지 않는다. 너희에게는 너희 종교가 있고 나에게는 나의 종교가 있다.'),
  _Surah(110,'An-Nasr','নাসর','안나스르','النصر',[
    'إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ','وَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا','فَسَبِّحْ بِحَمْدِ رَبِّكَ وَاسْتَغْفِرْهُ إِنَّهُ كَانَ تَوَّابًا',
  ],['Idha jaa nasrullahi wal-fath','Wa raaytan-nasa yadkhuluna fi dinillahi afwaja','Fasabbih bihamdi Rabbika wastaghfirh innahu kana tawwaba'],
  'যখন আল্লাহর সাহায্য ও বিজয় আসে এবং মানুষকে দলে দলে আল্লাহর দ্বীনে প্রবেশ করতে দেখেন, তখন আপনার রবের প্রশংসাসহ পবিত্রতা ঘোষণা করুন ও তাঁর কাছে ক্ষমা চান। নিশ্চয়ই তিনি তওবা কবুলকারী।',
  'When Allah’s help and victory come, and you see people entering Allah’s religion in crowds, glorify your Lord with praise and seek His forgiveness. He accepts repentance.',
  '알라의 도움과 승리가 오고 사람들이 무리 지어 그분의 종교에 들어오는 것을 보면 주님을 찬미하고 용서를 구하십시오. 그분은 회개를 받아 주십니다.'),
  _Surah(111,'Al-Masad','লাহাব / মাসাদ','알마사드','المسد',[
    'تَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ','مَا أَغْنَىٰ عَنْهُ مَالُهُ وَمَا كَسَبَ','سَيَصْلَىٰ نَارًا ذَاتَ لَهَبٍ','وَامْرَأَتُهُ حَمَّالَةَ الْحَطَبِ','فِي جِيدِهَا حَبْلٌ مِنْ مَسَدٍ',
  ],['Tabbat yada abi lahabin wa tabb','Ma aghna anhu maluhu wa ma kasab','Sayasla naran dhata lahab','Wamraatuhu hammalatal-hatab','Fi jidiha hablum mim masad'],
  'আবু লাহাবের দুই হাত ধ্বংস হোক এবং সে নিজেও ধ্বংস হোক। তার সম্পদ ও উপার্জন তার কোনো কাজে আসেনি। সে অগ্নিশিখায় প্রবেশ করবে; তার স্ত্রীও, যে জ্বালানি কাঠ বহন করে। তার গলায় থাকবে পাকানো আঁশের রশি।',
  'May Abu Lahab’s hands perish, and may he perish. His wealth and gains will not benefit him. He will burn in a blazing fire, and his wife, the carrier of firewood, will have a rope of twisted fiber around her neck.',
  '아부 라합은 멸망할 것이며 그의 재산도 그를 구하지 못합니다. 그는 타오르는 불에 들어가고 땔나무를 나르는 그의 아내도 목에 꼬인 섬유 밧줄을 두를 것입니다.'),
  _Surah(112,'Al-Ikhlas','ইখলাস','알이클라스','الإخلاص',[
    'قُلْ هُوَ اللَّهُ أَحَدٌ','اللَّهُ الصَّمَدُ','لَمْ يَلِدْ وَلَمْ يُولَدْ','وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ',
  ],['Qul huwallahu ahad','Allahus-samad','Lam yalid wa lam yulad','Wa lam yakul-lahu kufuwan ahad'],
  'বলুন, তিনি আল্লাহ, এক ও অদ্বিতীয়। আল্লাহ অমুখাপেক্ষী। তিনি কাউকে জন্ম দেননি এবং তাঁকেও জন্ম দেওয়া হয়নি। আর তাঁর সমতুল্য কেউ নেই।',
  'Say: He is Allah, One. Allah, the Eternal Refuge. He neither begets nor is born, and none is comparable to Him.',
  '말하라. 알라는 유일하신 분, 모든 것이 의지하는 분이십니다. 그분은 낳지도 태어나지도 않으셨으며 그분과 동등한 존재는 없습니다.'),
  _Surah(113,'Al-Falaq','ফালাক','알팔라크','الفلق',[
    'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ','مِنْ شَرِّ مَا خَلَقَ','وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ','وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ','وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ',
  ],['Qul audhu bi-Rabbil-falaq','Min sharri ma khalaq','Wa min sharri ghasiqin idha waqab','Wa min sharrin-naffathati fil-uqad','Wa min sharri hasidin idha hasad'],
  'বলুন, আমি আশ্রয় চাই প্রভাতের রবের কাছে—তিনি যা সৃষ্টি করেছেন তার অনিষ্ট থেকে, রাতের অন্ধকারের অনিষ্ট থেকে, গিরায় ফুঁ দেওয়া ব্যক্তিদের অনিষ্ট থেকে এবং হিংসুকের অনিষ্ট থেকে যখন সে হিংসা করে।',
  'Say: I seek refuge in the Lord of daybreak from the evil of what He created, the darkness as it settles, those who blow on knots, and the envier when they envy.',
  '말하라. 나는 새벽의 주님께 피난을 구합니다. 창조된 것들의 악, 어둠이 깔릴 때의 악, 매듭에 입김을 부는 자들의 악, 질투하는 자의 악으로부터 보호를 구합니다.'),
  _Surah(114,'An-Nas','নাস','안나스','الناس',[
    'قُلْ أَعُوذُ بِرَبِّ النَّاسِ','مَلِكِ النَّاسِ','إِلَٰهِ النَّاسِ','مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ','الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ','مِنَ الْجِنَّةِ وَالنَّاسِ',
  ],['Qul audhu bi-Rabbin-nas','Malikin-nas','Ilahin-nas','Min sharril-waswasil-khannas','Alladhi yuwaswisu fi sudurin-nas','Minal-jinnati wan-nas'],
  'বলুন, আমি আশ্রয় চাই মানুষের রব, মানুষের অধিপতি, মানুষের উপাস্যের কাছে—আত্মগোপনকারী কুমন্ত্রণাদাতার অনিষ্ট থেকে, যে মানুষের অন্তরে কুমন্ত্রণা দেয়, জিন ও মানুষের মধ্য থেকে।',
  'Say: I seek refuge in the Lord of humanity, the King of humanity, the God of humanity, from the evil of the retreating whisperer, who whispers into human hearts, from among jinn and humans.',
  '말하라. 나는 사람들의 주님, 왕, 신께 피난을 구합니다. 사람들의 마음에 속삭이는 악, 물러나 숨는 유혹자, 진과 사람 가운데 있는 자들의 악으로부터 보호를 구합니다.'),
];


// Bengali/Korean phonetic aids (approximate, NOT a tajwid-certified transcription).
const _phoneticBySurah = <int, List<List<String>>>{
  1: [
    ['বিসমিল্লাহির-রাহমানির-রাহীম', '비스밀라히르-라흐마니르-라힘'],
    ['আলহামদু লিল্লাহি রাব্বিল-আলামীন', '알함두 릴라히 랍빌-알라민'],
    ['আর-রাহমানির-রাহীম', '아르-라흐마니르-라힘'],
    ['মালিকি ইয়াওমিদ-দীন', '말리키 야우미드-딘'],
    ['ইয়্যাকা নাবুদু ওয়া ইয়্যাকা নাস্তাঈন', '이야카 나부두 와 이야카 나스타인'],
    ['ইহদিনাস-সিরাতাল-মুস্তাকীম', '이흐디나스-시라탈-무스타킴'],
    ['সিরাতাল-লআধইনআ আনআমতআ আলআইহইম গ়আইরইল-মআগ়দউবই আলআইহইম ওয়া লআদ-দআললইন', '시라탈-ㄹ아드인아 안아므트아 알아이흐이므 그아이르이ㄹ-므아그드우브이 알아이흐이므 와 ㄹ아드-드알ㄹ인'],
  ],
  103: [
    ['ওয়াল-আসর', '왈-아스르'],
    ['ইন্নাল-ইনসানা লাফী খুসর', '인날-인사나 라피 후스르'],
    ['ইল্লআল-লআধইনআ আমআনউ ওয়া আমইলউস-সআলইহআতই ওয়া তআউআসআউ বইল-হআককই ওয়া তআউআসআউ বইস-সআবর', '이ㄹ알-ㄹ아드인아 아므안우 와 아므이ㄹ우스-스알이흐아트이 와 트아우아스아우 브이ㄹ-흐아끄끄이 와 트아우아스아우 브이스-스아브르'],
  ],
  106: [
    ['লই-ইলআফই কুরআইশ', 'ㄹ이-이ㄹ아프이 꾸르아이시'],
    ['ইলআফইহইম রইহলআতআশ-শইতআই ওয়আস-সআইফ', '이ㄹ아프이흐이므 르이흐ㄹ아트아시-시이트아이 와아스-스아이프'],
    ['ফআলয়আবউদউ রআব্বআ হআধআল-বআইত', '프알이아브우드우 르아ㅂ아 흐아드알-브아이트'],
    ['আললআধই আতআমআহউম মিন জউইন ওয়া আমআনআহউম মিন খআউফ', '알ㄹ아드이 아트아므아흐우므 민 즈우인 와 아므안아흐우므 민 흐아우프'],
  ],
  107: [
    ['আরআয়তআল-লআধই য়উকআধধইবউ বইদ-দীন', '아르아이트알-ㄹ아드이 이우크아드드이브우 브이드-딘'],
    ['ফআধআলইকআল-লআধই য়আদউল-য়আতইম', '프아드알이크알-ㄹ아드이 이아드우ㄹ-이아트이므'],
    ['ওয়া লআ য়আহউদ্দউ আলআ তআমইল-মইসকইন', '와 ㄹ아 이아흐우ㄷ우 알아 트아므이ㄹ-므이스크인'],
    ['ফআউআইলউল-লইল-মউসআললইন', '프아우아이ㄹ우ㄹ-ㄹ이ㄹ-므우스알ㄹ인'],
    ['আললআধইনআ হউম আন সআলআতইহইম সআহউন', '알ㄹ아드인아 흐우므 안 스알아트이흐이므 스아흐운'],
    ['আললআধইনআ হউম য়উরআউন', '알ㄹ아드인아 흐우므 이우르아운'],
    ['ওয়া য়আমনআউনআল-মআউন', '와 이아므느아운알-므아운'],
  ],
  108: [
    ['ইননআ আতআইনআকআল-কআউথআর', '인느아 아트아이느아크알-크아우트아르'],
    ['ফআসআললই লই-রআব্বইকআ ওয়আনহআর', '프아스알ㄹ이 ㄹ이-르아ㅂ이크아 와안흐아르'],
    ['ইননআ শআনইআকআ হউওয়আল-আবতআর', '인느아 시안이아크아 흐우와알-아브트아르'],
  ],
  109: [
    ['কুল য়আ আইয়উহআল-কআফইরউন', '꿀 이아 아이이우흐알-크아프이르운'],
    ['লআ আবউদউ মআ তআবউদউন', 'ㄹ아 아브우드우 므아 트아브우드운'],
    ['ওয়া লআ আনতউম আবইদউনআ মআ আবউদ', '와 ㄹ아 안트우므 아브이드운아 므아 아브우드'],
    ['ওয়া লআ আনআ আবইদউম মআ আবআদতউম', '와 ㄹ아 안아 아브이드우므 므아 아브아드트우므'],
    ['ওয়া লআ আনতউম আবইদউনআ মআ আবউদ', '와 ㄹ아 안트우므 아브이드운아 므아 아브우드'],
    ['লআকউম দইনউকউম ওয়া লইয়আ দীন', 'ㄹ아크우므 드인우크우므 와 ㄹ이이아 딘'],
  ],
  110: [
    ['ইধআ জআ নআসরউল্লআহই ওয়াল-ফআথ', '이드아 즈아 느아스르우ㄹ아흐이 왈-프아트'],
    ['ওয়া রআয়তআন-নআসআ য়আদখউলউনআ ফই দইনইল্লআহই আফওয়আজআ', '와 르아이트안-느아스아 이아드흐우ㄹ운아 프이 드인이ㄹ아흐이 아프와아즈아'],
    ['ফআসআব্বইহ বইহআমদই রআব্বইকআ ওয়আসতআগ়ফইরহ ইননআহউ কআনআ তআউওয়আবআ', '프아스아ㅂ이흐 브이흐아므드이 르아ㅂ이크아 와아스트아그프이르흐 인느아흐우 크안아 트아우와아브아'],
  ],
  111: [
    ['তআব্বআত য়আদআ আবই লআহআবইন ওয়া তআব্ব', '트아ㅂ아트 이아드아 아브이 ㄹ아흐아브인 와 트아ㅂ'],
    ['মআ আগ়নআ আনহউ মআলউহউ ওয়া মআ কআসআব', '므아 아그느아 안흐우 므알우흐우 와 므아 크아스아브'],
    ['সআইআসলআ নআরআন ধআতআ লআহআব', '스아이아스ㄹ아 느아르안 드아트아 ㄹ아흐아브'],
    ['ওয়আমরআতউহউ হআম্মআলআতআল-হআতআব', '와아므르아트우흐우 흐아ㅁ알아트알-흐아트아브'],
    ['ফই জইদইহআ হআবলউম মইম মআসআদ', '프이 즈이드이흐아 흐아브ㄹ우므 므이므 므아스아드'],
  ],
  112: [
    ['কুল হুওয়াল্লাহু আহাদ', '꿀 후왈라후 아하드'],
    ['আল্লাহুস-সামাদ', '알라후스-사마드'],
    ['লাম ইয়ালিদ ওয়া লাম ইউলাদ', '람 얄리드 와 람 율라드'],
    ['ওয়া লাম য়আকউল-লআহউ কউফউওয়আন আহাদ', '와 람 이아크우ㄹ-ㄹ아흐우 크우프우와안 아하드'],
  ],
  113: [
    ['কুল আউধউ বই-রাব্বিল-ফালাক', '꿀 아우드우 브이-랍빌-팔라크'],
    ['মিন শাররি মআ খআলআক', '민 샤르리 므아 흐알아끄'],
    ['ওয়া মিন শাররি গ়আসইকইন ইধআ ওয়আকআব', '와 민 샤르리 그아스이끄인 이드아 와아끄아브'],
    ['ওয়া মিন শআররইন-নআফফআথআতই ফইল-উকআদ', '와 민 시아르르인-느아프프아트아트이 프이ㄹ-우끄아드'],
    ['ওয়া মিন শাররি হআসইদইন ইধআ হআসআদ', '와 민 샤르리 흐아스이드인 이드아 흐아스아드'],
  ],
  114: [
    ['কুল আউধউ বই-রআব্বইন-নাস', '꿀 아우드우 브이-르아ㅂ인-나스'],
    ['মআলইকইন-নাস', '므알이크인-나스'],
    ['ইলআহইন-নাস', '이ㄹ아흐인-나스'],
    ['মিন শআররইল-ওয়আসওয়আসইল-খআননআস', '민 시아르르이ㄹ-와아스와아스이ㄹ-흐안느아스'],
    ['আললআধই য়উওয়আসওয়ইসউ ফই সউদউরইন-নাস', '알ㄹ아드이 이우와아스와이스우 프이 스우드우르인-나스'],
    ['মইনআল-জইননআতই ওয়আন-নাস', '므인알-즈인느아트이 와안-나스'],
  ],
};

class _Surah {
  final int number;
  final String enName, bnName, koName, arName;
  final List<String> verses, roman;
  final String bnMeaning, enMeaning, koMeaning;
  const _Surah(this.number,this.enName,this.bnName,this.koName,this.arName,this.verses,this.roman,this.bnMeaning,this.enMeaning,this.koMeaning);
  String title(String lang) => lang == 'bn' ? bnName : lang == 'ko' ? koName : lang == 'ar' ? arName : enName;
  String meaning(String lang) => lang == 'bn' ? bnMeaning : lang == 'ko' ? koMeaning : lang == 'ar' ? verses.join(' ') : enMeaning;
}

class SurahLibraryPage extends StatelessWidget {
  final String language;
  const SurahLibraryPage({super.key,required this.language});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(learningLabel(language,'surah'))),
    body: ListView.builder(padding: const EdgeInsets.all(14), itemCount: _surahs.length, itemBuilder: (context,index) {
      final s=_surahs[index];
      return Card(child: ListTile(
        leading: CircleAvatar(backgroundColor:_green,foregroundColor:Colors.white,child:Text('${index+1}')),
        title: Text(s.title(language),style:const TextStyle(fontWeight:FontWeight.bold)),
        subtitle: Text('${s.enName} · ${s.number} · ${s.verses.length} ${learningLabel(language,'verses')}'),
        trailing:const Icon(Icons.chevron_right),
        onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>_SurahReader(surah:s,language:language))),
      ));
    }),
  );
}

class _SurahReader extends StatefulWidget {
  final _Surah surah;
  final String language;
  const _SurahReader({required this.surah,required this.language});
  @override State<_SurahReader> createState()=>_SurahReaderState();
}
class _SurahReaderState extends State<_SurahReader> {
  bool showPron=true, showMeaning=true;
  @override Widget build(BuildContext context) {
    final s=widget.surah,lang=widget.language;
    return Scaffold(appBar:AppBar(title:Text(s.title(lang))),body:ListView(padding:const EdgeInsets.all(16),children:[
      Text('${s.enName} · ${s.number} · ${s.verses.length} ${learningLabel(lang,'verses')}',textAlign:TextAlign.center,style:const TextStyle(color:_green,fontWeight:FontWeight.bold)),
      if(s.number!=1) const Padding(padding:EdgeInsets.symmetric(vertical:20),child:Text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',textDirection:TextDirection.rtl,textAlign:TextAlign.center,style:TextStyle(fontSize:27,height:1.7))),
      SwitchListTile(title:Text(learningLabel(lang,'pron')),value:showPron,onChanged:(v)=>setState(()=>showPron=v)),
      SwitchListTile(title:Text(learningLabel(lang,'meaning')),value:showMeaning,onChanged:(v)=>setState(()=>showMeaning=v)),
      for(var i=0;i<s.verses.length;i++) Card(margin:const EdgeInsets.only(bottom:10),child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
        Text('${i+1}',style:const TextStyle(color:_green,fontWeight:FontWeight.bold)),
        Text(s.verses[i],textDirection:TextDirection.rtl,textAlign:TextAlign.right,style:const TextStyle(fontSize:27,height:2.0)),
        if(showPron && lang!='ar') Text(lang=='bn' ? _phoneticBySurah[s.number]![i][0] : lang=='ko' ? _phoneticBySurah[s.number]![i][1] : s.roman[i],style:const TextStyle(color:_green,fontSize:15,height:1.7)),
        if(showMeaning) Padding(padding:const EdgeInsets.only(top:8),child:Text(mptVerseMeanings[s.number]![i][lang] ?? mptVerseMeanings[s.number]![i]['en']!,style:const TextStyle(fontSize:15,height:1.6))),
      ]))),

      const SizedBox(height:12),Text(learningLabel(lang,'note'),style:const TextStyle(fontSize:12)),
    ]));
  }
}

// Commonly taught South Asian six-Kalima compilation. It is not a Quranic surah.
const _kalimas = <_Entry>[
  _Entry('1. Kalima Tayyibah','لَا إِلَٰهَ إِلَّا اللَّهُ مُحَمَّدٌ رَسُولُ اللَّهِ','La ilaha illallahu Muhammadur rasulullah','আল্লাহ ছাড়া কোনো উপাস্য নেই; মুহাম্মদ (সা.) আল্লাহর রাসুল।','There is no deity worthy of worship except Allah; Muhammad is the Messenger of Allah.','알라 외에는 경배받을 신이 없으며 무함마드는 알라의 사도입니다.','Traditional six Kalimas: Tayyibah'),
  _Entry('2. Kalima Shahadah','أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ','Ashhadu al-la ilaha illallah wa ashhadu anna Muhammadan abduhu wa rasuluh','আমি সাক্ষ্য দিচ্ছি যে আল্লাহ ছাড়া কোনো উপাস্য নেই এবং মুহাম্মদ (সা.) তাঁর বান্দা ও রাসুল।','I testify that none is worthy of worship but Allah and that Muhammad is His servant and Messenger.','알라 외에는 경배받을 신이 없으며 무함마드는 그분의 종이자 사도임을 증언합니다.','Traditional six Kalimas: Shahadah'),
  _Entry('3. Kalima Tamjid','سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَٰهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ','Subhanallahi walhamdu lillahi wa la ilaha illallahu wallahu akbar; wa la hawla wa la quwwata illa billahil-aliyyil-azim','আল্লাহ পবিত্র, সকল প্রশংসা তাঁর, তিনি ছাড়া কোনো উপাস্য নেই, তিনি সর্বশ্রেষ্ঠ; তাঁর সাহায্য ছাড়া কোনো শক্তি নেই।','Glory and praise belong to Allah. There is no deity but Allah; Allah is greatest. There is no power except through Allah, the Most High, the Great.','알라는 완전하시고 모든 찬미는 그분께 있습니다. 알라 외에 신은 없고 그분은 가장 위대하십니다. 모든 힘은 그분께서 주십니다.','Traditional six Kalimas: Tamjid'),
  _Entry('4. Kalima Tawhid','لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ يُحْيِي وَيُمِيتُ وَهُوَ حَيٌّ لَا يَمُوتُ أَبَدًا أَبَدًا ذُو الْجَلَالِ وَالْإِكْرَامِ بِيَدِهِ الْخَيْرُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ','La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamd, yuhyi wa yumit, wa huwa hayyul-la yamutu abadan abada, dhul-jalali wal-ikram, biyadihil-khayr, wa huwa ala kulli shayin qadir','আল্লাহ এক, তাঁর কোনো শরিক নেই। রাজত্ব ও প্রশংসা তাঁরই। তিনি জীবন ও মৃত্যু দেন; তিনি চিরঞ্জীব এবং সর্বশক্তিমান।','Allah is One, without partner. Sovereignty and praise belong to Him. He gives life and death, is ever-living, and has power over everything.','알라는 유일하시며 동반자가 없습니다. 모든 주권과 찬미는 그분께 있습니다. 생사와 모든 권능이 그분께 속합니다.','Traditional six Kalimas: Tawhid'),
  _Entry('5. Kalima Istighfar','أَسْتَغْفِرُ اللَّهَ رَبِّي مِنْ كُلِّ ذَنْبٍ أَذْنَبْتُهُ عَمَدًا أَوْ خَطَأً سِرًّا أَوْ عَلَانِيَةً وَأَتُوبُ إِلَيْهِ مِنَ الذَّنْبِ الَّذِي أَعْلَمُ وَمِنَ الذَّنْبِ الَّذِي لَا أَعْلَمُ إِنَّكَ أَنْتَ عَلَّامُ الْغُيُوبِ وَسَتَّارُ الْعُيُوبِ وَغَفَّارُ الذُّنُوبِ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ','Astaghfirullaha Rabbi min kulli dhanbin adhnabtuhu amadan aw khataan sirran aw alaniyah, wa atubu ilayhi minadh-dhanbilladhi alamu wa minadh-dhanbilladhi la alam, innaka anta allamul-ghuyub wa sattarul-uyub wa ghaffarudh-dhunub, wa la hawla wa la quwwata illa billahil-aliyyil-azim','হে আল্লাহ, জেনে বা না জেনে, গোপনে বা প্রকাশ্যে করা সব পাপের ক্ষমা চাই এবং আপনার কাছে তওবা করি।','I ask Allah to forgive every sin, intentional or mistaken, hidden or public, known or unknown, and I repent to Him.','알라께 고의나 실수로, 드러나거나 숨겨진 모든 죄의 용서를 구하며 회개합니다.','Traditional six Kalimas: Istighfar'),
  _Entry('6. Kalima Radd-e-Kufr','اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ أَنْ أُشْرِكَ بِكَ شَيْئًا وَأَنَا أَعْلَمُ بِهِ وَأَسْتَغْفِرُكَ لِمَا لَا أَعْلَمُ بِهِ تُبْتُ عَنْهُ وَتَبَرَّأْتُ مِنَ الْكُفْرِ وَالشِّرْكِ وَالْكَذِبِ وَالْغِيبَةِ وَالْبِدْعَةِ وَالنَّمِيمَةِ وَالْفَوَاحِشِ وَالْبُهْتَانِ وَالْمَعَاصِي كُلِّهَا وَأَسْلَمْتُ وَأَقُولُ لَا إِلَٰهَ إِلَّا اللَّهُ مُحَمَّدٌ رَسُولُ اللَّهِ','Allahumma inni audhu bika min an ushrika bika shayan wa ana alamu bihi wa astaghfiruka lima la alamu bihi; tubtu anhu wa tabarraatu minal-kufri wash-shirki wal-kadhibi wal-ghibati wal-bidati wan-namimati wal-fawahishi wal-buhtani wal-maasi kulliha; wa aslamtu wa aqulu la ilaha illallahu Muhammadur rasulullah','হে আল্লাহ, জেনে-শুনে শিরক করা থেকে আপনার আশ্রয় চাই; অজান্তে করা ভুলের ক্ষমা চাই। কুফর, শিরক ও সব পাপ থেকে তওবা করি এবং ইসলামের সাক্ষ্য দিই।','O Allah, protect me from knowingly associating partners with You and forgive what I do unknowingly. I repent of disbelief, shirk and sins, and affirm faith.','알라여, 알고 범하는 다신 숭배로부터 보호하시고 모르고 지은 죄를 용서하소서. 불신과 모든 죄를 회개하고 믿음을 고백합니다.','Traditional six Kalimas: Radd-e-Kufr'),
];

const _salahDuas = <_Entry>[
  _Entry('Opening supplication (Sana)','سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ وَتَبَارَكَ اسْمُكَ وَتَعَالَىٰ جَدُّكَ وَلَا إِلَٰهَ غَيْرُكَ','Subhanakallahumma wa bihamdika wa tabarakasmuka wa taala jadduka wa la ilaha ghayruk','হে আল্লাহ, আপনি পবিত্র; আপনারই প্রশংসা। আপনার নাম বরকতময়, মর্যাদা মহান; আপনি ছাড়া কোনো উপাস্য নেই।','Glory and praise be to You, O Allah. Blessed is Your name, exalted is Your majesty, and there is no deity besides You.','알라여, 주님께 영광과 찬미를 드립니다. 주님의 이름은 복되며 위엄은 높고 주님 외에는 신이 없습니다.','Sunan Abi Dawud 775 (wording variants exist)'),
  _Entry('Ruku remembrance','سُبْحَانَ رَبِّيَ الْعَظِيمِ','Subhana Rabbiyal-azim','আমার মহান রব পবিত্র।','Glory be to my Lord, the Magnificent.','위대하신 나의 주님께 영광을 드립니다.','Sahih Muslim 772 (remembrance)'),
  _Entry('Sujud remembrance','سُبْحَانَ رَبِّيَ الْأَعْلَى','Subhana Rabbiyal-ala','আমার সর্বোচ্চ রব পবিত্র।','Glory be to my Lord, the Most High.','가장 높으신 나의 주님께 영광을 드립니다.','Sahih Muslim 772 (remembrance)'),
  _Entry('Between two prostrations','رَبِّ اغْفِرْ لِي','Rabbighfir li','হে আমার রব, আমাকে ক্ষমা করুন।','My Lord, forgive me.','주님, 저를 용서하소서.','Sunan Abi Dawud 874'),
  _Entry('Prayer for parents','رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ','Rabbighfir li wa liwalidayya','হে আমার রব, আমাকে ও আমার পিতা-মাতাকে ক্ষমা করুন।','My Lord, forgive me and my parents.','주님, 저와 부모님을 용서하소서.','Quran 14:41 (excerpt)'),
];

const _dailyDuas = <_Entry>[
  _Entry('Before eating','بِسْمِ اللَّهِ','Bismillah','আল্লাহর নামে শুরু করছি।','In the name of Allah.','알라의 이름으로 시작합니다.','Sunan Abi Dawud 3767'),
  _Entry('After eating','الْحَمْدُ لِلَّهِ','Alhamdulillah','সকল প্রশংসা আল্লাহর।','All praise is due to Allah.','모든 찬미는 알라께 있습니다.','General remembrance'),
  _Entry('Before sleeping','بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا','Bismikallahumma amutu wa ahya','হে আল্লাহ, আপনার নামেই আমি মরি ও বাঁচি।','O Allah, in Your name I die and live.','알라여, 주님의 이름으로 죽고 살아납니다.','Sahih al-Bukhari 6324'),
  _Entry('Upon waking','الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ','Alhamdu lillahil-ladhi ahyana bada ma amatana wa ilayhin-nushur','সকল প্রশংসা আল্লাহর, যিনি মৃত্যুর মতো ঘুমের পর আমাদের জীবন দিয়েছেন; তাঁর কাছেই ফিরে যেতে হবে।','Praise Allah who gave us life after causing us to sleep; to Him is the resurrection.','잠든 뒤 다시 생명을 주신 알라께 찬미를 드립니다. 그분께 돌아갑니다.','Sahih al-Bukhari 6324'),
];

const _kursi = <_Entry>[
  _Entry('Ayatul Kursi · Quran 2:255','اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ','Allahu la ilaha illa huwal-hayyul-qayyum, la takhudhuhu sinatuw-wa la nawm, lahu ma fis-samawati wa ma fil-ard, man dhal-ladhi yashfau indahu illa bi-idhnih, yalamu ma bayna aydihim wa ma khalfahum, wa la yuhituna bi-shayim-min ilmihi illa bima shaa, wasia kursiyyuhus-samawati wal-ard, wa la yauduhu hifzuhuma, wa huwal-aliyyul-azim','আল্লাহ ছাড়া কোনো উপাস্য নেই। তিনি চিরঞ্জীব, সবকিছুর ধারক। তাঁকে তন্দ্রা বা নিদ্রা স্পর্শ করে না। আসমান ও জমিনের সবকিছু তাঁর। তাঁর অনুমতি ছাড়া কেউ সুপারিশ করতে পারে না। তিনি সব জানেন; তাঁর জ্ঞান থেকে কেউ কিছু আয়ত্ত করতে পারে না, তিনি যা চান তা ছাড়া। তাঁর কুরসি আসমান ও জমিন পরিব্যাপ্ত। এগুলোর রক্ষণাবেক্ষণ তাঁকে ক্লান্ত করে না। তিনি সর্বোচ্চ, মহান।','Allah—there is no deity except Him, the Ever-Living, Sustainer. Neither drowsiness nor sleep overtakes Him. All in the heavens and earth belongs to Him. No one intercedes except by His permission. He knows all that is before and behind them; none encompass His knowledge except as He wills. His Kursi extends over the heavens and earth; preserving them does not tire Him. He is Most High, Most Great.','알라 외에는 신이 없습니다. 그분은 영원히 살아 계시며 만물을 유지하십니다. 졸음도 잠도 그분을 덮지 못합니다. 하늘과 땅의 모든 것은 그분의 것입니다. 그분의 허락 없이는 누구도 중재하지 못합니다. 그분의 지식은 모든 것을 포괄하며 그분의 권좌는 하늘과 땅에 미칩니다. 그분은 가장 높고 위대하십니다.','Quran 2:255'),
];

class LearningDuaPage extends StatelessWidget {
  final String language;
  final VoidCallback onOpenQuranicDuas;
  const LearningDuaPage({super.key,required this.language,required this.onOpenQuranicDuas});
  @override Widget build(BuildContext context) {
    final sections=<({String key,IconData icon,List<_Entry> items})>[
      (key:'daily',icon:Icons.wb_sunny_outlined,items:_dailyDuas),
      (key:'salah',icon:Icons.mosque_outlined,items:_salahDuas),
      (key:'kalima',icon:Icons.filter_6_outlined,items:_kalimas),
      (key:'kursi',icon:Icons.auto_awesome_outlined,items:_kursi),
      (key:'quran',icon:Icons.menu_book_outlined,items:const []),
      (key:'morning',icon:Icons.wb_twilight_outlined,items:[_kursi[0]]),
      (key:'protection',icon:Icons.shield_outlined,items:[_kursi[0]]),
    ];
    return Scaffold(appBar:AppBar(title:Text(learningLabel(language,'dua'))),body:ListView(padding:const EdgeInsets.all(14),children:[
      for(final section in sections) Card(margin:const EdgeInsets.only(bottom:9),child:ListTile(
        leading:Icon(section.icon,color:_green,size:30),
        title:Text(learningLabel(language,section.key),style:const TextStyle(fontWeight:FontWeight.bold)),
        subtitle:section.key=='kalima'?const Text('6 Kalima · ৬ কালিমা'):null,
        trailing:const Icon(Icons.chevron_right),
        onTap:(){ if(section.key=='quran'){ onOpenQuranicDuas(); } else { Navigator.push(context,MaterialPageRoute(builder:(_)=>_DuaCollection(title:learningLabel(language,section.key),entries:section.items,language:language))); } },
      )),
      const SizedBox(height:10),Text(learningLabel(language,'note'),style:const TextStyle(fontSize:12)),
    ]));
  }
}

class _DuaCollection extends StatelessWidget {
  final String title,language;
  final List<_Entry> entries;
  const _DuaCollection({required this.title,required this.entries,required this.language});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:Text(title)),body:ListView.builder(
    padding:const EdgeInsets.all(14),itemCount:entries.length,itemBuilder:(context,i){
      final d=entries[i];
      return Card(margin:const EdgeInsets.only(bottom:12),child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
        Text(d.title,style:const TextStyle(color:_green,fontSize:18,fontWeight:FontWeight.bold)),
        const SizedBox(height:12),Text(d.arabic,textDirection:TextDirection.rtl,textAlign:TextAlign.center,style:const TextStyle(fontSize:26,height:1.9)),
        const SizedBox(height:12),Text(d.roman,style:const TextStyle(fontSize:15,color:_green,height:1.6)),
        const SizedBox(height:10),Text(learningLabel(language,'meaning'),style:const TextStyle(fontWeight:FontWeight.bold)),
        Text(language=='bn'?d.bn:language=='ko'?d.ko:language=='ar'?'المعنى العربي التفصيلي قيد المراجعة؛ النص أعلاه هو الأصل العربي.':d.en,style:const TextStyle(fontSize:15,height:1.6)),
        const SizedBox(height:8),Text('${learningLabel(language,'reference')}: ${d.reference}',style:const TextStyle(fontSize:11,color:Colors.grey)),
      ])));
    }));
}
