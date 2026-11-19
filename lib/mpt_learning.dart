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

const _entryLocalization = <String, List<String>>{
  'Morning remembrance': ['সকালের যিকির', '아침의 기억', 'ذكر الصباح', 'আসবাহনা ওয়া আসবাহাল মুলকু লিল্লাহ', '아스바흐나 와 아스바할 물쿠 릴라'],
  'Evening remembrance': ['সন্ধ্যার যিকির', '저녁의 기억', 'ذكر المساء', 'আমসাইনা ওয়া আমসাল মুলকু লিল্লাহ', '암사이나 와 암살 물쿠 릴라'],
  'Seeking refuge': ['আশ্রয় প্রার্থনা', '보호를 구하는 두아', 'دعاء الاستعاذة', 'আউযু বিকালিমাতিল্লাহিত তাম্মাতি মিন শাররি মা খালাক', '아우주 비칼리마틸라힛 탐마티 민 샤르리 마 할라끄'],
  'Protection in Allah’s name': ['আল্লাহর নামে সুরক্ষার দোয়া', '알라의 이름으로 보호를 구하는 두아', 'دعاء الحفظ باسم الله', '', ''],
  '1. Kalima Tayyibah': ['১. কালিমা তাইয়্যিবা', '1. 칼리마 타이이바', '١. الكلمة الطيبة', '', ''],
  '2. Kalima Shahadah': ['২. কালিমা শাহাদাত', '2. 칼리마 샤하다', '٢. كلمة الشهادة', '', ''],
  '3. Kalima Tamjid': ['৩. কালিমা তামজীদ', '3. 칼리마 탐지드', '٣. كلمة التمجيد', '', ''],
  '4. Kalima Tawhid': ['৪. কালিমা তাওহীদ', '4. 칼리마 타우히드', '٤. كلمة التوحيد', '', ''],
  '5. Kalima Istighfar': ['৫. কালিমা ইস্তিগফার', '5. 칼리마 이스티그파르', '٥. كلمة الاستغفار', '', ''],
  '6. Kalima Radd-e-Kufr': ['৬. কালিমা রদ্দে কুফর', '6. 칼리마 라드 알쿠프르', '٦. كلمة رد الكفر', '', ''],
  'Before eating': ['খাওয়ার আগে', '식사 전', 'قبل الطعام', 'বিসমিল্লাহ', '비스밀라'],
  'After eating': ['খাওয়ার পরে', '식사 후', 'بعد الطعام', 'আলহামদুলিল্লাহ', '알함두릴라'],
  'Before sleeping': ['ঘুমানোর আগে', '잠자기 전', 'قبل النوم', 'বিসমিকা আল্লাহুম্মা আমূতু ওয়া আহইয়া', '비스미칼라훔마 아무투 와 아흐야'],
  'Upon waking': ['ঘুম থেকে ওঠার পরে', '기상 후', 'عند الاستيقاظ', 'আলহামদু লিল্লাহিল্লাযী আহইয়ানা বা’দা মা আমাতানা ওয়া ইলাইহিন নুশূর', '알함두 릴라힐라지 아흐야나 바으다 마 아마타나 와 일라이힌 누슈르'],
  'Opening supplication (Sana)': ['সানা (নামাজ শুরুর দোয়া)', '개시 두아 (사나)', 'دعاء الاستفتاح', 'সুবহানাকা আল্লাহুম্মা ওয়া বিহামদিকা ওয়া তাবারাকাসমুকা ওয়া তা’আলা জাদ্দুকা ওয়া লা ইলাহা গাইরুক', '수브하나칼라훔마 와 비함디카 와 타바라카스무카 와 타알라 자두카 와 라 일라하 가이루크'],
  'Ruku remembrance': ['রুকুর তাসবিহ', '루쿠의 찬미', 'ذكر الركوع', 'সুবহানা রাব্বিয়াল আযীম', '수브하나 랍비얄 아짐'],
  'Sujud remembrance': ['সিজদার তাসবিহ', '수주드의 찬미', 'ذكر السجود', 'সুবহানা রাব্বিয়াল আ’লা', '수브하나 랍비얄 아알라'],
  'Between two prostrations': ['দুই সিজদার মাঝের দোয়া', '두 번의 수주드 사이', 'الدعاء بين السجدتين', 'রাব্বিগফির লী', '랍비그피르 리'],
  'Prayer for parents': ['মা-বাবার জন্য দোয়া', '부모님을 위한 두아', 'الدعاء للوالدين', 'রাব্বিগফির লী ওয়া লিওয়ালিদাইয়্যা', '랍비그피르 리 와 리왈리다이야'],
  'Ayatul Kursi · Quran 2:255': ['আয়াতুল কুরসি · ২:২৫৫', '아야툴 쿠르시 · 2:255', 'آية الكرسي · البقرة ٢٥٥', '', ''],
};
const _arabicEntryMeanings = <String, String>{
  'Morning remembrance': 'أصبحنا وأصبح الملك لله، وله الحمد.',
  'Evening remembrance': 'أمسينا وأمسى الملك لله، وله الحمد.',
  'Seeking refuge': 'أطلب الحماية بكلمات الله التامات من شر المخلوقات.',
  'Protection in Allah’s name': 'أستعين باسم الله الذي لا يضر مع اسمه شيء، وهو السميع العليم.',
  'Before eating': 'أبدأ الطعام مستعينًا باسم الله.',
  'After eating': 'الحمد والثناء كله لله تعالى.',
  'Before sleeping': 'أذكر اسم الله عند النوم، فبأمره تكون الحياة والموت.',
  'Upon waking': 'الحمد لله الذي أعاد إلينا الحياة بعد النوم، وإليه البعث والرجوع.',
  'Opening supplication (Sana)': 'تنزيه الله والثناء عليه، والتبرك باسمه، وتعظيم شأنه، والإقرار بأنه لا معبود بحق سواه.',
  'Ruku remembrance': 'تنزيه ربي العظيم عن كل نقص.',
  'Sujud remembrance': 'تنزيه ربي الأعلى عن كل نقص.',
  'Between two prostrations': 'أسأل ربي أن يغفر لي.',
  'Prayer for parents': 'أسأل ربي المغفرة لي ولوالديّ.',
  'Ayatul Kursi · Quran 2:255': 'الله وحده المستحق للعبادة، الحي القيوم الذي لا ينام، له ملك السماوات والأرض، ولا شفاعة إلا بإذنه، وعلمه محيط بكل شيء، وحفظ الكون لا يعجزه، وهو العلي العظيم.',
  '1. Kalima Tayyibah': 'الإقرار بوحدانية الله وبرسالة محمد صلى الله عليه وسلم.',
  '2. Kalima Shahadah': 'أشهد أن الله وحده المستحق للعبادة وأن محمدًا عبده ورسوله.',
  '3. Kalima Tamjid': 'تسبيح الله وحمده وتوحيده وتكبيره، والإقرار بأن القوة لا تكون إلا بالله.',
  '4. Kalima Tawhid': 'الإقرار بأن الله واحد لا شريك له، له الملك والحمد، يحيي ويميت، وهو الحي القدير.',
  '5. Kalima Istighfar': 'أستغفر الله من الذنوب كلها، ما علمت منها وما لم أعلم، وأتوب إليه.',
  '6. Kalima Radd-e-Kufr': 'أستعيذ بالله من الشرك المتعمد، وأستغفره من الشرك غير المقصود، وأتوب من الكفر وسائر الذنوب وأجدد الشهادة.',
};
const _kalimaTitles = <String, List<String>>{
  '1. Kalima Tayyibah': ['১. কালিমা তাইয়্যিবা', '1. 칼리마 타이이바', '١. الكلمة الطيبة'],
  '2. Kalima Shahadah': ['২. কালিমা শাহাদাত', '2. 칼리마 샤하다', '٢. كلمة الشهادة'],
  '3. Kalima Tamjid': ['৩. কালিমা তামজীদ', '3. 칼리마 탐지드', '٣. كلمة التمجيد'],
  '4. Kalima Tawhid': ['৪. কালিমা তাওহীদ', '4. 칼리마 타우히드', '٤. كلمة التوحيد'],
  '5. Kalima Istighfar': ['৫. কালিমা ইস্তিগফার', '5. 칼리마 이스티그파르', '٥. كلمة الاستغفار'],
  '6. Kalima Radd-e-Kufr': ['৬. কালিমা রদ্দে কুফর', '6. 칼리마 라드 알쿠프르', '٦. كلمة رد الكفر'],
};
String _localizedEntryTitle(_Entry d, String lang) {
  final v = _entryLocalization[d.title];
  if (v == null) {
    final k = _kalimaTitles[d.title];
    if (k != null) return lang == 'bn' ? k[0] : lang == 'ko' ? k[1] : lang == 'ar' ? k[2] : d.title;
    return d.title;
  }
  return lang == 'bn' ? v[0] : lang == 'ko' ? v[1] : lang == 'ar' ? v[2] : d.title;
}
// Complete reading guides for the six traditional Kalimas and Ayatul Kursi.
// Approximate script aids only: recitation must be learned from Arabic/tajwid.
const _longEntryPronunciations = <String, Map<String, String>>{
  '1. Kalima Tayyibah': {
    'bn': 'লা ইলাহা ইল্লাল্লাহু মুহাম্মাদুর রাসূলুল্লাহ।',
    'ko': '라 일라하 일랄라후 무함마두르 라술룰라.',
  },
  '2. Kalima Shahadah': {
    'bn': 'আশহাদু আল্লা ইলাহা ইল্লাল্লাহু ওয়া আশহাদু আন্না মুহাম্মাদান আবদুহু ওয়া রাসূলুহু।',
    'ko': '아슈하두 알 라 일라하 일랄라후 와 아슈하두 안나 무함마단 압두후 와 라술루후.',
  },
  '3. Kalima Tamjid': {
    'bn': 'সুবহানাল্লাহি ওয়াল হামদু লিল্লাহি ওয়া লা ইলাহা ইল্লাল্লাহু ওয়াল্লাহু আকবার। ওয়া লা হাওলা ওয়া লা কুওয়াতা ইল্লা বিল্লাহিল আলিয়্যিল আযীম।',
    'ko': '수브하날라히 왈함두 릴라히 와 라 일라하 일랄라후 왈라후 아크바르. 와 라 하울라 와 라 꾸와타 일라 빌라힐 알리이일 아짐.',
  },
  '4. Kalima Tawhid': {
    'bn': 'লা ইলাহা ইল্লাল্লাহু ওয়াহদাহু লা শারীকা লাহু, লাহুল মুলকু ওয়া লাহুল হামদু, ইউহয়ী ওয়া ইউমীতু, ওয়া হুওয়া হাইয়্যুল লা ইয়ামূতু আবাদান আবাদা, যুল জালালি ওয়াল ইকরাম, বিইয়াদিহিল খাইরু, ওয়া হুওয়া আলা কুল্লি শাইইন কাদীর।',
    'ko': '라 일라하 일랄라후 와흐다후 라 샤리카 라후, 라훌 물쿠 와 라훌 함두, 유흐이 와 유미투, 와 후와 하이율 라 야무투 아바단 아바다, 줄 잘랄리 왈 이크람, 비야디힐 하이루, 와 후와 알라 쿨리 샤이인 까디르.',
  },
  '5. Kalima Istighfar': {
    'bn': 'আস্তাগফিরুল্লাহা রাব্বী মিন কুল্লি যানবিন আযনাবতুহু আমাদান আও খাতাআন, সিররান আও আলানিয়াতান, ওয়া আতূবু ইলাইহি মিনায যানবিল্লাযী আ’লামু ওয়া মিনায যানবিল্লাযী লা আ’লামু। ইন্নাকা আনতা আল্লামুল গুয়ূবি ওয়া সাত্তারুল উয়ূবি ওয়া গাফফারুয যুনূবি। ওয়া লা হাওলা ওয়া লা কুওয়াতা ইল্লা বিল্লাহিল আলিয়্যিল আযীম।',
    'ko': '아스타그피룰라하 랍비 민 쿨리 잔빈 아즈납투후 아마단 아우 하타안, 시르란 아우 알라니야탄, 와 아투부 일라이히 미나즈 잔빌라지 아알라무 와 미나즈 잔빌라지 라 아알라무. 인나카 안타 알라물 구유비 와 삿타룰 우유비 와 가파루즈 주누비. 와 라 하울라 와 라 꾸와타 일라 빌라힐 알리이일 아짐.',
  },
  '6. Kalima Radd-e-Kufr': {
    'bn': 'আল্লাহুম্মা ইন্নী আউযু বিকা মিন আন উশরিকা বিকা শাইআন ওয়া আনা আ’লামু বিহী, ওয়া আস্তাগফিরুকা লিমা লা আ’লামু বিহী। তুবতু আনহু ওয়া তাবাররাতু মিনাল কুফরি ওয়াশ শিরকি ওয়াল কাযিবি ওয়াল গীবাতি ওয়াল বিদআতি ওয়ান নামীমাতি ওয়াল ফাওয়াহিশি ওয়াল বুহতানি ওয়াল মাআসী কুল্লিহা। ওয়া আসলামতু ওয়া আকূলু লা ইলাহা ইল্লাল্লাহু মুহাম্মাদুর রাসূলুল্লাহ।',
    'ko': '알라훔마 인니 아우주 비카 민 안 우슈리카 비카 샤이안 와 아나 아알라무 비히, 와 아스타그피루카 리마 라 아알라무 비히. 툽투 안후 와 타바라투 미날 쿠프리 와슈 시르키 왈 카지비 왈 기바티 왈 비드아티 완 나미마티 왈 파와히시 왈 부흐타니 왈 마아시 쿨리하. 와 아슬람투 와 아꿀루 라 일라하 일랄라후 무함마두르 라술룰라.',
  },
  'Ayatul Kursi · Quran 2:255': {
    'bn': 'আল্লাহু লা ইলাহা ইল্লা হুওয়াল হাইয়্যুল কাইয়্যূম। লা তা’খুযুহু সিনাতুওঁ ওয়া লা নাওম। লাহু মা ফিস সামাওয়াতি ওয়া মা ফিল আরদ। মান যাল্লাযী ইয়াশফাউ ইনদাহু ইল্লা বিইযনিহী। ইয়া’লামু মা বাইনা আইদীহিম ওয়া মা খালফাহুম। ওয়া লা ইউহীতূনা বিশাইইম মিন ইলমিহী ইল্লা বিমা শাআ। ওয়াসিআ কুরসিয়্যুহুস সামাওয়াতি ওয়াল আরদ। ওয়া লা ইয়াউদুহু হিফযুহুমা। ওয়া হুওয়াল আলিয়্যুল আযীম।',
    'ko': '알라후 라 일라하 일라 후왈 하이율 까이윰. 라 타후주후 시나툰 와 라 나움. 라후 마 피스 사마와티 와 마 필 아르드. 만 잘라지 야슈파우 인다후 일라 비이즈니히. 야알라무 마 바이나 아이디힘 와 마 할파훔. 와 라 유히투나 비샤이임 민 일미히 일라 비마 샤아. 와시아 쿠르시이유후스 사마와티 왈 아르드. 와 라 야우두후 히프주후마. 와 후왈 알리이율 아짐.',
  },
};

String _localizedEntryPron(_Entry d, String lang) {
  final complete = _longEntryPronunciations[d.title]?[lang];
  if (complete != null) return complete;
  final v = _entryLocalization[d.title];
  if (v != null && lang == 'bn' && v[3].isNotEmpty) return v[3];
  if (v != null && lang == 'ko' && v[4].isNotEmpty) return v[4];
  return lang == 'ar' ? d.arabic : d.roman;
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
    ['বিসমিল্লাহির রাহমানির রাহীম', '비스밀라히르 라흐마니르 라힘'],
    ['আলহামদু লিল্লাহি রাব্বিল আলামীন', '알함두 릴라히 랍빌 알라민'],
    ['আর রাহমানির রাহীম', '아르 라흐마니르 라힘'],
    ['মালিকি ইয়াওমিদ্দীন', '말리키 야우믿 딘'],
    ['ইয়্যাকা না’বুদু ওয়া ইয়্যাকা নাস্তাঈন', '이야카 나부두 와 이야카 나스타인'],
    ['ইহদিনাস সিরাতাল মুস্তাকীম', '이흐디나스 시라탈 무스타킴'],
    ['সিরাতাল্লাযীনা আনআমতা আলাইহিম গাইরিল মাগদূবি আলাইহিম ওয়ালাদ্দাল্লীন',
     '시라탈 라지나 안암타 알라이힘 가이릴 마그두비 알라이힘 왈라 달린'],
  ],
  103: [
    ['ওয়াল আসর', '왈 아스르'],
    ['ইন্নাল ইনসানা লাফী খুসর', '인날 인사나 라피 후스르'],
    ['ইল্লাল্লাযীনা আমানূ ওয়া আমিলুস সালিহাতি ওয়া তাওয়াসাও বিল হাক্কি ওয়া তাওয়াসাও বিস সাবর',
     '일랄 라지나 아마누 와 아밀루스 살리하티 와 타와사우 빌 하끼 와 타와사우 비스 사브르'],
  ],
  106: [
    ['লি-ঈলাফি কুরাইশ', '리일라피 꾸라이시'],
    ['ঈলাফিহিম রিহলাতাশ শিতাই ওয়াস সাইফ', '일라피힘 리흘라타쉬 시타이 왓 사이프'],
    ['ফালইয়াবুদূ রাব্বা হাযাল বাইত', '팔야부두 랍바 하잘 바이트'],
    ['আল্লাযী আতআমাহুম মিন জূইঁ ওয়া আমানাহুম মিন খাওফ', '알라지 아트아마훔 민 주인 와 아마나훔 민 하우프'],
  ],
  107: [
    ['আরাআইতাল্লাযী ইউকাযযিবু বিদ্দীন', '아라아이탈라지 유카지부 빋딘'],
    ['ফাযালিকাল্লাযী ইয়াদুউল ইয়াতীম', '파잘리칼라지 야두울 야팀'],
    ['ওয়ালা ইয়াহুদ্দু আলা তাআমিল মিসকীন', '왈라 야후두 알라 타아밀 미스킨'],
    ['ফাওয়াইলুল্লিল মুসাল্লীন', '파와일룰 릴무살린'],
    ['আল্লাযীনা হুম আন সালাতিহিম সাহূন', '알라지나 훔 안 살라티힘 사훈'],
    ['আল্লাযীনা হুম ইউরাঊন', '알라지나 훔 유라운'],
    ['ওয়া ইয়ামনাঊনাল মাঊন', '와 얌나우날 마운'],
  ],
  108: [
    ['ইন্না আতাইনাকাল কাউসার', '인나 아타이나칼 카우사르'],
    ['ফাসাল্লি লিরাব্বিকা ওয়ানহার', '파살리 리랍비카 완하르'],
    ['ইন্না শানিআকা হুয়াল আবতার', '인나 샤니아카 후왈 압타르'],
  ],
  109: [
    ['কুল ইয়া আইয়ুহাল কাফিরূন', '꿀 야 아이유할 카피룬'],
    ['লা আ’বুদু মা তা’বুদূন', '라 아부두 마 타부둔'],
    ['ওয়ালা আনতুম আবিদূনা মা আ’বুদ', '왈라 안툼 아비두나 마 아부드'],
    ['ওয়ালা আনা আবিদুম মা আবাত্তুম', '왈라 아나 아비둠 마 아밧툼'],
    ['ওয়ালা আনতুম আবিদূনা মা আ’বুদ', '왈라 안툼 아비두나 마 아부드'],
    ['লাকুম দীনুকুম ওয়ালিয়া দীন', '라쿰 디누쿰 왈리야 딘'],
  ],
  110: [
    ['ইযা জাআ নাসরুল্লাহি ওয়াল ফাতহ', '이자 자아 나스룰라히 왈 파트흐'],
    ['ওয়া রাআইতান নাসা ইয়াদখুলূনা ফী দীনিল্লাহি আফওয়াজা', '와 라아이탄 나사 야드훌루나 피 디닐라히 아프와자'],
    ['ফাসাব্বিহ বিহামদি রাব্বিকা ওয়াস্তাগফিরহু ইন্নাহু কানা তাওয়াবা', '파삽비흐 비함디 랍비카 와스타그피르후 인나후 카나 타와바'],
  ],
  111: [
    ['তাব্বাত ইয়াদা আবী লাহাবিঁও ওয়া তাব্ব', '탑밧 야다 아비 라하빈 와 탑'],
    ['মা আগনা আনহু মালুহু ওয়ামা কাসাব', '마 아그나 안후 말루후 와마 카삽'],
    ['সাইয়াসলা নারান যাতা লাহাব', '사야슬라 나란 자타 라합'],
    ['ওয়ামরাআতুহু হাম্মালাতাল হাতাব', '왐라아투후 함말라탈 하탑'],
    ['ফী জীদিহা হাবলুম মিম মাসাদ', '피 지디하 하블룸 밈 마사드'],
  ],
  112: [
    ['কুল হুওয়াল্লাহু আহাদ', '꿀 후왈라후 아하드'],
    ['আল্লাহুস সামাদ', '알라후스 사마드'],
    ['লাম ইয়ালিদ ওয়া লাম ইউলাদ', '람 얄리드 와 람 율라드'],
    ['ওয়া লাম ইয়াকুল্লাহু কুফুওয়ান আহাদ', '와 람 야꿀라후 쿠푸완 아하드'],
  ],
  113: [
    ['কুল আউযু বিরাব্বিল ফালাক', '꿀 아우주 비랍빌 팔라끄'],
    ['মিন শাররি মা খালাক', '민 샤르리 마 할라끄'],
    ['ওয়া মিন শাররি গাসিকিন ইযা ওয়াকাব', '와 민 샤르리 가시낀 이자 와깝'],
    ['ওয়া মিন শাররিন নাফফাসাতি ফিল উকাদ', '와 민 샤르린 나파사티 필 우까드'],
    ['ওয়া মিন শাররি হাসিদিন ইযা হাসাদ', '와 민 샤르리 하시딘 이자 하사드'],
  ],
  114: [
    ['কুল আউযু বিরাব্বিন নাস', '꿀 아우주 비랍빈 나스'],
    ['মালিকিন নাস', '말리킨 나스'],
    ['ইলাহিন নাস', '일라힌 나스'],
    ['মিন শাররিল ওয়াসওয়াসিল খান্নাস', '민 샤르릴 와스와실 한나스'],
    ['আল্লাযী ইউওয়াসউইসু ফী সুদূরিন নাস', '알라지 유와스위수 피 수두린 나스'],
    ['মিনাল জিন্নাতি ওয়ান নাস', '미날 진나티 완 나스'],
  ],
};

class _Surah {
  final int number;
  final String enName, bnName, koName, arName;
  final List<String> verses, roman;
  final String bnMeaning, enMeaning, koMeaning;
  const _Surah(this.number,this.enName,this.bnName,this.koName,this.arName,this.verses,this.roman,this.bnMeaning,this.enMeaning,this.koMeaning);
  String title(String lang) => lang == 'bn' ? bnName : lang == 'ko' ? koName : lang == 'ar' ? arName : enName;
  String meaning(String lang) => lang == 'bn' ? bnMeaning : lang == 'ko' ? koMeaning : enMeaning;
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

// Adjustable Arabic text size shared by Surah and Dua readers.
Widget _arabicSizeControl(String language, double size, ValueChanged<double> onChanged) {
  final label = language == 'bn' ? 'আরবি লেখার আকার' : language == 'ko'
      ? '아랍어 글자 크기' : language == 'ar' ? 'حجم الخط العربي' : 'Arabic text size';
  return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    Row(children: [
      const Icon(Icons.format_size, size: 20, color: _green),
      const SizedBox(width: 8),
      Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
      Text('${size.round()}', style: const TextStyle(color: _green)),
    ]),
    Slider(min: 20, max: 40, divisions: 20, value: size,
        label: '${size.round()}', onChanged: onChanged),
  ]);
}

class _SurahReader extends StatefulWidget {
  final _Surah surah;
  final String language;
  const _SurahReader({required this.surah,required this.language});
  @override State<_SurahReader> createState()=>_SurahReaderState();
}
class _SurahReaderState extends State<_SurahReader> {
  bool showPron=true, showMeaning=true;
  double arabicFontSize = 27;
  @override Widget build(BuildContext context) {
    final s=widget.surah,lang=widget.language;
    return Scaffold(appBar:AppBar(title:Text(s.title(lang))),body:ListView(padding:const EdgeInsets.fromLTRB(14,14,14,36),children:[
      Text('${s.enName} · ${s.number} · ${s.verses.length} ${learningLabel(lang,'verses')}',textAlign:TextAlign.center,style:const TextStyle(color:_green,fontWeight:FontWeight.bold)),
      if(s.number!=1) Padding(padding:const EdgeInsets.symmetric(vertical:16),child:Text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',textDirection:TextDirection.rtl,textAlign:TextAlign.center,style:TextStyle(fontSize:arabicFontSize,height:1.75))),
      _arabicSizeControl(lang, arabicFontSize, (value) => setState(() => arabicFontSize = value)),
      SwitchListTile(title:Text(learningLabel(lang,'pron')),value:showPron,onChanged:(v)=>setState(()=>showPron=v)),
      SwitchListTile(title:Text(learningLabel(lang,'meaning')),value:showMeaning,onChanged:(v)=>setState(()=>showMeaning=v)),
      for(var i=0;i<s.verses.length;i++) Card(margin:const EdgeInsets.only(bottom:10),child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
        Text('${i+1}',style:const TextStyle(color:_green,fontWeight:FontWeight.bold)),
        Text(s.verses[i],textDirection:TextDirection.rtl,textAlign:TextAlign.right,style:TextStyle(fontSize:arabicFontSize,height:1.85)),
        if (showPron && lang != 'ar')
          Text(
            (lang == 'bn' || lang == 'ko') &&
                    (_phoneticBySurah[s.number]?.length ?? 0) > i
                ? _phoneticBySurah[s.number]![i][lang == 'bn' ? 0 : 1]
                : s.roman[i],
            style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize:15,height:1.7),
          ),
        if(showMeaning) Padding(
          padding:const EdgeInsets.only(top:8),
          child:Text(
            (mptVerseMeanings[s.number] != null && mptVerseMeanings[s.number]!.length > i)
                ? (mptVerseMeanings[s.number]![i][lang] ??
                    mptVerseMeanings[s.number]![i]['en'] ??
                    s.meaning(lang))
                : s.meaning(lang),
            style:const TextStyle(fontSize:15,height:1.6),
          ),
        ),
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

final _morningEveningDuas = <_Entry>[
  _Entry('Morning remembrance',
    'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ',
    'Asbahna wa asbahal-mulku lillah walhamdu lillah',
    'আমরা সকালে উপনীত হয়েছি; সকল রাজত্ব ও প্রশংসা আল্লাহর।',
    'We have entered the morning; all dominion and praise belong to Allah.',
    '우리는 아침을 맞았습니다. 모든 주권과 찬미는 알라께 있습니다.',
    'Sahih Muslim 2723 (opening excerpt)'),
  _Entry('Evening remembrance',
    'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ',
    'Amsayna wa amsal-mulku lillah walhamdu lillah',
    'আমরা সন্ধ্যায় উপনীত হয়েছি; সকল রাজত্ব ও প্রশংসা আল্লাহর।',
    'We have entered the evening; all dominion and praise belong to Allah.',
    '우리는 저녁을 맞았습니다. 모든 주권과 찬미는 알라께 있습니다.',
    'Sahih Muslim 2723 (opening excerpt)'),
];

final _protectionDuas = <_Entry>[
  _Entry('Seeking refuge',
    'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
    'Audhu bikalimatillahit-tammati min sharri ma khalaq',
    'আল্লাহর পরিপূর্ণ বাণীর আশ্রয় চাই তাঁর সৃষ্টির অনিষ্ট থেকে।',
    'I seek refuge in Allah’s perfect words from the evil of what He created.',
    '알라의 완전한 말씀에 의지하여 그분이 창조하신 것의 악으로부터 보호를 구합니다.',
    'Sahih Muslim 2708'),
  _Entry('Protection in Allah’s name',
    'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
    'Bismillahil-ladhi la yadurru maasmihi shayun fil-ardi wa la fis-samai wa huwas-samiul-alim',
    'আল্লাহর নামে, যাঁর নামের সঙ্গে পৃথিবী ও আকাশের কোনো কিছু ক্ষতি করতে পারে না; তিনি সর্বশ্রোতা, সর্বজ্ঞ।',
    'In Allah’s name, with which nothing on earth or in heaven can cause harm; He is All-Hearing, All-Knowing.',
    '알라의 이름으로. 그분의 이름과 함께라면 땅과 하늘의 어떤 것도 해를 끼칠 수 없으며 그분은 모든 것을 들으시고 아십니다.',
    'Sunan Abi Dawud 5088'),
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
      (key:'morning',icon:Icons.wb_twilight_outlined,items:_morningEveningDuas),
      (key:'protection',icon:Icons.shield_outlined,items:_protectionDuas),
    ];
    return Scaffold(appBar:AppBar(title:Text(learningLabel(language,'dua'))),body:ListView(padding:const EdgeInsets.all(14),children:[
      for(final section in sections) Card(margin:const EdgeInsets.only(bottom:9),child:ListTile(
        leading:Icon(section.icon,color:_green,size:30),
        title:Text(learningLabel(language,section.key),style:const TextStyle(fontWeight:FontWeight.bold)),
        subtitle:section.key=='kalima'?Text(learningLabel(language,'kalima')):null,
        trailing:const Icon(Icons.chevron_right),
        onTap:(){ if(section.key=='quran'){ onOpenQuranicDuas(); } else { Navigator.push(context,MaterialPageRoute(builder:(_)=>_DuaCollection(title:learningLabel(language,section.key),entries:section.items,language:language))); } },
      )),
      const SizedBox(height:10),Text(learningLabel(language,'note'),style:const TextStyle(fontSize:12)),
    ]));
  }
}

class _DuaCollection extends StatefulWidget {
  final String title,language;
  final List<_Entry> entries;
  const _DuaCollection({required this.title,required this.entries,required this.language});
  @override State<_DuaCollection> createState() => _DuaCollectionState();
}
class _DuaCollectionState extends State<_DuaCollection> {
  double arabicFontSize = 27;
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.title)),
    body: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
        child: _arabicSizeControl(widget.language, arabicFontSize,
            (value) => setState(() => arabicFontSize = value))),
      Expanded(child: ListView.builder(
    padding:const EdgeInsets.fromLTRB(14,4,14,36),itemCount:widget.entries.length,itemBuilder:(context,i){
      final d=widget.entries[i];
      return Card(margin:const EdgeInsets.only(bottom:12),child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
        Text(_localizedEntryTitle(d,widget.language),style:const TextStyle(color:_green,fontSize:18,fontWeight:FontWeight.bold)),
        const SizedBox(height:12),Text(d.arabic,textDirection:TextDirection.rtl,textAlign:TextAlign.center,style:TextStyle(fontSize:arabicFontSize,height:1.75)),
        if (widget.language != 'ar') ...[
          const SizedBox(height:12),
          Text(_localizedEntryPron(d,widget.language),style:TextStyle(fontSize:15,color:Theme.of(context).colorScheme.primary,height:1.7)),
        ],
        const SizedBox(height:10),Text(learningLabel(widget.language,'meaning'),style:const TextStyle(fontWeight:FontWeight.bold)),
        Text(widget.language=='bn'?d.bn:widget.language=='ko'?d.ko:widget.language=='ar'?(_arabicEntryMeanings[d.title] ?? d.en):d.en,style:const TextStyle(fontSize:15,height:1.6)),
        const SizedBox(height:8),Text('${learningLabel(widget.language,'reference')}: ${d.reference}',style:const TextStyle(fontSize:11,color:Colors.grey)),
      ])));
    })),
    ]),
  );
}
