MPT v1.5.2 — সম্পূর্ণ সোর্স আপডেট

১. ZIP খুলে সব ফাইল GitHub repository root-এ আপলোড করুন (পুরোনো ফাইল overwrite)।
২. Codemagic-এ mpt_android_debug workflow দিয়ে নতুন Build করুন।
৩. APK install/update করুন।
৪. Android Settings > Apps > MPT > Notifications = Allow।
৫. MPT > Settings > Allow precise Adhan alarms বাটন চাপুন; Alarms & reminders অনুমতি দিন (ফোনে অপশন থাকলে)।
৬. Prayer notifications > Full/Short ও Special Fajr বেছে Save & Schedule Alerts চাপুন।
৭. Test notification দিয়ে পরীক্ষা করুন, তারপর বাস্তব নামাজের সময়ে আজান পরীক্ষা করুন।

সংশোধন: ক্যালেন্ডারের চার ভাষায় weekday, সংস্করণ 1.5.2, Flutter থেকে Android native automatic Adhan schedule, প্রার্থনা on/off অনুযায়ী scheduling, native file installer।

সীমাবদ্ধতা: Android battery/Doze ও exact alarm অনুমতির কারণে আজান দেরি হতে পারে। ফোন restart, force stop, app update-এর পর আবার অ্যাপ খুলে Save & Schedule Alerts করুন। ১০ দিনের বেশি সময়ের জন্য নিজে থেকে renewal নেই। Android 14+ foreground service restrictions-এ নির্দিষ্ট ফোনে playback ব্যর্থ হতে পারে। Play Store-এ প্রকাশের আগে অডিওর distribution rights নিশ্চিত করুন।

Codemagic সফল Build না হওয়া পর্যন্ত এটি tested APK নয়।
