// Additional language strings. Existing four languages remain unchanged.
// Qur'anic translations and phonetic guides require native-speaker/tajwid review.
const mptExtraTranslations = <String, Map<String, String>>{
  'ur': {
    'arabicSize':'عربی حروف کا سائز','gpsSuccess':'GPS مقام استعمال ہو رہا ہے۔','duaNumber':'دعا',
    'adhanSuccess':'نماز کی اطلاعات اور اذان مقرر ہو گئیں۔','alertError':'اطلاع میں خرابی',
    'northBearing':'شمال سے','testTitle':'MPT · آزمائشی اطلاع','testBody':'نماز کی آزمائشی اطلاع کامیاب رہی۔',
    'preciseAdhan':'درست وقت پر اذان کی اجازت دیں','adhanSettings':'اذان کی ترتیبات',
    'fullAdhan':'مکمل اذان','shortAdhan':'مختصر اذان','specialFajr':'فجر کی خصوصی اذان',
    'specialFajrHint':'فجر کے لیے خصوصی اذان استعمال کریں','previewAdhan':'اذان سنیں',
    'previewFajr':'فجر کی اذان سنیں','stopAdhan':'بند کریں',
    'adhanHelp':'اذان کا نمونہ ایپ میں چلتا ہے۔ اطلاعات محفوظ کرنے سے Android پر اذان بھی مقرر ہوتی ہے۔',
    'adhanScheduled':'اذان مقرر ہو گئی۔','audioError':'آڈیو کی خرابی',
  },
  'uz': {
    'arabicSize':'Arabcha matn o‘lchami','gpsSuccess':'GPS joylashuvi ishlatilmoqda.','duaNumber':'Duo',
    'adhanSuccess':'Namoz eslatmalari va azon rejalashtirildi.','alertError':'Eslatma xatosi',
    'northBearing':'shimoldan','testTitle':'MPT · Sinov xabari','testBody':'Sinov xabari muvaffaqiyatli.',
    'preciseAdhan':'Aniq azon signaliga ruxsat berish','adhanSettings':'Azon sozlamalari',
    'fullAdhan':'To‘liq azon','shortAdhan':'Qisqa azon','specialFajr':'Bomdod uchun maxsus azon',
    'specialFajrHint':'Bomdodda maxsus azondan foydalanish','previewAdhan':'Azonni tinglash',
    'previewFajr':'Bomdod azonini tinglash','stopAdhan':'To‘xtatish',
    'adhanHelp':'Azonni ilovada tinglash mumkin. Eslatmalarni saqlash Android azonini ham rejalashtiradi.',
    'adhanScheduled':'Avtomatik azon belgilandi.','audioError':'Audio xatosi',
  },
  'id': {
    'arabicSize':'Ukuran huruf Arab','gpsSuccess':'Menggunakan lokasi GPS.','duaNumber':'Doa',
    'adhanSuccess':'Pengingat salat dan azan dijadwalkan.','alertError':'Kesalahan pengingat',
    'northBearing':'dari utara','testTitle':'MPT · Notifikasi uji','testBody':'Uji notifikasi salat berhasil.',
    'preciseAdhan':'Izinkan alarm azan tepat waktu','adhanSettings':'Pengaturan azan',
    'fullAdhan':'Azan lengkap','shortAdhan':'Azan singkat','specialFajr':'Azan Subuh khusus',
    'specialFajrHint':'Gunakan azan khusus untuk Subuh','previewAdhan':'Dengarkan azan',
    'previewFajr':'Dengarkan azan Subuh','stopAdhan':'Hentikan',
    'adhanHelp':'Pratinjau diputar di aplikasi. Menyimpan pengingat juga menjadwalkan azan Android.',
    'adhanScheduled':'Azan otomatis dijadwalkan.','audioError':'Kesalahan audio',
  },
  'hi': {
    'arabicSize':'अरबी अक्षरों का आकार','gpsSuccess':'GPS लोकेशन इस्तेमाल हो रही है।','duaNumber':'दुआ',
    'adhanSuccess':'नमाज़ की सूचनाएँ और अज़ान निर्धारित हैं।','alertError':'सूचना में त्रुटि',
    'northBearing':'उत्तर से','testTitle':'MPT · टेस्ट सूचना','testBody':'नमाज़ की टेस्ट सूचना सफल रही।',
    'preciseAdhan':'सटीक अज़ान अलार्म की अनुमति दें','adhanSettings':'अज़ान सेटिंग्स',
    'fullAdhan':'पूरी अज़ान','shortAdhan':'छोटी अज़ान','specialFajr':'फ़ज्र की विशेष अज़ान',
    'specialFajrHint':'फ़ज्र के लिए विशेष अज़ान इस्तेमाल करें','previewAdhan':'अज़ान सुनें',
    'previewFajr':'फ़ज्र की अज़ान सुनें','stopAdhan':'बंद करें',
    'adhanHelp':'अज़ान ऐप में सुनाई देती है। सूचनाएँ सहेजने पर Android अज़ान भी निर्धारित होती है।',
    'adhanScheduled':'स्वचालित अज़ान निर्धारित है।','audioError':'ऑडियो त्रुटि',
  },
};

const mptLearningLabels = <String, Map<String, String>>{
  'ur': {'surah':'سورتیں','dua':'دعاؤں کا مجموعہ','daily':'روزانہ دعائیں','salah':'نماز کی دعائیں','kalima':'چھ کلمے','kursi':'آیت الکرسی','quran':'قرآنی دعائیں (۱۳)','morning':'صبح و شام کی دعائیں','protection':'حفاظت کی دعائیں','pron':'تلفظ (لاطینی رہنمائی)','meaning':'مطلب','verses':'آیات','reference':'حوالہ','note':'لاطینی تلفظ صرف سیکھنے میں مدد کے لیے ہے؛ صحیح تلاوت استاد سے سیکھیں۔'},
  'uz': {'surah':'Suralar','dua':'Duolar to‘plami','daily':'Kundalik duolar','salah':'Namozdagi duolar','kalima':'Olti kalima','kursi':'Oyatul Kursiy','quran':'Qur’oniy duolar (13)','morning':'Ertalab va kechqurun','protection':'Himoya duolari','pron':'Talaffuz (lotincha)','meaning':'Ma’nosi','verses':'oyat','reference':'Manba','note':'Lotincha talaffuz faqat o‘rganish uchun; qiroatni ustozdan tekshiring.'},
  'id': {'surah':'Surah','dua':'Kumpulan doa','daily':'Doa harian','salah':'Doa dalam salat','kalima':'Enam kalimat','kursi':'Ayat Kursi','quran':'Doa Al-Qur’an (13)','morning':'Zikir pagi dan petang','protection':'Doa perlindungan','pron':'Panduan pelafalan (Latin)','meaning':'Arti','verses':'ayat','reference':'Sumber','note':'Transliterasi Latin hanya panduan belajar; periksa bacaan dengan guru yang kompeten.'},
  'hi': {'surah':'सूरह','dua':'दुआ संग्रह','daily':'रोज़ाना दुआएँ','salah':'नमाज़ की दुआएँ','kalima':'छह कलिमे','kursi':'आयतुल कुर्सी','quran':'क़ुरआनी दुआएँ (13)','morning':'सुबह और शाम की दुआएँ','protection':'हिफ़ाज़त की दुआएँ','pron':'उच्चारण (लैटिन मार्गदर्शिका)','meaning':'अर्थ','verses':'आयतें','reference':'स्रोत','note':'लैटिन उच्चारण केवल सीखने में सहायता है; सही तिलावत शिक्षक से जाँचें।'},
};

const mptDuaTitles = <String, Map<String, String>>{
  'ur': {'Morning remembrance':'صبح کا ذکر','Evening remembrance':'شام کا ذکر','Seeking refuge':'پناہ کی دعا','Protection in Allah’s name':'اللہ کے نام سے حفاظت','Before eating':'کھانے سے پہلے','After eating':'کھانے کے بعد','Before sleeping':'سونے سے پہلے','Upon waking':'جاگنے پر','Opening supplication (Sana)':'ثنا','Ruku remembrance':'رکوع کی تسبیح','Sujud remembrance':'سجدے کی تسبیح','Between two prostrations':'دو سجدوں کے درمیان','Prayer for parents':'والدین کے لیے دعا','Ayatul Kursi · Quran 2:255':'آیت الکرسی · ۲:۲۵۵','1. Kalima Tayyibah':'۱۔ کلمہ طیبہ','2. Kalima Shahadah':'۲۔ کلمہ شہادت','3. Kalima Tamjid':'۳۔ کلمہ تمجید','4. Kalima Tawhid':'۴۔ کلمہ توحید','5. Kalima Istighfar':'۵۔ کلمہ استغفار','6. Kalima Radd-e-Kufr':'۶۔ کلمہ رد کفر'},
  'uz': {'Morning remembrance':'Tonggi zikr','Evening remembrance':'Kechki zikr','Seeking refuge':'Panoh so‘rash','Protection in Allah’s name':'Alloh nomi bilan himoya','Before eating':'Ovqatdan oldin','After eating':'Ovqatdan keyin','Before sleeping':'Uxlashdan oldin','Upon waking':'Uyg‘onganda','Opening supplication (Sana)':'Sano duosi','Ruku remembrance':'Ruku tasbehi','Sujud remembrance':'Sajda tasbehi','Between two prostrations':'Ikki sajda orasida','Prayer for parents':'Ota-ona uchun duo','Ayatul Kursi · Quran 2:255':'Oyatul Kursiy · 2:255','1. Kalima Tayyibah':'1. Kalimai tayyiba','2. Kalima Shahadah':'2. Kalimai shahodat','3. Kalima Tamjid':'3. Kalimai tamjid','4. Kalima Tawhid':'4. Kalimai tavhid','5. Kalima Istighfar':'5. Kalimai istig‘for','6. Kalima Radd-e-Kufr':'6. Kalimai raddu kufr'},
  'id': {'Morning remembrance':'Zikir pagi','Evening remembrance':'Zikir petang','Seeking refuge':'Memohon perlindungan','Protection in Allah’s name':'Perlindungan dengan nama Allah','Before eating':'Sebelum makan','After eating':'Setelah makan','Before sleeping':'Sebelum tidur','Upon waking':'Bangun tidur','Opening supplication (Sana)':'Doa iftitah (Sana)','Ruku remembrance':'Zikir rukuk','Sujud remembrance':'Zikir sujud','Between two prostrations':'Di antara dua sujud','Prayer for parents':'Doa untuk orang tua','Ayatul Kursi · Quran 2:255':'Ayat Kursi · 2:255','1. Kalima Tayyibah':'1. Kalimat Tayyibah','2. Kalima Shahadah':'2. Kalimat Syahadat','3. Kalima Tamjid':'3. Kalimat Tamjid','4. Kalima Tawhid':'4. Kalimat Tauhid','5. Kalima Istighfar':'5. Kalimat Istigfar','6. Kalima Radd-e-Kufr':'6. Kalimat Raddul Kufur'},
  'hi': {'Morning remembrance':'सुबह का ज़िक्र','Evening remembrance':'शाम का ज़िक्र','Seeking refuge':'पनाह की दुआ','Protection in Allah’s name':'अल्लाह के नाम से हिफ़ाज़त','Before eating':'खाने से पहले','After eating':'खाने के बाद','Before sleeping':'सोने से पहले','Upon waking':'जागने पर','Opening supplication (Sana)':'सना','Ruku remembrance':'रुकू की तस्बीह','Sujud remembrance':'सजदे की तस्बीह','Between two prostrations':'दो सजदों के बीच','Prayer for parents':'माता-पिता के लिए दुआ','Ayatul Kursi · Quran 2:255':'आयतुल कुर्सी · 2:255','1. Kalima Tayyibah':'१. कलिमा तय्यिबा','2. Kalima Shahadah':'२. कलिमा शहादत','3. Kalima Tamjid':'३. कलिमा तमजीद','4. Kalima Tawhid':'४. कलिमा तौहीद','5. Kalima Istighfar':'५. कलिमा इस्तिग़फ़ार','6. Kalima Radd-e-Kufr':'६. कलिमा रद्दे कुफ़्र'},
};

// Translation overlays are added only when independently reviewed.
// Other meanings retain the original English rather than inventing religious translations.
const mptDuaMeanings = <String, Map<String, String>>{};
