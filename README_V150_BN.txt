MPT v1.5.0 - সম্পূর্ণ GitHub project

নতুন:
১. ক্যালেন্ডারের সপ্তাহের দিন বাংলা, English, Korean, Arabic ভাষা অনুযায়ী বদলায়।
২. Test Notification চাপলে এখনই একটি নোটিফিকেশন পাঠায় (১০ সেকেন্ডের inexact schedule নয়)।
৩. ৫ ওয়াক্তে MP3 আজান বাজাতে Android AlarmManager + BroadcastReceiver + Foreground Media Service।
৪. Full/Short, Special Fajr এবং Settings-এ preview আগের মতোই আছে।
৫. Settings-এ precise alarm permission চালু করার বাটন আছে।

ব্যবহার:
১. ZIP extract করে ভিতরের সব ফাইল আপনার GitHub repository root-এ আপলোড/replace করুন।
২. Codemagic-এ mpt_android_debug workflow দিয়ে নতুন APK build করুন।
৩. APK ইনস্টল করে Settings > Allow precise Adhan alarms চাপুন এবং অনুমতি দিন।
৪. Settings > Enable prayer notifications অথবা Prayer notifications > Save & Schedule Alerts চাপুন।
৫. Prayer notifications > Test notification now চাপুন।
৬. Adhan Settings > Preview Fajr/Adhan দিয়ে MP3 পরীক্ষা করুন।

সীমাবদ্ধতা:
- APK এখানে build করা হয়নি; Flutter/Codemagic compile ও Android device test প্রয়োজন।
- Android 12+ precise alarm অনুমতি এবং Samsung battery restrictions কার্যকারিতায় প্রভাব ফেলে।
- ফোন restart হলে native MP3 alarms আবার schedule করতে অ্যাপ খুলে Save & Schedule Alerts চাপতে হবে।
- নতুন Full/Short/Special Fajr পছন্দের পরে Save & Schedule Alerts আবার চাপতে হবে।
- Android কিছু পরিস্থিতিতে background service শুরু হতে বাধা দিতে পারে; ১০০% নিশ্চয়তা নেই।
- MP3 বিতরণের আগে recording ব্যবহারের অনুমতি নিশ্চিত করুন।
- Notification sound আলাদা; দুই ধরনের শব্দ একসঙ্গে এড়াতে notification sound OFF রাখুন, কিন্তু native adhan scheduling আলাদা ভাবে চালু থাকবে।
